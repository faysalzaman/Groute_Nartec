import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';

enum LoadingState {
  initial,
  // Bin location
  binLocationLoading,
  binLocationLoaded,
  binLocationError,
}

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingState.initial);

  static LoadingCubit get(context) => BlocProvider.of(context);

  SalesInvoiceDetails? salesInvoiceDetails;

  // Methods
  void setSalesInvoiceDetails(SalesInvoiceDetails details) {
    salesInvoiceDetails = details;
  }

  void getSuggestedBinLocations() async {}
}
