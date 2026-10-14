import 'package:billing_and_sales_management/domain/request_forms/entities/request_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestFormModel extends RequestForm {
  const RequestFormModel({
    super.id,
    required super.clientId,
    required super.clientName,
    required super.date,
    required super.startTime,
    required super.endTime,
  });

  factory RequestFormModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return RequestFormModel(
      id: snapshot.id,
      clientId: data['clientId'] as String? ?? '',
      clientName: data['clientName'] as String? ?? '',
      date: data['date'] as String? ?? '',
      startTime: data['startTime'] as String? ?? '',
      endTime: data['endTime'] as String? ?? '',
    );
  }

  factory RequestFormModel.fromEntity(RequestForm requestForm) {
    return RequestFormModel(
      id: requestForm.id,
      clientId: requestForm.clientId,
      clientName: requestForm.clientName,
      date: requestForm.date,
      startTime: requestForm.startTime,
      endTime: requestForm.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientId': clientId,
      'clientName': clientName,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
