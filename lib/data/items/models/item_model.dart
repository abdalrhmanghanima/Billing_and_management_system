import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel extends Item {
  const ItemModel({
    super.id,
    required super.name,
    required super.companyId,
    required super.companyName,
    required super.typeId,
    required super.typeName,
    required super.sellingPrice,
    required super.buyingPrice,
    super.notes,
  });

  factory ItemModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return ItemModel(
      id: snapshot.id,
      name: data['name'] as String? ?? '',
      companyId: data['companyId'] as String? ?? '',
      companyName: data['companyName'] as String? ?? '',
      typeId: data['typeId'] as String? ?? '',
      typeName: data['typeName'] as String? ?? '',
      sellingPrice: (data['sellingPrice'] as num?)?.toDouble() ?? 0,
      buyingPrice: (data['buyingPrice'] as num?)?.toDouble() ?? 0,
      notes: data['notes'] as String? ?? '',
    );
  }

  factory ItemModel.fromEntity(Item item) {
    return ItemModel(
      id: item.id,
      name: item.name,
      companyId: item.companyId,
      companyName: item.companyName,
      typeId: item.typeId,
      typeName: item.typeName,
      sellingPrice: item.sellingPrice,
      buyingPrice: item.buyingPrice,
      notes: item.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'companyId': companyId,
      'companyName': companyName,
      'typeId': typeId,
      'typeName': typeName,
      'sellingPrice': sellingPrice,
      'buyingPrice': buyingPrice,
      'notes': notes,
    };
  }
}
