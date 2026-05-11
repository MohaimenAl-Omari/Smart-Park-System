import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_park/controller/auth_controller.dart';
import 'package:smart_park/controller/garage_controller.dart';
import 'package:smart_park/screen/garage_owner/add_garage_info_screen.dart';
import 'package:smart_park/screen/garage_owner/my_reservation.dart';
import 'package:smart_park/screen/garage_owner/statistics_screen.dart';
import 'package:smart_park/screen/sharing/login_screen.dart';
import 'package:smart_park/screen/garage_owner/settings_screen.dart';
import 'package:smart_park/screen/garage_owner/update_availability_screen.dart';

import 'edit_garage_screen.dart';

class GarageOwnerHomeScreen extends StatefulWidget {
  const GarageOwnerHomeScreen({super.key});
  @override
  State<GarageOwnerHomeScreen> createState() => _GarageOwnerHomeScreenState();
}

class _GarageOwnerHomeScreenState extends State<GarageOwnerHomeScreen> {
  final AuthController authController = Get.find<AuthController>();
  final GarageController garageController = Get.put(GarageController());
  @override
  void initState() {
    super.initState();
    garageController.getMyGarage();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1F45),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Garage Owner Home'.tr,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => SettingsScreen());
              },
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () async {
                await authController.logout();
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF06152E),
                  Color(0xFF0B1F45),
                  Color(0xFF0C3D68),
                ],
              ),
            ),
          ),
          Positioned(
            top: -h * 0.08,
            right: -w * 0.12,
            child: _GlowCircle(
              size: w * 0.5,
              color: const Color(0xFF2EC4B6),
              opacity: 0.14,
            ),
          ),
          SafeArea(
            child: Obx(() {
              if (garageController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(w * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome'.tr,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: h * 0.008),
                    Text(
                      'Manage your garage and reservations from here.'.tr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.76),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: h * 0.025),
                    if (!garageController.hasGarage.value)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(w * 0.045),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(w * 0.05),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.38),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.orange.shade300,
                                  size: w * 0.07,
                                ),
                                SizedBox(width: w * 0.025),
                                Expanded(
                                  child: Text(
                                    'You have not added your garage information yet.'.tr,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: h * 0.012),
                            Text(
                              'Please add your garage information to make it visible for car owners.'.tr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                height: 1.45,
                              ),
                            ),
                            SizedBox(height: h * 0.02),
                            SizedBox(
                              width: double.infinity,
                              height: h * 0.06,
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => const AddGarageInfoScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(w * 0.04),
                                  ),
                                ),
                                child: Text(
                                  'Add Garage Information'.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (garageController.hasGarage.value) ...[
                      Text(
                        'Quick Actions'.tr,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: h * 0.015),

                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: w * 0.04,
                        mainAxisSpacing: h * 0.02,
                        childAspectRatio: 0.85,
                        children: [
                          _ActionButton(
                            icon: Icons.edit_outlined,
                            title: 'Edit Garage'.tr,
                            subtitle: 'Update your garage details'.tr,
                            onTap: () {
                              Get.to(() => EditGarageScreen());

                            },
                          ),
                          _ActionButton(
                            icon: Icons.event_note_outlined,
                            title: 'Reservations'.tr,
                            subtitle: 'View booking requests'.tr,
                            onTap: () {
                              Get.to(() =>  MyReservationScreen());
                            },
                          ),
                          _ActionButton(
                            icon: Icons.update_outlined,
                            title: 'Update Availability'.tr,
                            subtitle: 'Manage available spaces'.tr,
                            onTap: () {
                              Get.to(() => UpdateAvailabilityScreen());
                            },
                          ),
                          _ActionButton(
                            icon: Icons.bar_chart_outlined,
                            title: 'Statistics'.tr,
                            subtitle: 'Check garage performance'.tr,
                            onTap: () {
                              Get.to(() => StatisticsScreen());
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: w * 0.03),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(w * 0.05),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(w * 0.05),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.16),
                Colors.white.withOpacity(0.07),
              ],
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.14),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(w * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(w * 0.025),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2EC4B6).withOpacity(0.16),
                    borderRadius: BorderRadius.circular(w * 0.03),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF2EC4B6),
                    size: w * 0.07,
                  ),
                ),
                const Spacer(),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: w * 0.04 > 17 ? 17 : w * 0.04,
                  ),
                ),
                SizedBox(height: w * 0.015),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.72),
                    fontSize: w * 0.031 > 13 ? 13 : w * 0.031,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: w * 0.03),
                Row(
                  children: [
                    Text(
                      'Open'.tr,
                      style: TextStyle(
                        color: const Color(0xFF2EC4B6),
                        fontWeight: FontWeight.w700,
                        fontSize: w * 0.032 > 13 ? 13 : w * 0.032,
                      ),
                    ),
                    SizedBox(width: w * 0.015),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF2EC4B6),
                      size: 14,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _GlowCircle extends StatelessWidget {
  const _GlowCircle({
    required this.size,
    required this.color,
    required this.opacity,
  });

  final double size;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(opacity),
      ),
    );
  }
}