import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'signup_screen.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final theme = Theme.of(context);

    return Scaffold(
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
              opacity: 0.16,
            ),
          ),
          Positioned(
            bottom: -h * 0.07,
            left: -w * 0.08,
            child: _GlowCircle(
              size: w * 0.56,
              color: const Color(0xFF00D4FF),
              opacity: 0.1,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06),
              child: Column(
                children: [
                  SizedBox(height: h * 0.05),
                  Container(
                    width: w * 0.2 > 82 ? 82 : w * 0.2,
                    height: w * 0.2 > 82 ? 82 : w * 0.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w * 0.06),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2EC4B6),
                          Color(0xFF4DA3FF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.24),
                          blurRadius: 26,
                          offset: Offset(0, h * 0.014),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.local_parking_rounded,
                      color: Colors.white,
                      size: w * 0.1,
                    ),
                  ),
                  SizedBox(height: h * 0.03),
                  Text(
                    'Choose Your Role'.tr,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    'Select how you want to use Smart Park.'.tr,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.76),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: h * 0.05),
                  _RoleCard(
                    title: 'Car Owner'.tr,
                    subtitle: 'Find garages, check availability, and reserve your parking spot.'.tr,
                    icon: Icons.directions_car_filled_rounded,
                    onTap: () {
                      Get.to(() => const SignupScreen(role: 'car_owner'));
                    },
                  ),
                  SizedBox(height: h * 0.02),
                  _RoleCard(
                    title: 'Garage Owner'.tr,
                    subtitle: 'Manage your garage, parking spaces, and reservations.'.tr,
                    icon: Icons.garage_rounded,
                    onTap: () {
                      Get.to(() => const SignupScreen(role: 'garage_owner'));
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: Text(
                      'Already have an account? Login'.tr,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontWeight: FontWeight.w700,
                        fontSize: w * 0.038 > 16 ? 16 : w * 0.038,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(w * 0.05),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.05,
          vertical: h * 0.025,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(w * 0.05),
          border: Border.all(
            color: Colors.white.withOpacity(0.14),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 24,
              offset: Offset(0, h * 0.012),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: w * 0.16,
              height: w * 0.16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(w * 0.04),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF2EC4B6),
                    Color(0xFF00A6FF),
                  ],
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: w * 0.08,
              ),
            ),
            SizedBox(width: w * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: h * 0.006),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.75),
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: w * 0.02),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.8),
              size: w * 0.045,
            ),
          ],
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