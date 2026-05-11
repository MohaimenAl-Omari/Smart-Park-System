import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_park/controller/auth_controller.dart';
import 'package:smart_park/models/user_model.dart';
import 'package:smart_park/screen/garage_owner/add_garage_info_screen.dart';
import 'package:smart_park/screen/garage_owner/garage_owner_home_screen.dart';
import 'package:smart_park/screen/car_owner/home_screen.dart';
import 'package:smart_park/screen/sharing/contact_us_screen.dart';
import 'package:smart_park/screen/sharing/role_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  String? _errorMsg;

  final AuthController _authController = Get.put(AuthController());

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _loading = true;
      _errorMsg = null;
    });

    final res = await _authController.login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    if (res['status'] == true && res['statusCode'] == 200) {
      final user = res['user'] as UserModel;
      final hasGarage = res['has_garage'] == true;

      if (user.role == 'car_owner') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (user.role == 'garage_owner') {
        if (!hasGarage) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AddGarageInfoScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GarageOwnerHomeScreen()),
          );
        }
      }
    } else {
      setState(() {
        _errorMsg = res['message']?.toString() ??
            'Login failed. Please check your credentials.'.tr;
      });
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;
    final w = size.width;
    final h = size.height;
    final theme = Theme.of(context);

    final horizontalPadding = w * 0.06;
    final topSpace = h * 0.035;
    final headerSpace = h * 0.025;
    final cardRadius = w * 0.05;
    final fieldGap = h * 0.016;
    final sectionGap = h * 0.022;
    final buttonHeight = h * 0.065;
    final logoSize = w * 0.2 > 82 ? 82.0 : w * 0.2;

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
            top: h * 0.22,
            left: -w * 0.14,
            child: _GlowCircle(
              size: w * 0.42,
              color: const Color(0xFF4DA3FF),
              opacity: 0.14,
            ),
          ),
          Positioned(
            bottom: -h * 0.07,
            right: -w * 0.08,
            child: _GlowCircle(
              size: w * 0.56,
              color: const Color(0xFF00D4FF),
              opacity: 0.1,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h - mq.padding.top),
                child: Column(
                  children: [
                    SizedBox(height: topSpace),
                    Container(
                      width: logoSize,
                      height: logoSize,
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
                        size: logoSize * 0.52,
                      ),
                    ),
                    SizedBox(height: headerSpace),
                    Text(
                      'Smart Park'.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: w * 0.075 > 32 ? 32 : w * 0.075,
                      ),
                    ),
                    SizedBox(height: h * 0.008),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                      child: Text(
                        'Reserve your parking spot before you arrive.'.tr,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.74),
                          height: 1.5,
                          fontSize: w * 0.038 > 16 ? 16 : w * 0.038,
                        ),
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.05,
                        vertical: h * 0.025,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(cardRadius),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.14),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: Offset(0, h * 0.015),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Welcome back'.tr,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: w * 0.06 > 26 ? 26 : w * 0.06,
                            ),
                          ),
                          SizedBox(height: h * 0.007),
                          Text(
                            'Log in to find nearby garages and book a spot in seconds.'.tr,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.72),
                              height: 1.45,
                            ),
                          ),
                          SizedBox(height: sectionGap),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _PremiumTextField(
                                  controller: _emailCtrl,
                                  label: 'Email'.tr,
                                  hint: 'example@email.com'.tr,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: Icons.email_outlined,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) {
                                      return 'Email is required'.tr;
                                    }
                                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                        .hasMatch(v.trim())) {
                                      return 'Enter a valid email'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: fieldGap),
                                _PremiumTextField(
                                  controller: _passwordCtrl,
                                  label: 'Password'.tr,
                                  hint: 'Enter your password'.tr,
                                  prefixIcon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  validator: (v) {
                                    if (v == null || v.isEmpty) {
                                      return 'Password is required'.tr;
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (_errorMsg != null) ...[
                            SizedBox(height: h * 0.018),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.035,
                                vertical: h * 0.014,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.14),
                                borderRadius: BorderRadius.circular(w * 0.04),
                                border: Border.all(
                                  color: const Color(0xFFEF4444).withOpacity(0.35),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.error_outline_rounded,
                                    color: Color(0xFFFF6B6B),
                                  ),
                                  SizedBox(width: w * 0.025),
                                  Expanded(
                                    child: Text(
                                      _errorMsg!,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          SizedBox(height: sectionGap),
                          SizedBox(
                            height: buttonHeight,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(w * 0.045),
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF2EC4B6),
                                    Color(0xFF00A6FF),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00A6FF).withOpacity(0.22),
                                    blurRadius: 22,
                                    offset: Offset(0, h * 0.012),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: _loading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  disabledBackgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(w * 0.045),
                                  ),
                                ),
                                child: _loading
                                    ? SizedBox(
                                  width: w * 0.06,
                                  height: w * 0.06,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                    color: Colors.white,
                                  ),
                                )
                                    : Text(
                                  'Login'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: w * 0.043 > 18 ? 18 : w * 0.043,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.018),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RoleSelectionScreen(),
                                ),
                              );
                            },

                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: h * 0.01),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Don’t have an account? '.tr,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.72),
                                      fontSize: w * 0.037 > 15 ? 15 : w * 0.037,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign Up'.tr,
                                    style: TextStyle(
                                      color: const Color(0xFF7DEBFF),
                                      fontSize: w * 0.037 > 15 ? 15 : w * 0.037,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: h * 0.01),

                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ContactUsScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.support_agent, color: Colors.white70),
                            label: Text(
                              'Contact Us'.tr,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.025),
                    Text(
                      '© ${DateTime.now().year} Smart Park • Parking made simple'.tr,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: w * 0.032 > 13 ? 13 : w * 0.032,
                      ),
                    ),
                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumTextField extends StatelessWidget {
  const _PremiumTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final h = mq.size.height;
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        color: Colors.white,
        fontSize: w * 0.038 > 16 ? 16 : w * 0.038,
        fontWeight: FontWeight.w500,
      ),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.86),
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.45),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.white.withOpacity(0.85),
          size: w * 0.055,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.08),
        contentPadding: EdgeInsets.symmetric(
          horizontal: w * 0.035,
          vertical: h * 0.018,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.045),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.045),
          borderSide: const BorderSide(
            color: Color(0xFF2EC4B6),
            width: 1.2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.045),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.65),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(w * 0.045),
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.85),
          ),
        ),
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontSize: w * 0.031 > 13 ? 13 : w * 0.031,
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