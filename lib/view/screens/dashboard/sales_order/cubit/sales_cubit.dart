import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/controller/sales_controller.dart';
import 'package:groute_nartec/view/screens/dashboard/sales_order/cubit/sales_state.dart';

class SalesCubit extends Cubit<SalesState> {
  SalesCubit({SalesController? controller}) : super(SalesInitial());

  Future<void> getSalesOrder(int page, int limit) async {
    emit(SalesLoading());

    try {
      final salesController = SalesController();
      final salesOrders = await salesController.getSalesOrders(page, limit);

      if (salesOrders.isNotEmpty) {
        emit(SalesLoaded(salesOrders));
      }
    } catch (e) {
      emit(SalesError(e.toString()));
    }
  }
}
