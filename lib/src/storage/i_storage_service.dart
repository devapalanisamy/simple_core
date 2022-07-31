abstract class IStorageService {
  Future<void> clearStorage();

  Future<T?> getEncryptedValue<T>({required String key});
  Future<void> setEncryptedValue<T>({required String key, required T value});
}

class StorageConstants {
  static const String unencrypted = 'unencrypted';
  static const String encrypted = 'encrypted';
  static const String secureStorageKey = 'secureKey';
}
