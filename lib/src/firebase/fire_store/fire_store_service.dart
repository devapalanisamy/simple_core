import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/src/firebase/fire_store/i_fire_store_service.dart';
import 'package:core/src/logger/custom_logger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FireStoreService extends IFireStoreService {
  final Logger _logger = getLogger();
  @override
  Future<bool> addDocument(
    String documentName,
    Map<String, dynamic> data,
  ) async {
    try {
      final DocumentReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance
              .collection(documentName)
              .doc(FirebaseAuth.instance.currentUser!.uid);
      await collectionReference.set(data);
      return true;
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> addDocumentToSubCollection(
    String subCollectionName,
    Map<String, dynamic> data,
  ) async {
    try {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(subCollectionName);
      final DocumentReference<Object?> result =
          await collectionReference.add(data);
      return result.id.isNotEmpty;
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> deleteDocument(String documentName, String documentId) async {
    try {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection(documentName);
      await collectionReference.doc(documentId).delete();
      return true;
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getDocument(
    String documentName,
    String documentId,
  ) async {
    try {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection(documentName);
      final DocumentSnapshot<Object?> result =
          await collectionReference.doc(documentId).get();
      return result.data() as Map<String, dynamic>? ?? <String, dynamic>{};
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getDocuments(String documentName) async {
    try {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(documentName);
      final QuerySnapshot<Map<String, dynamic>> result =
          await collectionReference.get();
      return result.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot) =>
                documentSnapshot.data(),
          )
          .toList();
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<bool> updateDocument(
    String documentName,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance.collection(documentName);
      await collectionReference.doc(documentId).update(data);
      return true;
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getDocumentStream(
    String documentName,
    String documentId,
  ) {
    try {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(documentName);
      final Stream<QuerySnapshot<Map<String, dynamic>>> result =
          collectionReference.snapshots();

      return result;
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getDocumentsStream(
    String documentName,
  ) {
    try {
      final CollectionReference<Map<String, dynamic>> collectionReference =
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(documentName);
      final Stream<QuerySnapshot<Map<String, dynamic>>> result =
          collectionReference.snapshots(includeMetadataChanges: true);
      return result;
    } on Exception catch (e) {
      _logger.e(e.toString());
      rethrow;
    }
  }
}
