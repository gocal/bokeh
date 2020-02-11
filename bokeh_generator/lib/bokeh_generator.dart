import 'package:bokeh_generator/src/bokeh_protocol_generator.dart';
import 'package:bokeh_generator/src/bokeh_bloc_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder bokeh(BuilderOptions options) => SharedPartBuilder(
    [BokehProtocolGenerator(), BokehBlocGenerator()],
    'bokeh');
