import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. المحتوى الأساسي للشاشة
        child,

        // 2. طبقة التحميل التي تظهر عند الحاجة
        if (isLoading)
          // طبقة شبه شفافة لتعتيم الخلفية
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              // ملف Lottie الخاص بك
              child: Lottie.asset(
                'assets/animations/loading.json', // <--- ضع مسار ملفك هنا
                width: 150,
                height: 150,
              ),
            ),
          ),
      ],
    );
  }
}
