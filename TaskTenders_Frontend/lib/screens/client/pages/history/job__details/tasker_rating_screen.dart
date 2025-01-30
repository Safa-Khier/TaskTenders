import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tasktender_frontend/models/reviews.model.dart';
import 'package:tasktender_frontend/models/user.model.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/toast.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:toastification/toastification.dart' hide ToastificationItem;

class TaskerRatingScreen extends StatefulWidget {
  final String jobId;
  final UserDetails userDetails;

  const TaskerRatingScreen({
    super.key,
    required this.jobId,
    required this.userDetails,
  });

  @override
  State<TaskerRatingScreen> createState() => _TaskerRatingScreenState();
}

class _TaskerRatingScreenState extends State<TaskerRatingScreen> {
  final UserService _userService = locator<UserService>();
  final ToastService _toastService = locator<ToastService>();

  double _rating = 0;
  final _reviewController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a rating')));
      _toastService.showToast(
          context,
          ToastificationItem(
            type: ToastificationType.warning,
            duration: const Duration(seconds: 3),
            description: RichText(
              text: TextSpan(
                text: 'Please select a rating',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ));
      return;
    }
    LoadingService.showLoadingIndicator(context);
    setState(() => _submitting = true);

    final Reviews review = Reviews(
      rating: _rating.toInt(),
      comment: _reviewController.text,
      jobId: widget.jobId,
      reviewDate: DateTime.now(),
    );

    try {
      _userService.reviewSubmit(widget.userDetails.uid!, review).then((value) {
        _toastService.showToast(
            context,
            ToastificationItem(
              type: ToastificationType.success,
              duration: const Duration(seconds: 3),
              description: RichText(
                text: TextSpan(
                  text: 'Rating submitted successfully',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ));
        Navigator.pop(context, true);
      });
    } catch (e) {
      _toastService.showToast(
          context,
          ToastificationItem(
            type: ToastificationType.error,
            duration: const Duration(seconds: 3),
            description: RichText(
              text: TextSpan(
                text: 'Error submitting rating',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ));
    } finally {
      setState(() => _submitting = false);
      LoadingService.hideLoadingIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, int> ratingMap = widget.userDetails.rating;
    final int totalRatings = widget.userDetails.totalRates;

    return SafeArea(
        child: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'How was your experience with ${widget.userDetails.fullName}?',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 5,
                      children: [
                    Text('${_rating.toInt()}', style: TextStyle(fontSize: 25)),
                    RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 25,
                      glow: false,
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rate_rounded,
                        color: Colors.amber,
                      ),
                      updateOnDrag: true,
                      onRatingUpdate: (rating) {
                        setState(() => _rating = rating);
                      },
                    ),
                    Text(
                        '${widget.userDetails.overAllRating.toStringAsFixed(1)} (${widget.userDetails.totalRates})')
                  ])),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    for (int i = 5; i >= 1; i--)
                      _buildratingBar(
                          i, ratingMap[i.toString()]!, totalRatings),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: _reviewController,
            decoration: InputDecoration(
              labelText: 'Write a review (optional)',
              alignLabelWithHint: true,
              hintText: 'Share your experience...',
              helperText: ' ',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
            maxLines: 4,
          ),
          SizedBox(height: 16),
          MainButton(
              context: context,
              onPressed: _submitting ? null : _submitRating,
              text: 'Submit Rating'),
        ],
      ),
    ));
  }

  Widget _buildratingBar(int rating, int count, int totalRatings) {
    double percentage = totalRatings > 0 ? count / totalRatings : 0;

    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Text(rating.toString()),
        ),
        SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            backgroundColor: Colors.grey[500],
            color: Colors.amber,
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${(percentage * 100).toStringAsFixed(0)}%', // Show percentage
            style: TextStyle(
              fontSize: 14,
            ),
            textAlign: TextAlign.end,
          ),
        )
      ],
    );
  }
}
