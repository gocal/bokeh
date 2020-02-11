import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:bokeh/bokeh.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import 'package:recase/recase.dart';

class BokehBlocGenerator extends GeneratorForAnnotation<BlocOf> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (!(element is ClassElement)) {
      throw Exception(
        '@${annotation} anontation must be used on class element',
      );
    }
    
    final protocol = annotation.read("event").typeValue as InterfaceType;
    final statesProtocol = annotation.read("state").typeValue as InterfaceType;

    final protocolName =
        protocol.displayName.substring(1);

    final methodName = statesProtocol.displayName.substring(1);
    final methodBuilder = MethodBuilder();

    final codeBlocs = List<Code>();
    protocol.methods.forEach((method) {
      final args = method.parameters.isNotEmpty
          ? "this as ${method.name.pascalCase}"
          : "";

      codeBlocs.add(Code(
          '''if(this is ${method.name.pascalCase}) { yield* ${method.name.camelCase}($args); return; }'''));
    });

    methodBuilder
      ..name = "when"
      ..modifier = MethodModifier.asyncStar
      ..returns = refer("Stream<$methodName>")
      ..optionalParameters.addAll(protocol.methods.map((method) {
        final ft = FunctionTypeBuilder()
          ..returnType = refer("Stream<$methodName>");

        if (method.parameters.isNotEmpty) {
          ft.requiredParameters.add(refer("${method.name.pascalCase}"));
        }

        final paramBuilder = ParameterBuilder()
          ..named = true
          ..name = method.name.camelCase
          ..type = ft.build()
          ..build();
        return paramBuilder.build();
      }))
      ..body = Block.of(codeBlocs);

    ///
    /// Build classes
    ///
    final emitter = DartEmitter();
    final formatter = DartFormatter();
    final stringBuilder = StringBuffer();
    stringBuilder
        .write("extension ${protocolName}Extension on ${protocolName} {");
    stringBuilder.write(methodBuilder.build().accept(emitter).toString());
    stringBuilder.write("}");

    return formatter.format(stringBuilder.toString());
  }
}
