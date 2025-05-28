part of 'loading_cubit.dart';

abstract class LoadingState {}

final class LoadingInitial extends LoadingState {}

// Bin location states
final class BinLocationLoading extends LoadingState {}

final class BinLocationLoaded extends LoadingState {}

final class BinLocationError extends LoadingState {
  final String message;

  BinLocationError({required this.message});
}

// Pick items states
final class ChangeScanType extends LoadingState {}

final class ScanItemLoading extends LoadingState {}

final class ScanItemLoaded extends LoadingState {}

final class ScanItemError extends LoadingState {
  final String message;

  ScanItemError({required this.message});
}

final class PickItemsLoading extends LoadingState {}

final class PickItemsLoaded extends LoadingState {}

final class PickItemsError extends LoadingState {
  final String message;

  PickItemsError({required this.message});
}

final class ScanBinLocationLoading extends LoadingState {}

final class ScanBinLocationLoaded extends LoadingState {
  final String message;

  ScanBinLocationLoaded({required this.message});
}

final class ScanBinLocationError extends LoadingState {
  final String message;

  ScanBinLocationError({required this.message});
}

// Selection states
final class SelectionChanged extends LoadingState {}

// Item states
final class ItemRemoved extends LoadingState {}
