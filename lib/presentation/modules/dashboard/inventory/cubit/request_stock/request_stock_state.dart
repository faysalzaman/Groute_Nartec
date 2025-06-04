part of 'request_stock_cubit.dart';

abstract class RequestStockState {}

final class RequestStockInitial extends RequestStockState {}

// Scan type states
final class RequestStockChangeScanType extends RequestStockState {}

// Scan item states
final class RequestStockScanItemLoading extends RequestStockState {}

final class RequestStockScanItemLoaded extends RequestStockState {}

final class RequestStockScanItemError extends RequestStockState {
  final String message;

  RequestStockScanItemError({required this.message});
}

// Selection states
final class RequestStockSelectionChanged extends RequestStockState {}

// Item states
final class RequestStockItemRemoved extends RequestStockState {}

// Request states
final class RequestStockRequestItemsLoading extends RequestStockState {}

final class RequestStockRequestItemsLoaded extends RequestStockState {}

final class RequestStockRequestItemsError extends RequestStockState {
  final String message;

  RequestStockRequestItemsError({required this.message});
}
