import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:iatros_web/uikit/extensions/context_extension.dart';
import 'package:iatros_web/features/home/provider/home_controller.dart';
import 'package:iatros_web/features/home/provider/model/home_state.dart';
import 'package:iatros_web/features/home/pages/widget/notification_card.dart';

class NotificationPanel extends StatelessWidget {
  final HomeState state;
  final HomeController controller;

  const NotificationPanel({
    super.key,
    required this.state,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 400,
        maxHeight: controller.handledShowPanelDoctors() ? context.sizeHeight(0.45) : context.sizeHeight(0.9),
      ),
      child: BaseCard(
          elevation: 4.0,
        backgroundColor: AppColors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Notificaciones', style: AppTypography.h5),
            UIHelpers.verticalSpaceSM,
            if (state.listNotification.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: controller.handledShowPanelDoctors() ? context.sizeHeight(0.1) : context.sizeHeight(0.4),),
                child: Column(
                  children: [
                    Icon(Icons.notification_add_outlined, size: 45),
                    SizedBox(height: 10),
                    Text('No hay notificaciones'),
                  ],
                ),
              )
            else
              ...state.listNotification.map(
                (notification) => NotificationCard(
                  notification: notification,
                  onRemove: () => controller.removeNotification(notification),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
