import 'package:billing_and_sales_management/data/request_forms/datasources/remote/request_form_remote_data_source.dart';
import 'package:billing_and_sales_management/data/request_forms/models/request_form_model.dart';
import 'package:billing_and_sales_management/domain/request_forms/entities/request_form.dart';
import 'package:billing_and_sales_management/domain/request_forms/repositories/request_form_repository.dart';

class RequestFormRepositoryImpl implements RequestFormRepository {
  RequestFormRepositoryImpl(this._remoteDataSource);

  final RequestFormRemoteDataSource _remoteDataSource;

  @override
  Future<void> addRequestForm(RequestForm requestForm) {
    return _remoteDataSource.addRequestForm(
      RequestFormModel.fromEntity(requestForm),
    );
  }
}
