import 'package:learnio/base.dart';
import 'package:learnio/script/types/deleted_item.dart';

mixin RecycleBin {
  static void put(Object key, DeletedItemData obj) {
    Data.recycleBin.put(key, obj);
  }

  static T recover<T>(String key) {
    T data = Data.recycleBin.get(key) as T;
    Data.recycleBin.delete(key);
    return data;
  }

  static Iterable<T> getAllDeletedItemByType<T>() {
    return Data.recycleBin.values().whereType<T>();
  }
}
