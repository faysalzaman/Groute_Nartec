import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubit/start_day_state.dart';
import 'package:groute_nartec/repositories/start_day_repository.dart';

class StartDayCubit extends Cubit<StartDayState> {
  StartDayCubit() : super(StartDayInitialState());

  final StartDayRepository _startDayRepository = StartDayRepository();

  Future<void> checkVehicle(
    File photo,
    String vehicleId,
    String tyresCondition,
    String aCCondition,
    String petrolLevel,
    String engineCondition,
    String odoMeterReading,
  ) async {
    print("Photo: ${photo.path}");
    print("Vehicle ID: $vehicleId");
    print("Tyres Condition: $tyresCondition");
    print("AC Condition: $aCCondition");
    print("Petrol Level: $petrolLevel");
    print("Engine Condition: $engineCondition");
    print("Odo Meter Reading: $odoMeterReading");

    emit(VehicleCheckLoadingState());

    try {
      await _startDayRepository.uploadPhotoAndSubmitDriverCondition(
        photo,
        vehicleId,
        tyresCondition,
        aCCondition,
        petrolLevel,
        engineCondition,
        odoMeterReading,
      );
      emit(VehicleCheckSuccessState());
    } catch (e) {
      print(e);
      emit(VehicleCheckErrorState(e.toString()));
    }
  }
}
