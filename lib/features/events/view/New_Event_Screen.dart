import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'event_widgets/custom_field.dart';
import 'event_widgets/custom_field_with_icon.dart';
import 'event_widgets/custom_submit_button.dart';
import 'event_widgets/file_upload.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({super.key});

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final List<DateTime?>? picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: [DateTime.now()],
      borderRadius: BorderRadius.circular(15),
    );
    if (picked != null && picked.isNotEmpty && picked.first != null) {
      final selected = picked.first!;
      dateController.text = "${selected.day}-${selected.month}-${selected.year}";
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      timeController.text =
      "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Create An Event"),
        actions: const [
          Icon(Icons.notifications, color: Colors.blue),
          SizedBox(width: 10),
          Icon(Icons.settings, color: Colors.blue),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CREATE AN EVENT",
              style: TextStyle(
                fontSize: width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.03),
            const CustomField(title: "Name Your Event", hint: "Event name"),
            const CustomField(title: "Description", hint: "Description"),
            const CustomField(title: "Address", hint: "Full address"),
            const CustomField(title: "Cost Of Event", hint: "\$"),

            SizedBox(height: height * 0.02),

            CustomFieldWithIcon(
              title: "Event Date",
              hint: "MM-DD-YYYY",
              controller: dateController,
              icon: Icons.calendar_month_outlined,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: height * 0.02),
            CustomFieldWithIcon(
              title: "Event Time",
              hint: "HH-MM-SS",
              controller: timeController,
              icon: Icons.access_time_outlined,
              onTap: () => _selectTime(context),
            ),

            SizedBox(height: height * 0.03),
            const FileUploadRow(
              title: "Upload Event Photo",
              hint: "No file chosen",
              buttonText: "Choose File",
            ),
            SizedBox(height: height * 0.03),
            const CustomSubmitButton(),
          ],
        ),
      ),
    );
  }
}