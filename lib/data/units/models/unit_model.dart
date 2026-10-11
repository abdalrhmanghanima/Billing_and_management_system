import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billing_and_sales_management/domain/units/entities/unit.dart';

class UnitModel extends Unit {
  const UnitModel({super.id, required super.name, super.notes});

  factory UnitModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return UnitModel(
      id: snapshot.id,
      name: data['name'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
    );
  }

  factory UnitModel.fromEntity(Unit unit) {
    return UnitModel(id: unit.id, name: unit.name, notes: unit.notes);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'notes': notes};
  }
}
