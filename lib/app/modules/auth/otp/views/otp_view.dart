import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hire_me/app/modules/auth/otp/controllers/otp_controller.dart';
import 'package:hire_me/core/utils/app_color.dart';
import 'package:hire_me/core/utils/app_text_style.dart';

class AuthOtpView extends GetView<AuthOtpController> {
  const AuthOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              _buildTitle(),
              const SizedBox(height: 56),
              _buildOtpFields(),
              const SizedBox(height: 28),
              _buildResendRow(),
              const Spacer(),
              _buildConfirmButton(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text('Enter OTP', style: CustomTextstyle.Poppinsbold2),
        const SizedBox(height: 16),
        Text(
          'An 4 digit code has been sent to your\nemail',
          textAlign: TextAlign.center,
          style: CustomTextstyle.Poppinssemibold500,
        ),
      ],
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(4, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index < 3 ? 12 : 0),
          child: _OtpBox(
            controller: controller.otpControllers[index],
            focusNode: controller.focusNodes[index],
            onChanged: (val) => controller.onOtpChanged(index, val),
            isFirst: index == 0,
          ),
        );
      }),
    );
  }

  Widget _buildResendRow() {
    return Obx(() {
      final cooldown = controller.resendCooldown.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Didn't recieve the OTP? ",
            style: TextStyle(color: Color(0xFF8A8A9A), fontSize: 14),
          ),
          GestureDetector(
            onTap: cooldown == 0 ? controller.onResendPressed : null,
            child: Text(
              cooldown > 0 ? 'Resend OTP (${cooldown}s)' : 'Resend OTP',
              style: TextStyle(
                color: cooldown > 0 ? const Color(0xFFB0B0C0) : AppColor.kblue,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildConfirmButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.onConfirmPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.kblue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text('Confirm', style: CustomTextstyle.Poppinssemiboldwhite),
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool isFirst;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.isFirst = false,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() => _isFocused = widget.focusNode.hasFocus);
    });
    if (widget.isFirst) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isFocused ? const Color(0xFF1A3794) : Colors.transparent,
          width: 2,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: widget.onChanged,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1A3794),
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
