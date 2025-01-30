import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:tasktender_frontend/models/job.model.dart';
import 'package:tasktender_frontend/services/job.service.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/toast.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/widgets/pick_location.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:tasktender_frontend/widgets/select.dart';
import 'package:toastification/toastification.dart' hide ToastificationItem;

class CreateJobSheet extends StatefulWidget {
  final String title;
  final Job? job;

  const CreateJobSheet({super.key, this.title = 'Create Job', this.job});

  @override
  State<CreateJobSheet> createState() => _CreateJobSheetState();
}

class _CreateJobSheetState extends State<CreateJobSheet> {
  final UserService _userService = locator<UserService>();
  final JobService _jobService = locator<JobService>();
  final ToastService _toastService = locator<ToastService>();

  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();
  final List<String> _options = ['Option 1', 'Option 2', 'Option 3'];
  String? _selectedCategory;
  String? _selectedJobType;
  LatLng? _location;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  DateTime? _deadlineDate;

  @override
  void initState() {
    super.initState();
    final Job? job = widget.job;

    if (job != null) {
      // setState(() {
      _titleController.text = job.title;
      _descriptionController.text = job.description;
      _selectedJobType = job.jobType;
      _selectedCategory = job.categoryId;
      _budgetController.text = job.price.toString();
      _deadlineDate = job.deadline;
      _dateController.text = job.deadline.toString().split(' ')[0];
      _tags.addAll(job.tags);
      // });
    }
  }

  bool validateJob() {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedJobType == null ||
        _selectedCategory == null ||
        (_budgetController.text.isEmpty &&
            _selectedJobType != 'volunteering') ||
        _deadlineDate == null ||
        _tags.isEmpty) {
      _toastService.showToast(
        context,
        ToastificationItem(
          type: ToastificationType.warning,
          style: ToastificationStyle.flatColored,
          duration: const Duration(seconds: 3),
          description: RichText(
            text: TextSpan(
              text: 'Please fill all fields',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(widget.title, style: TextStyle(fontSize: 16)),
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.33), // Height of the border
            child: Container(
              color: Color(0xFF000000).withAlpha(76), // Border color
              height: 0.33, // Thickness of the border
            ),
          ),
        ),
        body: ListView(children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'e.g. Need To Clean My House',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        helperText: ' ',
                      ),
                      // inputFormatters: [
                      //   FilteringTextInputFormatter.allow(
                      //       RegExp(r'^\d+\.?\d{0,2}')),
                      // ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        if (value.length < 3) {
                          return 'Title must be at least 3 characters';
                        }

                        return null;
                      },
                    ),
                    // ListTile(
                    //   contentPadding: EdgeInsets.zero,
                    //   title: Text(
                    //     'Title',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // MainInput(
                    //     controller: _titleController,
                    //     hintText: 'e.g. Need To Clean My House',
                    //     color: Color(0xFF999999)),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        alignLabelWithHint: true,
                        hintText: 'Decsribe the work to be done...',
                        helperText: ' ',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a job description';
                        }
                        if (value.length < 50) {
                          return 'Job description should be at least 50 characters';
                        }
                        return null;
                      },
                    ),
                    // ListTile(
                    //   contentPadding: EdgeInsets.zero,
                    //   title: Text(
                    //     'Description',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // MainInput(
                    //     maxLines: 5,
                    //     controller: _descriptionController,
                    //     hintText: 'Decsribe the work to be done...',
                    //     color: Color(0xFF999999)),
                    const SizedBox(height: 16),
                    // ListTile(
                    //   contentPadding: EdgeInsets.zero,
                    //   title: Text(
                    //     'Job Type',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    Select(
                      initialSelection: _selectedJobType,
                      label: Text('Job Type'),
                      hintText: 'Select a Job Type',
                      borderColor: Theme.of(context).primaryColor,
                      options: JobType.values
                          .map((e) => e.name.split('.').last)
                          .toList(),
                      onSelectionChanged: (type) => setJobType(type),
                    ),
                    const SizedBox(height: 30),
                    _selectedJobType != 'volunteering'
                        ? TextFormField(
                            controller: _budgetController,
                            decoration: InputDecoration(
                              labelText: 'Budget',
                              prefixText: '\$',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              helperText: ' ',
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a budget amount';
                              }
                              final bidAmount = double.tryParse(value);
                              if (bidAmount == null || bidAmount <= 0) {
                                return 'Please enter a valid budget amount';
                              }
                              return null;
                            },
                          )
                        : SizedBox(),
                    // ListTile(
                    //   contentPadding: EdgeInsets.zero,
                    //   title: Text(
                    //     'Category',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    Select(
                      initialSelection: _selectedCategory,
                      label: Text('Category'),
                      hintText: 'Select a category',
                      options: _options,
                      borderColor: Theme.of(context).primaryColor,
                      onSelectionChanged: (p0) {
                        setState(() {
                          _selectedCategory = p0;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                        readOnly: true,
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Deadline',
                          alignLabelWithHint: true,
                          hintText: 'Select Deadline',
                          helperText: ' ',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a cover letter';
                          }
                          if (value.length < 50) {
                            return 'Cover letter should be at least 50 characters';
                          }
                          return null;
                        },
                        onTap: () => _showDatePicker(context)),
                    const SizedBox(height: 16),
                    MapScreen(
                      callbackAction: (LatLng point) {
                        setState(() {
                          _location = point;
                        });
                      },
                      height: 400,
                    ),
                    const SizedBox(height: 16),
                    // ListTile(
                    //   contentPadding: EdgeInsets.zero,
                    //   title: Text(
                    //     'Deadline',
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    // TextField(
                    //     controller: _dateController,
                    //     readOnly: true,
                    //     decoration: InputDecoration(
                    //       hintText: 'Select Deadline',
                    //       // hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    //       enabledBorder: OutlineInputBorder(
                    //         // Border style when TextField is enabled
                    //         borderRadius: BorderRadius.circular(15),
                    //         borderSide:
                    //             BorderSide(color: Color(0xFF999999), width: 1),
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         // Border style when TextField is focused
                    //         borderRadius: BorderRadius.circular(15),
                    //         borderSide:
                    //             BorderSide(color: Color(0xFF999999), width: 2),
                    //       ),
                    //     ),
                    //     onTap: () => _showDatePicker(context)),
                    const SizedBox(height: 10),
                    StatefulBuilder(builder:
                        (BuildContext context, StateSetter setModalState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _tagController,
                            onSubmitted: (tag) {
                              tag = tag.trim().replaceAll(' ', '_');
                              if (tag.isNotEmpty && !_tags.contains(tag)) {
                                setState(() {
                                  _tags.add(tag);
                                });
                                setModalState(
                                    () {}); // Reflect change in the modal UI
                              }
                              _tagController.clear();
                            },
                            decoration: InputDecoration(
                              prefix: Text('#'),
                              labelText: "Enter a tag",
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  final String tag = _tagController.text
                                      .trim()
                                      .replaceAll(' ', '_');
                                  if (tag.isNotEmpty && !_tags.contains(tag)) {
                                    setState(() {
                                      _tags.add(tag);
                                    });
                                    setModalState(
                                        () {}); // Reflect in the modal
                                  }
                                  _tagController.clear();
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 8.0,
                            children: _tags
                                .map((tag) => Chip(
                                      label: Text('#$tag'),
                                      deleteIcon: Icon(Icons.close),
                                      onDeleted: () {
                                        setState(() {
                                          _tags.remove(tag);
                                        });
                                        setModalState(
                                            () {}); // Reflect in the modal
                                      },
                                    ))
                                .toList(),
                          ),
                        ],
                      );
                    }),
                  ],
                )),
          )
        ]),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: MainButton(
              context: context,
              onPressed: () {
                if (!validateJob()) return;

                final double price = _selectedJobType == 'volunteering'
                    ? 0
                    : double.parse(_budgetController.text);

                // Create Job
                final Job job = Job(
                  userId: _userService.getUserUid(),
                  title: _titleController.text,
                  description: _descriptionController.text,
                  jobType: JobType.values
                      .firstWhere((element) =>
                          element.name.split('.').last == _selectedJobType)
                      .name,
                  status: 'open',
                  categoryId: _selectedCategory ?? '',
                  price: price,
                  createdAt: DateTime.now(),
                  location: _location ?? LatLng(0, 0),
                  deadline: _deadlineDate,
                  tags: _tags,
                );
                LoadingService.showLoadingIndicator(context);
                if (widget.job != null) {
                  job.id = widget.job!.id;
                  job.createdAt = widget.job!.createdAt;
                  _jobService
                      .editJob(job)
                      .then((result) => {
                            _toastService.showToast(
                              context,
                              ToastificationItem(
                                type: ToastificationType.success,
                                style: ToastificationStyle.flatColored,
                                duration: const Duration(seconds: 3),
                                description: RichText(
                                  text: TextSpan(
                                    text: 'Job Edited successfully',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Navigator.pop(context, job)
                          })
                      .onError((error, stackTrace) => {
                            _toastService.showToast(
                              context,
                              ToastificationItem(
                                type: ToastificationType.error,
                                style: ToastificationStyle.flatColored,
                                duration: const Duration(seconds: 3),
                                description: RichText(
                                  text: TextSpan(
                                    text: 'Failed to Edit job',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          })
                      .whenComplete(() {
                    LoadingService.hideLoadingIndicator();
                  });
                } else {
                  _jobService
                      .createJob(job)
                      .then((result) => {
                            _toastService.showToast(
                              context,
                              ToastificationItem(
                                type: ToastificationType.success,
                                style: ToastificationStyle.flatColored,
                                duration: const Duration(seconds: 3),
                                description: RichText(
                                  text: TextSpan(
                                    text: 'Job created successfully',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Navigator.pop(context, true)
                          })
                      .onError((error, stackTrace) => {
                            _toastService.showToast(
                              context,
                              ToastificationItem(
                                type: ToastificationType.error,
                                style: ToastificationStyle.flatColored,
                                duration: const Duration(seconds: 3),
                                description: RichText(
                                  text: TextSpan(
                                    text: 'Failed to create job',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          })
                      .whenComplete(() {
                    LoadingService.hideLoadingIndicator();
                  });
                }
              },
              text: widget.title,
              color: Color(0xFF00CED1)),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime initialDate =
        DateTime.now().compareTo(_deadlineDate ?? DateTime.now()) > 0
            ? DateTime.now()
            : _deadlineDate ?? DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      helpText: 'Select Job Deadline',
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        _deadlineDate = picked;
      });
      _dateController.text = picked.toString().split(' ')[0];
    }
  }

  void setJobType(String? p0) {
    setState(() {
      _selectedJobType = p0;
    });
  }
}
