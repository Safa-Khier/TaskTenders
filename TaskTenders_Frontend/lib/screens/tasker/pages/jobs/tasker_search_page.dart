import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/shared/history_screen_placeholder.dart';
import 'package:tasktender_frontend/screens/tasker/pages/jobs/applied_jobs_tab.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/main_input.dart';
import 'package:tasktender_frontend/widgets/tasker_job_card.dart';

@RoutePage()
class TaskerSearchPage extends StatefulWidget {
  const TaskerSearchPage({super.key});

  @override
  State<TaskerSearchPage> createState() => _TaskerSearchPageState();
}

class _TaskerSearchPageState extends State<TaskerSearchPage> {
  final JobService _jobService = locator<JobService>();

  List<Job> jobs = [];
  List<Job> filteredAppliedJobs = [];
  List<Job> filteredJobs = [];
  List<Job> appliedJobs = [];
  bool _isLoading = true;
  bool _hasMore = true;
  Job? lastJob;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJobs();
    // _jobService.getJobsForTaksers().then((jobs) {
    //   setState(() {
    //     this.jobs = jobs;
    //   });
    // }).whenComplete(() {
    //   setState(() {
    //     isLoading = false;
    //   });
    // });
  }

  Future<void> _refreshAppliedJobs() {
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
    print('here');
    setState(() {
      filteredJobs = jobs.where((job) {
        return job.title.toLowerCase().contains(query.toLowerCase()) ||
            job.description.toLowerCase().contains(query.toLowerCase()) ||
            job.jobType.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredAppliedJobs = appliedJobs.where((job) {
        return job.title.toLowerCase().contains(query.toLowerCase()) ||
            job.description.toLowerCase().contains(query.toLowerCase()) ||
            job.jobType.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _refreshJobs() async {
    setState(() {
      _isLoading = true;
    });
    await _jobService.getJobsForTaksers().then((jobs) {
      setState(() {
        this.jobs = jobs;
        filteredJobs = jobs;
      });
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'tasktenders',
                style: TextStyle(
                    color: Color(0xFF00CED1),
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'All',
                  ),
                  Tab(text: 'Applied Jobs'),
                ],
                indicatorSize: TabBarIndicatorSize.tab,
                dividerHeight: 0.33,
                dividerColor: Color(0xFF000000).withAlpha(76),
              ),
            ),
            body: TabBarView(children: [
              if (_isLoading) CardScreenPlaceholder() else _buildAllJobs(),
              AppliedJobsTab(),
            ])));
  }

  Widget _buildAllJobs() {
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
                  context.router.push(TaskerJobDetailsRoute(
                      jobId: filteredJobs[index].id!,
                      job: filteredJobs[index]));
                },
                job: filteredJobs[index],
              );
            })
        // )
        );
  }
}
