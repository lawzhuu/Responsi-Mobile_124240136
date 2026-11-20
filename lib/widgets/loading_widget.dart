import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class MagicalLoadingWidget extends StatelessWidget {
  final String message;

  const MagicalLoadingWidget({
    super.key,
    this.message = 'Memanggil data magic...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.antiqueGold,
                    ),
                  ),
                ),
                Icon(
                  Icons.auto_awesome,
                  color: AppTheme.antiqueGold.withValues(alpha: 0.9),
                  size: 26,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.antiqueGold,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
