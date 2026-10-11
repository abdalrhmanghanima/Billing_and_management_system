import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billing_and_sales_management/domain/companies/entities/company.dart';

class CompanyModel extends Company {
  const CompanyModel({super.id, required super.name, super.notes});

  factory CompanyModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return CompanyModel(
      id: snapshot.id,
      name: data['name'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
    );
  }

  factory CompanyModel.fromEntity(Company company) {
    return CompanyModel(
      id: company.id,
      name: company.name,
      notes: company.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'notes': notes};
  }
}
