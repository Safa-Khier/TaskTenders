import 'package:flutter/material.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/models/job_updates.model.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';

class AddUpdatesSheet extends StatefulWidget {
  final Job job;

  const AddUpdatesSheet({
    super.key,
    required this.job,
  });

  @override
  State<AddUpdatesSheet> createState() => _AddUpdatesSheetState();
}

class _AddUpdatesSheetState extends State<AddUpdatesSheet> {
  final JobService _jobService = locator<JobService>();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _updateTitleController;
  late TextEditingController _updateDescriptionController;

  @override
  void initState() {
    super.initState();
    _updateTitleController = TextEditingController();
    _updateDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _updateTitleController.dispose();
    _updateDescriptionController.dispose();
    super.dispose();
  }

  void _submitUpdate() {
    if (_formKey.currentState!.validate()) {
      final JobUpdates jobUpdate = JobUpdates(
        title: _updateTitleController.text,
        description: _updateDescriptionController.text,
        date: DateTime.now(),
      );

      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Add New Update"),
                content: Text("Are you sure you want to add this update?"),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Add"),
                    onPressed: () {
                      LoadingService.showLoadingIndicator(context);
                      _jobService
                          .addNewUpdate(widget.job.id!, jobUpdate)
                          .then((value) {
                        Navigator.of(context).pop();
                        Navigator.pop(context, true);
                        LoadingService.hideLoadingIndicator();
                      });
                    },
                  ),
                ],
              ));

      //   // TODO: Implement bid submission logic (e.g., API call)
      //   // Navigator.pop(context, bid);
      //   // ScaffoldMessenger.of(context)
      //   //     .showSnackBar(SnackBar(content: Text('Bid submitted successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Details Preview

              TextFormField(
                controller: _updateTitleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  hintText: 'Enter a title for the update',
                  helperText: ' ',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a title';
                  }
                  if (value.length < 3) {
                    return 'Title should be at least 3 characters';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Cover Letter Input
              TextFormField(
                controller: _updateDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Update Description',
                  alignLabelWithHint: true,
                  hintText: 'Write a detailed description of the update',
                  helperText: ' ',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a description';
                  }
                  if (value.length < 10) {
                    return 'Description should be at least 10 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),

              // Submit Bid Button
              MainButton(
                  context: context,
                  onPressed: () {
                    _submitUpdate();
                  },
                  text: 'Submit'),
            ],
          ),
        ),
      ),
    ));
  }
}
