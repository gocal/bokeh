import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:bokeh/bokeh.dart';

class BokehBlocEventsGenerator extends GeneratorForAnnotation<BlocStatesClass> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return "";
  }
}
