import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:bokeh_gen/src/bokeh_data_generator.dart';

Builder bokeh(BuilderOptions options) =>
    SharedPartBuilder([BokehDataGenerator()], 'bokeh');
