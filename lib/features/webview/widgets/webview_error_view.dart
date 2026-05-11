import 'package:flutter/material.dart';
class WebViewErrorView extends StatelessWidget {
  const WebViewErrorView({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 72, color: Colors.grey.shade300),
            const SizedBox(height: 24),
            const Text(
              'Failed to load page',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 180,
              height: 48,
              child: ElevatedButton(
                onPressed: onRetry,
                child: const Text(
                  'TRY AGAIN',
                  style: TextStyle(letterSpacing: 1.2, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
