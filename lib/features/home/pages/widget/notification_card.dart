import 'package:flutter/material.dart';
import 'package:iatros_web/core/models/notification_result_model.dart';
import 'package:iatros_web/uikit/index.dart';

class NotificationCard extends StatefulWidget {
  final NotificationResultModel notification;
  final VoidCallback onRemove;

  const NotificationCard({required this.notification, required this.onRemove, super.key});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    // After 18 seconds, fade out
    Future.delayed(const Duration(seconds: 18), () {
      _controller.reverse();
      Future.delayed(const Duration(seconds: 2), widget.onRemove);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color getColor() {
    switch (widget.notification.status) {
      case StatusNotification.SUCCESS:
        return Colors.green.shade400;
      case StatusNotification.ERROR:
        return Colors.red.shade400;
      case StatusNotification.WARNING:
        return Colors.orange.shade400;
      case StatusNotification.ALERT:
        return Colors.grey.shade400;
    }
  }

  String getStatusTitle() {
    switch (widget.notification.status) {
      case StatusNotification.SUCCESS:
        return 'Éxito';
      case StatusNotification.ERROR:
        return 'Error';
      case StatusNotification.WARNING:
        return 'Advertencia';
      case StatusNotification.ALERT:
        return 'Alerta';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: BaseCard(
            backgroundColor: getColor(),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    UIHelpers.horizontalSpaceMD,
                    Expanded(
                      child: Text(
                        getStatusTitle(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '${widget.notification.createdAt.hour}:${widget.notification.createdAt.minute.toString().padLeft(2, '0')}',
                      style: AppTypography.bodySmall.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Descripción: ${widget.notification.message}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}