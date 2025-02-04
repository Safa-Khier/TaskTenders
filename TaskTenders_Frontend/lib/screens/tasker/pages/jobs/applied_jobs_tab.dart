import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/main_input.dart';
import 'package:tasktender_frontend/widgets/tasker_job_card.dart';

class AppliedJobsTab extends StatefulWidget {
  const AppliedJobsTab({super.key});

  @override
  State<AppliedJobsTab> createState() => _AppliedJobsTabState();
}

class _AppliedJobsTabState extends State<AppliedJobsTab> {
  final JobService _jobService = locator<JobService>();
  final List<Job> jobs = [];
  List filteredJobs = [];
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
        filteredJobs = jobs;
      });
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void filterArray(String query) {
    setState(() {
      filteredJobs = jobs.where((job) {
        return job.title.toLowerCase().contains(query.toLowerCase()) ||
            job.description.toLowerCase().contains(query.toLowerCase()) ||
            job.jobType.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _refreshJobs,
        child: ListView.builder(
            itemCount: filteredJobs.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    child: MainInput(
                        hintText: 'Search',
                        borderRadius: 10,
                        leadingIcon: Icons.search,
                        trailingIcon: Icons.clear,
                        fontSize: 13,
                        height: 36,
                        color: Color(0xFF999999),
                        onTextChanged: (str) => filterArray(str)));
              }
              if (_isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return TaskerJobCard(
                onTap: () {
                  context.router
                      .push(TaskerAppliedJobRoute(job: filteredJobs[index]));
                },
                job: filteredJobs[index],
              );
            })
        // )
        );
  }
}
