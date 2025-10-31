import 'package:event_planning_app/core/utils/theme/app_colors.dart';
import 'package:event_planning_app/core/utils/utils/app_string.dart';
import 'package:event_planning_app/features/booking/view/widget/booking_appbar.dart';
import 'package:event_planning_app/features/booking/view/widget/booking_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_planning_app/features/booking/cubit/booking_cubit.dart';
import 'package:event_planning_app/features/booking/cubit/booking_state.dart';

class BookingScreenBody extends StatelessWidget {
  const BookingScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<BookingCubit>().streamBusinessBookings();

    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      appBar: const BookingAppBar(),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingSuccess) {
            if (state.bookings.isEmpty) {
              return const Center(child: Text(AppString.noBooking));
            }
            return BookingListView(bookings: state.bookings);
          } else if (state is BookingFailure) {
            return Center(child: Text(state.error));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
