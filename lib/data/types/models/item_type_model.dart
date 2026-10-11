import 'package:billing_and_sales_management/domain/types/entities/item_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemTypeModel extends ItemType {
  const ItemTypeModel({
    super.id,
    required super.name,
    required super.companyId,
    required super.companyName,
    super.notes,
  });

  factory ItemTypeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return ItemTypeModel(
      id: snapshot.id,
      name: data['name'] as String? ?? '',
      companyId: data['companyId'] as String? ?? '',
      companyName: data['companyName'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
    );
  }

  factory ItemTypeModel.fromEntity(ItemType type) {
    return ItemTypeModel(
      id: type.id,
      name: type.name,
      companyId: type.companyId,
      companyName: type.companyName,
      notes: type.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'companyId': companyId,
      'companyName': companyName,
      'notes': notes,
    };
  }
}
