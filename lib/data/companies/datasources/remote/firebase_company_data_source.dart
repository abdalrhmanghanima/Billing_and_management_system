import 'dart:convert';

import 'package:billing_and_sales_management/core/errors/company_exception.dart';
import 'package:billing_and_sales_management/data/companies/datasources/remote/company_remote_data_source.dart';
import 'package:billing_and_sales_management/data/companies/models/company_model.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCompanyRemoteDataSource implements CompanyRemoteDataSource {
  FirebaseCompanyRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'companies';
  static const String _typesCollection = 'types';
  static const String _itemsCollection = 'items';
  static const int _maxTransactionWrites = 500;

  CollectionReference<Map<String, dynamic>> get _companies =>
      _firestore.collection(_collection);

  CollectionReference<Map<String, dynamic>> get _types =>
      _firestore.collection(_typesCollection);

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection(_itemsCollection);

  @override
  Future<List<CompanyModel>> getCompanies() async {
    try {
      final snapshot = await _companies.get();

      final companies = snapshot.docs
          .map(CompanyModel.fromFirestore)
          .where((company) => company.name.isNotEmpty)
          .toList();

      companies.sort(
        (a, b) => Company.normalizeName(
          a.name,
        ).compareTo(Company.normalizeName(b.name)),
      );

      return companies;
    } on FirebaseException catch (error) {
      throw CompanyException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> addCompany(CompanyModel company) async {
    final normalizedName = Company.normalizeName(company.name);
    if (normalizedName.isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.nameRequired);
    }

    final document = _companies.doc(_documentIdFor(normalizedName));

    try {
      await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(document);
        if (existing.exists) {
          throw const CompanyException(CompanyExceptionCodes.nameDuplicate);
        }

        transaction.set(document, company.toMap());
      });
    } on FirebaseException catch (error) {
      throw CompanyException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> updateCompany(CompanyModel company) async {
    final normalizedName = Company.normalizeName(company.name);
    if (normalizedName.isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.nameRequired);
    }

    final oldId = company.id;
    if (oldId.isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.notFound);
    }

    final newId = _documentIdFor(normalizedName);
    final renamesDocument = newId != oldId;

    try {
      var typeIds = const <String>[];
      var itemIds = const <String>[];
      var cascadeReferences = renamesDocument;

      if (renamesDocument) {
        typeIds = await _typeIdsReferencing(oldId);
        itemIds = await _itemIdsReferencing(oldId);
      } else {
        final storedName = await _storedName(oldId);
        if (storedName == null) {
          throw const CompanyException(CompanyExceptionCodes.notFound);
        }
        cascadeReferences = storedName != company.name;
        if (cascadeReferences) {
          typeIds = await _typeIdsReferencing(oldId);
          itemIds = await _itemIdsReferencing(oldId);
        }
      }

      final writeCount =
          typeIds.length + itemIds.length + (renamesDocument ? 2 : 1);
      if (writeCount > _maxTransactionWrites) {
        throw const CompanyException(CompanyExceptionCodes.tooManyReferences);
      }

      await _firestore.runTransaction((transaction) async {
        final oldDocument = _companies.doc(oldId);
        final oldSnapshot = await transaction.get(oldDocument);
        if (!oldSnapshot.exists) {
          throw const CompanyException(CompanyExceptionCodes.notFound);
        }

        if (renamesDocument) {
          final newDocument = _companies.doc(newId);
          final newSnapshot = await transaction.get(newDocument);
          if (newSnapshot.exists) {
            throw const CompanyException(CompanyExceptionCodes.nameDuplicate);
          }

          transaction.delete(oldDocument);
          transaction.set(newDocument, company.toMap());
        } else {
          transaction.set(oldDocument, company.toMap());
        }

        if (!cascadeReferences) return;

        final referenceUpdates = <String, dynamic>{
          'companyName': company.name,
          if (renamesDocument) 'companyId': newId,
        };

        for (final typeId in typeIds) {
          transaction.update(_types.doc(typeId), referenceUpdates);
        }
        for (final itemId in itemIds) {
          transaction.update(_items.doc(itemId), referenceUpdates);
        }
      });
    } on FirebaseException catch (error) {
      throw CompanyException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<void> deleteCompany(String id) async {
    if (id.isEmpty) {
      throw const CompanyException(CompanyExceptionCodes.notFound);
    }

    try {
      await _firestore.runTransaction((transaction) async {
        final document = _companies.doc(id);
        final snapshot = await transaction.get(document);
        if (!snapshot.exists) {
          throw const CompanyException(CompanyExceptionCodes.notFound);
        }

        transaction.delete(document);
      });
    } on FirebaseException catch (error) {
      throw CompanyException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  Future<String?> _storedName(String id) async {
    final snapshot = await _companies.doc(id).get();
    if (!snapshot.exists) return null;
    return snapshot.data()?['name'] as String?;
  }

  Future<List<String>> _typeIdsReferencing(String companyId) async {
    final snapshot = await _types
        .where('companyId', isEqualTo: companyId)
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> _itemIdsReferencing(String companyId) async {
    final snapshot = await _items
        .where('companyId', isEqualTo: companyId)
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  static String _documentIdFor(String normalizedName) {
    return base64Url.encode(utf8.encode(normalizedName));
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return CompanyExceptionCodes.networkRequestFailed;
      default:
        return CompanyExceptionCodes.unknown;
    }
  }
}
