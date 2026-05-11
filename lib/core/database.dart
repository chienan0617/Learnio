import 'package:learnio/base.dart';

class Database implements Registerable, Initialable {
  final String boxName;
  late final Box _box;

  Database(this.boxName);

  static String transferKey(Object key) {
    return Security.encryption(key).substring(0, 8);
  }

  @override
  Future<void> initialize() async {
    String name = Data.getDatabaseName(boxName);
    _box = await Hive.openBox(name);
    final data = await FileHandle.getRegister(boxName.split('@').last);

    if (data == null) return;

    for (final entry in data.entries) {
      final key = transferKey(entry.key);
      final value = entry.value;

      if (!_box.containsKey(key)) {
        _box.put(key, value);
      }
    }
  }

  bool checkKeyExist(String key, dynamic defaultValue) {
    if (!_box.containsKey(key)) {
      put(key, defaultValue);
      return false;
    }
    return true;
  }

  Future<void> put<E>(Object key, value) async =>
      await _box.put(transferKey(key), value);
  E get<E>(Object key, [dynamic defaultV]) =>
      _box.get(transferKey(key), defaultValue: defaultV) as E;
  void delete<E>(Object key) => _box.delete(transferKey(key));
  Iterable<E> values<E>() => _box.values.cast<E>();
  Iterable<E> whereType<E>() => _box.values.whereType<E>();

  Box getBox() => _box;
}

class LazyDatabase implements Registerable, Initialable {
  final String boxName;
  late final LazyBox _box;

  LazyDatabase(this.boxName);

  static String transferKey(String key) {
    return Security.encryption(key).substring(0, 8);
  }

  @override
  Future<void> initialize() async {
    String name = Data.getDatabaseName(boxName);
    _box = await Hive.openLazyBox(name); // <-- 使用 LazyBox

    final data = await FileHandle.getRegister(boxName.split('@').last);
    if (data == null) return;

    for (final entry in data.entries) {
      final key = transferKey(entry.key);
      final value = entry.value;
      if (!_box.containsKey(key)) {
        await _box.put(key, value);
      }
    }
  }

  Future<bool> checkKeyExist(String key, dynamic defaultValue) async {
    final k = transferKey(key);
    if (!_box.containsKey(k)) {
      await _box.put(k, defaultValue);
      return false;
    }
    return true;
  }

  Future<void> put<E>(String key, E value) => _box.put(transferKey(key), value);

  Future<E?> get<E>(String key) async =>
      (await _box.get(transferKey(key))) as E?;

  Future<void> delete(String key) => _box.delete(transferKey(key));

  Future<List<E>> values<E>() async {
    final out = <E>[];
    for (final k in _box.keys) {
      final v = await _box.get(k) as E?;
      if (v != null) out.add(v);
    }
    return out;
  }

  Future<List<E>> whereType<E>() async {
    final out = <E>[];
    for (final k in _box.keys) {
      final v = await _box.get(k);
      if (v is E) out.add(v);
    }
    return out;
  }

  LazyBox getBox() => _box;
}
