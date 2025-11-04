import 'package:flutter/material.dart';
import 'package:iatros_web/uikit/index.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BaseCard(
                backgroundColor: AppColors.medicalBlue,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXL),
                padding: const EdgeInsets.all(AppSpacing.paddingLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          child: Icon(Icons.person, size: 28),
                        ),
                        UIHelpers.horizontalSpaceMD,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("name", style: AppTypography.h5),
                              Text(
                                "jeison vargas",
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    UIHelpers.verticalSpaceLG,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _miniMetric('Age', '36y'),
                        _miniMetric('Height', '170 cm'),
                        _miniMetric('Weight', '60 kg'),
                      ],
                    ),
                  ],
                ),
              ),
              UIHelpers.verticalSpaceMD,
              Text('Notificaciones', style: AppTypography.h5),
              UIHelpers.verticalSpaceSM,
              ...List.generate(3, (i) {
                return BaseCard(
                  backgroundColor: AppColors.surface,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      UIHelpers.horizontalSpaceMD,
                      const Expanded(
                        child: Text('Recordatorio de cita y seguimiento.'),
                      ),
                      Text('29 Ago', style: AppTypography.bodySmall),
                    ],
                  ),
                );
              }),
              UIHelpers.verticalSpaceMD,
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(label: 'Nueva cita', onPressed: () {}),
                  ),
                  UIHelpers.horizontalSpaceSM,
                  Expanded(
                    child: SecondaryButton(
                      label: 'Ver historial',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        UIHelpers.horizontalSpaceLG,
        // Panel principal
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Examinations', style: AppTypography.h3),
                  TextButton(onPressed: () {}, child: const Text('Ver todo')),
                ],
              ),
              UIHelpers.verticalSpaceSM,
              // Tarjetas de exámenes
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _examCard(
                    'Hypertensive crisis',
                    'Ongoing treatment',
                    AppColors.turquoise,
                  ),
                  _examCard('Osteoporosis', 'Examination', AppColors.peach),
                  _examCard(
                    'Hypertensive crisis',
                    'Examination',
                    AppColors.coral,
                  ),
                ],
              ),
              UIHelpers.verticalSpaceLG,
              // Curva de salud
              BaseCard(
                backgroundColor: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Health Curve', style: AppTypography.h4),
                    UIHelpers.verticalSpaceMD,
                    SizedBox(
                      height: 180,
                      child: CustomPaint(
                        painter: _HealthCurvePainter(color: AppColors.primary),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary.withOpacity(0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              UIHelpers.verticalSpaceLG,
              // Nearest Treatment + Advice
              Row(
                children: [
                  Expanded(
                    child: BaseCard(
                      backgroundColor: AppColors.medicalBlue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nearest Treatment', style: AppTypography.h4),
                          UIHelpers.verticalSpaceSM,
                          Text(
                            'Agosto 29, 10:00 AM — Cardiología',
                            style: AppTypography.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIHelpers.horizontalSpaceMD,
                  Expanded(
                    child: BaseCard(
                      backgroundColor: AppColors.botanicalGreen,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Advice', style: AppTypography.h4),
                          UIHelpers.verticalSpaceSM,
                          const Text(
                            'Mantén un seguimiento constante y revisa la presión diariamente.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Helpers UI
Widget _miniMetric(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: AppTypography.bodySmall),
      Text(value, style: AppTypography.h6),
    ],
  );
}

Widget _examCard(String title, String subtitle, Color bg) {
  return SizedBox(
    width: 260,
    child: BaseCard(
      backgroundColor: bg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [Icon(Icons.favorite, color: Colors.redAccent)]),
          UIHelpers.verticalSpaceSM,
          Text(title, style: AppTypography.h5),
          Text(subtitle, style: AppTypography.bodySmall),
        ],
      ),
    ),
  );
}

class _HealthCurvePainter extends CustomPainter {
  final Color color;
  _HealthCurvePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.4,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width * 0.9,
      size.height * 0.9,
      size.width,
      size.height * 0.5,
    );

    canvas.drawPath(path, paint);

    // puntos
    final dotPaint = Paint()..color = color;
    for (double x = 0; x <= size.width; x += size.width / 6) {
      canvas.drawCircle(
        Offset(x, size.height * 0.5 + 10 * (x / size.width - 0.5)),
        3,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
