import 'package:billing_and_sales_management/core/errors/invoice_exception.dart';
import 'package:billing_and_sales_management/data/invoices/datasources/remote/invoice_remote_data_source.dart';
import 'package:billing_and_sales_management/data/invoices/models/sales_invoice_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseInvoiceRemoteDataSource implements InvoiceRemoteDataSource {
  FirebaseInvoiceRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  static const String _collection = 'invoices';
  static const String _countersCollection = 'counters';
  static const String _counterDocumentId = 'invoices';
  static const int _firstBillNumber = 1001;

  CollectionReference<Map<String, dynamic>> get _invoices =>
      _firestore.collection(_collection);

  DocumentReference<Map<String, dynamic>> get _counter =>
      _firestore.collection(_countersCollection).doc(_counterDocumentId);

  @override
  Future<List<SalesInvoiceModel>> getInvoices() async {
    try {
      final snapshot = await _invoices.get();

      final invoices = snapshot.docs
          .map(SalesInvoiceModel.fromFirestore)
          .where((invoice) => invoice.billNumber > 0)
          .toList();

      invoices.sort((a, b) => b.billNumber.compareTo(a.billNumber));

      return invoices;
    } on FirebaseException catch (error) {
      throw InvoiceException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<SalesInvoiceModel> addInvoice(SalesInvoiceModel invoice) async {
    final document = _invoices.doc();

    try {
      return await _firestore.runTransaction((transaction) async {
        final counterSnapshot = await transaction.get(_counter);

        final nextNumber = _nextNumberFrom(counterSnapshot);

        transaction.set(_counter, <String, dynamic>{
          'lastNumber': nextNumber,
        }, SetOptions(merge: true));

        final saved = invoice.copyWith(id: document.id, billNumber: nextNumber);

        transaction.set(document, saved.toMap());

        return saved;
      });
    } on FirebaseException catch (error) {
      throw InvoiceException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  @override
  Future<int> getNextBillNumber() async {
    try {
      final counterSnapshot = await _counter.get();
      return _nextNumberFrom(counterSnapshot);
    } on FirebaseException catch (error) {
      throw InvoiceException(mapFirebaseFirestoreErrorCode(error.code));
    }
  }

  static int _nextNumberFrom(
    DocumentSnapshot<Map<String, dynamic>> counterSnapshot,
  ) {
    final lastNumber =
        (counterSnapshot.data()?['lastNumber'] as num?)?.toInt() ??
        _firstBillNumber - 1;

    return lastNumber + 1;
  }

  static String mapFirebaseFirestoreErrorCode(String code) {
    switch (code) {
      case 'unavailable':
      case 'deadline-exceeded':
        return InvoiceExceptionCodes.networkRequestFailed;
      default:
        return InvoiceExceptionCodes.unknown;
    }
  }
}
