import 'package:bokeh_generator/src/bokeh_bloc_selector_generator.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/bokeh_bloc_events_generator.dart';
import 'src/bokeh_bloc_states_generator.dart';

Builder bokeh(BuilderOptions options) => SharedPartBuilder([
      BokehBlocEventsGenerator(),
      BokehBlocStatesGenerator(),
      BokehBlocSelectorGenerator()
    ], 'bokeh');
