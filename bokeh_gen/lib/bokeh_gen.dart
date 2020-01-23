import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:bokeh_gen/src/bokeh_gen.dart';

Builder bokeh(BuilderOptions options) =>
    SharedPartBuilder([bokehDataGenerator()], 'bokeh');
