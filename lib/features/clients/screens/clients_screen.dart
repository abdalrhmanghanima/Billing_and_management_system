import 'package:billing_and_sales_management/core/enums/delete_result.dart';
import 'package:billing_and_sales_management/core/errors/client_exception.dart';
import 'package:billing_and_sales_management/core/translate/app_translate.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/features/clients/providers/clients_notifier.dart';
import 'package:billing_and_sales_management/features/clients/screens/client_details_screen.dart';
import 'package:billing_and_sales_management/features/clients/widgets/client_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  bool _isDeleting = false;
  bool _isRefreshing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddClientSheet() {
    showAppBottomSheet<void>(
      context: context,
      title: AppTranslate.addClient.tr(),
      builder: (_) => const ClientFormSheet(),
    );
  }

  void _openEditClientSheet(Client client) {
    showAppBottomSheet<void>(
      context: context,
      title: AppTranslate.editClient.tr(),
      builder: (_) => ClientFormSheet(existing: client),
    );
  }

  void _openClientDetails(Client client) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ClientDetailsScreen(client: client),
      ),
    );
  }

  Future<void> _confirmDeleteClient(Client client) async {
    if (_isDeleting) return;

    final confirmed = await showConfirmDeleteDialog(
      context: context,
      title: AppTranslate.deleteClientQuestion.tr(),
      message: AppTranslate.deleteClientConfirmationMessage.tr(
        namedArgs: {'name': client.name},
      ),
    );

    if (!confirmed || !mounted) return;

    setState(() => _isDeleting = true);

    final result = await ref
        .read(clientsProvider.notifier)
        .deleteClient(client.id);

    if (!mounted) return;

    setState(() => _isDeleting = false);

    switch (result) {
      case DeleteResult.success:
        CustomSnackbar.showSuccess(
          context,
          AppTranslate.clientDeletedSuccessfully.tr(),
        );
      case DeleteResult.blocked:
        CustomSnackbar.showError(
          context,
          AppTranslate.cannotDeleteClientRightNow.tr(),
        );
      case DeleteResult.failure:
        CustomSnackbar.showError(
          context,
          AppTranslate.couldNotDeleteClient.tr(),
        );
    }
  }

  Future<void> _refresh() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      await ref.read(clientsProvider.notifier).refresh();
    } finally {
      _isRefreshing = false;
    }
  }

  List<Client> _filter(List<Client> clients) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return clients;

    return clients
        .where(
          (client) =>
              client.name.toLowerCase().contains(query) ||
              client.phone.contains(query) ||
              client.address.toLowerCase().contains(query),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final clientsState = ref.watch(clientsProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AppTranslate.clients.tr(),
        subtitle: AppTranslate.clientsSubtitle.tr(),
        showBackArrow: false,
      ),
      body: MaxWidthBox(
        maxWidth: AppDimensions.maxContentWidth,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.base.h),
              CustomSearchBar(
                controller: _searchController,
                hint: AppTranslate.searchClients.tr(),
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: RefreshIndicator(
                  color: context.palette.accentText,
                  onRefresh: _refresh,
                  child: clientsState.when(
                    loading: () => const CustomSkeletonList(count: 4),
                    error: (error, _) => CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: CustomErrorState(
                            title: AppTranslate.couldNotLoadClients.tr(),
                            message: error is ClientException
                                ? error.message
                                : AppTranslate.somethingWentWrong.tr(),
                            onRetry: () =>
                                ref.read(clientsProvider.notifier).refresh(),
                          ),
                        ),
                      ],
                    ),
                    data: (clients) => _ClientsList(
                      clients: _filter(clients),
                      isSearching: _query.trim().isNotEmpty,
                      onAddClient: _openAddClientSheet,
                      onOpenClient: _openClientDetails,
                      onEditClient: _openEditClientSheet,
                      onDeleteClient: _confirmDeleteClient,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.pageBottom.h),
            ],
          ),
        ),
      ),
      floatingActionButton: _AddClientButton(onPressed: _openAddClientSheet),
    );
  }
}

class _ClientsList extends StatelessWidget {
  const _ClientsList({
    required this.clients,
    required this.isSearching,
    required this.onAddClient,
    required this.onOpenClient,
    required this.onEditClient,
    required this.onDeleteClient,
  });

  final List<Client> clients;
  final bool isSearching;
  final VoidCallback onAddClient;
  final ValueChanged<Client> onOpenClient;
  final ValueChanged<Client> onEditClient;
  final ValueChanged<Client> onDeleteClient;

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      final emptyState = isSearching
          ? CustomEmptyState(
              icon: Icons.search_off_outlined,
              title: AppTranslate.noClientsFound.tr(),
              message: AppTranslate.noClientsMatchSearch.tr(),
            )
          : CustomEmptyState(
              icon: Icons.people_outline,
              iconColor: context.palette.accentText,
              iconBackgroundColor: context.palette.primarySubtle,
              title: AppTranslate.noClientsRegistered.tr(),
              message: AppTranslate.addCustomerAccountsMessage.tr(),
              action: CustomButton(
                text: AppTranslate.plusAddClient.tr(),
                size: CustomButtonSize.small,
                width: 200.w,
                onPressed: onAddClient,
              ),
            );

      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [SliverFillRemaining(hasScrollBody: false, child: emptyState)],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: clients.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppSpacing.cardGap.h),
      itemBuilder: (context, index) {
        final client = clients[index];

        return CustomEntityTile(
          avatarText: client.initials,
          avatarTone: index.isEven
              ? EntityAvatarTone.coral
              : EntityAvatarTone.primary,
          title: client.name,
          subtitle: '${client.phone} · #${client.number}',
          showChevron: false,
          onTap: () => onOpenClient(client),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                icon: Icons.edit_outlined,
                onPressed: () => onEditClient(client),
                size: AppDimensions.headerActionSize,
                iconSize: AppDimensions.iconSm,
                shadow: false,
                tooltip: AppTranslate.edit.tr(),
              ),
              SizedBox(width: AppSpacing.xs.w),
              CustomIconButton(
                icon: Icons.delete_outline,
                onPressed: () => onDeleteClient(client),
                size: AppDimensions.headerActionSize,
                iconSize: AppDimensions.iconSm,
                shadow: false,
                foregroundColor: AppColors.error,
                tooltip: AppTranslate.delete.tr(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddClientButton extends StatelessWidget {
  const _AddClientButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = AppDimensions.fabSize.r;

    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: AppShadows.fab,
      ),
      child: Material(
        color: AppColors.primary,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              Icons.add,
              size: AppDimensions.iconLg.r,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
