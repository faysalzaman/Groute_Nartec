import 'package:groute_nartec/presentation/modules/dashboard/start_day/model/vehicle_check_model.dart';

class StartDayState {}

class StartDayInitialState extends StartDayState {}

class VehicleCheckLoadingState extends StartDayState {}

class VehicleCheckSuccessState extends StartDayState {}

class VehicleCheckErrorState extends StartDayState {
  final String error;

  VehicleCheckErrorState(this.error);
}

class VehicleCheckHistoryLoading extends StartDayState {}

class VehicleCheckHistorySuccess extends StartDayState {
  final VehicleCheckModel vehicleCheckHistory;

  VehicleCheckHistorySuccess(this.vehicleCheckHistory);
}

class VehicleCheckHistoryError extends StartDayState {
  final String error;

  VehicleCheckHistoryError(this.error);
}
