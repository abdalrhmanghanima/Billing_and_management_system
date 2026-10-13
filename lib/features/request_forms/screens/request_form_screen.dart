import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/features/request_forms/providers/request_forms_notifier.dart';
import 'package:billing_and_sales_management/features/request_forms/widgets/request_form_fields.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestFormScreen extends ConsumerStatefulWidget {
  const RequestFormScreen({super.key});

  @override
  ConsumerState<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends ConsumerState<RequestFormScreen> {
  final TextEditingController _employeeNameController = TextEditingController();
  late final TextEditingController _dateController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;

  late DateTime _date;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  String? _employeeNameError;
  String? _dateError;
  String? _startTimeError;
  String? _endTimeError;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _date = DateTime.now();
    _dateController = TextEditingController(text: _toIsoDate(_date));
    _startTimeController = TextEditingController(text: _formatTime(_startTime));
    _endTimeController = TextEditingController(text: _formatTime(_endTime));
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  String _toIsoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatTime(TimeOfDay time) {
    final period = time.hour < 12 ? 'AM' : 'PM';
    var hour12 = time.hour % 12;
    if (hour12 == 0) hour12 = 12;
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour12:$minute $period';
  }

  String _to24HourTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int _minutesOf(TimeOfDay time) => time.hour * 60 + time.minute;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _date = picked;
        _dateController.text = _toIsoDate(picked);
        _dateError = null;
      });
    }
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
        _startTimeController.text = _formatTime(picked);
        _startTimeError = null;
        _endTimeError = null;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
        _endTimeController.text = _formatTime(picked);
        _endTimeError = null;
      });
    }
  }

  Future<void> _submit() async {
    if (_isSaving) return;

    final employeeName = _employeeNameController.text.trim();
    final nameInvalid = employeeName.isEmpty;
    final dateInvalid = _dateController.text.trim().isEmpty;
    final startTimeInvalid = _startTimeController.text.trim().isEmpty;
    final endTimeInvalid = _endTimeController.text.trim().isEmpty;
    final endTimeNotAfterStartTime =
        !startTimeInvalid &&
        !endTimeInvalid &&
        _minutesOf(_endTime) <= _minutesOf(_startTime);

    setState(() {
      _employeeNameError = nameInvalid ? 'Employee NAME is Required' : null;
      _dateError = dateInvalid ? 'DATE is Required' : null;
      _startTimeError = startTimeInvalid ? 'Start Time is Required' : null;
      _endTimeError = endTimeInvalid
          ? 'End Time is Required'
          : endTimeNotAfterStartTime
          ? 'End Time must be greater than Start Time'
          : null;
    });

    if (nameInvalid ||
        dateInvalid ||
        startTimeInvalid ||
        endTimeInvalid ||
        endTimeNotAfterStartTime) {
      return;
    }

    setState(() => _isSaving = true);

    final result = await ref
        .read(requestFormsProvider)
        .addRequestForm(
          employeeName: employeeName,
          date: _dateController.text.trim(),
          startTime: _to24HourTime(_startTime),
          endTime: _to24HourTime(_endTime),
        );

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(context, 'Request submitted successfully.');
        Navigator.of(context).pop();
      case SaveResult.duplicate:
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          'Could not submit the request. Please try again.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Request a Form'),
      body: SafeArea(
        top: false,
        child: MaxWidthBox(
          maxWidth: AppDimensions.maxContentWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.pageHorizontal.w,
                    vertical: AppSpacing.pageTop.h,
                  ),
                  child: RequestFormFields(
                    employeeNameController: _employeeNameController,
                    dateController: _dateController,
                    startTimeController: _startTimeController,
                    endTimeController: _endTimeController,
                    employeeNameError: _employeeNameError,
                    dateError: _dateError,
                    startTimeError: _startTimeError,
                    endTimeError: _endTimeError,
                    enabled: !_isSaving,
                    onEmployeeNameChanged: (_) {
                      if (_employeeNameError != null) {
                        setState(() => _employeeNameError = null);
                      }
                    },
                    onPickDate: _pickDate,
                    onPickStartTime: _pickStartTime,
                    onPickEndTime: _pickEndTime,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.pageHorizontal.w,
                ),
                child: CustomButton(
                  text: 'Submit Request',
                  onPressed: _isSaving ? null : _submit,
                  loading: _isSaving,
                ),
              ),
              SizedBox(height: AppSpacing.pageBottom.h),
            ],
          ),
        ),
      ),
    );
  }
}
