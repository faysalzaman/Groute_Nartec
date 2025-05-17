import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/core/constants/constants.dart';
import 'package:groute_nartec/core/services/http_service.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/bin_location_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/container_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/pallet_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/serial_response_model.dart';
import 'package:groute_nartec/presentation/modules/dashboard/start_day/models/loading/sscc_response_model.dart';
import 'package:groute_nartec/repositories/bin_location_repository.dart';

part 'loading_states.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingInitial());

  static LoadingCubit get(context) => BlocProvider.of(context);

  final BinLocationRepository _binLocationRepository = BinLocationRepository();
  final HttpService _httpService = HttpService(baseUrl: kGTrackUrl);

  SalesInvoiceDetails? salesInvoiceDetails;
  BinLocationModel? selectedBinLocation;
  bool _byPallet = true;
  bool _bySerial = false;

  // Lists
  List<BinLocationModel> _binLocations = [];

  // Maps
  final Map<String, List<Map>> _packagingScanResults = {};

  // Getters
  List<BinLocationModel> get binLocations => _binLocations;
  bool get byPallet => _byPallet;
  bool get bySerial => _bySerial;

  /*
  ##############################################################################
  ! Bin Location Methods
  ##############################################################################
  */
  void setSalesInvoiceDetails(SalesInvoiceDetails details) {
    salesInvoiceDetails = details;
  }

  void getSuggestedBinLocations() async {
    try {
      if (state is BinLocationLoading) return;

      emit(BinLocationLoading());

      _binLocations = await _binLocationRepository.getBinLocations();

      emit(BinLocationLoaded());
    } catch (error) {
      emit(BinLocationError(message: error.toString()));
    }
  }

  void setSelectedBinLocation(String binNumber) {
    selectedBinLocation = binLocations.firstWhere(
      (binLocation) => binLocation.binNumber == binNumber,
    );
    emit(BinLocationLoaded());
  }

  /*
  ##############################################################################
  ! Pick Items Methods
  ##############################################################################
  */

  void setScanType(bool byPallet, bool bySerial) {
    _byPallet = byPallet;
    _bySerial = bySerial;
    print("Scan Type: $_byPallet, $_bySerial");
    emit(ChangeScanType());
  }

  void scanPackagingBySscc({String? palletCode, String? serialNo}) async {
    if (state is ScanItemLoading) {
      return;
    }

    if (palletCode != null) {
      if (palletCode.isEmpty) {
        emit(ScanItemError(message: 'Pallet code is required'));
        return;
      }
    } else if (serialNo != null) {
      if (serialNo.isEmpty) {
        emit(ScanItemError(message: 'Serial number is required'));
        return;
      }
    }
    emit(ScanItemLoading());
    try {
      // check if the ssccNo is already scanned
      if (_packagingScanResults.containsKey(serialNo ?? palletCode)) {
        emit(ScanItemError(message: 'Packaging already scanned'));
        return;
      }

      final path =
          palletCode != null
              ? 'scanPackaging/sscc?ssccNo=$palletCode'
              : 'ssccPackaging/details?serialNo=$serialNo&association=true';

      // call the API
      final response = await _httpService.request(path);

      if (response.success) {
        // If we are scanning by pallet
        if (palletCode != null) {
          if (response.data['level'] == 'container') {
            final containerData = ContainerResponseModel.fromJson(
              response.data,
            );

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_packagingScanResults.containsKey(palletCode)) {
              _packagingScanResults[palletCode] = [];
            }

            for (final pallet in containerData.container.pallets) {
              for (final ssccPackage in pallet.ssccPackages) {
                for (final detail in ssccPackage.details) {
                  _packagingScanResults[palletCode]!.add({
                    "ssccNo": ssccPackage.ssccNo,
                    "description": ssccPackage.description,
                    "memberId": ssccPackage.memberId,
                    "binLocationId": ssccPackage.binLocationId,
                    "masterPackagingId": detail.masterPackagingId,
                    "serialGTIN": detail.serialGTIN,
                    "serialNo": detail.serialNo,
                  });
                }
              }
            }
          } else if (response.data['level'] == 'pallet') {
            final palletData = PalletResponseModel.fromJson(response.data);

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_packagingScanResults.containsKey(palletCode)) {
              _packagingScanResults[palletCode] = [];
            }

            for (final pallet in palletData.pallet.ssccPackages) {
              for (final detail in pallet.details) {
                _packagingScanResults[palletCode]!.add({
                  "ssccNo": pallet.ssccNo,
                  "description": pallet.description,
                  "memberId": pallet.memberId,
                  "binLocationId": pallet.binLocationId,
                  "masterPackagingId": detail.masterPackagingId,
                  "serialGTIN": detail.serialGTIN,
                  "serialNo": detail.serialNo,
                });
              }
            }
          } else if (response.data['level'] == 'sscc') {
            final ssccData = SSCCResponseModel.fromJson(response.data);

            // Initialize an empty list for this ssccNo if it doesn't exist yet
            if (!_packagingScanResults.containsKey(palletCode)) {
              _packagingScanResults[palletCode] = [];
            }

            for (final detail in ssccData.sscc.details) {
              _packagingScanResults[palletCode]!.add({
                "ssccNo": ssccData.sscc.ssccNo,
                "description": ssccData.sscc.description,
                "memberId": ssccData.sscc.memberId,
                "binLocationId": ssccData.sscc.binLocationId,
                "masterPackagingId": detail.masterPackagingId,
                "serialGTIN": detail.serialGTIN,
                "serialNo": detail.serialNo,
              });
            }
          }
        }
        // If we are scanning by serial
        else if (serialNo != null) {
          final serialResponse = SerialResponseModel.fromJson(response.data);
          // Initialize an empty list for this ssccNo if it doesn't exist yet
          if (!_packagingScanResults.containsKey(serialNo)) {
            _packagingScanResults[serialNo] = [];
          }

          for (final item in serialResponse.data.items) {
            _packagingScanResults[serialNo]!.add({
              "ssccNo": item.masterPackaging.ssccNo,
              "description": item.masterPackaging.description,
              "memberId": item.masterPackaging.memberId,
              "binLocationId": item.masterPackaging.binLocationId,
              "masterPackagingId": item.masterPackaging.id,
              "serialGTIN": item.serialGTIN,
              "serialNo": item.serialNo,
            });
          }
        }

        // Emit the loaded state with the scan results for this SSCC
        // emit(PackagingScanLoaded(response: _packagingScanResults));
        emit(ScanItemLoaded());
      } else {
        final errorMessage =
            response.data?['message'] ?? 'Failed to scan packaging';
        emit(ScanItemError(message: errorMessage));
      }
    } catch (error) {
      emit(ScanItemError(message: error.toString()));
    }
  }
}
