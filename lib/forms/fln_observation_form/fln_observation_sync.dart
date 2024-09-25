import 'dart:convert';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_controller.dart';
import 'package:app17000ft_new/forms/in_person_quantitative/in_person_quantitative_controller.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
class FlnObservationSync extends StatefulWidget {
  const FlnObservationSync({super.key});

  @override
  State<FlnObservationSync> createState() => _FlnObservationSync();
}

class _FlnObservationSync extends State<FlnObservationSync> {
  final FlnObservationController _flnObservationController = Get.put(FlnObservationController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;
  var syncProgress = 0.0.obs; // Progress variable for syncing
  var hasError = false.obs; // Variable to track if syncing failed

  @override
  void initState() {
    super.initState();
    _flnObservationController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'FLN Observation Sync'),
        body: GetBuilder<FlnObservationController>(
          builder: (flnObservationController) {
            if (flnObservationController.flnObservationList.isEmpty) {
              return const Center(
                child: Text(
                  'No Records Found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              );
            }

            return Obx(() => isLoading.value
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 20),
                  Text(
                    'Syncing: ${(syncProgress.value * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if (hasError.value)
                    const Text(
                      'Syncing failed. Please try again.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemCount: flnObservationController.flnObservationList.length,
                    itemBuilder: (context, index) {
                      final item = flnObservationController.flnObservationList[index];
                      return ListTile(
                        title: Text(
                          "${index + 1}. Tour ID: ${item.tourId!}\n    School: ${item.school!}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          color: AppColors.primary,
                          icon: const Icon(Icons.sync),
                          onPressed: () async {
                            IconData icon = Icons.check_circle;
                            showDialog(
                              context: context,
                              builder: (_) => Confirmation(
                                iconname: icon,
                                title: 'Confirm',
                                yes: 'Confirm',
                                no: 'Cancel',
                                desc: 'Are you sure you want to Sync?',
                                onPressed: () async {
                                  setState(() {
                                    isLoading.value = true; // Show loading spinner
                                    syncProgress.value = 0.0; // Reset progress
                                    hasError.value = false; // Reset error state
                                  });

                                  if (_networkManager.connectionType.value == 0) {
                                    customSnackbar(
                                        'Warning',
                                        'You are offline please connect to the internet',
                                        AppColors.secondary,
                                        AppColors.onSecondary,
                                        Icons.warning);
                                  } else {
                                    if (_networkManager.connectionType.value == 1 ||
                                        _networkManager.connectionType.value == 2) {
                                      // Simulate a delay for syncing
                                      for (int i = 0; i <= 100; i++) {
                                        await Future.delayed(const Duration(milliseconds: 50));
                                        syncProgress.value = i / 100; // Update progress
                                      }

                                      var rsp = await insertFlnObservation(
                                        item.tourId,
                                        item.school,
                                        item.udiseValue,
                                        item.correctUdise,
                                        item.noStaffTrained,
                                        item.imgNurTimeTable,
                                        item.imgLKGTimeTable,
                                        item.imgUKGTimeTable,
                                        item.lessonPlanValue,
                                        item.activityValue,
                                        item.imgActivity,
                                        item.imgTLM,
                                        item.baselineValue,
                                        item.baselineGradeReport,
                                        item.flnConductValue,
                                        item.flnGradeReport,
                                        item.imgFLN,
                                        item.refresherValue,
                                        item.numTrainedTeacher,
                                        item.imgTraining,
                                        item.readingValue,
                                        item.libGradeReport,
                                        item.imgLib,
                                        item.methodologyValue,
                                        item.imgClass,
                                        item.observation,
                                        item.created_by,
                                        item.createdAt,
                                        item.submittedAt,
                                        item.id,
                                            (progress) {
                                          syncProgress.value = progress; // Update sync progress
                                        },
                                      );

                                      if (rsp['status'] == 1) {
                                        customSnackbar(
                                            'Successfully',
                                            "${rsp['message']}",
                                            AppColors.secondary,
                                            AppColors.onSecondary,
                                            Icons.check);
                                      } else {
                                        hasError.value = true; // Set error state if sync fails
                                        customSnackbar(
                                            "Error",
                                            "${rsp['message']}",
                                            AppColors.error,
                                            AppColors.onError,
                                            Icons.warning);
                                      }
                                    }
                                  }
                                  setState(() {
                                    isLoading.value = false; // Hide loading spinner
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        onTap: () {
                          flnObservationController.flnObservationList[index].tourId;
                        },
                      );
                    },
                  ),
                ),
              ],
            ));
          },
        ),
      ),
    );
  }
}

var baseurl = "https://mis.17000ft.org/apis/fast_apis/insert_fln.php";

Future<Map<String, dynamic>> insertFlnObservation(
    String? tourId,
    String? school,
    String? udiseValue,
    String? correctUdise,
    String? noStaffTrained,
    String? imgNurTimeTable,
    String? imgLKGTimeTable,
    String? imgUKGTimeTable,
    String? lessonPlanValue,
    String? activityValue,
    String? imgActivity,
    String? imgTLM,
    String? baselineValue,
    String? baselineGradeReport,
    String? flnConductValue,
    String? flnGradeReport,
    String? imgFLN,
    String? refresherValue,
    String? numTrainedTeacher,
    String? imgTraining,
    String? readingValue,
    String? libGradeReport,
    String? imgLib,
    String? methodologyValue,
    String? imgClass,
    String? observation,
    String? created_by,
    String? createdAt,
    String? submittedAt,
    int? id,
    Function(double) updateProgress, // Progress callback
    ) async {
  if (kDebugMode) {
    print('Inserting Fln Observation Data');
    print('tourId: $tourId');
    print('school: $school');
    // Add more debug prints as needed
  }

  var request = http.MultipartRequest('POST', Uri.parse(baseurl));
  request.headers["Accept"] = "Application/json";

  request.fields.addAll({
    'tourId': tourId ?? '',
    'school': school ?? '',
    'udiseValue': udiseValue ?? '',
    'correctUdise': correctUdise ?? '',
    'noStaffTrained': noStaffTrained ?? '',
    'lessonPlanValue': lessonPlanValue ?? '',
    'activityValue': activityValue ?? '',
    'baselineValue': baselineValue ?? '',
    'baselineGradeReport': baselineGradeReport ?? '',
    'flnConductValue': flnConductValue ?? '',
    'flnGradeReport': flnGradeReport ?? '',
    'refresherValue': refresherValue ?? '',
    'numTrainedTeacher': numTrainedTeacher ?? '',
    'readingValue': readingValue ?? '',
    'libGradeReport': libGradeReport ?? '',
    'methodologyValue': methodologyValue ?? 'hhh',
    'observation': observation ?? '',
    'created_by': created_by ?? '',
    'createdAt': createdAt ?? '',
    'submittedAt': submittedAt ?? '',
  });


  try {
    if (imgNurTimeTable != null && imgNurTimeTable.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgNurTimeTable.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgNurTimeTable[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgNurTimeTable${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }

    if (imgLKGTimeTable != null && imgLKGTimeTable.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgLKGTimeTable.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgLKGTimeTable[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgLKGTimeTable${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }


    if (imgUKGTimeTable != null && imgUKGTimeTable.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgUKGTimeTable.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgUKGTimeTable[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgUKGTimeTable${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }

    if (imgActivity != null && imgActivity.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgActivity.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgActivity[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgActivity${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }

    if (imgTLM != null && imgTLM.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgTLM.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgTLM[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgTLM${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }

    if (imgFLN != null && imgFLN.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgFLN.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgFLN[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgFLN${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }


    if (imgTraining != null && imgTraining.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgTraining.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgTraining[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgTraining${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }


    if (imgLib != null && imgLib.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgLib.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgLib[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgLib${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload
        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }

    if (imgClass != null && imgClass.isNotEmpty) {
      // Split the Base64-encoded images based on the separator (e.g., ',')
      List<String> imageStrings = imgClass.split(',');
      int totalImages = imageStrings.length;
      // Iterate through the list of Base64-encoded images and add each as a multipart file
      for (int i = 0; i < imageStrings.length; i++) {
        String imageString = imageStrings[i].trim(); // Clean up any extra spaces

        // Convert each Base64 image to Uint8List
        Uint8List imageBytes = base64Decode(imageString);

        // Create MultipartFile from the image bytes
        var multipartFile = http.MultipartFile.fromBytes(
          'imgClass[]', // Name of the field in the server request
          imageBytes,
          filename: 'imgClass${id ?? ''}_$i.jpg', // Unique file name for each image
          contentType: MediaType('image', 'jpeg'), // Specify the content type
        );

        // Add the image to the request
        request.files.add(multipartFile);
        updateProgress((i + 1) / totalImages); // Use the callback to update progress
        print('Sync progress: ${(i + 1) / totalImages * 100}%');
        // Debugging: Log each image upload

        print('Adding image $i to the request, filename: enrolment_image_${id ?? ''}_$i.jpg');
      }

      // Debugging: Print the total number of images added
      print('Total images added: ${request.files.length}');
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      if (responseBody.isEmpty) {
        return {"status": 0, "message": "Empty response from server"};
      }

      try {
        var parsedResponse = json.decode(responseBody);
        if (parsedResponse['status'] == 1) {
          await SqfliteDatabaseHelper().queryDelete(arg: id.toString(), table: 'flnObservation', field: 'id');
          await Get.find<FlnObservationController>().fetchData();
          return parsedResponse;
        } else {
          return {"status": 0, "message": parsedResponse['message'] ?? 'Failed to insert data'};
        }
      } catch (e) {
        return {"status": 0, "message": "Invalid response format"};
      }
    } else {
      print(responseBody);
      return {"status": 0, "message": "Server returned an error $responseBody"};
    }
  } catch (responseBody) {
    return {"status": 0, "message": "Something went wrong, Please contact Admin $responseBody"};
  }
}
