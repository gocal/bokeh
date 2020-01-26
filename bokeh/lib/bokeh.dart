library bokeh;

class BlocEvents {
  final String className;
  const BlocEvents({this.className});
}

class BlocStates {
  const BlocStates();
}

class BlocClass {
  final Type state;
  final Type event;

  const BlocClass({this.state, this.event});
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
