import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/client/pages/home/main_screen_placeholder.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/main_input.dart';
import 'package:tasktender_frontend/widgets/tasker_job_card.dart';

@RoutePage()
class TaskerHomePage extends StatefulWidget {
  const TaskerHomePage({super.key});

  @override
  State<TaskerHomePage> createState() => _TaskerHomePageState();
}

class _TaskerHomePageState extends State<TaskerHomePage> {
  final JobService _jobService = locator<JobService>();

  List<Job> jobs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshJobs();
  }

  Future<void> refreshJobs() async {
    setState(() {
      _isLoading = true;
    });
    _jobService.getBestMatchingJobs().then((value) {
      setState(() {
        jobs = value;
      });
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'tasktenders',
          style: TextStyle(
              color: Color(0xFF00CED1),
              fontWeight: FontWeight.w600,
              fontSize: 20),
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color: Color(0xFF000000).withAlpha(76),
                          width: 0.33))),
            )),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _buildMatchingJobs()),
    );
  }

  Widget _buildMatchingJobs() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: refreshJobs,
        child: ListView.builder(
          itemCount: jobs.length,
          itemBuilder: (context, index) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  if (index == 0)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Best matches for you',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600))),
                  TaskerJobCard(
                    onTap: () {
                      context.router.pushAll([
                        TaskerJobDetailsRoute(
                          jobId: jobs[index].id!,
                          job: jobs[index],
                        )
                      ]);
                    },
                    job: jobs[index],
                  )
                ]);
          },
        ),
      ),
    );
  }
}
