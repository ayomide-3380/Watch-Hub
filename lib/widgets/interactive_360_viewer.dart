import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class Interactive360Viewer extends StatefulWidget {
  final List<String> imageUrls;
  const Interactive360Viewer({super.key, required this.imageUrls});

  @override
  State<Interactive360Viewer> createState() => _Interactive360ViewerState();
}

class _Interactive360ViewerState extends State<Interactive360Viewer> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  double _dragOffset = 0;
  bool _showHotspots = true;
  late AnimationController _pulseController;

  final List<Map<String, dynamic>> _hotspots = [
    {
      'title': 'Ceramic Bezel',
      'description': 'Scratch-resistant Cerachrom rotatable bezel with gold-coated graduation marks.',
      'alignment': const Alignment(0.0, -0.6),
      'icon': Icons.brightness_high_outlined,
    },
    {
      'title': 'Triplock Crown',
      'description': 'Screw-down waterproof crown featuring three sealed gaskets to secure the movement.',
      'alignment': const Alignment(0.7, 0.05),
      'icon': Icons.lock_outline,
    },
    {
      'title': 'Exhibition Back',
      'description': 'Scratch-resistant sapphire back casing displaying the Swiss automatic calibre caliber movement.',
      'alignment': const Alignment(-0.6, 0.4),
      'icon': Icons.remove_red_eye_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.primaryDelta!;
      // Scale drag sensitivity: 20 pixels of drag changes 1 index frame
      const dragSensitivity = 20.0;
      if (_dragOffset.abs() > dragSensitivity) {
        final frameChange = (_dragOffset / dragSensitivity).truncate();
        _currentIndex = (_currentIndex - frameChange) % widget.imageUrls.length;
        if (_currentIndex < 0) {
          _currentIndex += widget.imageUrls.length;
        }
        _dragOffset = _dragOffset % dragSensitivity;
      }
    });
  }

  void _showHotspotDetail(BuildContext context, String title, String desc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.darkCharcoal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppTheme.goldAccent),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(desc, style: const TextStyle(color: AppTheme.textMuted, fontSize: 13, height: 1.4)),
        actions: [
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generate simulated angle image list using widget imageUrls fallback
    final displayUrls = widget.imageUrls.length >= 3 
        ? widget.imageUrls 
        : [
            widget.imageUrls.first,
            // Fallback simulated rotation angles from high-quality Unsplash watch details
            'https://images.unsplash.com/photo-1547996160-01ff60023533?auto=format&fit=crop&q=80&w=800',
            'https://images.unsplash.com/photo-1614164185128-e4ec99c436d7?auto=format&fit=crop&q=80&w=800',
            'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&q=80&w=800',
          ];

    final activeUrl = displayUrls[_currentIndex % displayUrls.length];

    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Drag-to-rotate active frame image
          GestureDetector(
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: Image.network(
                  activeUrl,
                  key: ValueKey<String>(activeUrl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),

          // Glassmorphic Overlay control hints
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.swipe_outlined, color: AppTheme.goldAccent, size: 12),
                      SizedBox(width: 6),
                      Text('Drag to Rotate 360°', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _showHotspots = !_showHotspots),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _showHotspots ? AppTheme.goldAccent.withOpacity(0.2) : Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _showHotspots ? AppTheme.goldAccent : Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        Icon(_showHotspots ? Icons.visibility : Icons.visibility_off, color: _showHotspots ? AppTheme.goldAccent : Colors.white, size: 12),
                        const SizedBox(width: 6),
                        Text(
                          _showHotspots ? 'Hide Specs' : 'Show Specs',
                          style: TextStyle(color: _showHotspots ? AppTheme.goldAccent : Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Detail Hotspots (Only shown in frame 0 and 2 to look realistic)
          if (_showHotspots && (_currentIndex % displayUrls.length == 0 || _currentIndex % displayUrls.length == 2))
            ..._hotspots.map((spot) {
              return Align(
                alignment: spot['alignment'],
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.8, end: 1.2),
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  builder: (context, scale, child) => Transform.scale(
                    scale: scale,
                    child: GestureDetector(
                      onTap: () => _showHotspotDetail(context, spot['title'], spot['description']),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.obsidianBlack.withOpacity(0.8),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppTheme.goldAccent, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.goldAccent.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) => Icon(
                            spot['icon'],
                            color: Color.lerp(AppTheme.goldAccent, Colors.white, _pulseController.value),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
