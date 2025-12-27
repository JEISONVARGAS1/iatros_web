import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iatros_web/core/models/user_company_model.dart';
import 'package:iatros_web/features/lobby/provider/lobby_controller.dart';

class CompanySelectionPanel extends ConsumerWidget {
  const CompanySelectionPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbyState = ref.watch(lobbyControllerProvider);
    final controller = ref.read(lobbyControllerProvider.notifier);

    if (lobbyState.isLoading || lobbyState.hasError) {
      return const SizedBox.shrink();
    }

    final state = lobbyState.value!;
    final userCompanies = state.userCompanies;

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Text(
              'Seleccionar Empresa',
              style: AppTypography.h2.copyWith(color: AppColors.gray900),
            ),
            const SizedBox(height: 16),
            // Company Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio: 0.1,
                  mainAxisExtent: context.sizeHeight(0.3),
                ),
                itemCount: userCompanies.length,
                itemBuilder: (context, index) {
                  final company = userCompanies[index];
                  final isSelected =
                      company.id == state.userCompaniesSelected.id;
  
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: InkWell(
                      onTap: () => controller.selectCompany(company),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [AppColors.primary.withOpacity(0.1), AppColors.primary.withOpacity(0.05)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          border: isSelected
                              ? Border.all(color: AppColors.primary, width: 2)
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.business,
                              size: 48,
                              color: isSelected ? AppColors.primary : AppColors.gray600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              company.company?.companyName ?? 'Empresa sin nombre',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.gray900,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'NIT: ${company.company?.nit ?? 'N/A'}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.gray600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Rol: ${company.rolUser.toName}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.gray600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Estado: ${company.status.toName}',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.gray600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (isSelected) ...[
                              const SizedBox(height: 8),
                              Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
