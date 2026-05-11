import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/StatisticsController.dart';

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({super.key});

  final controller = Get.put(StatisticsController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF0F2027),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F45),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Statistics'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            w * 0.05,
            h * 0.12,
            w * 0.05,
            h * 0.03,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HERO REVENUE CARD
              _buildRevenueCard(w, h),

              SizedBox(height: h * 0.035),

              // Section header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3.5,
                        height: 18,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2EC4B6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Statistics'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.analytics_outlined,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // GRID
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: w * 0.04,
                mainAxisSpacing: h * 0.02,
                childAspectRatio: 1.05,
                children: [
                  _statCard(
                    'total'.tr,
                    controller.total.value,
                    Icons.list_alt_rounded,
                    Colors.white,
                  ),
                  _statCard(
                    'pending'.tr,
                    controller.pending.value,
                    Icons.hourglass_bottom,
                    Colors.orange,
                  ),
                  _statCard(
                    'accepted'.tr,
                    controller.accepted.value,
                    Icons.check_circle,
                    Colors.green,
                  ),
                  _statCard(
                    'rejected'.tr,
                    controller.rejected.value,
                    Icons.cancel,
                    Colors.redAccent,
                  ),
                  _statCard(
                    'cancelled'.tr,
                    controller.cancelled.value,
                    Icons.block,
                    Colors.grey,
                  ),
                ],
              ),

              SizedBox(height: h * 0.025),

              // Distribution summary strip
              _buildDistributionStrip(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRevenueCard(double w, double h) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.06),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2EC4B6),
            Color(0xFF1A8F86),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2EC4B6).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.monetization_on,
              color: Colors.white,
              size: 28,
            ),
          ),
          SizedBox(width: w * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total_revenue'.tr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: h * 0.008),
                Obx(() => Text(
                  "${controller.revenue.value} JOD",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                )),
              ],
            ),
          ),
          // Small total reservations badge
          Obx(() => Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_rounded,
                    color: Colors.white, size: 13),
                const SizedBox(width: 4),
                Text(
                  '${controller.total.value}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _statCard(
      String title, dynamic value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.16),
            Colors.white.withOpacity(0.07),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon with colored dot accent
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF0F2027), width: 1.5),
                    ),
                  ),
                ),
              ],
            ),

            // Value
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),

            // Title pill
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: TextStyle(
                  color: color == Colors.white
                      ? Colors.white.withOpacity(0.8)
                      : color.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionStrip() {
    return Obx(() {
      final total = controller.total.value;
      if (total == 0) return const SizedBox.shrink();

      final segments = [
        _Seg(controller.accepted.value, Colors.green),
        _Seg(controller.pending.value, Colors.orange),
        _Seg(controller.rejected.value, Colors.redAccent),
        _Seg(controller.cancelled.value, Colors.grey),
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESERVATIONS BREAKDOWN',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              height: 6,
              child: Row(
                children: segments.map((s) {
                  final flex =
                  ((s.value / total) * 1000).round().clamp(1, 1000);
                  return Expanded(
                    flex: flex,
                    child: Container(
                      color: s.color,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _dot(Colors.green, 'Accepted'),
              _dot(Colors.orange, 'Pending'),
              _dot(Colors.redAccent, 'Rejected'),
              _dot(Colors.grey, 'Cancelled'),
            ],
          ),
        ],
      );
    });
  }

  Widget _dot(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        children: [
          Container(
              width: 7,
              height: 7,
              decoration:
              BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 10,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _Seg {
  final int value;
  final Color color;
  const _Seg(this.value, this.color);
}