library bokeh;

const protocol = Protocol();
const data = Data();
const selector = Selector();

class Data extends _BohehAnnotation {
  final String className;
  const Data({this.className, String prefix, String suffix})
      : super(prefix: prefix, suffix: suffix);
}

class Protocol extends _BohehAnnotation {
  final String className;
  final bool copyWith;
  const Protocol({this.className, this.copyWith, String prefix, String suffix})
      : super(prefix: prefix, suffix: suffix);
}

class Selector extends _BohehAnnotation {
  final Type statesClass;
  const Selector({this.statesClass, String prefix, String suffix})
      : super(prefix: prefix, suffix: suffix);
}

class _BohehAnnotation {
  final String prefix;
  final String suffix;

  const _BohehAnnotation({this.prefix = "_", this.suffix = ""});
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
