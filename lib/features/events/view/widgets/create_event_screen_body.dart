import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:event_planning_app/core/utils/function/app_toast.dart';
import 'package:event_planning_app/core/utils/widgets/custom_textbutton.dart';
import 'package:event_planning_app/features/events/cubit/events_cubit.dart';
import 'package:event_planning_app/features/events/cubit/events_state.dart';
import 'package:event_planning_app/features/events/data/events_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventScreenBody extends StatefulWidget {
  const CreateEventScreenBody({super.key});

  @override
  State<CreateEventScreenBody> createState() => _CreateEventScreenBodyState();
}

class _CreateEventScreenBodyState extends State<CreateEventScreenBody> {
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
      AppToast.warning('Price must be a valid non-negative number');
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
    return BlocConsumer<CreateEventCubit, CreateEventState>(
      listener: (context, state) {
        if (state is CreateEventSuccess) {
          AppToast.success('Event created');
          if (!context.mounted) return;
          Navigator.pop(context, state.event);
        } else if (state is CreateEventFailure) {
          AppToast.error(state.message);
        } else if (state is CreateEventValidationError) {
          // show first error
          final first = state.errors.values.isNotEmpty
              ? state.errors.values.first
              : 'Invalid input';
          AppToast.warning(first);
        }
      },
      builder: (context, state) {
        final isLoading = state is CreateEventSubmitting;
        return AbsorbPointer(
          absorbing: isLoading,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Create An Event'),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Field(
                            title: 'Name Your Event',
                            child: TextFormField(
                              controller: _titleCtrl,
                              decoration:
                                  const InputDecoration(hintText: 'Event name'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            )),
                        _Field(
                            title: 'Description',
                            child: TextFormField(
                              controller: _descCtrl,
                              decoration: const InputDecoration(
                                  hintText: 'Description'),
                              maxLines: 3,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            )),
                        _Field(
                            title: 'Address',
                            child: TextFormField(
                              controller: _locationCtrl,
                              decoration: const InputDecoration(
                                  hintText: 'Full address'),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            )),
                        _Field(
                            title: 'Cost Of Event',
                            child: TextFormField(
                              controller: _priceCtrl,
                              decoration: const InputDecoration(hintText: '\$'),
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final d = double.tryParse(v?.trim() ?? '');
                                if (d == null || d < 0) {
                                  return 'Enter a valid non-negative number';
                                }
                                return null;
                              },
                            )),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: _ReadOnlyField(
                              title: 'Event Date',
                              controller: _dateCtrl,
                              hint: 'YYYY-MM-DD',
                              icon: Icons.calendar_month_outlined,
                              onTap: _selectDate,
                            )),
                            const SizedBox(width: 12),
                            Expanded(
                                child: _ReadOnlyField(
                              title: 'Event Time',
                              controller: _timeCtrl,
                              hint: 'HH:MM',
                              icon: Icons.access_time_outlined,
                              onTap: _selectTime,
                            )),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _Field(
                            title: 'Tags (comma separated)',
                            child: TextFormField(
                              controller: _tagsCtrl,
                              decoration: const InputDecoration(
                                  hintText: 'music, festival, party'),
                            )),
                        const SizedBox(height: 16),
                        _ImagePickerRow(
                          file: _imageFile,
                          onPick: _pickImage,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: CustomTextbutton(
                            text: 'Create',
                            onpressed: _onSubmit,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                if (isLoading)
                  const Positioned.fill(
                    child: ColoredBox(
                      color: Color(0x66000000),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Field extends StatelessWidget {
  final String title;
  final Widget child;
  const _Field({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final VoidCallback onTap;
  const _ReadOnlyField({
    required this.title,
    required this.hint,
    required this.controller,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _Field(
      title: title,
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: onTap,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: Icon(icon),
          ),
        ),
        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }
}

class _ImagePickerRow extends StatelessWidget {
  final File? file;
  final VoidCallback onPick;

  const _ImagePickerRow({
    required this.file,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final name = file != null ? file!.path.split('/').last : 'No file chosen';
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Upload Event Photo'),
              Text(name, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: onPick,
          icon: const Icon(Icons.file_upload, color: Colors.white),
          label:
              const Text('Choose File', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
