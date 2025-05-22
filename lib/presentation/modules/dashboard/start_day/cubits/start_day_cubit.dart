import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/start_day_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';
import 'package:groute_nartec/repositories/product_repository.dart';
import 'package:groute_nartec/repositories/start_day_repository.dart';

class StartDayCubit extends Cubit<StartDayState> {
  StartDayCubit() : super(StartDayInitialState());

  final StartDayRepository _startDayRepository = StartDayRepository();
  final Gs1Repository _gs1Repository = Gs1Repository();

  Product? product;

  Future<void> getVehicleCheckHistory() async {
    emit(VehicleCheckHistoryLoading());

    try {
      final vehicleCheckHistory =
          await _startDayRepository.getVehicleCheckHistory();
      emit(VehicleCheckHistorySuccess(vehicleCheckHistory));
    } catch (e) {
      emit(VehicleCheckHistoryError(e.toString()));
    }
  }

  Future<void> checkVehicle(
    List<File> photo,
    String vehicleId,
    String tyresCondition,
    String aCCondition,
    String petrolLevel,
    String engineCondition,
    String odoMeterReading,
    String remarks,
  ) async {
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
        remarks,
      );
      emit(VehicleCheckSuccessState());
    } catch (e) {
      emit(VehicleCheckErrorState(e.toString()));
    }
  }

  /*
  ##############################################################################
  ! Start Picking Section
  ############################################################################## 
  */

  Future<void> getGS1ProductDetails(String barcode) async {
    emit(GS1ProductLoadingState());

    try {
      product = await _gs1Repository.getProductById(barcode);
      emit(GS1ProductSuccessState());
    } catch (e) {
      emit(GS1ProductErrorState(e.toString()));
    }
  }
}
