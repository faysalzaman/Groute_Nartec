import 'package:groute_nartec/view/screens/dashboard/sales_order/models/sales_order.dart';

class SalesState {}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesLoaded extends SalesState {
  final List<SalesOrderModel> salesOrders;

  SalesLoaded(this.salesOrders);
}

class SalesError extends SalesState {
  final String error;

  SalesError(this.error);
}
