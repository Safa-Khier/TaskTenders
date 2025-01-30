import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/bids.model.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/shared/loading_screen.dart';
import 'package:tasktender_frontend/screens/tasker/pages/jobs/create_offer_sheet.dart';
import 'package:tasktender_frontend/services/chat.service.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/toast.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';
import 'package:tasktender_frontend/widgets/display_location.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:toastification/toastification.dart' hide ToastificationItem;

@RoutePage()
class TaskerJobDetailsPage extends StatefulWidget {
  final String jobId;
  final Job job;

  const TaskerJobDetailsPage({
    super.key,
    @PathParam('jobId') required this.jobId,
    required this.job,
  });

  @override
  State<TaskerJobDetailsPage> createState() => _TaskerJobDetailsPageState();
}

class _TaskerJobDetailsPageState extends State<TaskerJobDetailsPage> {
  final UserService _userService = locator<UserService>();
  final JobService _jobService = locator<JobService>();
  final ToastService _toastService = locator<ToastService>();
  final ChatService _chatService = locator<ChatService>();

  List<Bid> bids = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshJobs();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshJobs() {
    setState(() {
      isLoading = true;
    });
    _jobService.getUserBidsByJobId(widget.job.id!).then((value) {
      setState(() {
        value.sort((a, b) => b.bidDate.compareTo(a.bidDate));
        bids = value;
        isLoading = false;
      });
    });
  }

  double get _maxBidAllowed => widget.job.price - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        // elevation: 2,
      ),
      body: isLoading
          ? LoadingScreen()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.job.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '\$${widget.job.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Status and Job Type Badges
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00CED1).withAlpha(50),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.job.jobType.toUpperCase(),
                            style: TextStyle(
                              color: const Color(0xFF00CED1),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Job Description
                    Text(
                      'Job Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.job.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Additional Job Details

                    SizedBox(height: 8),
                    _buildDetailRow(context, 'Job Type', widget.job.jobType),
                    SizedBox(height: 8),
                    DisplayLocation(
                      selectedPoint: widget.job.location,
                      height: 200,
                    ),
                    SizedBox(height: 8),
                    _buildTags(),
                    SizedBox(height: 8),
                    if (widget.job.jobType == 'tender')
                      _buildBidInfoCard(context)
                    else if (bids.isNotEmpty)
                      _buildOfferInfoCard(),
                    SizedBox(height: 16),

                    // Action Buttons
                    Column(
                      spacing: 10,
                      children: [
                        MainButton(
                            context: context,
                            onPressed: () => {
                                  if (widget.job.jobType != 'tender' &&
                                      bids.isNotEmpty)
                                    _toastService.showToast(
                                      context,
                                      ToastificationItem(
                                        type: ToastificationType.warning,
                                        style: ToastificationStyle.flatColored,
                                        duration: const Duration(seconds: 3),
                                        description: RichText(
                                          text: TextSpan(
                                            text:
                                                'You have already submitted an offer for this job. You can only submit one offer per job.',
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    )
                                  else
                                    _showAddOfferDialog(context)
                                },
                            text: 'Apply for Job'),
                        MainButton(
                            context: context,
                            isOutlined: true,
                            onPressed: () {
                              LoadingService.showLoadingIndicator(context);
                              final clientId = widget.job.userId;
                              final clientName = 'Client';
                              final taskerId = _userService.getUserUid();
                              final taskerName = _userService.getUserName();

                              _chatService
                                  .createChat(taskerId, clientId, taskerName,
                                      clientName)
                                  .then((chat) {
                                if (chat == null) {
                                  return;
                                }
                                context.router.push(
                                    ChatRoute(chatId: chat.id, chat: chat));
                              }).whenComplete(() {
                                LoadingService.hideLoadingIndicator();
                              });
                            },
                            text: 'Chat with the Client')
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTags() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: widget.job.tags.map((tag) {
          return Container(
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .extension<CustomThemeExtension>()
                    ?.chatReceiverBackground,
                borderRadius: BorderRadius.all(Radius.circular(5))),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              '#$tag',
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOfferInfoCard() {
    return Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .extension<CustomThemeExtension>()
              ?.listItemBackground,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
                'You have already submitted an offer for this job. You can only submit one offer per job.')));
  }

  // Helper method to create consistent detail rows
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .extension<CustomThemeExtension>()
            ?.listItemBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              // color: Colors.grey[800],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidInfoCard(
    BuildContext context,
  ) {
    return Container(
      // elevation: 2,
      decoration: BoxDecoration(
        color: Theme.of(context)
            .extension<CustomThemeExtension>()
            ?.listItemBackground,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Highest Bid

            // TODO: Implement the lowest bid
            _buildBidInfoRow(
                context,
                'Lowest Bid',
                false
                    ? '\$${widget.job.price.toStringAsFixed(2)}'
                    : 'No bids yet'),
            SizedBox(height: 8),

            // User's Last Bid
            _buildBidInfoRow(
                context,
                'Your Last Bid',
                isLoading
                    ? 'Loading...'
                    : bids.isNotEmpty
                        ? '\$${bids[0].bidAmount.toStringAsFixed(2)}'
                        : 'No previous bid'),
            SizedBox(height: 8),

            // Max Bid Allowed
            _buildBidInfoRow(context, 'Max Bid Allowed',
                '\$${_maxBidAllowed.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  // Helper method to create consistent bid info rows
  Widget _buildBidInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  void _showAddOfferDialog(BuildContext context) {
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
        builder: (context) => CreateOfferSheet(job: widget.job)).then((result) {
      // Check if the dialog returned a value
      if (result == true) {
        // Refresh the job list
        // _refreshJobs();
        _refreshJobs();
      }
    }).catchError((error) {
      // Handle any errors gracefully
      debugPrint('Error in showModalBottomSheet: $error');
    });
  }
}
