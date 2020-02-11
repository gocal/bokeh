library bokeh;

const protocol = Protocol(prefix: "_\$", suffix: "s");
const data = Data(prefix: "_\$", suffix: "");
const selector = Selector();

class Data {
  final String prefix;
  final String suffix;
  final String className;
  const Data({this.className, this.prefix, this.suffix});
}

class Protocol {
  final String prefix;
  final String suffix;
  final String className;
  final bool copyWith;
  const Protocol({this.className, this.copyWith, this.prefix, this.suffix});
}

class Selector {
  final Type statesClass;
  const Selector({this.statesClass});
}

/// Jenkins Hash Functions
/// https://en.wikipedia.org/wiki/Jenkins_hash_function
/// For use by generated code in calculating hash codes. Do not use directly.
/// jenkins combine
int $jc(int hash, int value) {
  // Jenkins hash "combine".
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

/// For use by generated code in calculating hash codes. Do not use directly.
/// jenkins finish
int $jf(int hash) {
  // Jenkins hash "finish".
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}
