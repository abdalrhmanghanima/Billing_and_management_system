class RequestForm {
  const RequestForm({
    this.id = '',
    required this.employeeName,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final String employeeName;
  final String date;
  final String startTime;
  final String endTime;
}
