import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

class ZoomableImageModal extends StatelessWidget {
  final String imageUrl;
  final String title;

  const ZoomableImageModal({
    super.key,
    required this.imageUrl,
    required this.title,
  });

  static void show(BuildContext context, String imageUrl, String title) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.92),
      builder: (context) => ZoomableImageModal(imageUrl: imageUrl, title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            panEnabled: true,
            minScale: 0.8,
            maxScale: 4.0,
            child: AppImage(
              url: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: AppTheme.cardBg,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.goldAccent),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: AppTheme.darkCharcoal,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: const Text(
                'Pinch or double tap to zoom in high detail',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
