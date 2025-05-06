class StartDayState {}

class StartDayInitialState extends StartDayState {}

class VehicleCheckLoadingState extends StartDayState {}

class VehicleCheckSuccessState extends StartDayState {}

class VehicleCheckErrorState extends StartDayState {
  final String error;

  VehicleCheckErrorState(this.error);
}
