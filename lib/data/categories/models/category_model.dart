import 'package:billing_and_sales_management/domain/categories/entities/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel extends Category {
  const CategoryModel({super.id, required super.name, super.notes});

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data() ?? <String, dynamic>{};

    return CategoryModel(
      id: snapshot.id,
      name: data['name'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      notes: category.notes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name, 'notes': notes};
  }
}
