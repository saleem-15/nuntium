import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nuntium/core/theme/app_colors.dart';

class EmailVerificationAnimation extends StatefulWidget {
  const EmailVerificationAnimation({super.key});

  @override
  State<EmailVerificationAnimation> createState() =>
      _EmailVerificationAnimationState();
}

class _EmailVerificationAnimationState extends State<EmailVerificationAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _orbitController1;
  late final AnimationController _orbitController2;
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _orbitController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _orbitController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _orbitController1.dispose();
    _orbitController2.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // ── Ambient blobs ──────────────────────────────────────────────
        Positioned(
          top: -20.h,
          right: -40.w,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
              tileMode: TileMode.decal,
            ),
            child: Container(
              width: 180.w,
              height: 180.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purplePrimary.withValues(alpha: 0.06),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -20.h,
          left: -30.w,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
              tileMode: TileMode.decal,
            ),
            child: Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD6DBFE).withValues(alpha: 0.15),
              ),
            ),
          ),
        ),

        // ── Outer orbit (clockwise) ────────────────────────────────────
        RotationTransition(
          turns: _orbitController1,
          child: SizedBox(
            width: 250.w,
            height: 250.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.purplePrimary.withValues(alpha: 0.08),
                        width: 1.w,
                      ),
                    ),
                  ),
                ),
                // Node at top-center of the circle
                Positioned(
                  left: 125.w - 5.w,
                  top: -5.w,
                  child: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purplePrimary.withValues(alpha: 0.35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Inner orbit (counter-clockwise) ────────────────────────────
        RotationTransition(
          turns: ReverseAnimation(_orbitController2),
          child: SizedBox(
            width: 180.w,
            height: 180.w,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.purplePrimary.withValues(alpha: 0.04),
                        width: 1.w,
                      ),
                    ),
                  ),
                ),
                // Node at bottom-right of the circle (pi/4)
                Positioned(
                  left: 90.w - 3.w + (90.w * math.cos(math.pi / 4)),
                  top: 90.w - 3.w + (90.w * math.sin(math.pi / 4)),
                  child: Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purplePrimary.withValues(alpha: 0.25),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Floating central card ──────────────────────────────────────
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main card
              Container(
                width: 130.w,
                height: 130.w,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(36.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purplePrimary.withValues(alpha: 0.12),
                      blurRadius: 30,
                      spreadRadius: 0,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purplePrimary,
                  ),
                  child: Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.white,
                    size: 40.sp,
                  ),
                ),
              ),

              // Verified badge (top-right)
              Positioned(
                top: -10.w,
                right: -10.w,
                child: Transform.rotate(
                  angle: 12 * math.pi / 180,
                  child: Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6DBFE),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purplePrimary.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.verified_rounded,
                        color: const Color(0xFF2035B5),
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),

              // Link badge (bottom-left)
              Positioned(
                bottom: -6.w,
                left: -14.w,
                child: Transform.rotate(
                  angle: -12 * math.pi / 180,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFE1F7),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purplePrimary.withValues(
                            alpha: 0.08,
                          ),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.link_rounded,
                        color: AppColors.purplePrimary,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
