import 'dart:convert';

import 'package:billing_and_sales_management/core/errors/type_exception.dart';
import 'package:billing_and_sales_management/data/types/datasources/remote/type_remote_data_source.dart';
import 'package:billing_and_sales_management/data/types/models/item_type_model.dart';
import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTypeRemoteDataSource implements TypeRemoteDataSource {
  FirebaseTypeRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'types';

  CollectionReference<Map<String, dynamic>> get _types =>
      _firestore.collection(_collection);

  @override
  Future<List<ItemTypeModel>> getTypes() async {
    try {
      final snapshot = await _types.get();

      final types = snapshot.docs
          .map(ItemTypeModel.fromFirestore)
          .where((type) => type.name.isNotEmpty)
          .toList();

      types.sort(
        (a, b) => ItemType.normalizeName(
          a.name,
        ).compareTo(ItemType.normalizeName(b.name)),
      );

      return types;
    } on FirebaseException catch (error) {
      throw TypeException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> addType(ItemTypeModel type) async {
    final normalizedName = ItemType.normalizeName(type.name);
    if (normalizedName.isEmpty) {
      throw const TypeException(TypeExceptionCodes.nameRequired);
    }

    final document = _types.doc(_documentIdFor(normalizedName));

    try {
      await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(document);
        if (existing.exists) {
          throw const TypeException(TypeExceptionCodes.nameDuplicate);
        }

        transaction.set(document, type.toMap());
      });
    } on FirebaseException catch (error) {
      throw TypeException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> updateType(ItemTypeModel type) async {
    final normalizedName = ItemType.normalizeName(type.name);
    if (normalizedName.isEmpty) {
      throw const TypeException(TypeExceptionCodes.nameRequired);
    }

    final oldId = type.id;
    if (oldId.isEmpty) {
      throw const TypeException(TypeExceptionCodes.notFound);
    }

    final newId = _documentIdFor(normalizedName);

    try {
      await _firestore.runTransaction((transaction) async {
        final oldDocument = _types.doc(oldId);
        final oldSnapshot = await transaction.get(oldDocument);
        if (!oldSnapshot.exists) {
          throw const TypeException(TypeExceptionCodes.notFound);
        }

        if (newId == oldId) {
          transaction.set(oldDocument, type.toMap());
          return;
        }

        final newDocument = _types.doc(newId);
        final newSnapshot = await transaction.get(newDocument);
        if (newSnapshot.exists) {
          throw const TypeException(TypeExceptionCodes.nameDuplicate);
        }

        transaction.delete(oldDocument);
        transaction.set(newDocument, type.toMap());
      });
    } on FirebaseException catch (error) {
      throw TypeException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> deleteType(String id) async {
    if (id.isEmpty) {
      throw const TypeException(TypeExceptionCodes.notFound);
    }

    try {
      await _firestore.runTransaction((transaction) async {
        final document = _types.doc(id);
        final snapshot = await transaction.get(document);
        if (!snapshot.exists) {
          throw const TypeException(TypeExceptionCodes.notFound);
        }

        transaction.delete(document);
      });
    } on FirebaseException catch (error) {
      throw TypeException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  static String _documentIdFor(String normalizedName) {
    return base64Url.encode(utf8.encode(normalizedName));
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return TypeExceptionCodes.networkRequestFailed;
      default:
        return TypeExceptionCodes.unknown;
    }
  }
}
