import 'package:flutter_bloc/flutter_bloc.dart';
import 'cancel_booking_state.dart';

class CancelBookingCubit extends Cubit<CancelBookingState> {
  CancelBookingCubit() : super(const CancelBookingState());

  void selectReason(String reason) {
    emit(state.copyWith(selectedReason: reason));
  }

  void updateReasonText(String text) {
    emit(state.copyWith(reasonText: text));
  }

  bool get isReasonValid =>
      state.selectedReason != null || state.reasonText.isNotEmpty;
}
