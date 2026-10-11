import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/features/clients/providers/clients_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientFormSheet extends ConsumerStatefulWidget {
  const ClientFormSheet({super.key});

  @override
  ConsumerState<ClientFormSheet> createState() => _ClientFormSheetState();
}

class _ClientFormSheetState extends ConsumerState<ClientFormSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _nameError;
  String? _phoneError;
  String? _addressError;
  bool _isSaving = false;

  static final RegExp _phoneRegex = RegExp(r'^[0-9]{11}$');

  @override
  void initState() {
    super.initState();
    ref.invalidate(nextClientNumberProvider);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    final nameInvalid = name.isEmpty;
    final phoneEmpty = phone.isEmpty;
    final phoneInvalid = !phoneEmpty && !_phoneRegex.hasMatch(phone);
    final addressInvalid = address.isEmpty;

    setState(() {
      _nameError = nameInvalid ? 'CLIENT NAME is Required' : null;
      _phoneError = phoneEmpty
          ? 'PHONE is Required'
          : phoneInvalid
          ? 'PHONE must be just a 11 digit number'
          : null;
      _addressError = addressInvalid ? 'Address is Required' : null;
    });

    if (nameInvalid || phoneEmpty || phoneInvalid || addressInvalid) return;

    setState(() => _isSaving = true);

    final result = await ref
        .read(clientsProvider.notifier)
        .addClient(name: name, phone: phone, address: address);

    if (!mounted) return;

    setState(() => _isSaving = false);

    switch (result) {
      case SaveResult.success:
        CustomSnackbar.showSuccess(
          context,
          'Client "$name" added successfully!',
        );
        Navigator.of(context).pop();
      case SaveResult.duplicate:
        setState(() => _nameError = 'CLIENT NAME has already existed before');
      case SaveResult.failure:
        CustomSnackbar.showError(
          context,
          'Could not save the client. Please try again.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final nextNumberText = ref
        .watch(nextClientNumberProvider)
        .maybeWhen(
          data: (number) => '#$number',
          error: (_, _) => 'Auto generated',
          orElse: () => 'Generating...',
        );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: _nameController,
            label: 'Client Name',
            isRequired: true,
            hint: 'Enter client name',
            errorText: _nameError,
            enabled: !_isSaving,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_nameError != null) setState(() => _nameError = null);
            },
          ),
          SizedBox(height: AppSpacing.formGroupGap.h),
          CustomTextField(
            controller: _phoneController,
            label: 'Phone Number (11 digits)',
            isRequired: true,
            hint: '01123456789',
            errorText: _phoneError,
            enabled: !_isSaving,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_phoneError != null) setState(() => _phoneError = null);
            },
          ),
          SizedBox(height: AppSpacing.formGroupGap.h),
          CustomTextField(
            key: ValueKey<String>(nextNumberText),
            initialValue: nextNumberText,
            label: 'Client Number (Auto)',
            enabled: false,
          ),
          SizedBox(height: AppSpacing.formGroupGap.h),
          CustomTextField(
            controller: _addressController,
            label: 'Address',
            isRequired: true,
            hint: 'Enter address',
            errorText: _addressError,
            enabled: !_isSaving,
            textInputAction: TextInputAction.done,
            onChanged: (_) {
              if (_addressError != null) setState(() => _addressError = null);
            },
          ),
          SizedBox(height: AppSpacing.lg.h),
          CustomButton(
            text: 'Save Client',
            onPressed: _save,
            loading: _isSaving,
          ),
        ],
      ),
    );
  }
}
