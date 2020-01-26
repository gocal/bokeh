import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

class CommonCodeGenerator {
  ClassBuilder generateProtocolClass(ClassElement protocol, String className) {
    _assertElementValid(protocol);

    return ClassBuilder()
      ..abstract = true
      ..name = className
      ..methods.addAll(protocol.methods.map((method) {
        final args = method.parameters.isNotEmpty
            ? method.parameters.map((parameter) {
                final parameterName = parameter.name;

                return parameter.isNamed
                    ? "$parameterName: $parameterName"
                    : "$parameterName";
              }).join(", ")
            : "";

        final builder = MethodBuilder()
          ..static = true
          ..name = method.name.camelCase
          ..lambda = true
          ..returns = refer(className)
          ..body = Code('${method.name.pascalCase}($args)')
          ..requiredParameters.addAll(
              method.parameters.where((param) => !param.isNamed).map((param) {
            final paramBuilder = ParameterBuilder()
              ..named = false
              ..type = refer(param.type.getDisplayString())
              ..name = param.name;
            return paramBuilder.build();
          }))
          ..optionalParameters.addAll(
              method.parameters.where((param) => param.isOptional).map((param) {
            final paramBuilder = ParameterBuilder()
              ..named = true
              ..type = refer(param.type.getDisplayString())
              ..name = param.name;
            return paramBuilder.build();
          }));

        return builder.build();
      }));
  }

  List<ClassBuilder> generateProtocolDerivedClasses(
      ClassElement protocol, String protocolClassName) {
    return protocol.methods.map((method) {
      final className = '${method.name.pascalCase}';

      final eventClassBuilder = ClassBuilder()
        ..name = className
        ..implements.add(refer(protocolClassName))
        ..constructors.add((ConstructorBuilder()
              ..optionalParameters.addAll(method.parameters.map((param) {
                final builder = ParameterBuilder()
                  ..name = param.name
                  ..type = refer(param.type.getDisplayString())
                  ..named = param.isNamed
                  ..toThis = true;
                return builder.build();
              }))
              ..constant = true)
            .build())
        ..fields.addAll(method.parameters.map((param) {
          final builder = FieldBuilder()
            ..name = param.name
            ..modifier = FieldModifier.final$
            ..type = refer(param.type.getDisplayString());
          return builder.build();
        }))
        ..methods.add(generateEqualsMethod(className, method.parameters))
        ..methods.add(generateHashCodeMethod(method.parameters))
        ..methods.add(generateToStringMethod(className, method.parameters));

      return eventClassBuilder;
    }).toList();
  }

  void _assertElementValid(ClassElement element) {
    // abstract
    if (element.isAbstract != true) {
      throw InvalidGenerationSourceError(
          'The ${element.name} must be abstract');
    }

    if (element.unnamedConstructor != null &&
        element.unnamedConstructor.parameters.isNotEmpty) {
      throw InvalidGenerationSourceError(
          'The ${element.name}  must not have unnamed constructor');
    }

    if (element.fields.isNotEmpty) {
      throw InvalidGenerationSourceError(
          '@$element.name cannot have parameters');
    }

    if (element.methods.isEmpty) {
      throw InvalidGenerationSourceError(
          '@$element.name need at least one method');
    }

    element.methods.forEach((method) => {
          if (!(method.returnType.isDynamic))
            {
              throw InvalidGenerationSourceError(
                  'Wrong return type ${method.returnType} - needs to be dynamic')
            }
        });
  }

  Method generateEqualsMethod(String className, List<ParameterElement> fields) {
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

    return mb.build();
  }

  bool _hasDeepCollectionEquality(ParameterElement fieldElement) {
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

  Method generateHashCodeMethod(List<ParameterElement> fields) {
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
          return \$jf($hashString);
        """;
    }

    final builder = MethodBuilder()
      ..name = 'hashCode'
      ..type = MethodType.getter
      ..returns = refer('int')
      ..body = Code(body);

    return builder.build();
  }

  Method generateCopyWithMethod(
      ClassElement clazz, List<ParameterElement> fields) {
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

  Method generateToStringMethod(
      String className, List<ParameterElement> fields) {
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

    return "return '$className [$fieldsToString]';";
  }
}