import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RequestFormFields extends StatelessWidget {
  const RequestFormFields({
    super.key,
    required this.clients,
    required this.selectedClient,
    required this.dateController,
    required this.startTimeController,
    required this.endTimeController,
    required this.clientError,
    required this.dateError,
    required this.startTimeError,
    required this.endTimeError,
    required this.enabled,
    required this.onClientChanged,
    required this.onPickDate,
    required this.onPickStartTime,
    required this.onPickEndTime,
  });

  final List<Client> clients;
  final Client? selectedClient;
  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final String? clientError;
  final String? dateError;
  final String? startTimeError;
  final String? endTimeError;
  final bool enabled;
  final ValueChanged<Client?> onClientChanged;
  final VoidCallback onPickDate;
  final VoidCallback onPickStartTime;
  final VoidCallback onPickEndTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDropdown<Client>(
          label: AppTranslate.clientName.tr(),
          isRequired: true,
          hint: AppTranslate.selectClient.tr(),
          options: clients,
          value: selectedClient,
          labelOf: (client) => client.name,
          enabled: enabled,
          onChanged: onClientChanged,
        ),
        if (clientError != null) ...[
          SizedBox(height: AppSpacing.xs.h),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: AppDimensions.inputHorizontalPadding.w,
            ),
            child: CustomText(
              text: clientError!,
              style: AppTextStyles.fieldError,
              color: AppColors.error,
            ),
          ),
        ],
        SizedBox(height: AppSpacing.formGroupGap.h),
        CustomTextField(
          controller: dateController,
          label: AppTranslate.date.tr(),
          isRequired: true,
          hint: AppTranslate.dateFormatHint.tr(),
          errorText: dateError,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          enabled: enabled,
          readOnly: true,
          onTap: enabled ? onPickDate : null,
        ),
        SizedBox(height: AppSpacing.formGroupGap.h),
        AdaptiveFormRow(
          children: [
            CustomTextField(
              controller: startTimeController,
              label: AppTranslate.startTime.tr(),
              isRequired: true,
              hint: AppTranslate.timeFormatHint.tr(),
              errorText: startTimeError,
              prefixIcon: const Icon(Icons.access_time_outlined),
              enabled: enabled,
              readOnly: true,
              onTap: enabled ? onPickStartTime : null,
            ),
            CustomTextField(
              controller: endTimeController,
              label: AppTranslate.endTime.tr(),
              isRequired: true,
              hint: AppTranslate.timeFormatHint.tr(),
              errorText: endTimeError,
              prefixIcon: const Icon(Icons.access_time_outlined),
              enabled: enabled,
              readOnly: true,
              onTap: enabled ? onPickEndTime : null,
            ),
          ],
        ),
      ],
    );
  }
}
