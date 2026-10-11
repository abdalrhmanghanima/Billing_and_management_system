import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel extends Client {
  const ClientModel({
    super.id,
    required super.number,
    required super.name,
    required super.phone,
    required super.address,
  });

  factory ClientModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return ClientModel(
      id: snapshot.id,
      number: (data['number'] as num?)?.toInt() ?? 0,
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
    );
  }

  factory ClientModel.fromEntity(Client client) {
    return ClientModel(
      id: client.id,
      number: client.number,
      name: client.name,
      phone: client.phone,
      address: client.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'name': name,
      'phone': phone,
      'address': address,
    };
  }
}
