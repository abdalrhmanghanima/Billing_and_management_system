import 'package:billing_and_sales_management/domain/request_forms/entities/request_form.dart';

class RequestFormModel extends RequestForm {
  const RequestFormModel({
    super.id,
    required super.employeeName,
    required super.date,
    required super.startTime,
    required super.endTime,
  });

  factory RequestFormModel.fromEntity(RequestForm requestForm) {
    return RequestFormModel(
      id: requestForm.id,
      employeeName: requestForm.employeeName,
      date: requestForm.date,
      startTime: requestForm.startTime,
      endTime: requestForm.endTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'employeeName': employeeName,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
