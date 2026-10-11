import 'dart:convert';

import 'package:billing_and_sales_management/core/errors/unit_exception.dart';
import 'package:billing_and_sales_management/data/units/datasources/remote/unit_remote_data_source.dart';
import 'package:billing_and_sales_management/data/units/models/unit_model.dart';
import 'package:billing_and_sales_management/domain/units/entities/unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUnitRemoteDataSource implements UnitRemoteDataSource {
  FirebaseUnitRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'units';

  CollectionReference<Map<String, dynamic>> get _units =>
      _firestore.collection(_collection);

  @override
  Future<List<UnitModel>> getUnits() async {
    try {
      final snapshot = await _units.get();

      final units = snapshot.docs
          .map(UnitModel.fromFirestore)
          .where((unit) => unit.name.isNotEmpty)
          .toList();

      units.sort(
        (a, b) =>
            Unit.normalizeName(a.name).compareTo(Unit.normalizeName(b.name)),
      );

      return units;
    } on FirebaseException catch (error) {
      throw UnitException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> addUnit(UnitModel unit) async {
    final normalizedName = Unit.normalizeName(unit.name);
    if (normalizedName.isEmpty) {
      throw const UnitException(UnitExceptionCodes.nameRequired);
    }

    final document = _units.doc(_documentIdFor(normalizedName));

    try {
      await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(document);
        if (existing.exists) {
          throw const UnitException(UnitExceptionCodes.nameDuplicate);
        }

        transaction.set(document, unit.toMap());
      });
    } on FirebaseException catch (error) {
      throw UnitException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  static String _documentIdFor(String normalizedName) {
    return base64Url.encode(utf8.encode(normalizedName));
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return UnitExceptionCodes.networkRequestFailed;
      default:
        return UnitExceptionCodes.unknown;
    }
  }
}
