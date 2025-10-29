import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/features/events/cubit/events_cubit.dart';
import 'package:event_planning_app/features/events/data/events_model.dart';
import 'package:event_planning_app/features/events/view/widgets/even_image_picker_row.dart';
import 'package:event_planning_app/features/events/view/widgets/event_field.dart';
import 'package:event_planning_app/features/events/view/widgets/event_readonly_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  State<CreateEventForm> createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _tagsCtrl = TextEditingController();

  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;
  File? _imageFile;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _priceCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    _tagsCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final result = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: [DateTime.now()],
      borderRadius: BorderRadius.circular(15),
    );

    final picked = (result?.isNotEmpty ?? false) ? result!.first : null;
    if (picked != null) {
      setState(() {
        _pickedDate = DateTime(picked.year, picked.month, picked.day);
        _dateCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _selectTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _pickedTime = picked;
        _timeCtrl.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (xFile != null) {
      setState(() {
        _imageFile = File(xFile.path);
      });
    }
  }

  DateTime? _combineDateTime() {
    if (_pickedDate == null || _pickedTime == null) return null;
    return DateTime(
      _pickedDate!.year,
      _pickedDate!.month,
      _pickedDate!.day,
      _pickedTime!.hour,
      _pickedTime!.minute,
    );
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final dt = _combineDateTime();
    if (dt == null) {
      AppToast.warning('Please select date and time');
      return;
    }

    final price = double.tryParse(_priceCtrl.text.trim()) ?? -1;
    if (price < 0) {
      AppToast.warning('Invalid price');
      return;
    }

    final tags = _tagsCtrl.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    const categoryId = 'general';
    const categoryName = 'General';

    final input = CreateEventInput(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      categoryId: categoryId,
      categoryName: categoryName,
      location: _locationCtrl.text.trim(),
      date: dt,
      tags: tags,
      price: price,
      imageUrl: _imageFile?.path ?? '',
    );

    context.read<CreateEventCubit>().submit(
          input: input,
          imageFile: _imageFile,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventField(
                  title: 'Name Your Event',
                  child: TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(hintText: 'Event name'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                EventField(
                  title: 'Description',
                  child: TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Description'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                EventField(
                  title: 'Address',
                  child: TextFormField(
                    controller: _locationCtrl,
                    decoration: const InputDecoration(hintText: 'Full address'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                EventField(
                  title: 'Cost Of Event',
                  child: TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: '\$'),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: EventReadOnlyField(
                        title: 'Event Date',
                        controller: _dateCtrl,
                        hint: 'YYYY-MM-DD',
                        icon: Icons.calendar_month_outlined,
                        onTap: _selectDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: EventReadOnlyField(
                        title: 'Event Time',
                        controller: _timeCtrl,
                        hint: 'HH:MM',
                        icon: Icons.access_time_outlined,
                        onTap: _selectTime,
                      ),
                    ),
                  ],
                ),
                EventField(
                  title: 'Tags (comma separated)',
                  child: TextFormField(
                    controller: _tagsCtrl,
                    decoration: const InputDecoration(
                        hintText: 'music, festival, party'),
                  ),
                ),
                EventImagePickerRow(
                  file: _imageFile,
                  onPick: _pickImage,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: CustomTextbutton(
                    text: 'Create',
                    onpressed: _onSubmit,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
