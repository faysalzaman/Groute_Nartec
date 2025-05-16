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
