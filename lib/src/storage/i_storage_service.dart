abstract class IStorageService {
  Future<T?> getUnencryptedValue<T>(String key);
  Future<T?> getEncryptedValue<T>(String key);
  Future<void> setEncryptedValue<T>(String key, T value);
  Future<void> setUnencryptedValue<T>(String key, T value);
  Future<void> clearStorage();
}
