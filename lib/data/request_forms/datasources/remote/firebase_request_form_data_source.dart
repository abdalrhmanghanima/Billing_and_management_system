import 'package:billing_and_sales_management/core/errors/request_form_exception.dart';
import 'package:billing_and_sales_management/data/request_forms/datasources/remote/request_form_remote_data_source.dart';
import 'package:billing_and_sales_management/data/request_forms/models/request_form_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseRequestFormRemoteDataSource
    implements RequestFormRemoteDataSource {
  FirebaseRequestFormRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'request_forms';

  CollectionReference<Map<String, dynamic>> get _requestForms =>
      _firestore.collection(_collection);

  @override
  Future<void> addRequestForm(RequestFormModel requestForm) async {
    try {
      await _requestForms.add(requestForm.toMap());
    } on FirebaseException catch (error) {
      throw RequestFormException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<List<RequestFormModel>> getRequestFormsByClientId(
    String clientId,
  ) async {
    try {
      final snapshot = await _requestForms
          .where('clientId', isEqualTo: clientId)
          .get();

      final requestForms = snapshot.docs
          .map(RequestFormModel.fromFirestore)
          .where((requestForm) => requestForm.clientId.isNotEmpty)
          .toList();

      requestForms.sort((a, b) {
        final byDate = b.date.compareTo(a.date);
        if (byDate != 0) return byDate;
        return b.startTime.compareTo(a.startTime);
      });

      return requestForms;
    } on FirebaseException catch (error) {
      throw RequestFormException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return RequestFormExceptionCodes.networkRequestFailed;
      default:
        return RequestFormExceptionCodes.unknown;
    }
  }
}
