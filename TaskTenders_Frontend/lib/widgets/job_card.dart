import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/utils/app.theme.dart';
import 'package:tasktender_frontend/utils/date_utils.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final VoidCallback? onTap;

  const JobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
            color: Theme.of(context)
                .extension<CustomThemeExtension>()
                ?.listItemBackground,
            margin: const EdgeInsets.fromLTRB(
                12, 12, 12, 0), // Ripple effect matches the border radius
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.title,
                    style:
                        TextStyle(fontSize: 16.5, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    job.description,
                  ),
                  const SizedBox(height: 10),
                  getJobPrice(),
                  const SizedBox(height: 10),
                  Row(
                    children: [const Spacer(), getJobStatus()],
                  ),
                  const SizedBox(height: 10),
                  Container(
                      padding: EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey,
                            width: 0.33,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            getDateInFormat(
                                date: job.deadline ?? DateTime.now()),
                            style: TextStyle(fontSize: 10),
                          ),
                          const Spacer(),
                        ],
                      ))
                ],
              ),
            )));
  }

  Widget getJobPrice() {
    String priceText = 'Volunteering';

    switch (job.jobType) {
      case 'volunteering':
        priceText = 'Volunteering';
        break;
      case 'regular':
        priceText = '${job.price} \$US';
        break;
      case 'tender':
        priceText = '${job.price} \$US - Tender';
        break;
      default:
        priceText = 'Volunteering';
    }

    return Text(
      priceText,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget getJobStatus() {
    String status = 'cancelled';
    Color color = Colors.red;

    switch (job.status) {
      case 'open':
        status = 'Open';
        color = Colors.blue;
        break;
      case 'completed':
        status = 'Completed';
        color = Colors.green;
        break;
      case 'in-progress':
        status = 'In Progress';
        color = Colors.orange;
        break;
      case 'cancelled':
        status = 'Cancelled';
        color = Colors.red;
        break;
      default:
        status = 'Cancelled';
        color = Colors.red;
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          status,
          style: TextStyle(
              fontSize: 10, color: color, fontWeight: FontWeight.bold),
        ));
  }
}
