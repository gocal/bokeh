import 'package:bokeh_gen/src/template/hash_code.dart';
import 'package:bokeh_gen/src/template/params.dart';
import 'package:bokeh_gen/src/template/to_string.dart';

import 'comma_list.dart';

class bokehTemplate {
  final String className;
  ParamListTemplate<GetterParamTemplate> params;

  bokehTemplate(this.className, List<ParamTemplate> args) {
    var bokehClassParams = <GetterParamTemplate>[];
    for (int i = 0; i < args.length; i++) {
      var param = args[i];
      bokehClassParams.add(GetterParamTemplate(param));
    }
    params = ParamListTemplate<GetterParamTemplate>(bokehClassParams);
  }

  @override
  String toString() => """
  // ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars
  
  abstract class _\$$className {
   _\$$className._();
    $params  
  }""";
}

class bokehInitTemplate {
  final String className;

  ConstructorParamsTemplate constructorParams;
  ParamListTemplate<OverrideParamTemplate> params;
  HashCodeTemplate hashCodeTemplate;
  ToStringTemplate toStringTemplate;
  EqualsTemplate equalsTemplate;

  bokehInitTemplate(this.className, List<ParamTemplate> args) {
    var bokehClassParams = <OverrideParamTemplate>[];
    for (int i = 0; i < args.length; i++) {
      var param = args[i];
      bokehClassParams.add(OverrideParamTemplate(param));
    }

    params = ParamListTemplate<OverrideParamTemplate>(bokehClassParams);

    constructorParams = ConstructorParamsTemplate(args);
    hashCodeTemplate = HashCodeTemplate(className, args);
    toStringTemplate = ToStringTemplate(className, args);
    equalsTemplate = EqualsTemplate(className, args);
  }

  @override
  String toString() => """

  class _\$${className}\$ extends ${className} {
   _\$${className}\$._($constructorParams) : super._();
   $params

   $toStringTemplate

   $hashCodeTemplate

   $equalsTemplate

  }""";
}

class ConstructorParamsTemplate {
  ConstructorParamsTemplate(this.templates) : assert(templates != null);

  final List<ParamTemplate> templates;

  @override
  String toString() {
    bool hasNamedParams = false;

    var params = templates
        .map((t) {
          if (t.isNamed && !hasNamedParams) {
            hasNamedParams = true;
            return '\{ this.${t.name}';
          }
          return 'this.${t.name}';
        })
        .where((s) => s.isNotEmpty)
        .join(', ');

    if (hasNamedParams) {
      return params + "}";
    }

    return params;
  }
}
