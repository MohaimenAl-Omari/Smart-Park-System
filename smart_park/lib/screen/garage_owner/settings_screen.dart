import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_park/screen/sharing/contact_us_screen.dart';
import 'package:smart_park/screen/sharing/terms_and_conditions_screen.dart';
import '../../controller/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final SettingsController controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Settings'.tr,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2EC4B6),
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(w * 0.05),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(w * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: w * 0.09,
                          backgroundColor:
                          const Color(0xFF2EC4B6).withOpacity(0.18),
                          child: const Icon(
                            Icons.person,
                            color: Color(0xFF2EC4B6),
                            size: 42,
                          ),
                        ),
                        SizedBox(height: h * 0.015),
                        Obx(
                              () => Text(
                            controller.name.value.isEmpty
                                ? 'User'.tr
                                : controller.name.value,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.006),
                        Obx(
                              () => Text(
                            controller.role.value,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.72),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: h * 0.025),

                  _settingTile(
                    icon: Icons.person_outline,
                    title: 'My Information'.tr,
                    subtitle: 'View your account details'.tr,
                    onTap: () => _showUserInfo(context),
                  ),

                  _settingTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password'.tr,
                    subtitle: 'Update your account password'.tr,
                    onTap: () => _showChangePasswordDialog(context),
                  ),

                  _settingTile(
                    icon: Icons.language_outlined,
                    title: 'Language'.tr,
                    subtitle: 'Change app language'.tr,
                    onTap: () => _showLanguageBottomSheet(context),
                  ),

                  _settingTile(
                    icon: Icons.description_outlined,
                    title: 'Terms & Conditions'.tr,
                    subtitle: 'Read app terms and conditions'.tr,
                    onTap: () {
                      Get.to(() => TermsAndConditionsScreen());
                    },
                  ),

                  _settingTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Contact Support'.tr,
                    subtitle: 'Get help from support team'.tr,
                    onTap: () {
                     Get.to(() => ContactUsScreen());
                    },
                  ),

                  _settingTile(
                    icon: Icons.logout,
                    title: 'Logout'.tr,
                    subtitle: 'Sign out from your account'.tr,
                    iconColor: Colors.redAccent,
                    onTap: () => controller.logout(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF2EC4B6),
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.68),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUserInfo(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1C2E35),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Obx(
              () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('Name'.tr, controller.name.value),
              _infoRow('Email'.tr, controller.email.value),
              _infoRow('Phone'.tr, controller.phone.value),
              _infoRow('Role'.tr, controller.role.value),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isEmpty ? '-' : value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1C2E35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Change Password'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 18),
              _dialogField(
                controller: controller.currentPasswordController,
                label: 'Current Password'.tr,
              ),
              const SizedBox(height: 12),
              _dialogField(
                controller: controller.newPasswordController,
                label: 'New Password'.tr,
              ),
              const SizedBox(height: 12),
              _dialogField(
                controller: controller.confirmPasswordController,
                label: 'Confirm Password'.tr,
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC4B6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Save'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.70)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1C2E35),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Get.back();
                controller.changeLanguage('en');
              },
              leading: const Icon(Icons.language, color: Color(0xFF2EC4B6)),
              title: const Text(
                'English',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                controller.changeLanguage('ar');
              },
              leading: const Icon(Icons.language, color: Color(0xFF2EC4B6)),
              title: const Text(
                'العربية',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
