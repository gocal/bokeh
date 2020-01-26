import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:bokeh/bokeh.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:recase/recase.dart';

import '_common.dart';

class BokehBlocEventsGenerator extends GeneratorForAnnotation<BlocEvents> {
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
    _assertElementValid(element);

    final commonGenerator = CommonCodeGenerator();
    final protocol = element as ClassElement;

    ///
    /// Classes
    ///
    final eventsClassesBuilders = List<ClassBuilder>();

    ///
    /// Base event class
    ///
    final baseEventClassName = annotation.peek("className")?.stringValue ??
        protocol.displayName.substring(0, protocol.displayName.length - 1);

    final baseClassBuilder = ClassBuilder()
      ..abstract = true
      ..name = baseEventClassName
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
          ..returns = refer(baseEventClassName)
          ..body = Code('${method.name.pascalCase}($args)')
          ..optionalParameters.addAll(
              method.parameters.where((param) => param.isNamed).map((param) {
            final paramBuilder = ParameterBuilder()
              ..named = true
              ..name = param.name;
            return paramBuilder.build();
          }));

        return builder.build();
      }));

    eventsClassesBuilders.add(baseClassBuilder);

    ///
    /// Events
    ///
    protocol.methods.forEach((method) {
      final String name = method.name;

      final className = '${name.pascalCase}';

      final eventClassBuilder = ClassBuilder()
        ..name = className
        ..implements.add(refer(baseEventClassName))
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
            ..type = refer(param.type.getDisplayString());
          return builder.build();
        }))
        ..methods.add(
            commonGenerator.generateEqualsMethod(className, method.parameters))
        ..methods.add(commonGenerator.generateHashCodeMethod(method.parameters))
        ..methods.add(commonGenerator.generateToStringMethod(
            className, method.parameters));

      eventsClassesBuilders.add(eventClassBuilder);
    });

    ///
    /// Build classes
    ///
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
}
