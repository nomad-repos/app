

abstract class KeyValueStorageServices{

  Future<void> setKeyValue<T>(String key, T value);
  Future<bool> deleteKeyValue(String key);
  Future<T?> getValue<T>(String key);

}