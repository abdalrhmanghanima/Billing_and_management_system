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

  CollectionReference<Map<String, dynamic>> get _companies =>
      _firestore.collection(_collection);

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
