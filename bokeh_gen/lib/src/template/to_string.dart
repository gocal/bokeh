import 'params.dart';

class ToStringTemplate {

  final String className; 
  final List<ParamTemplate> params;

  ToStringTemplate(this.className, this.params);

  @override
  String toString() {
    var paramsString = params.map(((t) => "${t.name}=\$\{${t.name}\}")).where((s) => s.isNotEmpty).join(', ');
    var value = "$className[$paramsString]";

    return """
      @override
      String toString() {
        return \"$value\";
      }
      """;
  }
}