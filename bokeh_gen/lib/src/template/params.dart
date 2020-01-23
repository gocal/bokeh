class ParamTemplate {
  bool isNamed;
  String name;
  String type;
  String defaultValue;

  ParamTemplate(this.isNamed, this.type, this.name);  

  String get asArgument => name;

  NamedArgTemplate get asNamedArgument => NamedArgTemplate()..name = name;

  @override
  String toString() =>
      defaultValue == null ? '$type $name' : '$type $name = $defaultValue';
}

class TypeParamTemplate {
  String name;
  String bound;

  String get asArgument => name;

  @override
  String toString() => bound == null ? name : '$name extends $bound';
}

class NamedArgTemplate {
  String name;

  @override
  String toString() => '$name: $name';
}

class GetterParamTemplate {
  final ParamTemplate param;

  GetterParamTemplate(this.param);  

  @override
  String toString() {
    return "${param.type} get ${param.name};\n";
  }
}

class OverrideParamTemplate {
  final ParamTemplate param;

  OverrideParamTemplate(this.param);  

  @override
  String toString() {
    return "@override\nfinal ${param.type} ${param.name};\n";
  }
}

class ParamListTemplate<T> {

  final List<T> params;

  ParamListTemplate(this.params);

  @override
  String toString() {
    var sb = StringBuffer();
    for(int i=0; i<params.length; i++) {
      sb.write("\n");
      sb.write(params[i].toString());
    }
    return sb.toString();
  }

}

