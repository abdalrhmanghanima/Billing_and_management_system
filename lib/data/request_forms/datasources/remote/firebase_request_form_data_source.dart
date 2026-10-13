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
