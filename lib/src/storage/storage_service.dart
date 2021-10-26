import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_core/src/storage/i_storage_service.dart';

class StorageService extends IStorageService {
  @override
  Future<T?> getEncryptedValue<T>(String key) async {
    final List<int> secureKey = await _getSecureKey();
    final Box<T> box = await Hive.openBox(
      StorageConstants.encrypted,
      encryptionCipher: HiveAesCipher(secureKey),
    );
    return box.get(key);
  }

  @override
  Future<T?> getUnencryptedValue<T>(String key) async {
    final Box<T> box = await Hive.openBox(StorageConstants.unencrypted);
    return box.get(key);
  }

  @override
  Future<void> setEncryptedValue<T>(String key, T value) async {
    final List<int> secureKey = await _getSecureKey();
    final Box<T> box = await Hive.openBox(
      StorageConstants.encrypted,
      encryptionCipher: HiveAesCipher(secureKey),
    );
    box.put(key, value);
  }

  @override
  Future<void> setUnencryptedValue<T>(String key, T value) async {
    final Box<T> box = await Hive.openBox(StorageConstants.unencrypted);
    box.put(key, value);
  }

  Future<List<int>> _createNewSecureKey() async {
    final List<int> secureKey = Hive.generateSecureKey();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(
        key: StorageConstants.secureStorageKey, value: json.encode(secureKey));
    return secureKey;
  }

  Future<List<int>> _getSecureKey() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? key =
        await storage.read(key: StorageConstants.secureStorageKey);
    if (key != null) {
      final secureKeyString = json.decode(key);
      return List<int>.from(secureKeyString);
    }
    return await _createNewSecureKey();
  }

  @override
  Future<void> clearStorage() async {
    final List<int> secureKey = await _getSecureKey();
    final Box<void> securedBox = await Hive.openBox(
      StorageConstants.encrypted,
      encryptionCipher: HiveAesCipher(secureKey),
    );
    await securedBox.deleteFromDisk();
    final Box<void> box = await Hive.openBox(StorageConstants.unencrypted);
    box.deleteFromDisk();
    const FlutterSecureStorage storage = FlutterSecureStorage();
    storage.deleteAll();
  }
}

class StorageConstants {
  static const String unencrypted = 'unencrypted';
  static const String encrypted = 'encrypted';
  static const String secureStorageKey = 'secureKey';
}
