class RequestForm {
  const RequestForm({
    this.id = '',
    required this.clientId,
    required this.clientName,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final String id;
  final String clientId;
  final String clientName;
  final String date;
  final String startTime;
  final String endTime;
}
