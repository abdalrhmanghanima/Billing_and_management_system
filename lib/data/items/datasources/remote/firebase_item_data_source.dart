import 'dart:convert';

import 'package:billing_and_sales_management/core/errors/item_exception.dart';
import 'package:billing_and_sales_management/data/items/datasources/remote/item_remote_data_source.dart';
import 'package:billing_and_sales_management/data/items/models/item_model.dart';
import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseItemRemoteDataSource implements ItemRemoteDataSource {
  FirebaseItemRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'items';

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(_collection);

  @override
  Future<List<ItemModel>> getItems() async {
    try {
      final snapshot = await _items.get();

      final items = snapshot.docs
          .map(ItemModel.fromFirestore)
          .where((item) => item.name.isNotEmpty)
          .toList();

      items.sort(
        (a, b) =>
            Item.normalizeName(a.name).compareTo(Item.normalizeName(b.name)),
      );

      return items;
    } on FirebaseException catch (error) {
      throw ItemException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> addItem(ItemModel item) async {
    final normalizedName = Item.normalizeName(item.name);
    if (normalizedName.isEmpty) {
      throw const ItemException(ItemExceptionCodes.nameRequired);
    }

    final document = _items.doc(_documentIdFor(normalizedName));

    try {
      await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(document);
        if (existing.exists) {
          throw const ItemException(ItemExceptionCodes.nameDuplicate);
        }

        transaction.set(document, item.toMap());
      });
    } on FirebaseException catch (error) {
      throw ItemException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  static String _documentIdFor(String normalizedName) {
    return base64Url.encode(utf8.encode(normalizedName));
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return ItemExceptionCodes.networkRequestFailed;
      default:
        return ItemExceptionCodes.unknown;
    }
  }
}
