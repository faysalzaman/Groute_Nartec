import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/repositories/sales_order_repository.dart';

import 'sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit({SalesOrderRepository? controller}) : super(SalesInitial());

  Future<void> getSalesOrder(int page, int limit) async {
    emit(SalesLoading());

    try {
      final salesController = SalesOrderRepository();
      final salesOrders = await salesController.getSalesOrders(page, limit);

      if (salesOrders.isNotEmpty) {
        emit(SalesLoaded(salesOrders));
      }
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }

  Future<void> updateStatus(String id, Map<String, dynamic> body) async {
    emit(SalesStatusUpdateLoadingState());

    try {
      final salesController = SalesOrderRepository();
      await salesController.updateStatus(id, body);
      emit(SalesStatusUpdateSuccessState());
    } catch (e) {
      emit(SalesStatusUpdateErrorState(e.toString()));
    }
  }

  Future<void> uploadImage(String id, File image) async {
    emit(SalesOrderAddSignatureLoadingState());

    try {
      final salesController = SalesOrderRepository();
      await salesController.uploadImage(image, id);
      emit(SalesOrderAddSignatureSuccessState());
    } catch (e) {
      emit(SalesOrderAddSignatureErrorState(e.toString()));
    }
  }
}
