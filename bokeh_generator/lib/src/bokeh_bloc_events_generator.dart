import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:bokeh/bokeh.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';

class BokehBlocEventsGenerator extends GeneratorForAnnotation<BlocEventsClass> {
  final emitter = DartEmitter();
  final formatter = DartFormatter();
  final annotationName = "BlocEventsClass";

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (!(element is ClassElement)) {
      throw Exception(
        '@$annotationName anontation must be used on class element',
      );
    }

    final events = element as ClassElement;

    final eventType = annotation.read("event").typeValue;

    final eventsClassesBuilders = List<ClassBuilder>();

    _assertElementValid(element);

    events.methods.forEach((method) {
      final String name = method.name;

      final eventBuilder = ClassBuilder()
        ..name = '${name.pascalCase}_${eventType.getDisplayString()}'
        ..constructors.add((ConstructorBuilder()
              ..optionalParameters.addAll(method.parameters.map((param) {
                final builder = ParameterBuilder()
                  ..name = param.name
                  ..named = true
                  ..toThis = true;
                return builder.build();
              }))
              ..constant = true)
            .build())
        ..fields.addAll(method.parameters.map((param) {
          final builder = FieldBuilder()
            ..name = param.name
            ..modifier = FieldModifier.final$
            ..type = refer(param.type.displayName);
          return builder.build();
        }));

      eventsClassesBuilders.add(eventBuilder);
    });

    final equalsMethod =
        _generateEqualsMethod(element.displayName, events.fields);
    final copyWithMethod = _generateCopyWithMethod(events, events.fields);
    final hashCodeMethod = _generateHashCodeMethod(events.fields);
    final toStringMethod =
        _generateToStringMethod(element.displayName, events.fields);

    final getters = events.fields
        .map((field) => MethodBuilder()
          ..name = field.displayName
          ..returns = refer(field.type.displayName)
          ..type = MethodType.getter)
        .map((mb) => mb.build());

    final partialClass = ClassBuilder()
      ..name = '_\$${element.name}'
      ..constructors.add((ConstructorBuilder()..constant = true).build())
      ..types.addAll(events.typeParameters
          .map((typeParam) => refer(typeParam.displayName)))
      ..methods.addAll(getters)
      ..methods.add(equalsMethod)
      ..methods.add(hashCodeMethod)
      ..methods.add(toStringMethod)
      ..methods.add(copyWithMethod)
      ..abstract = true;

    final stringBuilder = StringBuffer();
    eventsClassesBuilders.forEach((builder) {
      stringBuilder.write(builder.build().accept(emitter).toString());
    });
    //

    return formatter.format(stringBuilder.toString());
  }

  void _assertElementValid(ClassElement element) {
    // abstract
    if (element.isAbstract != true) {
      throw InvalidGenerationSourceError(
          'The ${element.name} @$annotationName must be abstract');
    }

    if (element.unnamedConstructor != null &&
        element.unnamedConstructor.parameters.isNotEmpty) {
      throw InvalidGenerationSourceError(
          'The ${element.name} @$annotationName must not have unnamed constructor');
    }

    if (element.fields.isNotEmpty) {
      throw InvalidGenerationSourceError(
          '@$annotationName cannot have parameters');
    }

    if (element.methods.isEmpty) {
      throw InvalidGenerationSourceError(
          '@$annotationName need at least one method');
    }

    element.methods.forEach((method) => {
          if (!(method.returnType.isDynamic))
            {
              throw InvalidGenerationSourceError(
                  'Wrong return type ${method.returnType} - needs to be dynamic')
            }
        });
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
