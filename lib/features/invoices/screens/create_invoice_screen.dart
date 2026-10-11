import 'package:billing_and_sales_management/core/enums/save_result.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/invoice_line.dart';
import 'package:billing_and_sales_management/domain/invoices/entities/sales_invoice.dart';
import 'package:billing_and_sales_management/domain/items/entities/item.dart';
import 'package:billing_and_sales_management/features/clients/providers/clients_notifier.dart';
import 'package:billing_and_sales_management/features/dashboard/models/dashboard_state.dart';
import 'package:billing_and_sales_management/features/invoices/providers/invoices_notifier.dart';
import 'package:billing_and_sales_management/features/invoices/screens/invoice_details_screen.dart';
import 'package:billing_and_sales_management/features/items/providers/items_notifier.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateInvoiceScreen extends ConsumerStatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  ConsumerState<CreateInvoiceScreen> createState() =>
      _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends ConsumerState<CreateInvoiceScreen> {
  late final TextEditingController _billDateController;
  final TextEditingController _quantityController = TextEditingController(
    text: '1',
  );
  final TextEditingController _sellingPriceController = TextEditingController(
    text: '0.00',
  );
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _percentageDiscountController =
      TextEditingController();
  final TextEditingController _valueDiscountController =
      TextEditingController();
  final TextEditingController _paidUpController = TextEditingController();

  int _step = 1;
  bool _addingItem = false;
  bool _isSaving = false;

  DateTime _billDate = DateTime.now();
  Client? _selectedClient;
  Item? _selectedItem;
  final List<InvoiceLine> _lines = <InvoiceLine>[];

  String? _clientError;
  String? _itemError;
  String? _quantityError;
  String? _sellingPriceError;
  String? _discountError;
  String? _percentageDiscountError;
  String? _valueDiscountError;
  String? _paidUpError;

  static final RegExp _numberRegex = RegExp(r'^-?\d+(\.\d+)?$');

  @override
  void initState() {
    super.initState();
    _billDateController = TextEditingController(text: _toIsoDate(_billDate));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.invalidate(nextBillNumberProvider);
    });
  }

  @override
  void dispose() {
    _billDateController.dispose();
    _quantityController.dispose();
    _sellingPriceController.dispose();
    _discountController.dispose();
    _percentageDiscountController.dispose();
    _valueDiscountController.dispose();
    _paidUpController.dispose();
    super.dispose();
  }

  String _toIsoDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  double get _billsTotal => _lines.fold(0.0, (sum, line) => sum + line.total);

  double get _percentageDiscount =>
      double.tryParse(_percentageDiscountController.text.trim()) ?? 0;

  double get _valueDiscount =>
      double.tryParse(_valueDiscountController.text.trim()) ?? 0;

  double get _paidUp => double.tryParse(_paidUpController.text.trim()) ?? 0;

  double get _theNet => SalesInvoice.calculateNet(
    billsTotal: _billsTotal,
    percentageDiscount: _percentageDiscount,
    valueDiscount: _valueDiscount,
  );

  double get _theRest => _theNet - _paidUp;

  String _formatAmount(double amount) =>
      DashboardAmountFormatter.format(amount);

  Future<void> _pickBillDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _billDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _billDate = picked;
        _billDateController.text = _toIsoDate(picked);
      });
    }
  }

  void _goBack() {
    if (_step == 3) {
      setState(() => _step = 2);
      return;
    }
    if (_step == 2) {
      if (_addingItem) {
        setState(() {
          _addingItem = false;
          _resetAddItemForm();
        });
      } else {
        setState(() => _step = 1);
      }
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _goToNextFromDetails() {
    final client = _selectedClient;

    setState(
      () => _clientError = client == null ? 'CLIENT NAME is Required' : null,
    );

    if (client == null) return;

    setState(() => _step = 2);
  }

  void _resetAddItemForm() {
    _selectedItem = null;
    _quantityController.text = '1';
    _sellingPriceController.text = '0.00';
    _discountController.clear();
    _itemError = null;
    _quantityError = null;
    _sellingPriceError = null;
    _discountError = null;
  }

  void _onItemChanged(Item? item) {
    setState(() {
      _selectedItem = item;
      if (item != null) {
        _sellingPriceController.text = item.sellingPrice.toStringAsFixed(2);
      }
      _itemError = null;
    });
  }

  void _changeQuantity(double delta) {
    final current = double.tryParse(_quantityController.text.trim()) ?? 1;
    var next = current + delta;
    if (next < 1) next = 1;

    setState(() {
      _quantityController.text = next == next.truncateToDouble()
          ? next.toInt().toString()
          : next.toString();
      if (_quantityError != null) _quantityError = null;
    });
  }

  bool _validateAddItem() {
    final item = _selectedItem;
    final quantityText = _quantityController.text.trim();
    final sellingPriceText = _sellingPriceController.text.trim();
    final discountText = _discountController.text.trim();

    final itemInvalid = item == null;
    final quantityEmpty = quantityText.isEmpty;
    final parsedQuantity = double.tryParse(quantityText);
    final quantityInvalid =
        quantityEmpty ||
        parsedQuantity == null ||
        parsedQuantity.isNaN ||
        parsedQuantity <= 0;

    String? sellingPriceError;
    if (sellingPriceText.isNotEmpty &&
        !_numberRegex.hasMatch(sellingPriceText)) {
      sellingPriceError = 'Invalid number';
    }

    String? discountError;
    if (discountText.isNotEmpty) {
      if (!_numberRegex.hasMatch(discountText)) {
        discountError = 'Invalid number';
      } else if ((double.tryParse(discountText) ?? 0) < 0) {
        discountError = 'Discount Must be Greater than or equal Zero';
      }
    }

    setState(() {
      _itemError = itemInvalid ? 'ITEM NAME is Required' : null;
      _quantityError = quantityEmpty
          ? 'Quantity is Required'
          : quantityInvalid
          ? 'Quantity Must be Greater than Zero'
          : null;
      _sellingPriceError = sellingPriceError;
      _discountError = discountError;
    });

    return !itemInvalid &&
        !quantityInvalid &&
        sellingPriceError == null &&
        discountError == null;
  }

  void _addLine() {
    if (!_validateAddItem()) return;

    final item = _selectedItem!;
    final quantity = double.parse(_quantityController.text.trim());
    final sellingPrice = _sellingPriceController.text.trim().isEmpty
        ? 0.0
        : double.parse(_sellingPriceController.text.trim());
    final discount = _discountController.text.trim().isEmpty
        ? 0.0
        : double.parse(_discountController.text.trim());

    final line = InvoiceLine(
      itemId: item.id,
      itemName: item.name,
      sellingPrice: sellingPrice,
      quantity: quantity,
      discount: discount,
      total: InvoiceLine.calculateTotal(
        sellingPrice: sellingPrice,
        quantity: quantity,
        discount: discount,
      ),
    );

    setState(() {
      _lines.add(line);
      _addingItem = false;
      _resetAddItemForm();
    });

    CustomSnackbar.showSuccess(context, 'Added "${item.name}" to invoice');
  }

  void _removeLine(int index) {
    setState(() => _lines.removeAt(index));
    CustomSnackbar.showInfo(context, 'Item removed from invoice');
  }

  bool _validateSummary() {
    final percentageText = _percentageDiscountController.text.trim();
    final valueText = _valueDiscountController.text.trim();
    final paidUpText = _paidUpController.text.trim();

    String? percentageError;
    if (percentageText.isNotEmpty) {
      if (!_numberRegex.hasMatch(percentageText)) {
        percentageError = 'Invalid number';
      } else if ((double.tryParse(percentageText) ?? 0) < 0) {
        percentageError =
            'Percentage discount Must be Greater than or equal Zero';
      }
    }

    String? valueError;
    if (valueText.isNotEmpty) {
      if (!_numberRegex.hasMatch(valueText)) {
        valueError = 'Invalid number';
      } else if ((double.tryParse(valueText) ?? 0) < 0) {
        valueError = 'Value discount Must be Greater than or equal Zero';
      }
    }

    String? paidUpError;
    if (paidUpText.isNotEmpty) {
      if (!_numberRegex.hasMatch(paidUpText)) {
        paidUpError = 'Invalid number';
      } else if ((double.tryParse(paidUpText) ?? 0) < 0) {
        paidUpError = 'Paid Up Must be Greater than or equal Zero';
      }
    }

    setState(() {
      _percentageDiscountError = percentageError;
      _valueDiscountError = valueError;
      _paidUpError = paidUpError;
    });

    return percentageError == null && valueError == null && paidUpError == null;
  }

  Future<void> _createInvoice() async {
    if (_isSaving) return;
    if (_lines.isEmpty) return;
    if (!_validateSummary()) return;

    final client = _selectedClient;
    if (client == null) {
      setState(() => _clientError = 'CLIENT NAME is Required');
      return;
    }

    setState(() => _isSaving = true);

    final outcome = await ref
        .read(invoicesProvider.notifier)
        .addInvoice(
          billDate: _toIsoDate(_billDate),
          clientId: client.id,
          clientName: client.name,
          lines: List<InvoiceLine>.of(_lines),
          percentageDiscount: _percentageDiscount,
          valueDiscount: _valueDiscount,
          paidUp: _paidUp,
        );

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (outcome.result == SaveResult.success && outcome.invoice != null) {
      final invoice = outcome.invoice!;
      CustomSnackbar.showSuccess(
        context,
        'Sales Invoice #${invoice.billNumber} created successfully!',
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => InvoiceDetailsScreen(invoice: invoice),
        ),
      );
    } else {
      CustomSnackbar.showError(
        context,
        'Could not save the invoice. Please try again.',
      );
    }
  }

  String get _stepSubtitle {
    if (_step == 1) return 'Step 1: Bill Details';
    if (_step == 3) return 'Step 3: Summary';
    return _addingItem ? 'Step 2: Add Item' : 'Step 2: Items List';
  }

  @override
  Widget build(BuildContext context) {
    final nextBillNumber = ref
        .watch(nextBillNumberProvider)
        .maybeWhen(
          data: (number) => '#$number',
          error: (_, _) => 'Auto generated',
          orElse: () => 'Generating...',
        );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'New Invoice',
        subtitle: _stepSubtitle,
        showBackArrow: false,
        leading: IconButton(
          onPressed: _goBack,
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          style: IconButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.neutral700,
            minimumSize: Size(
              AppDimensions.headerActionSize.w,
              AppDimensions.headerActionSize.w,
            ),
            shape: const CircleBorder(),
          ),
          icon: Icon(Icons.arrow_back, size: 22.r),
        ),
      ),
      body: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal.w,
              ),
              child: _InvoiceStepIndicator(currentStep: _step),
            ),
            SizedBox(height: AppSpacing.base.h),
            Expanded(child: _buildStepBody(nextBillNumber)),
            _buildActionsBar(),
            SizedBox(height: AppSpacing.pageBottom.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBody(String nextBillNumber) {
    if (_step == 1) {
      return _buildDetailsStep(nextBillNumber);
    }
    if (_step == 2) {
      return _addingItem ? _buildAddItemStep() : _buildItemsListStep();
    }
    return _buildSummaryStep();
  }

  Widget _buildDetailsStep(String nextBillNumber) {
    final clientsState = ref.watch(clientsProvider);

    return clientsState.when(
      loading: () =>
          const Center(child: CustomLoading(color: AppColors.primary)),
      error: (error, _) => CustomErrorState(
        title: 'Could not load clients',
        onRetry: () => ref.read(clientsProvider.notifier).refresh(),
      ),
      data: (clients) {
        if (clients.isEmpty) {
          return const CustomEmptyState(
            icon: Icons.people_outline,
            iconColor: AppColors.cyanDark,
            iconBackgroundColor: AppColors.cyanLight,
            title: 'No Clients Available',
            message:
                'Add a client first before creating invoices. Invoices must belong to a client.',
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _billDateController,
                label: 'Bill Date',
                isRequired: true,
                hint: 'yyyy-MM-dd',
                prefixIcon: const Icon(Icons.calendar_today_outlined),
                enabled: !_isSaving,
                readOnly: true,
                onTap: _isSaving ? null : _pickBillDate,
              ),
              SizedBox(height: AppSpacing.formGroupGap.h),
              CustomTextField(
                key: ValueKey<String>(nextBillNumber),
                initialValue: nextBillNumber,
                label: 'Bill Number (Auto)',
                enabled: false,
              ),
              SizedBox(height: AppSpacing.formGroupGap.h),
              CustomDropdown<Client>(
                label: 'Client Name',
                isRequired: true,
                hint: 'Select client',
                options: clients,
                value: _selectedClient,
                labelOf: (client) => client.name,
                enabled: !_isSaving,
                onChanged: (client) {
                  setState(() {
                    _selectedClient = client;
                    if (_clientError != null) _clientError = null;
                  });
                },
              ),
              if (_clientError != null) ...[
                SizedBox(height: AppSpacing.xs.h),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: AppDimensions.inputHorizontalPadding.w,
                  ),
                  child: CustomText(
                    text: _clientError!,
                    style: AppTextStyles.fieldError,
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemsListStep() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: 'Invoice Items (${_lines.length})',
                  style: AppTextStyles.sectionTitle,
                  color: AppColors.neutral900,
                ),
              ),
              CustomButton(
                text: '+ Add Item',
                variant: CustomButtonVariant.outline,
                size: CustomButtonSize.small,
                width: 110.w,
                onPressed: _isSaving
                    ? null
                    : () => setState(() => _addingItem = true),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          Expanded(
            child: _lines.isEmpty
                ? CustomEmptyState(
                    icon: Icons.inventory_2_outlined,
                    iconColor: AppColors.primary,
                    iconBackgroundColor: AppColors.primarySubtle,
                    title: 'No Items Added',
                    message: 'Add items to calculate invoice totals.',
                    action: CustomButton(
                      text: '+ Add Item',
                      size: CustomButtonSize.small,
                      width: 200.w,
                      onPressed: () => setState(() => _addingItem = true),
                    ),
                  )
                : ListView.separated(
                    itemCount: _lines.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSpacing.cardGap.h),
                    itemBuilder: (context, index) {
                      final line = _lines[index];

                      return _InvoiceLineCard(
                        line: line,
                        onDelete: () => _removeLine(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemStep() {
    final itemsState = ref.watch(itemsProvider);

    return itemsState.when(
      loading: () =>
          const Center(child: CustomLoading(color: AppColors.primary)),
      error: (error, _) => CustomErrorState(
        title: 'Could not load items',
        onRetry: () => ref.read(itemsProvider.notifier).refresh(),
      ),
      data: (items) {
        if (items.isEmpty) {
          return const CustomEmptyState(
            icon: Icons.inventory_2_outlined,
            iconColor: AppColors.primary,
            iconBackgroundColor: AppColors.primarySubtle,
            title: 'No Items Available',
            message:
                'Add an item first before creating invoices. Invoice lines must reference catalog items.',
          );
        }

        final lineTotal = InvoiceLine.calculateTotal(
          sellingPrice:
              double.tryParse(_sellingPriceController.text.trim()) ?? 0,
          quantity: double.tryParse(_quantityController.text.trim()) ?? 0,
          discount: double.tryParse(_discountController.text.trim()) ?? 0,
        );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomDropdown<Item>(
                label: 'Item Name',
                isRequired: true,
                hint: 'Select item',
                options: items,
                value: _selectedItem,
                labelOf: (item) => item.name,
                enabled: !_isSaving,
                onChanged: _onItemChanged,
              ),
              if (_itemError != null) ...[
                SizedBox(height: AppSpacing.xs.h),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: AppDimensions.inputHorizontalPadding.w,
                  ),
                  child: CustomText(
                    text: _itemError!,
                    style: AppTextStyles.fieldError,
                    color: AppColors.error,
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.formGroupGap.h),
              CustomTextField(
                controller: _sellingPriceController,
                label: 'Selling Price',
                hint: '0.00',
                errorText: _sellingPriceError,
                enabled: !_isSaving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  setState(() {
                    if (_sellingPriceError != null) _sellingPriceError = null;
                  });
                },
              ),
              SizedBox(height: AppSpacing.formGroupGap.h),
              CustomFieldLabel(label: 'Quantity', isRequired: true),
              SizedBox(height: AppSpacing.xs.h),
              Row(
                children: [
                  _StepperButton(
                    icon: Icons.remove,
                    onPressed: _isSaving ? null : () => _changeQuantity(-1),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm.w,
                      ),
                      child: CustomTextField(
                        controller: _quantityController,
                        errorText: _quantityError,
                        enabled: !_isSaving,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          setState(() {
                            if (_quantityError != null) {
                              _quantityError = null;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  _StepperButton(
                    icon: Icons.add,
                    onPressed: _isSaving ? null : () => _changeQuantity(1),
                  ),
                ],
              ),
              if (_quantityError != null) ...[
                SizedBox(height: AppSpacing.xs.h),
                Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: AppDimensions.inputHorizontalPadding.w,
                  ),
                  child: CustomText(
                    text: _quantityError!,
                    style: AppTextStyles.fieldError,
                    color: AppColors.error,
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.formGroupGap.h),
              CustomTextField(
                controller: _discountController,
                label: 'Discount',
                hint: '0',
                errorText: _discountError,
                enabled: !_isSaving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onChanged: (_) {
                  setState(() {
                    if (_discountError != null) _discountError = null;
                  });
                },
              ),
              SizedBox(height: AppSpacing.formGroupGap.h),
              CustomTextField(
                key: ValueKey<String>(lineTotal.toStringAsFixed(2)),
                initialValue: lineTotal.toStringAsFixed(2),
                label: 'Total',
                enabled: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryStep() {
    final theNet = _theNet;
    final theRest = _theRest;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal.w),
      child: CustomCard(
        padding: EdgeInsets.all(AppSpacing.base.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryRow(
              label: 'Bills Total',
              value: _formatAmount(_billsTotal),
              emphasized: false,
            ),
            SizedBox(height: AppSpacing.md.h),
            CustomTextField(
              controller: _percentageDiscountController,
              label: 'Percentage Discount (%)',
              hint: '0',
              errorText: _percentageDiscountError,
              enabled: !_isSaving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                setState(() {
                  if (_percentageDiscountError != null) {
                    _percentageDiscountError = null;
                  }
                });
              },
            ),
            SizedBox(height: AppSpacing.formGroupGap.h),
            CustomTextField(
              controller: _valueDiscountController,
              label: 'Value Discount',
              hint: '0',
              errorText: _valueDiscountError,
              enabled: !_isSaving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                setState(() {
                  if (_valueDiscountError != null) {
                    _valueDiscountError = null;
                  }
                });
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            _SummaryRow(
              label: 'The Net',
              value: _formatAmount(theNet),
              emphasized: true,
            ),
            SizedBox(height: AppSpacing.md.h),
            CustomTextField(
              controller: _paidUpController,
              label: 'Paid Up',
              hint: '0',
              errorText: _paidUpError,
              enabled: !_isSaving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              onChanged: (_) {
                setState(() {
                  if (_paidUpError != null) _paidUpError = null;
                });
              },
            ),
            SizedBox(height: AppSpacing.md.h),
            _SummaryRow(
              label: 'The Rest',
              value: _formatAmount(theRest),
              coral: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsBar() {
    Widget bar;

    if (_step == 1) {
      bar = CustomButton(
        text: 'Next',
        onPressed: _isSaving ? null : _goToNextFromDetails,
        loading: _isSaving,
      );
    } else if (_step == 2) {
      if (_addingItem) {
        bar = CustomButton(
          text: 'Add to Invoice',
          onPressed: _isSaving ? null : _addLine,
          loading: _isSaving,
        );
      } else {
        bar = Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Back',
                variant: CustomButtonVariant.secondary,
                onPressed: _isSaving ? null : () => setState(() => _step = 1),
              ),
            ),
            SizedBox(width: AppSpacing.md.w),
            Expanded(
              child: CustomButton(
                text: 'Next',
                onPressed: _isSaving || _lines.isEmpty
                    ? null
                    : () => setState(() => _step = 3),
              ),
            ),
          ],
        );
      }
    } else {
      bar = Row(
        children: [
          Expanded(
            child: CustomButton(
              text: 'Back',
              variant: CustomButtonVariant.secondary,
              onPressed: _isSaving ? null : () => setState(() => _step = 2),
            ),
          ),
          SizedBox(width: AppSpacing.md.w),
          Expanded(
            child: CustomButton(
              text: 'Create Invoice',
              onPressed: _isSaving || _lines.isEmpty ? null : _createInvoice,
              loading: _isSaving,
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal.w),
      child: bar,
    );
  }
}

class _InvoiceStepIndicator extends StatelessWidget {
  const _InvoiceStepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg.r),
        border: Border.all(color: AppColors.neutral200),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          _StepItem(stepNumber: 1, label: 'Bill Details', state: _stepState(1)),
          _StepConnector(active: currentStep > 1),
          _StepItem(stepNumber: 2, label: 'Items', state: _stepState(2)),
          _StepConnector(active: currentStep > 2),
          _StepItem(stepNumber: 3, label: 'Summary', state: _stepState(3)),
        ],
      ),
    );
  }

  _StepVisualState _stepState(int step) {
    if (currentStep > step) return _StepVisualState.completed;
    if (currentStep == step) return _StepVisualState.active;
    return _StepVisualState.upcoming;
  }
}

enum _StepVisualState { upcoming, active, completed }

class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.stepNumber,
    required this.label,
    required this.state,
  });

  final int stepNumber;
  final String label;
  final _StepVisualState state;

  @override
  Widget build(BuildContext context) {
    Color circleBackground;
    Color circleForeground;
    BoxBorder? ring;

    switch (state) {
      case _StepVisualState.completed:
        circleBackground = AppColors.success;
        circleForeground = AppColors.white;
        ring = null;
      case _StepVisualState.active:
        circleBackground = AppColors.primary;
        circleForeground = AppColors.white;
        ring = Border.all(color: AppColors.primary, width: 3);
      case _StepVisualState.upcoming:
        circleBackground = AppColors.neutral200;
        circleForeground = AppColors.neutral600;
        ring = null;
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: circleBackground,
              shape: BoxShape.circle,
              border: ring,
            ),
            alignment: Alignment.center,
            child: state == _StepVisualState.completed
                ? Icon(
                    Icons.check,
                    size: AppDimensions.iconSm.r,
                    color: circleForeground,
                  )
                : CustomText(
                    text: '$stepNumber',
                    style: AppTextStyles.label,
                    color: circleForeground,
                  ),
          ),
          SizedBox(height: AppSpacing.s2xs.h),
          CustomText(
            text: label,
            style: AppTextStyles.microLabel,
            color: state == _StepVisualState.upcoming
                ? AppColors.neutral400
                : AppColors.neutral700,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.only(bottom: AppSpacing.lg.h),
        color: active ? AppColors.primary : AppColors.neutral200,
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd.r),
        side: const BorderSide(color: AppColors.neutral200),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: AppDimensions.stepperButtonSize.r,
          height: AppDimensions.inputHeight.h,
          child: Icon(
            icon,
            size: AppDimensions.iconSm.r,
            color: enabled ? AppColors.neutral700 : AppColors.neutral400,
          ),
        ),
      ),
    );
  }
}

class _InvoiceLineCard extends StatelessWidget {
  const _InvoiceLineCard({required this.line, required this.onDelete});

  final InvoiceLine line;
  final VoidCallback onDelete;

  static String _formatQuantity(double quantity) {
    if (quantity == quantity.truncateToDouble()) {
      return quantity.toInt().toString();
    }
    return quantity.toString();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomText(
                  text: line.itemName,
                  style: AppTextStyles.cardTitle,
                  color: AppColors.neutral900,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppSpacing.sm.w),
              SizedBox(
                width: AppDimensions.iconButtonSize.w,
                height: AppDimensions.iconButtonSize.w,
                child: IconButton(
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.delete_outline,
                    size: AppDimensions.iconMd.r,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs.h),
          Container(
            padding: EdgeInsets.only(top: AppSpacing.xs.h),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.neutral200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text:
                        '${_formatQuantity(line.quantity)} × ${DashboardAmountFormatter.format(line.sellingPrice)}',
                    style: AppTextStyles.bodySmall,
                    color: AppColors.neutral500,
                  ),
                ),
                CustomText(
                  text: DashboardAmountFormatter.format(line.total),
                  style: AppTextStyles.label,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.coral = false,
  });

  final String label;
  final String value;
  final bool emphasized;
  final bool coral;

  @override
  Widget build(BuildContext context) {
    if (coral) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.coralSubtle,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg.r),
          border: Border.all(color: AppColors.coral.withValues(alpha: 0.35)),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: label,
                style: AppTextStyles.sectionTitle,
                color: AppColors.coral,
              ),
            ),
            CustomText(
              text: value,
              style: AppTextStyles.amount,
              color: AppColors.coral,
            ),
          ],
        ),
      );
    }

    if (emphasized) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primarySubtle,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: label,
                style: AppTextStyles.sectionTitle,
                color: AppColors.primary,
              ),
            ),
            CustomText(
              text: value,
              style: AppTextStyles.sectionTitle,
              color: AppColors.primary,
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: CustomText(
            text: label,
            style: AppTextStyles.bodyMedium,
            color: AppColors.neutral600,
          ),
        ),
        CustomText(
          text: value,
          style: AppTextStyles.bodyStrong,
          color: AppColors.neutral900,
        ),
      ],
    );
  }
}
