import 'package:bokeh_generator/src/bokeh_data_generator.dart';
import 'package:bokeh_generator/src/bokeh_protocol_generator.dart';
import 'package:bokeh_generator/src/bokeh_selector_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder bokeh(BuilderOptions options) => SharedPartBuilder(
    [BokehDataGenerator(), BokehProtocolGenerator(), BokehSelectorGenerator()],
    'bokeh');
