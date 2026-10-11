import 'dart:convert';

import 'package:billing_and_sales_management/core/errors/client_exception.dart';
import 'package:billing_and_sales_management/data/clients/datasources/remote/client_remote_data_source.dart';
import 'package:billing_and_sales_management/data/clients/models/client_model.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClientRemoteDataSource implements ClientRemoteDataSource {
  FirebaseClientRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'clients';
  static const String _countersCollection = 'counters';
  static const String _counterDocumentId = 'clients';
  static const int _firstClientNumber = 1001;

  CollectionReference<Map<String, dynamic>> get _clients =>
      _firestore.collection(_collection);

  DocumentReference<Map<String, dynamic>> get _counter =>
      _firestore.collection(_countersCollection).doc(_counterDocumentId);

  @override
  Future<List<ClientModel>> getClients() async {
    try {
      final snapshot = await _clients.get();

      final clients = snapshot.docs
          .map(ClientModel.fromFirestore)
          .where((client) => client.name.isNotEmpty)
          .toList();

      clients.sort(
        (a, b) => Client.normalizeName(
          a.name,
        ).compareTo(Client.normalizeName(b.name)),
      );

      return clients;
    } on FirebaseException catch (error) {
      throw ClientException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> addClient(ClientModel client) async {
    final normalizedName = Client.normalizeName(client.name);
    if (normalizedName.isEmpty) {
      throw const ClientException(ClientExceptionCodes.nameRequired);
    }

    final document = _clients.doc(_documentIdFor(normalizedName));

    try {
      await _firestore.runTransaction((transaction) async {
        final counterSnapshot = await transaction.get(_counter);
        final existing = await transaction.get(document);

        if (existing.exists) {
          throw const ClientException(ClientExceptionCodes.nameDuplicate);
        }

        final nextNumber = _nextNumberFrom(counterSnapshot);

        transaction.set(_counter, <String, dynamic>{
          'lastNumber': nextNumber,
        }, SetOptions(merge: true));

        transaction.set(document, <String, dynamic>{
          ...client.toMap(),
          'number': nextNumber,
        });
      });
    } on FirebaseException catch (error) {
      throw ClientException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<int> getNextClientNumber() async {
    try {
      final counterSnapshot = await _counter.get();
      return _nextNumberFrom(counterSnapshot);
    } on FirebaseException catch (error) {
      throw ClientException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  static int _nextNumberFrom(
    DocumentSnapshot<Map<String, dynamic>> counterSnapshot,
  ) {
    final lastNumber =
        (counterSnapshot.data()?['lastNumber'] as num?)?.toInt() ??
        _firstClientNumber - 1;

    return lastNumber + 1;
  }

  static String _documentIdFor(String normalizedName) {
    return base64Url.encode(utf8.encode(normalizedName));
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return ClientExceptionCodes.networkRequestFailed;
      default:
        return ClientExceptionCodes.unknown;
    }
  }
}
