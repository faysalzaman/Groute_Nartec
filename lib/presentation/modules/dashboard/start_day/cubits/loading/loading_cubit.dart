import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groute_nartec/presentation/modules/dashboard/sales_order/models/sales_order.dart';

part 'loading_states.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(LoadingInitial());

  static LoadingCubit get(context) => BlocProvider.of(context);

  SalesInvoiceDetails? salesInvoiceDetails;

  // Methods
  void setSalesInvoiceDetails(SalesInvoiceDetails details) {
    salesInvoiceDetails = details;
  }

  void getSuggestedBinLocations() async {}
}
