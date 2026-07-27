import 'package:flutter/material.dart';
import '../../models/watch.dart';
import '../../theme/app_theme.dart';

class ARTryOnScreen extends StatefulWidget {
  final Watch watch;

  const ARTryOnScreen({super.key, required this.watch});

  @override
  State<ARTryOnScreen> createState() => _ARTryOnScreenState();
}

class _ARTryOnScreenState extends State<ARTryOnScreen> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  double _rotation = 0.0;
  Offset _position = const Offset(0, -30); // relative center offset
  bool _isFlashActive = false;

  // Flash Animation Controller
  late AnimationController _flashController;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _flashAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_flashController);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  void _triggerCapture() {
    setState(() => _isFlashActive = true);
    _flashController.forward().then((_) {
      _flashController.reverse().then((_) {
        setState(() => _isFlashActive = false);
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.photo_library_outlined, color: AppTheme.goldAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Captured successfully!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      Text('Bespoke AR Try-on photo saved to your gallery.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Mock Camera Viewport (Wrist placement template from Unsplash)
          Image.network(
            'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=1000',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // Dark camera frame overlay
          Container(color: Colors.black.withOpacity(0.15)),

          // 2. Interactive Draggable Watch Layer
          Center(
            child: Transform.translate(
              offset: _position,
              child: Transform.rotate(
                angle: _rotation,
                child: Transform.scale(
                  scale: _scale,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        _position += details.delta;
                      });
                    },
                    child: Image.network(
                      widget.watch.imageUrls.first,
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. Wrist alignment guide indicator (dotted lines)
          IgnorePointer(
            child: Center(
              child: Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.goldAccent.withOpacity(0.4), width: 1.5, style: BorderStyle.values[1]),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'ALIGN TIMEPIECE ON WRIST',
                      style: TextStyle(color: AppTheme.goldAccent, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.8),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Camera overlays: Header
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'AR VIRTUAL TRY-ON',
                  style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.flash_off, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Camera overlays: Controls Panel (Scale & Rotation Sliders)
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Scale slider
                  Row(
                    children: [
                      const Icon(Icons.photo_size_select_large, color: AppTheme.goldAccent, size: 16),
                      const SizedBox(width: 10),
                      const Text('Scale', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Slider(
                          value: _scale,
                          min: 0.5,
                          max: 1.8,
                          activeColor: AppTheme.goldAccent,
                          inactiveColor: AppTheme.cardBorder,
                          onChanged: (val) => setState(() => _scale = val),
                        ),
                      ),
                    ],
                  ),
                  // Rotation slider
                  Row(
                    children: [
                      const Icon(Icons.sync, color: AppTheme.roseGold, size: 16),
                      const SizedBox(width: 10),
                      const Text('Rotate', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Slider(
                          value: _rotation,
                          min: -1.5, // ~90 deg rad
                          max: 1.5,
                          activeColor: AppTheme.roseGold,
                          inactiveColor: AppTheme.cardBorder,
                          onChanged: (val) => setState(() => _rotation = val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Camera overlays: Capture Bar
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(width: 50),
                // Shutter Button
                GestureDetector(
                  onTap: _triggerCapture,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // Helper Reset Button
                IconButton(
                  icon: const Icon(Icons.restart_alt, color: Colors.white, size: 28),
                  tooltip: 'Reset Align',
                  onPressed: () {
                    setState(() {
                      _scale = 1.0;
                      _rotation = 0.0;
                      _position = const Offset(0, -30);
                    });
                  },
                ),
              ],
            ),
          ),

          // Camera Flash Effect overlay
          if (_isFlashActive)
            AnimatedBuilder(
              animation: _flashAnimation,
              builder: (ctx, child) => Opacity(
                opacity: _flashAnimation.value,
                child: Container(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
