import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:tasktender_frontend/models/user.model.dart';
import 'package:tasktender_frontend/routes/app_router.gr.dart';
import 'package:tasktender_frontend/services/loading.service.dart';
import 'package:tasktender_frontend/services/locator.service.dart';
import 'package:tasktender_frontend/services/toast.service.dart';
import 'package:tasktender_frontend/services/user.service.dart';
import 'package:tasktender_frontend/utils/app_gradients.dart';
import 'package:tasktender_frontend/widgets/main_button.dart';
import 'package:tasktender_frontend/widgets/pick_location.dart';
import 'package:toastification/toastification.dart' hide ToastificationItem;

@RoutePage()
class RegisterComplitionScreen extends StatefulWidget {
  const RegisterComplitionScreen({super.key});

  @override
  State<RegisterComplitionScreen> createState() =>
      _RegisterComplitionScreenState();
}

class _RegisterComplitionScreenState extends State<RegisterComplitionScreen> {
  final UserService _userService = locator<UserService>();
  int currentStep = 0;

  // Text Fields Controllers and Dropdown Value
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime? dateOfBirth;
  UserRole? selectedUserRole;
  LatLng? selectedLocation;

  bool get isFirstStep => currentStep == 0;
  bool get isLastStep => currentStep == steps().length - 1;

  int get fromYear => DateTime.now().year - 120;
  int get toYear => DateTime.now().year - 18;

  bool isCompleted = false;

  // Enum values without the admin
  List<UserRole> get userTypes =>
      UserRole.values.where((element) => element != UserRole.admin).toList();

  bool ifAllFieldsAreFilled() {
    return _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty &&
        _idNumberController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        selectedUserRole != null &&
        (selectedUserRole == UserRole.tasker && selectedLocation != null);
  }

  StepState getStepState(int step) {
    if (step == 0) {
      if (_firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty &&
          _idNumberController.text.isNotEmpty &&
          _dateController.text.isNotEmpty) {
        return StepState.complete;
      }
      if (currentStep <= 0) {
        return StepState.indexed;
      }
      return StepState.error;
    } else if (step == 1) {
      if (_phoneNumberController.text.isNotEmpty) {
        return StepState.complete;
      }
      if (currentStep <= 1) {
        return StepState.indexed;
      }
      return StepState.error;
    } else if (step == 2) {
      if (selectedUserRole != null) {
        return StepState.complete;
      }
      if (currentStep <= 2) {
        return StepState.indexed;
      }
      return StepState.error;
    }
    return StepState.error;
  }

  String enumToString(UserRole value) {
    // Customize how the enum values are displayed
    switch (value) {
      case UserRole.client:
        return "Client";
      case UserRole.tasker:
        return "Tasker";
      default:
        return "Unknown";
    }
  }

  List<Step> steps() => [
        Step(
          state: getStepState(0),
          isActive: currentStep >= 0,
          title: Text('Personal Information'),
          content: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: _idNumberController,
                decoration: const InputDecoration(labelText: 'ID Number'),
              ),
              TextField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Select your birthdate',
                  ),
                  onTap: () => _showDatePicker(context)),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Step(
          state: getStepState(1),
          isActive: currentStep >= 1,
          title: Text('Contact Information'),
          content: Column(
            children: [
              TextFormField(
                enabled: false,
                controller: TextEditingController(
                    text: _userService.getCurrentUser()?.email ?? ''),
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Step(
          state: getStepState(2),
          isActive: currentStep >= 2,
          title: Text('Role Selection'),
          content: Column(
            children: [
              DropdownButton<UserRole>(
                hint: Text("Select a role"),
                isExpanded: true,
                value: selectedUserRole,
                items: userTypes.map((e) {
                  return DropdownMenuItem<UserRole>(
                    value: e,
                    child: Text(enumToString(e)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUserRole = value;
                  });
                },
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 20),
              if (selectedUserRole == UserRole.tasker)
                MapScreen(
                  callbackAction: (point) {
                    setState(() {
                      selectedLocation = point;
                    });
                  },
                  height: 200,
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return isCompleted
        ? _buildCompletedScreen(context)
        : Scaffold(
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.logout),
                    color: Colors.redAccent,
                    onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: Text("Logout"),
                              content: Text("Are you sure you want to logout?"),
                              actions: [
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Logout",
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                  onPressed: () {
                                    _userService.logoutUser(context);
                                  },
                                ),
                              ],
                            ))),
                title: const Text('Register Complition')),
            body: Stepper(
              // type: StepperType.horizontal,
              steps: steps(),
              currentStep: currentStep,
              onStepContinue: () {
                if (isLastStep) {
                } else {
                  setState(() {
                    currentStep += 1;
                  });
                }
              },
              onStepCancel:
                  isFirstStep ? null : () => setState(() => currentStep -= 1),
              onStepTapped: (step) => setState(() => currentStep = step),
              controlsBuilder: (context, details) => Row(
                children: [
                  if (!isFirstStep)
                    Expanded(
                        child: ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    )),
                  const SizedBox(width: 20),
                  if (!isLastStep)
                    Expanded(
                        child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: const Text('Next'),
                    )),
                  if (isFirstStep) const SizedBox(width: 20),
                  if (isLastStep)
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        if (ifAllFieldsAreFilled()) {
                          LoadingService.showLoadingIndicator(context);
                          // Create user details
                          UserDetails userDetails = UserDetails(
                              uid: _userService.getUserUid(),
                              email: _userService.getUserEmail(),
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              id: _idNumberController.text,
                              dateOfBirth: dateOfBirth!,
                              phone: _phoneNumberController.text,
                              role: selectedUserRole!,
                              rating: {'1': 0, '2': 0, '3': 0, '4': 0, '5': 0},
                              location: selectedLocation!,
                              completedJobs: 0,
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now());
                          _userService
                              .completeRegistration(userDetails)
                              .then((value) {
                            ToastService().showToast(
                                context,
                                ToastificationItem(
                                  type: ToastificationType.success,
                                  description: RichText(
                                    text: TextSpan(
                                      text: 'Registration completed',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ));
                            setState(() {
                              isCompleted = true;
                            });
                            LoadingService.hideLoadingIndicator();
                          }).catchError((onError) {
                            ToastService().showToast(
                                context,
                                ToastificationItem(
                                  type: ToastificationType.error,
                                  description: RichText(
                                    text: TextSpan(
                                      text: 'Error completing registration',
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ));
                            LoadingService.hideLoadingIndicator();
                          });
                        } else {
                          ToastService().showToast(
                              context,
                              ToastificationItem(
                                type: ToastificationType.warning,
                                description: RichText(
                                  text: TextSpan(
                                    text: 'Please fill all fields',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ));
                        }
                      },
                      child: const Text('Finish'),
                    )),
                ],
              ),
            ));
  }

  Widget _buildCompletedScreen(BuildContext context) {
    return Scaffold(
        body: GradientBackground(
            child: Center(
                child: SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(75),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
                  size: 50,
                )),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Our Family!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your account has been created successfully',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Expanded(child: SizedBox()),
            MainButton(
                context: context,
                onPressed: () {
                  context.router.replace(LoginRoute());
                },
                text: "Get Started"),
          ],
        ),
      ),
    ))));
  }

  Future<void> _showDatePicker(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      helpText: 'Select your birthdate',
      initialEntryMode: DatePickerEntryMode.calendar,
      firstDate: DateTime(fromYear),
      lastDate: DateTime(toYear),
    );

    if (picked != null) {
      setState(() {
        dateOfBirth = picked;
      });
      _dateController.text = picked.toString().split(' ')[0];
    }
  }
}
