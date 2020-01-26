import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build/build.dart';
import 'package:bokeh/bokeh.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

import '_common.dart';

class BokehBlocStatesGenerator extends GeneratorForAnnotation<BlocStates> {
  final emitter = DartEmitter();
  final formatter = DartFormatter();
  final annotationName = "BlocStatesClass";

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

    final commonGenerator = CommonCodeGenerator();
    final protocol = element as ClassElement;
    final eventsClassesBuilders = List<ClassBuilder>();

    ///
    /// Base event class
    ///
    final className = annotation.peek("className")?.stringValue ??
        protocol.displayName.substring(0, protocol.displayName.length - 1);

    eventsClassesBuilders
        .add(commonGenerator.generateProtocolClass(protocol, className));

    ///
    /// Events
    ///
    eventsClassesBuilders.addAll(commonGenerator.generateProtocolDerivedClasses(
        protocol, className,
        addCopyWith: true));

    ///
    /// Build classes
    ///
    final emitter = DartEmitter();
    final formatter = DartFormatter();
    final stringBuilder = StringBuffer();
    eventsClassesBuilders.forEach((builder) {
      stringBuilder.write(builder.build().accept(emitter).toString());
    });
    return formatter.format(stringBuilder.toString());
  }
}
