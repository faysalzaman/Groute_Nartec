import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/vehicle_check_model.dart';

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

/*
##############################################################################
! Location Section
############################################################################## 
*/

class LocationLoadingState extends StartDayState {}

class LocationSuccessState extends StartDayState {
  final double latitude;
  final double longitude;

  LocationSuccessState({required this.latitude, required this.longitude});
}

class LocationErrorState extends StartDayState {
  final String error;

  LocationErrorState(this.error);
}

/*
##############################################################################
! Start Picking Section
############################################################################## 
*/

class GS1ProductLoadingState extends StartDayState {}

class GS1ProductSuccessState extends StartDayState {}

class GS1ProductErrorState extends StartDayState {
  final String error;

  GS1ProductErrorState(this.error);
}
