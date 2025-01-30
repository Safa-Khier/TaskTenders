import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasktender_frontend/models/bids.model.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/models/user.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/client/pages/history/job__details/tasker_rating_screen.dart';
import 'package:tasktender_frontend/services/chat.service.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';
import 'package:tasktender_frontend/utils/date_utils.dart';
import 'package:tasktender_frontend/widgets/display_location.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';

class JobDetailsTab extends StatefulWidget {
  final Job job;

  const JobDetailsTab({super.key, required this.job});

  @override
  State<JobDetailsTab> createState() => _JobDetailsTabState();
}

class _JobDetailsTabState extends State<JobDetailsTab> {
  final UserService _userService = locator<UserService>();
  final JobService _jobService = locator<JobService>();
  final ChatService _chatService = locator<ChatService>();

  UserDetails? tasker;
  Bid? acceptedOffer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.job.offerId == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print(widget.job.toJson());
      return;
    }
    getAcceptedOfferAndTaskerDetails(widget.job.offerId!).whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> getAcceptedOfferAndTaskerDetails(String offerId) async {
    try {
      final acceptedOffer =
          await _jobService.getBidById(widget.job.id!, offerId);
      if (acceptedOffer == null) {
        print(acceptedOffer);
        return;
      }
      final tasker = await _userService.getUserDetails(acceptedOffer.taskerId);
      if (tasker == null) {
        return;
      }
      if (mounted) {
        setState(() {
          this.acceptedOffer = acceptedOffer;
          this.tasker = tasker;
        });
      }
    } catch (e) {
      print('Error fetching tasker: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    bool isCompleted = widget.job.status == 'completed';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.job.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    getJobStatus(),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Posted ${getDateInFormat(date: widget.job.createdAt, format: 'MMM dd, yyyy')}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (acceptedOffer != null) ...[
            _buildSection(
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Accepted Offer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFF999999),
                        borderRadius: BorderRadius.circular(25)),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tasker?.firstName ?? 'Tasker',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          tasker?.email ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ]),
                ),
                ElevatedButton(
                  onPressed: () {
                    // View full profile or contact freelancer
                    _showBidBottomSheet(context, acceptedOffer!);
                  },
                  child: Text(
                    'Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ])),
            const SizedBox(height: 8),
          ],
          if (widget.job.status == 'completed' &&
              !(widget.job.isReviewSubmitted ?? false)) ...[
            _buildSection(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainButton(
                      context: context,
                      onPressed: () {
                        _showRatingDialog(context);
                      },
                      text: 'Leave a Review'),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (widget.job.status == 'in-progress' ||
              widget.job.status == 'completed') ...[
            _buildSection(Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Updates',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    _buildStep(context, 'You Accepted the Offer',
                        subtext: widget.job.offerAcceptedAt != null
                            ? DateFormat('MMM dd, yyyy - HH:mm')
                                .format(widget.job.offerAcceptedAt!)
                            : ''),
                    _buildDivider(context, 'Accepted',
                        color: Colors.green,
                        icon: Icons.check_circle_outline,
                        showLine: widget.job.updates.isNotEmpty || isCompleted),
                    for (var i = 0; i < widget.job.updates.length; i++) ...[
                      _buildStep(
                        context,
                        widget.job.updates[i].title,
                        subtext: DateFormat('MMM dd, yyyy - HH:mm')
                            .format(widget.job.updates[i].date),
                      ),
                      _buildDivider(context, widget.job.updates[i].description,
                          showLine: (i < widget.job.updates.length - 1) ||
                              isCompleted),
                    ],
                    if (isCompleted) ...[
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
              ],
            )),
            const SizedBox(height: 8),
          ],
          _buildSection(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget & Timeline',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Budget',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${widget.job.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.job.jobType,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deadline',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 20,
                                // color: Theme.of(context).colorScheme.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                getDateInFormat(
                                    date: widget.job.deadline ?? DateTime.now(),
                                    format: 'MMM dd, yyyy'),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSection(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.job.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildSection(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tags',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.job.tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .extension<CustomThemeExtension>()
                                  ?.chipBackground,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '#$tag',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // const SizedBox(height: 8),
          _buildSection(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DisplayLocation(
                  selectedPoint: widget.job.location,
                  height: 200,
                  borderRadius: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget _buildSection(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context)
          .extension<CustomThemeExtension>()
          ?.listItemBackground,
      width: double.infinity,
      child: child,
    );
  }

  Widget getJobStatus() {
    String status = 'cancelled';
    Color color = Colors.red;

    switch (widget.job.status) {
      case 'open':
        status = 'Open';
        color = Colors.blue;
        break;
      case 'completed':
        status = 'Completed';
        color = Colors.green;
        break;
      case 'in-progress':
        status = 'In Progress';
        color = Colors.orange;
        break;
      case 'cancelled':
        status = 'Cancelled';
        color = Colors.red;
        break;
      default:
        status = 'Cancelled';
        color = Colors.red;
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          status,
          style: TextStyle(
              fontSize: 12, color: color, fontWeight: FontWeight.bold),
        ));
  }

  void _showRatingDialog(BuildContext context) {
    showModalBottomSheet(
            context: context,
            // isScrollControlled: false,
            showDragHandle: true,
            // useSafeArea: true,
            useRootNavigator: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) =>
                TaskerRatingScreen(jobId: widget.job.id!, userDetails: tasker!))
        .then((value) {
      if (value != null && value) {
        if (mounted) {
          setState(() {
            widget.job.isReviewSubmitted = true;
          });
        }
      }
    });
  }

  void _showBidBottomSheet(BuildContext context, Bid bid) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: false,
      showDragHandle: true,
      // useSafeArea: true,
      useRootNavigator: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Freelancer Profile
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue[100],
                    child: Text(
                      bid.userName[0].toUpperCase(),
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bid.userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            Text(
                              "${bid.rating} (${bid.completedProjects} projects)",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bid Details
              const Text(
                'Offer Amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '\$${bid.bidAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 12),

              // Cover Letter
              const Text(
                'Cover Letter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                bid.coverLetter,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 50),

              Row(
                children: [
                  Expanded(
                    child: MainButton(
                      context: context,
                      isOutlined: true,
                      text: 'Chat',
                      onPressed: () {
                        LoadingService.showLoadingIndicator(context);
                        final clientId = widget.job.userId;
                        final taskerId = bid.taskerId;
                        final taskerName = bid.userName;
                        final clientName = _userService.getUserName();

                        _chatService
                            .createChat(
                                taskerId, clientId, taskerName, clientName)
                            .then((chat) {
                          if (chat == null) {
                            return;
                          }
                          context.router
                              .push(ChatRoute(chatId: chat.id, chat: chat));
                        }).whenComplete(() {
                          LoadingService.hideLoadingIndicator();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
