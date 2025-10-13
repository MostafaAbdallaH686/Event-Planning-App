import 'package:flutter/material.dart';

class CreateEventScreen extends StatelessWidget {
  CreateEventScreen({super.key});

  // Controllers to show selected date/time
  final TextEditingController dateController =  TextEditingController();
  final TextEditingController timeController =  TextEditingController();

  // 📅 Pick Date
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2003),
      lastDate: DateTime(2080),
    );
    if (picked != null) {
      controller.text = "${picked.day}-${picked.month}-${picked.year}";
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      controller.text =
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
          SizedBox(width: 8),
          Icon(Icons.settings, color: Colors.blue),
          SizedBox(width: 8),
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

            _buildField("Name Your Event", "Event name"),
            _buildField("Description", "Description"),
            _buildField("Address", "Full address"),
            _buildField("Cost Of Event", "\$"),

            SizedBox(height: height * 0.02),

            Row(
              children: [
                Expanded(
                  child: _buildFieldWithController(
                      "Event Date", "MM-DD-YYYY", dateController),
                ),
                const SizedBox(width: 10),
                _buildIconButton(
                  Icons.calendar_month_outlined,
                      () => _selectDate(context, dateController),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),

            // ⏰ Event Time
            Row(
              children: [
                Expanded(
                  child: _buildFieldWithController(
                      "Event Time", "HH-MM-SS", timeController),
                ),
                const SizedBox(width: 10),
                _buildIconButton(
                  Icons.access_time_outlined,
                      () => _selectTime(context, timeController),
                ),
              ],
            ),

            SizedBox(height: height * 0.02),

            _buildFileRow("Upload Event Photo", "No file chosen", "Choose File"),
            SizedBox(height: height * 0.02),

            _buildFileRow("Enter Captcha", "Enter captcha here", "a154a9"),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String title, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextField(
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }
  Widget _buildFieldWithController(
      String title, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          TextField(
            controller: controller,
            readOnly: true,
            decoration: InputDecoration(hintText: hint),
          ),
        ],
      ),
    );
  }

  Widget _buildFileRow(String title, String hint, String buttonText) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(hint, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _buildOrangeButton(buttonText),
      ],
    );
  }

  Widget _buildOrangeButton(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}