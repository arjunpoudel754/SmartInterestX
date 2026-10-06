import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:my_backend_app_2/screens/utils/colors.dart';
import 'package:my_backend_app_2/screens/widgets/dashboard_widgets.dart';
import 'package:my_backend_app_2/providers/transaction_provider.dart';
import 'package:my_backend_app_2/models/transaction_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashColors.background,
      body: SafeArea(
        bottom: false,
        child: Consumer<TransactionProvider>(
          builder: (context, provider, child) {
            final transactions = provider.transactions;

            double interestEarned = 0;
            double totalGiven = 0;
            double totalTaken = 0;

            for (var t in transactions) {
              if (t.type == TransactionType.given) {
                totalGiven += t.amount;
                // mock interest
              } else {
                totalTaken += t.amount;
              }
            }

            final totalSum = totalGiven + totalTaken;
            final flexGiven = totalSum == 0 ? 50 : ((totalGiven / totalSum) * 100).toInt();
            final flexTaken = totalSum == 0 ? 50 : 100 - flexGiven;
            final currentMonth = DateFormat('MMMM yyyy').format(DateTime.now());
            final currency = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                const DashAppBar(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Analytics', style: dashText(26, FontWeight.w800, DashColors.mainText)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: DashColors.blueSoft,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Text(currentMonth, style: dashText(12, FontWeight.w600, DashColors.blue)),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down, size: 16, color: DashColors.blue),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                DashCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Interest Earned', style: dashText(14, FontWeight.w600, DashColors.subText)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: DashColors.successBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('↑ 8.4%', style: dashText(12, FontWeight.w700, DashColors.success)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(currency.format(interestEarned), style: dashText(32, FontWeight.w800, DashColors.mainText)),
                      const SizedBox(height: 8),
                      Text('Interest accumulated across your active loans', style: dashText(12, FontWeight.w500, DashColors.subText)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DashCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Interest Flow', style: dashText(14, FontWeight.w700, DashColors.mainText)),
                          Text('H1 2026', style: dashText(12, FontWeight.w600, DashColors.subText)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: _ChartPainter(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun']
                            .map((m) => Text(m, style: dashText(12, FontWeight.w500, DashColors.subText)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                DashCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Given vs Taken', style: dashText(14, FontWeight.w700, DashColors.mainText)),
                          Text('Ratio Summary', style: dashText(12, FontWeight.w600, DashColors.subText)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: flexGiven,
                            child: Container(
                              height: 16,
                              decoration: BoxDecoration(
                                color: DashColors.success,
                                borderRadius: flexGiven == 100 
                                    ? BorderRadius.circular(8) 
                                    : const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: flexTaken,
                            child: Container(
                              height: 16,
                              decoration: BoxDecoration(
                                color: DashColors.danger,
                                borderRadius: flexTaken == 100 
                                    ? BorderRadius.circular(8) 
                                    : const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: DashColors.success, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Text('GIVEN', style: dashText(10, FontWeight.w700, DashColors.subText)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(currency.format(totalGiven), style: dashText(16, FontWeight.w800, DashColors.mainText)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: DashColors.danger, shape: BoxShape.circle)),
                                  const SizedBox(width: 6),
                                  Text('TAKEN', style: dashText(10, FontWeight.w700, DashColors.subText)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(currency.format(totalTaken), style: dashText(16, FontWeight.w800, DashColors.mainText)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = DashColors.border
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    // Grid lines
    for (int i = 0; i <= 3; i++) {
      double y = size.height * (i / 3);
      // Dotted line effect
      for (double j = 0; j < size.width; j += 6) {
        canvas.drawLine(Offset(j, y), Offset(j + 3, y), paintGrid);
      }
    }

    final paintGreen = Paint()
      ..color = DashColors.success
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
      
    final paintRed = Paint()
      ..color = DashColors.danger
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final dotPaintGreen = Paint()..color = DashColors.success;
    final dotPaintRed = Paint()..color = DashColors.danger;
    final dotPaintWhite = Paint()..color = Colors.white;

    // Dummy points
    final w = size.width;
    final h = size.height;
    final greenPoints = [
      Offset(0, h * 0.7),
      Offset(w * 0.2, h * 0.68),
      Offset(w * 0.4, h * 0.75),
      Offset(w * 0.6, h * 0.4),
      Offset(w * 0.8, h * 0.2),
      Offset(w, h * 0.05),
    ];

    final redPoints = [
      Offset(0, h * 0.95),
      Offset(w * 0.2, h * 0.9),
      Offset(w * 0.4, h * 0.9),
      Offset(w * 0.6, h * 0.85),
      Offset(w * 0.8, h * 0.87),
      Offset(w, h * 0.92),
    ];

    void drawLine(List<Offset> pts, Paint pLine, Paint pDot) {
      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      canvas.drawPath(path, pLine);
      for (final pt in pts) {
        canvas.drawCircle(pt, 4, pDot);
        canvas.drawCircle(pt, 2, dotPaintWhite);
      }
    }

    drawLine(greenPoints, paintGreen, dotPaintGreen);
    drawLine(redPoints, paintRed, dotPaintRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
