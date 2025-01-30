import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/tasker_job_card.dart';

class AppliedJobsTab extends StatefulWidget {
  const AppliedJobsTab({super.key});

  @override
  State<AppliedJobsTab> createState() => _AppliedJobsTabState();
}

class _AppliedJobsTabState extends State<AppliedJobsTab> {
  final JobService _jobService = locator<JobService>();
  final List<Job> jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshJobs();
  }

  Future<void> _refreshJobs() {
    setState(() {
      _isLoading = true;
    });
    return _jobService.getJobsForTasker().then((jobs) {
      setState(() {
        this.jobs.clear();
        this.jobs.addAll(jobs);
      });
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshJobs,
        child: ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              return TaskerJobCard(
                onTap: () {
                  context.router.push(TaskerAppliedJobRoute(job: jobs[index]));
                },
                job: jobs[index],
              );
            })
        // )
        );
  }
}
