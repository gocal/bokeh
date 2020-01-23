import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:bokeh/bokeh.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class BokehBlocStatesGenerator extends GeneratorForAnnotation<BlocStatesClass> {
  final emitter = DartEmitter();
  final formatter = DartFormatter();
  final annotationName = "BlocStatesClass";

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is ClassElement) {
      _assertElementValid(element);

      final equalsMethod =
          _generateEqualsMethod(element.displayName, element.fields);
      final copyWithMethod = _generateCopyWithMethod(element, element.fields);
      final hashCodeMethod = _generateHashCodeMethod(element.fields);
      final toStringMethod =
          _generateToStringMethod(element.displayName, element.fields);

      final getters = element.fields
          .map((field) => MethodBuilder()
            ..name = field.displayName
            ..returns = refer(field.type.displayName)
            ..type = MethodType.getter)
          .map((mb) => mb.build());

      final constConstructor = (ConstructorBuilder()..constant = true).build();

      final partialClass = ClassBuilder()
        ..name = '_\$${element.name}'
        ..constructors.add(constConstructor)
        ..types.addAll(element.typeParameters
            .map((typeParam) => refer(typeParam.displayName)))
        ..methods.addAll(getters)
        ..methods.add(equalsMethod)
        ..methods.add(hashCodeMethod)
        ..methods.add(toStringMethod)
        ..methods.add(copyWithMethod)
        ..abstract = true;

      return formatter.format(partialClass.build().accept(emitter).toString());
    } else {
      throw Exception(
        '@$annotationName anontation cannot be used on abstract classes',
      );
    }
  }

  void _assertElementValid(ClassElement element) {
    // abstract
    if (element.isAbstract == null) {
      throw InvalidGenerationSourceError(
          'The ${element.name} @$annotationName must be abstract');
    }

    if (element.unnamedConstructor == null) {
      throw InvalidGenerationSourceError(
          'The ${element.name} @$annotationName must have unnamed (default) constructor');
    }

    if (element.unnamedConstructor.parameters.isNotEmpty) {
      if (!element.unnamedConstructor.parameters
          .any((param) => param.isNamed)) {
        throw InvalidGenerationSourceError(
            'The ${element.name} @$annotationName constructor should have named params only');
      }
    }

    if (element.fields.any((field) => !field.isFinal)) {
      throw InvalidGenerationSourceError(
          '@$annotationName should have final fields only');
    }
  }

  Method _generateEqualsMethod(String className, List<FieldElement> fields) {
    MethodBuilder mb = MethodBuilder()
      ..name = 'operator=='
      ..requiredParameters.add((ParameterBuilder()..name = 'other').build())
      ..returns = refer('bool')
      ..body = Code(
        _equalsBody(
          className,
          Map.fromIterable(fields,
              key: (element) => element.displayName,
              value: (element) => _hasDeepCollectionEquality(element)),
        ),
      );

    fields.map(
      (element) => element.metadata.map(
        (annotation) => annotation
            .computeConstantValue()
            .getField('deepEquality')
            .toBoolValue(),
      ),
    );

    return mb.build();
  }

  bool _hasDeepCollectionEquality(FieldElement fieldElement) {
    /*
    final collectionAnnotation =
        TypeChecker.fromRuntime(Collection).firstAnnotationOf(fieldElement);

    if (collectionAnnotation == null)
      return false;
    else {
      return collectionAnnotation.getField('deepEquality').toBoolValue();
    }
    */
    return false;
  }

  Method _generateHashCodeMethod(List<FieldElement> fields) {
    String body;

    if (fields.isEmpty) {
      body = """
 super.hashCode;
            """;
    } else {
      var hashString = "0";

      for (int i = 0; i < fields.length; i++) {
        var param = fields[i];
        hashString = "\$jc($hashString, ${param.name}.hashCode)";
      }

      body = """
          \$jf($hashString)
        """;
    }

    final builder = MethodBuilder()
      ..name = 'hashCode'
      ..type = MethodType.getter
      ..returns = refer('int')
      ..body = Code(body);

    return builder.build();
  }

  Method _generateCopyWithMethod(
      ClassElement clazz, List<FieldElement> fields) {
    final params = fields
        .map((field) => ParameterBuilder()
          ..name = field.name
          ..type = refer(field.type.displayName)
          ..named = true)
        .map((paramBuilder) => paramBuilder.build());

    final mb = MethodBuilder()
      ..name = 'copyWith'
      ..optionalParameters.addAll(params)
      ..returns = refer(clazz.name)
      ..body = Code(
          _copyToMethodBody(clazz, fields.map((field) => field.displayName)));

    return mb.build();
  }

  Method _generateToStringMethod(String className, List<FieldElement> fields) {
    final mb = MethodBuilder()
      ..name = 'toString'
      ..returns = refer('String')
      ..body = Code(
          _toStringBody(className, fields.map((field) => field.displayName)));

    return mb.build();
  }

  String _equalsBody(String className, Map<String, bool> fields) {
    final fieldEquals = fields.entries.fold<String>('true', (value, element) {
      final hasDeepCollectionEquality = element.value;
      if (hasDeepCollectionEquality) {
        return '$value && DeepCollectionEquality().equals(this.${element.key},other.${element.key})';
      } else {
        return '$value && this.${element.key} == other.${element.key}';
      }
    });

    return '''
  if (identical(this, other)) return true;
  if (other is! $className) return false;
  return $fieldEquals;
''';
  }

  String _copyToMethodBody(ClassElement clazz, Iterable<String> fields) {
    final paramsInput = fields.fold(
      "",
      (r, field) => "$r ${field}: ${field} ?? this.${field},",
    );

    final typeParameters = clazz.typeParameters.isEmpty
        ? ''
        : '<' + clazz.typeParameters.map((type) => type.name).join(',') + '>';

    return '''return ${clazz.name}$typeParameters($paramsInput);''';
  }

  String _toStringBody(String className, Iterable<String> fields) {
    final fieldsToString =
        fields.fold('', (r, field) => r + '\\\'$field\\\': \${this.$field},');

    return "return '$className <$fieldsToString>';";
  }
}
