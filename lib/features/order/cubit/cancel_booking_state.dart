import 'package:equatable/equatable.dart';

class CancelBookingState extends Equatable {
  final String? selectedReason;
  final String reasonText;

  const CancelBookingState({
    this.selectedReason,
    this.reasonText = '',
  });

  CancelBookingState copyWith({
    String? selectedReason,
    String? reasonText,
  }) {
    return CancelBookingState(
      selectedReason: selectedReason ?? this.selectedReason,
      reasonText: reasonText ?? this.reasonText,
    );
  }

  @override
  List<Object?> get props => [selectedReason, reasonText];
}
