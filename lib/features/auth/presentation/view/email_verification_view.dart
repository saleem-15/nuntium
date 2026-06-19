import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nuntium/config/routes.dart';
import 'package:nuntium/core/theme/app_colors.dart';
import 'package:nuntium/core/widgets/header.dart';
import 'package:nuntium/features/auth/presentation/cubit/email_verification_cubit.dart';
import 'package:nuntium/features/auth/presentation/cubit/email_verification_state.dart';

import 'widgets/email_verification_animation.dart';

class EmailVerificationView extends StatefulWidget {
  const EmailVerificationView({super.key});

  @override
  State<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends State<EmailVerificationView> {
  String _resendText = "Resend email";
  bool _isResending = false;
  Color _resendTextColor = AppColors.purplePrimary;
  bool _isVerified = false;

  void _handleResend() {
    if (_isResending) return;
    context.read<EmailVerificationCubit>().sendVerificationEmail();
    setState(() {
      _isResending = true;
      _resendText = "Sending...";
      _resendTextColor = AppColors.purpleLight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailVerificationCubit, EmailVerificationState>(
      listener: (context, state) {
        switch (state) {
          case EmailVerificationVerified():
            _onVerified(context);
          case EmailVerificationSentSuccess():
            _onResendSuccess();
          case EmailVerificationError():
            _onError(context, state);
          default:
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
              child: Column(
                children: [
                  // ── Header (same pattern as every other auth screen) ──
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: _isVerified
                        ? Header(
                            key: const ValueKey('header_success'),
                            title: "Verified!",
                            subTtitle:
                                "Your email is successfully verified. Welcome to Nuntium!",
                          )
                        : Header(
                            key: const ValueKey('header_pending'),
                            title: "Email Verification",
                            subTtitle:
                                "A verification link has been sent to your email address.",
                          ),
                  ),

                  // ── Animation hero (fills remaining space) ────────────
                  Expanded(
                    flex: 2,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: _isVerified
                          ? _SuccessIcon(key: const ValueKey('success_icon'))
                          : const EmailVerificationAnimation(
                              key: ValueKey('anim'),
                            ),
                    ),
                  ),

                  Spacer(),

                  // ── Bottom resend row (pinned, matches other screens) ─
                  _buildResendRow(state is EmailVerificationLoading),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── BLoC handlers ─────────────────────────────────────────────────────

  void _onVerified(BuildContext context) async {
    setState(() => _isVerified = true);
    final navigator = Navigator.of(context);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      navigator.pushNamedAndRemoveUntil(Routes.mainView, (route) => false);
    }
  }

  void _onResendSuccess() {
    setState(() {
      _resendText = "Email sent!";
      _resendTextColor = AppColors.greyPrimary;
    });
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _resendText = "Resend email";
          _resendTextColor = AppColors.purplePrimary;
          _isResending = false;
        });
      }
    });
  }

  void _onError(BuildContext context, EmailVerificationError state) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
    );
    setState(() {
      _resendText = "Resend email";
      _resendTextColor = AppColors.purplePrimary;
      _isResending = false;
    });
  }

  // ── Sub-widgets ───────────────────────────────────────────────────────

  Widget _buildResendRow(bool isLoading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Didn't receive an email? ",
          style: TextStyle(fontSize: 14.sp, color: AppColors.greyPrimary),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (isLoading || _isResending) ? null : _handleResend,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: _resendTextColor,
              ),
              child: Text(_resendText),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Success icon widget ────────────────────────────────────────────────────
class _SuccessIcon extends StatefulWidget {
  const _SuccessIcon({super.key});

  @override
  State<_SuccessIcon> createState() => _SuccessIconState();
}

class _SuccessIconState extends State<_SuccessIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            color: AppColors.purplePrimary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 80.sp,
            color: AppColors.purplePrimary,
          ),
        ),
      ),
    );
  }
}
