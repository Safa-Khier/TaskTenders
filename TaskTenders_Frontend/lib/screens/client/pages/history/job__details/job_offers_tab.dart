import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasktender_frontend/models/bids.model.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/chat.service.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';

class JobOffersTab extends StatefulWidget {
  final Job job;

  const JobOffersTab({super.key, required this.job});

  @override
  State<JobOffersTab> createState() => _JobOffersTabState();
}

class _JobOffersTabState extends State<JobOffersTab> {
  final UserService _userService = locator<UserService>();
  final JobService _jobService = locator<JobService>();
  final ChatService _chatService = locator<ChatService>();
  bool isLoading = true;
  List<Bid> bids = [];

  @override
  void initState() {
    super.initState();
    getJobBids();
  }

  Future<void> getJobBids() async {
    try {
      final bids = await _jobService.getJobBids(widget.job.id!);
      if (mounted) {
        setState(() {
          this.bids = bids;
        });
      }
    } catch (e) {
      print('Error fetching job bids: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    } else {
      return DateFormat('MMM dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (bids.isEmpty) {
      final String imageSrc = Theme.of(context).brightness == Brightness.light
          ? 'lib/assets/placeholders/empty_box_placeholder_light.png'
          : 'lib/assets/placeholders/empty_box_placeholder_dark.png';
      return SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(imageSrc),
                width: 150,
              ),
              Text(
                'No bids yet',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ));
    }
    return RefreshIndicator(
        onRefresh: getJobBids,
        child: ListView.builder(
          itemCount: bids.length,
          itemBuilder: (context, index) {
            return _buildBidCard(context, bids[index]);
          },
        ));
  }

  Widget _buildBidCard(BuildContext context, Bid bid) {
    return Card(
      color: Theme.of(context)
          .extension<CustomThemeExtension>()
          ?.listItemBackground,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Text(bid.userName[0].toUpperCase()),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(
                            "${bid.rating.toStringAsFixed(1)} (${bid.completedProjects} projects)",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${bid.bidAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            if (bid.isAccepted) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(50),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Offer Accepted',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              bid.coverLetter,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Offer submitted: ${_formatTimeAgo(bid.bidDate)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                ElevatedButton(
                  onPressed: () {
                    // View full profile or contact freelancer
                    _showBidBottomSheet(context, bid);
                  },
                  child: Text(
                    widget.job.offerId != null ? 'Details' : 'Manage',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      builder: (context) => ListView(
        // controller: controller,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
                  'Offer Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Offer Amount: \$${bid.bidAmount.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 14),
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

                // Actions
                if (widget.job.status == 'open') ...[
                  Row(
                    children: [
                      Expanded(
                        child: MainButton(
                          context: context,
                          isOutlined: true,
                          text: 'Start Chat',
                          onPressed: () {
                            LoadingService.showLoadingIndicator(context);
                            final clientId = widget.job.userId;
                            final clientName = _userService.getUserName();
                            final taskerId = bid.taskerId;
                            final taskerName = bid.userName;

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
                      const SizedBox(width: 16),
                      Expanded(
                        child: MainButton(
                          context: context,
                          text: 'Accept Offer',
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Accept Offer'),
                                    content: const Text(
                                        'Are you sure you want to accept this offer?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Accept bid functionality
                                          LoadingService.showLoadingIndicator(
                                              context);
                                          _jobService
                                              .acceptOffer(bid)
                                              .then((value) {
                                            setState(() {
                                              bid.isAccepted = true;
                                              widget.job.status = 'in-progress';
                                              widget.job.offerId = bid.id;
                                            });
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          }).whenComplete(() {
                                            LoadingService
                                                .hideLoadingIndicator();
                                          });
                                        },
                                        child: const Text('Accept'),
                                      ),
                                    ],
                                  )),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
