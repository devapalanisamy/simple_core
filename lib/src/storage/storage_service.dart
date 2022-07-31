import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_core/simple_core.dart';

class StorageService extends IStorageService {
  @override
  Future<void> clearStorage() async {
    final List<int> secureKey = await _getSecureKey();
    final Box<bool?> securedBox = await Hive.openBox<bool?>(
      StorageConstants.encrypted,
      encryptionCipher: HiveAesCipher(secureKey),
    );
    await securedBox.deleteFromDisk();
    final Box<void> box = await Hive.openBox(StorageConstants.unencrypted);
    box.deleteFromDisk();
    const FlutterSecureStorage storage = FlutterSecureStorage();
    storage.deleteAll();
  }

  @override
  Future<T?> getEncryptedValue<T>({required String key}) async {
    final List<int> secureKey = await _getSecureKey();
    final Box<T> box = await Hive.openBox<T>(
      StorageConstants.encrypted + T.toString(),
      encryptionCipher: HiveAesCipher(secureKey),
    );
    return box.get(key);
  }

  @override
  Future<void> setEncryptedValue<T>({required String key, required T value}) async {
    final List<int> secureKey = await _getSecureKey();
    final Box<T> box = await Hive.openBox<T>(
      StorageConstants.encrypted + T.toString(),
      encryptionCipher: HiveAesCipher(secureKey),
    );
    box.put(key, value);
  }

  Future<List<int>> _createNewSecureKey() async {
    final List<int> secureKey = Hive.generateSecureKey();
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.write(key: StorageConstants.secureStorageKey, value: json.encode(secureKey));
    return secureKey;
  }

  Future<List<int>> _getSecureKey() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final String? key = await storage.read(key: StorageConstants.secureStorageKey);
    if (key != null) {
      final List<dynamic> secureKeyString = json.decode(key) as List<dynamic>;
      return List<int>.from(secureKeyString);
    }
    return _createNewSecureKey();
  }
}
