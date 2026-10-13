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
  static const String _itemsCollection = 'items';
  static const int _maxTransactionWrites = 500;

  CollectionReference<Map<String, dynamic>> get _types =>
      _firestore.collection(_collection);

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(_itemsCollection);

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
    final renamesDocument = newId != oldId;

    try {
      var itemIds = const <String>[];
      var cascadeReferences = renamesDocument;

      if (renamesDocument) {
        itemIds = await _itemIdsReferencing(oldId);
      } else {
        final storedName = await _storedName(oldId);
        if (storedName == null) {
          throw const TypeException(TypeExceptionCodes.notFound);
        }
        cascadeReferences = storedName != type.name;
        if (cascadeReferences) {
          itemIds = await _itemIdsReferencing(oldId);
        }
      }

      final writeCount = itemIds.length + (renamesDocument ? 2 : 1);
      if (writeCount > _maxTransactionWrites) {
        throw const TypeException(TypeExceptionCodes.tooManyReferences);
      }

      await _firestore.runTransaction((transaction) async {
        final oldDocument = _types.doc(oldId);
        final oldSnapshot = await transaction.get(oldDocument);
        if (!oldSnapshot.exists) {
          throw const TypeException(TypeExceptionCodes.notFound);
        }

        if (renamesDocument) {
          final newDocument = _types.doc(newId);
          final newSnapshot = await transaction.get(newDocument);
          if (newSnapshot.exists) {
            throw const TypeException(TypeExceptionCodes.nameDuplicate);
          }

          transaction.delete(oldDocument);
          transaction.set(newDocument, type.toMap());
        } else {
          transaction.set(oldDocument, type.toMap());
        }

        if (!cascadeReferences) return;

        final referenceUpdates = <String, dynamic>{
          'typeName': type.name,
          if (renamesDocument) 'typeId': newId,
        };

        for (final itemId in itemIds) {
          transaction.update(_items.doc(itemId), referenceUpdates);
        }
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

  Future<String?> _storedName(String id) async {
    final snapshot = await _types.doc(id).get();
    if (!snapshot.exists) return null;
    return snapshot.data()?['name'] as String?;
  }

  Future<List<String>> _itemIdsReferencing(String typeId) async {
    final snapshot = await _items.where('typeId', isEqualTo: typeId).get();
    return snapshot.docs.map((doc) => doc.id).toList();
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
