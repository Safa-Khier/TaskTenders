import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  // Queue to hold pending toasts
  final Queue<ToastificationItem> _toastQueue = Queue<ToastificationItem>();
  bool _isToastActive = false; // To track if a toast is active

  void showToast(BuildContext context, ToastificationItem toastItem) {
    // Add the toast to the queue
    _toastQueue.add(toastItem);

    // Show the next toast if none is currently active
    if (!_isToastActive) {
      _showNextToast(context);
    }
  }

  void _showNextToast(BuildContext context) {
    if (_toastQueue.isNotEmpty) {
      _isToastActive = true;
      ToastificationItem toastItem = _toastQueue.removeFirst();

      toastification.show(
        type: toastItem.type,
        style: toastItem.style,
        autoCloseDuration: toastItem.duration,
        description: toastItem.description,
        alignment: Alignment.bottomCenter,
        animationDuration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x07000000),
            blurRadius: 16,
            offset: Offset(0, 16),
            spreadRadius: 0,
          )
        ],
        callbacks: ToastificationCallbacks(
          onDismissed: (dismissedToast) {
            _isToastActive = false; // Mark the toast as dismissed
            _showNextToast(context); // Show the next toast in the queue
          },
          onAutoCompleteCompleted: (value) {
            _isToastActive = false;
            _showNextToast(context);
          },
          onCloseButtonTap: (value) {
            _isToastActive = false;
            _showNextToast(context);
            // dismiss the toast when the close button is tapped
            toastification.dismiss(value);
          },
        ),
      );
    }
  }
}

class ToastificationItem {
  final ToastificationType type;
  final ToastificationStyle style;
  final Duration duration;
  final RichText description;

  ToastificationItem({
    required this.type,
    this.style = ToastificationStyle.flatColored,
    this.duration = const Duration(seconds: 2),
    required this.description,
  });
}



      // toastification.show(
      //   type: ToastificationType.success,
      //   style: ToastificationStyle.fillColored,
      //   autoCloseDuration: const Duration(seconds: 5),
      //   // title: const Text('Success',
      //   //     style:
      //   //         TextStyle(fontFamily: "CodeNext", fontWeight: FontWeight.bold)),
      //   description: RichText(
      //       text: TextSpan(
      //           text: 'User $email signed in',
      //           style: TextStyle(fontFamily: "CodeNext"))),
      //   alignment: Alignment.bottomCenter,
      //   direction: TextDirection.ltr,
      //   animationDuration: const Duration(milliseconds: 300),
        // animationBuilder: (context, animation, alignment, child) {
        //   return FadeTransition(
        //     opacity: animation,
        //     child: child,
        //   );
        // },
      //   showIcon: true,
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.white,
        // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        // margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        // borderRadius: BorderRadius.circular(12),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Color(0x07000000),
        //     blurRadius: 16,
        //     offset: Offset(0, 16),
        //     spreadRadius: 0,
        //   )
        // ],
      //   showProgressBar: false,
      //   closeButtonShowType: CloseButtonShowType.onHover,
      //   closeOnClick: false,
      //   pauseOnHover: false,
      //   dragToClose: true,
      //   applyBlurEffect: false,
      //   callbacks: ToastificationCallbacks(
      //     onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
      //     onCloseButtonTap: (toastItem) =>
      //         print('Toast ${toastItem.id} close button tapped'),
      //     onAutoCompleteCompleted: (toastItem) =>
      //         print('Toast ${toastItem.id} auto complete completed'),
      //     onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      //   ),
      // );
      // ToastService.showToast(
      //   context,
      //   backgroundColor: Colors.green,
      //   leading: const Icon(Icons.check_circle_sharp,
      //       color: Colors.white),
      //   messageStyle: const TextStyle(color: Colors.white),
      //   length: ToastLength.medium,
      //   expandedHeight: 100,
      //   message: "This is a success toast!",
      // );