import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tasktender_frontend/widgets/loading_screen.dart';

class LoadingService {
  static OverlayEntry? _overlayEntry;
  static String? _loadingMessage;

  static void showLoadingIndicator(BuildContext rootContext,
      {String? title = "Loading..."}) {
    if (_overlayEntry != null) return; // Prevent multiple overlays

    _loadingMessage = title;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        child: Stack(
          children: [
            // Blur Effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black
                      .withValues(alpha: 0.33), // Darken the background
                ),
              ),
            ),
            // Loading Screen Content
            Center(
              child: LoadingScreen(
                title: _loadingMessage,
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(rootContext).insert(_overlayEntry!);
  }

  static void hideLoadingIndicator() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
