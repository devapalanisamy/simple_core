import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IFireStoreService {
  Future<bool> addDocument(
    String documentName,
    Map<String, dynamic> data,
  );

  Future<bool> addDocumentToSubCollection(
    String subCollectionName,
    Map<String, dynamic> data,
  );

  Future<Map<String, dynamic>> getDocument(
    String documentName,
    String documentId,
  );
  Future<List<Map<String, dynamic>>> getDocuments(String documentName);

  Stream<QuerySnapshot<Map<String, dynamic>>> getDocumentStream(
    String documentName,
    String documentId,
  );

  Stream<QuerySnapshot<Map<String, dynamic>>> getDocumentsStream(
    String documentName,
  );

  Future<bool> updateDocument(
    String documentName,
    String documentId,
    Map<String, dynamic> data,
  );

  Future<bool> deleteDocument(
    String documentName,
    String documentId,
  );
}
