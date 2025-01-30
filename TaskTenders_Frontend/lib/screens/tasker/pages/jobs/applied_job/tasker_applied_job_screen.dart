import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:tasktender_frontend/models/bids.model.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/screens/shared/job_chat_tab.dart';
import 'package:tasktender_frontend/screens/tasker/pages/jobs/applied_job/job_details_tab.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/pick_location.dart';

@RoutePage()
class TaskerAppliedJobScreen extends StatefulWidget {
  final Job job;
  const TaskerAppliedJobScreen({super.key, required this.job});

  @override
  State<TaskerAppliedJobScreen> createState() => _TaskerAppliedJobScreenState();
}

class _TaskerAppliedJobScreenState extends State<TaskerAppliedJobScreen> {
  final JobService _jobService = locator<JobService>();
  Bid? bid;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLastBid();
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Job Details'),
            elevation: 1,
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Details',
                ),
                Tab(text: 'Chat'),
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
          ]),
        ));
  }
}
