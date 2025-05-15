import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';

class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoadingMore extends SalesState {}

class SalesLoaded extends SalesState {
  final List<SalesOrderModel> salesOrders;

  SalesLoaded(this.salesOrders);
}

class SalesError extends SalesState {
  final String error;

  SalesError(this.error);
}

class SalesStatusUpdateLoadingState extends SalesState {}

class SalesStatusUpdateSuccessState extends SalesState {}

class SalesStatusUpdateErrorState extends SalesState {
  final String error;

  SalesStatusUpdateErrorState(this.error);
}

class SalesOrderAddSignatureLoadingState extends SalesState {}

class SalesOrderAddSignatureSuccessState extends SalesState {}

class SalesOrderAddSignatureErrorState extends SalesState {
  final String error;

  SalesOrderAddSignatureErrorState(this.error);
}

class SalesOrderUploadImageLoading extends SalesState {}

class SalesOrderUploadImageSuccess extends SalesState {}

class SalesOrderUploadImageError extends SalesState {
  final String error;

  SalesOrderUploadImageError(this.error);
}
