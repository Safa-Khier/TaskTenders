import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/shared/history_screen_placeholder.dart';
import 'package:tasktender_frontend/screens/tasker/pages/jobs/applied_jobs_tab.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
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
  List<Job> appliedJobs = [];
  bool isLoading = true;
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

  Future<void> _load() async {
    setState(() {
      isLoading = true;
    });
    await _jobService.loadJobs(limit: 2, lastDocument: lastJob).then((jobs) {
      setState(() {
        this.jobs.addAll(jobs);
        lastJob = jobs.last;
        if (jobs.length < 2) {
          _hasMore = false;
        }
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _refreshJobs() async {
    setState(() {
      isLoading = true;
    });
    await _jobService.getJobsForTaksers().then((jobs) {
      setState(() {
        this.jobs = jobs;
      });
    }).whenComplete(() {
      setState(() {
        isLoading = false;
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
              if (isLoading) CardScreenPlaceholder() else _buildAllJobs(),
              AppliedJobsTab(),
            ])));
  }

  Widget _buildAllJobs() {
    return RefreshIndicator(
        // notificationPredicate: (ScrollNotification scrollInfo) {
        //   if (!isLoading &&
        //       _hasMore &&
        //       scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
        //     _load(); // Load more jobs when reaching the bottom
        //   }
        //   return false;
        // },
        onRefresh: _refreshJobs,
        child:
            // NotificationListener<ScrollNotification>(
            // onNotification: (ScrollNotification scrollInfo) {
            //   if (!isLoading &&
            //       _hasMore &&
            //       scrollInfo.metrics.pixels ==
            //           scrollInfo.metrics.maxScrollExtent) {
            //     _load(); // Load more jobs when reaching the bottom
            //   }
            //   return false;
            // },
            // child:
            ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  return TaskerJobCard(
                    onTap: () {
                      context.router.push(TaskerJobDetailsRoute(
                          jobId: jobs[index].id!, job: jobs[index]));
                    },
                    job: jobs[index],
                  );
                })
        // )
        );
  }
}
