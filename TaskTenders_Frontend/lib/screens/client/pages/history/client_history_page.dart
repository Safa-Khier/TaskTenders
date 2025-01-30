import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/screens/client/pages/history/create_job_sheet.dart';
import 'package:tasktender_frontend/screens/client/pages/history/history_screen_placeholder.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/job_card.dart';
import 'package:tasktender_frontend/widgets/list_item.dart';

@RoutePage()
class ClientHistoryPage extends StatefulWidget {
  const ClientHistoryPage({super.key});

  @override
  State<ClientHistoryPage> createState() => _ClientHistoryPageState();
}

class _ClientHistoryPageState extends State<ClientHistoryPage> {
  final JobService _jobService = locator<JobService>();
  bool isLoading = true;
  List<Job> jobs = [];
  SortType sortType = SortType.deliveryDate;

  _ClientHistoryPageState() {
    getJobs();
  }

  Future<void> getJobs() async {
    try {
      final jobs = await _jobService.getJobs();
      setState(() {
        this.jobs = jobs;
        _sortJobs();
      });
    } catch (e) {
      print('Error fetching jobs: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortJobs() {
    if (sortType == SortType.deliveryDate) {
      jobs.sort((a, b) => a.deadline!.compareTo(b.deadline!));
    } else {
      jobs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          leading: Center(
              child: IconButton(
                  icon: Icon(Icons.notifications_outlined), onPressed: () {})),
          title: const Text(
            'Manage orders',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () => _showSortDialog())
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.33), // Height of the border
            child: Container(
              color: Color(0xFF000000).withAlpha(76), // Border color
              height: 0.33, // Thickness of the border
            ),
          ),
        ),
        body: Stack(children: [_buldListView(), _buildFloatingActionButton()]));
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          onPressed: () {
            _showAddJobDialog();
          },
          backgroundColor: Color(0xFF00CED1),
          child: Icon(Icons.add),
        ));
  }

  Widget _buldListView() {
    if (isLoading) {
      return const HistoryScreenPlaceholder();
    }
    if (jobs.isEmpty) {
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
                'No orders yet',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ],
          ));
    }

    return RefreshIndicator(
        onRefresh: getJobs,
        child: ListView(children: [
          for (var job in jobs)
            JobCard(
              job: job,
              onTap: () {
                // context.router.pushNamed('/client/history/${job.id}');
                if (job.id != null) {
                  context.router.push(JobDetailsRoute(id: job.id!, job: job));
                } else {
                  print('Job id is null');
                }
              },
            ),
          const SizedBox(height: 90),
        ]));
  }

  void _showAddJobDialog() {
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
        builder: (context) => CreateJobSheet()).then((result) {
      // Check if the dialog returned a value
      if (result == true) {
        // Refresh the job list
        _refreshJobs();
      }
    }).catchError((error) {
      // Handle any errors gracefully
      debugPrint('Error in showModalBottomSheet: $error');
    });
  }

  void _refreshJobs() {
    setState(() {
      isLoading = true; // Optional: Show a loading indicator
    });
    getJobs();
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
                ListTile(
                  title: const Text(
                    'Sort by',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListItem(
                  iconData: Icons.calendar_today,
                  title: 'Delivery Date',
                  color: sortType == SortType.deliveryDate
                      ? Color(0xFF00CED1)
                      : null,
                  trailingIcon:
                      sortType == SortType.deliveryDate ? Icons.check : null,
                  onPressed: () {
                    if (sortType != SortType.deliveryDate) {
                      setState(() {
                        sortType = SortType.deliveryDate;
                        _sortJobs();
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
                ListItem(
                  iconData: Icons.cake,
                  color:
                      sortType == SortType.orderDate ? Color(0xFF00CED1) : null,
                  title: 'Job Date',
                  trailingIcon:
                      sortType == SortType.orderDate ? Icons.check : null,
                  onPressed: () {
                    if (sortType != SortType.orderDate) {
                      setState(() {
                        sortType = SortType.orderDate;
                        _sortJobs();
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Filter by',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListItem(
                  iconData: Icons.cake,
                  color:
                      sortType == SortType.orderDate ? Color(0xFF00CED1) : null,
                  title: 'All',
                  trailingIcon:
                      sortType == SortType.orderDate ? Icons.check : null,
                  onPressed: () {
                    if (sortType != SortType.orderDate) {
                      setState(() {
                        sortType = SortType.orderDate;
                        _sortJobs();
                      });
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            )));
  }
}

enum SortType { deliveryDate, orderDate }
