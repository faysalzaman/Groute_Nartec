import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/cubits/start_day/start_day_state.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/gs1_product.dart';
import 'package:groute_nartec/repositories/driver_repository.dart';
import 'package:groute_nartec/repositories/product_repository.dart';
import 'package:groute_nartec/repositories/start_day_repository.dart';

class StartDayCubit extends Cubit<StartDayState> {
  StartDayCubit() : super(StartDayInitialState());

  final StartDayRepository _startDayRepository = StartDayRepository();
  final Gs1Repository _gs1Repository = Gs1Repository();
  final DriverRepositry _driverRepository = DriverRepositry();

  Product? product;
  double? latitude;
  double? longitude;

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<void> getCurrentLocation() async {
    emit(LocationLoadingState());

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(LocationErrorState('Location services are disabled.'));
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationErrorState('Location permissions are denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          LocationErrorState(
            'Location permissions are permanently denied, we cannot request permissions.',
          ),
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude = position.latitude;
      longitude = position.longitude;

      emit(LocationSuccessState(latitude: latitude!, longitude: longitude!));
    } catch (e) {
      emit(LocationErrorState(e.toString()));
    }
  }

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
      // Get current location if not already available
      if (latitude == null || longitude == null) {
        await getCurrentLocation();
        // If location retrieval failed, stop the process
        if (latitude == null || longitude == null) {
          emit(VehicleCheckErrorState('Failed to get location'));
          return;
        }
      }

      await _startDayRepository.uploadPhotoAndSubmitDriverCondition(
        photo,
        vehicleId,
        tyresCondition,
        aCCondition,
        petrolLevel,
        engineCondition,
        odoMeterReading,
        remarks,
        latitude!,
        longitude!,
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

  /*
##############################################################################
! View Assigned Route Section
############################################################################## 
*/

  Future<void> fetchViewAssignedRoute() async {
    emit(ViewAssignedRouteLoading());

    try {
      final assignedRoute = await _driverRepository.fetchViewAssignedRoute();

      emit(ViewAssignedRouteSuccess(assignedRoute));
    } catch (e) {
      emit(ViewAssignedRouteError(e.toString()));
    }
  }
}
