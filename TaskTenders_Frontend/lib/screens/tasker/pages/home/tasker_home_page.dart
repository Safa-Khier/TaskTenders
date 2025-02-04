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
  List<Job> filteredJobs = [];
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    refreshJobs();
  }

  void filterArray(String query) {
    print('here');
    setState(() {
      _searchQuery = query;
      filteredJobs = jobs.where((job) {
        return job.title.toLowerCase().contains(query.toLowerCase()) ||
            job.description.toLowerCase().contains(query.toLowerCase()) ||
            job.jobType.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> refreshJobs() async {
    setState(() {
      _isLoading = true;
    });
    _jobService.getBestMatchingJobs().then((value) {
      setState(() {
        jobs = value;
        filteredJobs = value;
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(105), // Extend height
        child: AppBar(
          title: const Text(
            'tasktenders',
            style: TextStyle(
                color: Color(0xFF00CED1),
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
          flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                MainInput(
                    hintText: 'Search',
                    borderRadius: 10,
                    leadingIcon: Icons.search,
                    trailingIcon: Icons.clear,
                    fontSize: 13,
                    height: 36,
                    color: Color(0xFF999999),
                    onTextChanged: (str) => filterArray(str))
              ])),
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
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: _buildMatchingJobs()),
    );
  }

  Widget _buildMatchingJobs() {
    return RefreshIndicator(
      onRefresh: refreshJobs,
      child: ListView.builder(
        itemCount: filteredJobs.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Best matches for you',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              TaskerJobCard(
                onTap: () {
                  context.router.pushAll([
                    TaskerJobDetailsRoute(
                      jobId: filteredJobs[index].id!,
                      job: filteredJobs[index],
                    )
                  ]);
                },
                job: filteredJobs[index],
              ),
            ],
          );
        },
      ),
    );
  }
}
