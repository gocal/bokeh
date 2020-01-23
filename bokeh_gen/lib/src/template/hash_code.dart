import 'params.dart';

class EqualsTemplate {
  final String className; 
  final List<ParamTemplate> params;

  EqualsTemplate(this.className, this.params);

  @override
  String toString() {

    var paramsString = params.map(((t) => "${t.name} == other.${t.name}")).where((s) => s.isNotEmpty).join('&&\n');

    return """
      @override
      bool operator ==(Object other) {
        if (identical(other, this)) return true;
        return other is ${className} &&
        ${paramsString};
      }
      """;
  }
}


class HashCodeTemplate {

  final String className; 
  final List<ParamTemplate> params;

  HashCodeTemplate(this.className, this.params);

  @override
  String toString() {
    if(params.length == 0) {
          return """
            @override
            int get hashCode {
              return super.hashCode;
            }
            """;
    }

    var hashString = "0";

    for(int i=0; i<params.length; i++) {
      var param = params[i];
      hashString = "\$jc($hashString, ${param.name}.hashCode)";  

    }

    return """
      @override
      int get hashCode {
        return \$jf($hashString);
      }
      """;
  }
}
