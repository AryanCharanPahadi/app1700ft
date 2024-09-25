import 'dart:convert';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../components/custom_appBar.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_sizedBox.dart';
import '../../tourDetails/tour_controller.dart';
import '../school_enrolment/school_enrolment.dart';
import '../school_enrolment/school_enrolment_model.dart';
import '../school_facilities_&_mapping_form/SchoolFacilitiesForm.dart';
import '../school_facilities_&_mapping_form/school_facilities_modals.dart';
import '../school_staff_vec_form/school_vec_from.dart';
import '../school_staff_vec_form/school_vec_modals.dart';
import 'edit controller.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../base_client/base_client.dart';
import '../../helper/responsive_helper.dart';

import 'local_db.dart';


class EditFormPage extends StatefulWidget {
  const EditFormPage({super.key});

  @override
  State<EditFormPage> createState() => _EditFormPageState();
}

class _EditFormPageState extends State<EditFormPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> splitSchoolLists = [];
  String selectedFormLabel = 'enrollment'; // Default form label
  Map<String, dynamic> formData = {}; // Store fetched form data
  String selectedSchool = '';

  // Instance of EditController
  late EditController editController;

  @override
  void initState() {
    super.initState();
    editController = Get.put(EditController()); // Initialize editController
    loadLocalData(); // Load previously stored data when initializing
  }

  Future<void> fetchData(String tourId, String school) async {
    final url = 'https://mis.17000ft.org/apis/fast_apis/pre-fill-data.php?id=$tourId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        formData = data[school] ?? {};
      });
      // Store fetched data locally
      await LocalDatabaseHelper().insertFormData(
          tourId, school, selectedFormLabel, formData);
    } else {
      print('Failed to fetch data');
    }
  }

  Future<void> loadLocalData() async {
    List<Map<String, dynamic>> storedData = await LocalDatabaseHelper()
        .getAllFormData();
    if (storedData.isNotEmpty) {
      // Optionally, you can display the last stored data
      final lastData = storedData.last;
      setState(() {
        editController.setTour(lastData['tourId']);
        editController.setSchool(lastData['school']);
        formData = jsonDecode(lastData['data']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await BaseClient().showLeaveConfirmationDialog(
            context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'Edit Form',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                GetBuilder<TourController>(
                  init: TourController(),
                  builder: (tourController) {
                    tourController.fetchTourDetails();
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          LabelText(
                            label: 'Select Tour ID',
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomDropdownFormField(
                            focusNode: editController.tourIdFocusNode,
                            options: tourController.getLocalTourList.map((
                                e) => e.tourId!).toList(),
                            selectedOption: editController.tourValue,
                            onChanged: (value) {
                              splitSchoolLists = tourController.getLocalTourList
                                  .where((e) => e.tourId == value)
                                  .map((e) => e.allSchool!.split('|').toList())
                                  .expand((x) => x)
                                  .toList();
                              setState(() {
                                editController.setSchool(null);
                                editController.setTour(value);
                              });
                            },
                            labelText: "Select Tour ID",
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'School',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          DropdownSearch<String>(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Select School";
                              }
                              return null;
                            },
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              showSearchBox: true,
                              disabledItemFn: (String s) => s.startsWith('I'),
                            ),
                            items: splitSchoolLists,
                            dropdownDecoratorProps: const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select School",
                                hintText: "Select School ",
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedSchool = value;
                                  editController.setSchool(value);
                                  fetchData(editController.tourValue!,
                                      value); // Ensure tourValue is non-null
                                });
                              }
                            },
                            selectedItem: editController.schoolValue,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          // Dropdown for form labels
                          LabelText(label: 'Select Form'),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedFormLabel,
                            items: ['enrollment', 'vec', 'facilities']
                                .map((label) =>
                                DropdownMenuItem(
                                  value: label,
                                  child: Text(label.toUpperCase()),
                                ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedFormLabel = value!;
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Select Form',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          // Display the fetched form data
                          if (formData.isNotEmpty)
                            buildFormDataWidget(selectedFormLabel),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Function to build widget to display form data in a single card horizontally
  Widget buildFormDataWidget(String label) {
    switch (label) {
      case 'enrollment':
        if (formData.containsKey('enrollment')) {
          final enrollmentFetch = formData['enrollment'];

          if (enrollmentFetch is Map) {
            List<Widget> classWidgets = [];

            // Creating a horizontal layout for class data
            enrollmentFetch.forEach((className, data) {
              if (data is Map && data.containsKey('boys') && data.containsKey('girls')) {
                final boys = int.tryParse(data['boys'] ?? '0') ?? 0; // Convert to int, default to 0 if parsing fails
                final girls = int.tryParse(data['girls'] ?? '0') ?? 0; // Convert to int, default to 0 if parsing fails
                classWidgets.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        className,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text('Boys: $boys'),
                      Text('Girls: $girls'),
                      SizedBox(height: 16), // Spacing between classes
                    ],
                  ),
                );
              }
            });

            // If there are no classes to display, show a message
            if (classWidgets.isEmpty) {
              return const Text('No enrollment data available');
            }

            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: classWidgets.map((classWidget) {
                        return Expanded(child: classWidget);
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Prepare the data in the correct format for SchoolEnrollmentForm
                        final enrolmentDataMap = <String, Map<String, String>>{};

                        // Mapping the data to match the structure expected by SchoolEnrollmentForm
                        enrollmentFetch.forEach((className, data) {
                          if (data is Map && data.containsKey('boys') && data.containsKey('girls')) {
                            enrolmentDataMap[className] = {
                              'boys': data['boys'] ?? '0',
                              'girls': data['girls'] ?? '0',
                            };
                          }
                        });

                        // Navigate to SchoolEnrollmentForm with the mapped data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchoolEnrollmentForm(
                              userid: 'userid',
                              existingRecord: EnrolmentCollectionModel(
                                enrolmentData: jsonEncode(enrolmentDataMap), // Pass the enrollment data as JSON
                                remarks: enrollmentFetch['remarks'] ?? '',
                                school: enrollmentFetch['school'] ?? '',

                                submittedBy: enrollmentFetch['submittedBy'] ?? '',
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Edit Enrollment Data'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text('Enrollment data format is incorrect');
          }
        } else {
          return const Text('No enrollment data available');
        }


      case 'vec':
        if (formData.containsKey('vec') && formData['vec'] != null && formData['vec'].isNotEmpty) {
          final vecData = formData['vec']; // Assuming vecData is a list of VEC records
          List<Widget> vecWidgets = [];

          // Build a widget for each VEC record
          vecData.forEach((vec) {
            vecWidgets.add(
              ListTile(
                title: Text('VEC Name: ${vec['SmcVecName']}'),
                subtitle: Text('Head Name: ${vec['headName']}'),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to the SchoolStaffVecForm and pass the selected VEC record
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchoolStaffVecForm(
                          userid: 'userid', // Pass the actual userId here
                          existingRecord: SchoolStaffVecRecords(


                            headName: vec['headName'],
                            headGender: vec['headGender'],
                            udiseValue: vec['udiseValue'],
                            correctUdise: vec['correctUdise'],
                            headMobile: vec['headMobile'],
                            headEmail: vec['headEmail'],
                            headDesignation: vec['headDesignation'],
                            totalTeachingStaff: vec['totalTeachingStaff'],
                            totalNonTeachingStaff: vec['totalNonTeachingStaff'],
                            totalStaff: vec['totalStaff'],
                            SmcVecName: vec['SmcVecName'],
                            genderVec: vec['genderVec'],
                            vecMobile: vec['vecMobile'],
                            vecEmail: vec['vecEmail'],
                            vecQualification: vec['vecQualification'],
                            vecTotal: vec['vecTotal'],
                            meetingDuration: vec['meetingDuration'],
                            createdBy: vec['createdBy'],
                            createdAt: vec['createdAt'],
                            other: vec['other'],
                            otherQual: vec['otherQual'],
                            // Map more fields here if needed
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          });

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: vecWidgets,
              ),
            ),
          );
        } else {
          return const Text('No VEC data available');
        }

      case 'facilities':
        if (formData.containsKey('facilities') &&
            formData['facilities'] != null &&
            formData['facilities'].isNotEmpty) {

          final facilitiesData = formData['facilities']; // Assuming facilitiesData is a list of facility records
          List<Widget> facilityWidgets = [];

          // Build a widget for each facility record
          facilitiesData.forEach((facility) {
            facilityWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Facility: ${facility['school']}'),
                  Text('Residential Value: ${facility['residentialValue']}'),
                  // Add other facility fields as necessary...
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the SchoolFacilitiesForm and pass the selected facility record
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolFacilitiesForm(
                            userid: 'userid', // Pass the actual userId here
                            existingRecord: SchoolFacilitiesRecords(
                              residentialValue: facility['residentialValue'],
                              electricityValue: facility['electricityValue'],
                              internetValue: facility['internetValue'],
                              udiseCode: facility['udiseValue'],
                              correctUdise: facility['correctUdise'],
                              school: facility['school'],
                              projectorValue: facility['projectorValue'],
                              smartClassValue: facility['smartClassValue'],
                              numFunctionalClass: facility['numFunctionalClass'],
                              playgroundValue: facility['playgroundValue'],
                              libValue: facility['libValue'],
                              libLocation: facility['libLocation'],
                              librarianName: facility['librarianName'],
                              librarianTraining: facility['librarianTraining'],
                              libRegisterValue: facility['libRegisterValue'],
                              created_by: facility['created_by'],
                              created_at: facility['created_at'],
                              // Map more fields here if needed
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Edit Facilities Data'),
                  ),
                ],
              ),
            );
          });

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: facilityWidgets,
              ),
            ),
          );
        } else {
          return const Text('No facilities data available');
        }

      default:
        return const Text('No data available'); // Ensure a default return case
    }
  }

}
