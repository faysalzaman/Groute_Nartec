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

// Bin location states

class BinLocationLoading extends SalesState {}

class BinLocationLoaded extends SalesState {}

class BinLocationError extends SalesState {
  final String message;

  BinLocationError({required this.message});
}

// Unloading items states
class ChangeScanType extends SalesState {}

class ScanItemLoading extends SalesState {}

class ScanItemLoaded extends SalesState {}

class ScanItemError extends SalesState {
  final String message;
  ScanItemError({required this.message});
}

class ScanBinLocationLoading extends SalesState {}

class ScanBinLocationLoaded extends SalesState {
  final String message;
  ScanBinLocationLoaded({required this.message});
}

class ScanBinLocationError extends SalesState {
  final String message;
  ScanBinLocationError({required this.message});
}

// Unloading items states

class UnloadItemsLoading extends SalesState {}

class UnloadItemsLoaded extends SalesState {}

class UnloadItemsError extends SalesState {
  final String message;
  UnloadItemsError({required this.message});
}

// Selection states
class SelectionChanged extends SalesState {}

// Item states
class ItemRemoved extends SalesState {}

// #################### Sales Invoice Details ####################

class ProductUpdateLoading extends SalesState {}

class ProductUpdateLoaded extends SalesState {}

class ProductUpdateError extends SalesState {
  final String message;
  ProductUpdateError({required this.message});
}

class SalesInvoiceDetailsLoading extends SalesState {}

class SalesInvoiceDetailsLoaded extends SalesState {
  final List<SalesInvoiceDetails> salesInvoiceDetails;

  SalesInvoiceDetailsLoaded(this.salesInvoiceDetails);
}

class SalesInvoiceDetailsError extends SalesState {
  final String message;

  SalesInvoiceDetailsError({required this.message});
}
