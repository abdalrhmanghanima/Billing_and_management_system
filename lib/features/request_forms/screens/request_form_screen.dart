import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/core/errors/client_exception.dart';
import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/features/clients/providers/clients_notifier.dart';
import 'package:billing_and_sales_management/features/request_forms/providers/request_forms_notifier.dart';
import 'package:billing_and_sales_management/features/request_forms/widgets/request_form_fields.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestFormScreen extends ConsumerStatefulWidget {
  const RequestFormScreen({super.key});

  @override
  ConsumerState<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends ConsumerState<RequestFormScreen> {
  late final TextEditingController _dateController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;

  late DateTime _date;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  Client? _selectedClient;
  String? _clientError;
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

    final client = _selectedClient;
    final clientInvalid = client == null;
    final dateInvalid = _dateController.text.trim().isEmpty;
    final startTimeInvalid = _startTimeController.text.trim().isEmpty;
    final endTimeInvalid = _endTimeController.text.trim().isEmpty;
    final endTimeNotAfterStartTime =
        !startTimeInvalid &&
        !endTimeInvalid &&
        _minutesOf(_endTime) <= _minutesOf(_startTime);

    setState(() {
      _clientError = clientInvalid
          ? AppTranslate.clientNameRequired.tr()
          : null;
      _dateError = dateInvalid ? AppTranslate.dateRequired.tr() : null;
      _startTimeError = startTimeInvalid
          ? AppTranslate.startTimeRequired.tr()
          : null;
      _endTimeError = endTimeInvalid
          ? AppTranslate.endTimeRequired.tr()
          : endTimeNotAfterStartTime
          ? AppTranslate.endTimeMustBeAfterStartTime.tr()
          : null;
    });

    if (clientInvalid ||
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
          clientId: client.id,
          clientName: client.name,
          date: _dateController.text.trim(),
          startTime: _to24HourTime(_startTime),
          endTime: _to24HourTime(_endTime),
        );

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(
          context,
          AppTranslate.requestSubmittedSuccessfully.tr(),
        );
        Navigator.of(context).pop();
      case SaveResult.duplicate:
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          AppTranslate.couldNotSubmitRequest.tr(),
        );
    }
  }

  Widget _buildForm(List<Client> clients) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.pageHorizontal.w,
              vertical: AppSpacing.pageTop.h,
            ),
            child: RequestFormFields(
              clients: clients,
              selectedClient: _selectedClient,
              dateController: _dateController,
              startTimeController: _startTimeController,
              endTimeController: _endTimeController,
              clientError: _clientError,
              dateError: _dateError,
              startTimeError: _startTimeError,
              endTimeError: _endTimeError,
              enabled: !_isSaving,
              onClientChanged: (client) {
                setState(() {
                  _selectedClient = client;
                  if (_clientError != null) _clientError = null;
                });
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
            text: AppTranslate.submitRequest.tr(),
            onPressed: _isSaving ? null : _submit,
            loading: _isSaving,
          ),
        ),
        SizedBox(height: AppSpacing.pageBottom.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientsProvider);

    return Scaffold(
      appBar: CustomAppBar(title: AppTranslate.requestAForm.tr()),
      body: SafeArea(
        top: false,
        child: MaxWidthBox(
          maxWidth: AppDimensions.maxContentWidth,
          child: clientsState.when(
            loading: () =>
                Center(child: CustomLoading(color: context.palette.accentText)),
            error: (error, _) => CustomErrorState(
              title: AppTranslate.couldNotLoadClients.tr(),
              message: error is ClientException
                  ? error.message
                  : AppTranslate.somethingWentWrong.tr(),
              onRetry: () => ref.read(clientsProvider.notifier).refresh(),
            ),
            data: (clients) {
              if (clients.isEmpty) {
                return CustomEmptyState(
                  icon: Icons.people_outline,
                  iconColor: context.palette.cyanText,
                  iconBackgroundColor: context.palette.cyanLight,
                  title: AppTranslate.noClientsAvailable.tr(),
                  message: AppTranslate.addClientFirstBeforeRequestsMessage
                      .tr(),
                );
              }

              return _buildForm(clients);
            },
          ),
        ),
      ),
    );
  }
}
