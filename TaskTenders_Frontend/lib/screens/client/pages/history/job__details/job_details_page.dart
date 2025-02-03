import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/client/pages/history/create_job_sheet.dart';
import 'package:tasktender_frontend/screens/shared/job_chat_tab.dart';
import 'package:tasktender_frontend/screens/client/pages/history/job__details/job_details_tab.dart';
import 'package:tasktender_frontend/screens/client/pages/history/job__details/job_offers_tab.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/list_item.dart';

@RoutePage()
class JobDetailsPage extends StatefulWidget {
  final String id;
  final Job job;

  const JobDetailsPage({
    super.key,
    @PathParam('id') required this.id,
    required this.job,
  });

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final JobService _jobService = locator<JobService>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Job Details', style: TextStyle(fontSize: 16)),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: _showSortDialog,
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Details',
                ),
                Tab(text: 'Chat'),
                Tab(text: 'Offers'),
              ],
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 0.33,
              isScrollable: false,
              dividerColor: Color(0xFF000000).withAlpha(76),
            ),
          ),
          body: TabBarView(children: [
            JobDetailsTab(job: widget.job),
            JobChatTab(
              job: widget.job,
            ),
            JobOffersTab(
              job: widget.job,
            ),
          ]),
        ));
  }

  void _showSortDialog() {
    showModalBottomSheet<dynamic>(
        context: context,
        showDragHandle: true,
        // useSafeArea: true,
        // isScrollControlled: true,
        useRootNavigator: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => SafeArea(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // shrinkWrap: true,
                    children: [
                  ListItem(
                    isDisabled: widget.job.status == 'in-progress',
                    iconData: Icons.edit,
                    title: 'Edit The Job',
                    onPressed: () {
                      // TODO: Implement edit the job
                      Navigator.pop(context);
                      _showEditJobDialog();
                    },
                  ),
                  ListItem(
                      isDisabled: widget.job.status == 'in-progress',
                      iconData: Icons.delete,
                      color: Colors.red,
                      title: 'Delete The Job',
                      onPressed: () {
                        // Navigator.pop(context);
                        // alert dialog appears to confirm deletion
                        showDialog(
                            context: context,
                            builder: (childContext) => AlertDialog(
                                    title: const Text('Delete Job'),
                                    content: const Text(
                                        'Are you sure you want to delete this job?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(childContext);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (widget.job.id != null) {
                                            try {
                                              LoadingService
                                                  .showLoadingIndicator(
                                                      context);
                                              await _jobService
                                                  .deleteJob(widget.job.id!);

                                              Navigator.pop(childContext);
                                              Navigator.of(context).pop();

                                              context.router.replace(
                                                  const ClientHistoryRoute());
                                            } catch (error) {
                                              // Handle error (e.g., show a snackbar or log)
                                              debugPrint(
                                                  'Failed to delete job: $error');
                                            } finally {
                                              LoadingService
                                                  .hideLoadingIndicator();
                                            }
                                          } else {
                                            debugPrint('Job id is null');
                                          }
                                        },
                                        child: Text(
                                          'delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      )
                                    ]));
                      }),
                ])));
  }

  void _showEditJobDialog() {
    showModalBottomSheet(
        context: context,
        // showDragHandle: true,
        barrierColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => CreateJobSheet(
              title: 'Edit Job',
              job: widget.job,
            )).then((result) {
      // Check if the dialog returned a value

      debugPrint('Result: $result');
      if (result != null) {
        setState(() {
          widget.job.title = result.title;
          widget.job.description = result.description;
          widget.job.price = result.price;
          widget.job.jobType = result.jobType;
          widget.job.tags = result.tags;
          widget.job.deadline = result.deadline;
          widget.job.categoryId = result.categoryId;
        });
      }
    }).catchError((error) {
      // Handle any errors gracefully
      debugPrint('Error in showModalBottomSheet: $error');
    });

    // if (result != null) {
    //   getJobs();
    // }
  }
}
