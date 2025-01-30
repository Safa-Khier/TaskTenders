import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasktender_frontend/models/bids.model.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/screens/tasker/pages/jobs/applied_job/add_updates_sheet.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/display_location.dart';
import 'package:tasktender_frontend/widgets/loading_screen.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';

class JobDetailsTab extends StatefulWidget {
  Job job;

  JobDetailsTab({super.key, required this.job});

  @override
  State<JobDetailsTab> createState() => _JobDetailsTabState();
}

class _JobDetailsTabState extends State<JobDetailsTab> {
  final JobService _jobService = locator<JobService>();

  Bid? bid;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLastBid();
  }

  Future<void> _refreshJob() async {
    try {
      final job = await _jobService.getJobById(widget.job.id!);
      setState(() {
        if (job != null) {
          widget.job = job;
        }
      });
    } catch (e) {
      print('Error refreshing job: $e');
    }
  }

  Future<void> getLastBid() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final bids = await _jobService.getUserBidsByJobId(widget.job.id!);
      setState(() {
        bids.sort((a, b) => b.bidDate.compareTo(a.bidDate));
        bid = bids.first;
      });
    } catch (e) {
      print('Error fetching bid: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPendingOffer = widget.job.offerId == null;
    bool isAccepted = bid?.isAccepted ?? false;
    bool isCompleted = widget.job.status == 'completed';

    if (_isLoading) {
      return LoadingScreen();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Job Details
            Text(
              widget.job.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.job.description,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text(
              'Updates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: [
                _buildStep(context, 'You submitted an offer',
                    subtext: DateFormat('MMM dd, yyyy - HH:mm')
                        .format(bid?.bidDate ?? DateTime.now())),
                _buildDivider(
                    context, '\$${bid?.bidAmount.toStringAsFixed(2)}'),
                _buildStep(context, 'Client\'s decision',
                    subtext: widget.job.offerAcceptedAt != null
                        ? DateFormat('MMM dd, yyyy - HH:mm')
                            .format(widget.job.offerAcceptedAt!)
                        : ''),
                if (isPendingOffer)
                  _buildDivider(context, 'Pending', showLine: false)
                else if (isAccepted)
                  _buildDivider(context, 'Accepted',
                      color: Colors.green,
                      icon: Icons.check_circle_outline,
                      showLine: isAccepted && widget.job.updates.isNotEmpty)
                else
                  _buildDivider(context, 'Declined',
                      color: Colors.red,
                      icon: Icons.cancel_outlined,
                      showLine: false),
                if (!isPendingOffer && isAccepted) ...[
                  for (var i = 0; i < widget.job.updates.length; i++) ...[
                    _buildStep(
                      context,
                      widget.job.updates[i].title,
                      subtext: DateFormat('MMM dd, yyyy - HH:mm')
                          .format(widget.job.updates[i].date),
                    ),
                    _buildDivider(context, widget.job.updates[i].description,
                        showLine: (i < widget.job.updates.length - 1) ||
                            widget.job.status == 'completed'),
                  ],
                ],
                if (widget.job.status == 'completed') ...[
                  _buildStep(context, 'Job Completed',
                      subtext: widget.job.completedAt != null
                          ? DateFormat('MMM dd, yyyy - HH:mm')
                              .format(widget.job.completedAt!)
                          : ''),
                  _buildDivider(context, 'Completed',
                      color: Colors.green,
                      icon: Icons.check_circle_outline,
                      showLine: false),
                ],
              ],
            ),
            Divider(),
            SizedBox(height: 16),
            // Your Bid Section
            Text(
              'Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            _buildInfoRow('Job Type', widget.job.jobType),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 0.5,
            ),
            _buildInfoRow('Budget', '\$${bid?.bidAmount.toStringAsFixed(2)}'),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 0.5,
            ),

            // Bid Details Card
            _buildInfoRow(
                'Bid Amount', '\$${bid?.bidAmount.toStringAsFixed(2)}'),

            Divider(
              color: Theme.of(context).colorScheme.secondary,
              thickness: 0.5,
            ),
            _buildInfoRow(
                'Bid Date',
                DateFormat('MMM dd, yyyy')
                    .format(bid?.bidDate ?? DateTime.now())),
            SizedBox(height: 16),

            // Cover Letter Section
            Text(
              'Your Cover Letter',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              bid?.coverLetter ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            DisplayLocation(
              selectedPoint: widget.job.location,
              height: 200,
            ),
            if (isAccepted && !isCompleted) ...[
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              MainButton(
                  context: context,
                  onPressed: () {
                    _showAddUpdateDialog(context);
                  },
                  text: 'Add Update'),
              SizedBox(height: 16),
              MainButton(
                context: context,
                onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: Text("Complete Job"),
                          content: Text(
                              "Are you sure you want to complete this job?"),
                          actions: [
                            TextButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text("Complete"),
                              onPressed: () {
                                LoadingService.showLoadingIndicator(context);
                                _jobService
                                    .completeJob(widget.job.id!)
                                    .then((value) {
                                  setState(() {
                                    widget.job.status = 'completed';
                                  });
                                  Navigator.of(context).pop();
                                }).whenComplete(() {
                                  LoadingService.hideLoadingIndicator();
                                });
                              },
                            ),
                          ],
                        )),
                text: 'Complete Job',
                isOutlined: true,
              ),
            ]
          ],
        ),
      ),
    );
    // FloatingButtons(
    //   firstButton: FloatingActionButton(
    //     onPressed: () {},
    //     child: Icon(Icons.edit),
    //   ),
    //   secondButton: FloatingActionButton(
    //     onPressed: () {},
    //     child: Icon(Icons.message),
    //   ),
    //   useAnimatedIcon: true, // or false for regular icon
    // ),
  }

  void _showAddUpdateDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        showDragHandle: true,
        // barrierColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: true,
        // useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => AddUpdatesSheet(job: widget.job)).then((result) {
      // Check if the dialog returned a value
      if (result == true) {
        // Refresh the job list

        _refreshJob();
      }
    }).catchError((error) {
      // Handle any errors gracefully
      debugPrint('Error in showModalBottomSheet: $error');
    });
  }

  Widget _buildStep(BuildContext context, String title, {String? subtext}) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (subtext != null) ...[
          const Spacer(),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDivider(BuildContext context, String text,
      {String? subtext, bool showLine = true, Color? color, IconData? icon}) {
    final textColor = color ?? Theme.of(context).colorScheme.secondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: 1,
          margin: EdgeInsets.symmetric(horizontal: 4.5),
          color: showLine
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
        ),
        const SizedBox(width: 20),
        if (icon != null) ...[
          Icon(
            icon,
            color: textColor,
            size: 20,
          ),
          const SizedBox(width: 5),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text,
                style: TextStyle(
                  fontSize: 13,
                  color: textColor,
                )),
            if (subtext != null) ...[
              const SizedBox(height: 1),
              Text(subtext,
                  style: TextStyle(
                      fontSize: 10,
                      color: textColor,
                      fontWeight: FontWeight.w100)),
            ],
          ],
        )
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// class FloatingButtons extends StatefulWidget {
//   final Widget firstButton;
//   final Widget secondButton;
//   final bool useAnimatedIcon;

//   const FloatingButtons({
//     Key? key,
//     required this.firstButton,
//     required this.secondButton,
//     this.useAnimatedIcon = false,
//   }) : super(key: key);

//   @override
//   State<FloatingButtons> createState() => _FloatingButtonsState();
// }

// class _FloatingButtonsState extends State<FloatingButtons>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//       reverseCurve: Curves.easeIn,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggle() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         SizeTransition(
//           sizeFactor: _animation,
//           axis: Axis.vertical,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: widget.secondButton,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: widget.firstButton,
//               ),
//             ],
//           ),
//         ),
//         FloatingActionButton(
//           onPressed: _toggle,
//           child: widget.useAnimatedIcon
//               ? AnimatedIcon(
//                   icon: AnimatedIcons.menu_close,
//                   progress: _controller,
//                 )
//               : Icon(_isExpanded ? Icons.close : Icons.add),
//         ),
//       ],
//     );
//   }
// }
