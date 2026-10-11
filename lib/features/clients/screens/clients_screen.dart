import 'package:billing_and_sales_management/core/errors/client_exception.dart';
import 'package:billing_and_sales_management/domain/clients/entities/client.dart';
import 'package:billing_and_sales_management/features/clients/providers/clients_notifier.dart';
import 'package:billing_and_sales_management/features/clients/widgets/client_form_sheet.dart';
import 'package:billing_and_sales_management/responsive/responsive.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddClientSheet() {
    showAppBottomSheet<void>(
      context: context,
      title: 'Add Client',
      builder: (_) => const ClientFormSheet(),
    );
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
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Clients',
        subtitle: 'Customer Database',
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
                hint: 'Search clients...',
                onChanged: (value) => setState(() => _query = value),
              ),
              SizedBox(height: AppSpacing.base.h),
              Expanded(
                child: clientsState.when(
                  loading: () => const CustomSkeletonList(count: 4),
                  error: (error, _) => CustomErrorState(
                    title: 'Could not load clients',
                    message: error is ClientException
                        ? error.message
                        : 'Something went wrong. Please try again.',
                    onRetry: () => ref.read(clientsProvider.notifier).refresh(),
                  ),
                  data: (clients) => _ClientsList(
                    clients: _filter(clients),
                    isSearching: _query.trim().isNotEmpty,
                    onAddClient: _openAddClientSheet,
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
  });

  final List<Client> clients;
  final bool isSearching;
  final VoidCallback onAddClient;

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      if (isSearching) {
        return const CustomEmptyState(
          icon: Icons.search_off_outlined,
          title: 'No Clients Found',
          message: 'No clients match your search.',
        );
      }

      return CustomEmptyState(
        icon: Icons.people_outline,
        iconColor: AppColors.primary,
        iconBackgroundColor: AppColors.primarySubtle,
        title: 'No Clients Registered',
        message: 'Add customer accounts to invoice them directly.',
        action: CustomButton(
          text: '+ Add Client',
          size: CustomButtonSize.small,
          width: 200.w,
          onPressed: onAddClient,
        ),
      );
    }

    return ListView.separated(
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
