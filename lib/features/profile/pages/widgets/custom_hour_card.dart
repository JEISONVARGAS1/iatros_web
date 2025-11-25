import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';

class CustomHourCard extends StatelessWidget {
  final Function() tap;
  final TimeOfDay endDate;
  final TimeOfDay startDate;
  final Function() deleteTap;

  const CustomHourCard({
    super.key,
    required this.tap,
    required this.endDate,
    required this.deleteTap,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      margin: const EdgeInsets.only(left: 16, bottom: AppSpacing.paddingSM),
      child: InkWell(
        onTap: tap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${startDate.format(context)} - ${endDate.format(context)}',
                style: AppTypography.bodyMedium,
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AppColors.error),
              onPressed: deleteTap,
            ),
          ],
        ),
      ),
    );
  }
}
