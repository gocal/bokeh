import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:bokeh/bokeh.dart';
import 'package:bokeh_gen/src/template/params.dart';

import 'template/bokeh.dart';

class bokehDataGenerator extends GeneratorForAnnotation<Data> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (!(element is ClassElement)) {
      throw Exception("Only class element are supported");
    }

    var classElement = element as ClassElement;

    if (classElement.constructors.length != 2) {
      throw Exception("Only single factory constructor is supported");
    }

    var constructorElement = classElement.constructors[1];

    if (!constructorElement.isFactory) {
      throw Exception(
          "Only factory element is supported, found $constructorElement");
    }

    var parameters = constructorElement.parameters;

    var bokehParams = <ParamTemplate>[];
    for (int i = 0; i < parameters.length; i++) {
      var param = parameters[i];

      bokehParams.add(
          ParamTemplate(param.isNamed, param.type.displayName, param.name));
    }

    var bokehClass = bokehTemplate(classElement.name, bokehParams);
    var bokehInitClass = bokehInitTemplate(classElement.name, bokehParams);

    return bokehClass.toString() + "\n\n" + bokehInitClass.toString();
  }
}
