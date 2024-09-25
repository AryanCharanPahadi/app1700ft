import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_model.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_sync.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_client/baseClient_controller.dart';
import 'in_person_quantitative.dart';
import 'in_person_quantitative_modal.dart';
class InPersonQuantitativeController extends GetxController with BaseController {
  var counterText = ''.obs;
  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;
  final TextEditingController tourIdController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController noOfEnrolledStudentAsOnDateController = TextEditingController();
  final TextEditingController remarksOnDigiLabSchedulingController = TextEditingController();
  final TextEditingController digiLabAdminNameController = TextEditingController();
  final TextEditingController digiLabAdminPhoneNumberController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController instructionProvidedRegardingClassSchedulingController = TextEditingController();
  final TextEditingController staafAttendedTrainingController = TextEditingController();
  final TextEditingController otherTopicsController = TextEditingController();
  final TextEditingController reasonForNotGivenpracticalDemoController = TextEditingController();
  final TextEditingController additionalCommentOnteacherCapacityController = TextEditingController();
  final TextEditingController howOftenDataBeingSyncedController = TextEditingController();
  final TextEditingController additionalObservationOnLibraryController = TextEditingController();
  final TextEditingController writeIssueController = TextEditingController();
  final TextEditingController writeResolutionController = TextEditingController();
  final TextEditingController participantsNameController = TextEditingController();



  // Map to store selected values for radio buttons
  final Map<String, String?> _selectedValues = {};
  String? getSelectedValue(String key) => _selectedValues[key];

  // Map to store error states for radio buttons
  final Map<String, bool> _radioFieldErrors = {};
  bool getRadioFieldError(String key) => _radioFieldErrors[key] ?? false;

  // Method to set the selected value and clear any previous error
  void setRadioValue(String key, String? value) {
    _selectedValues[key] = value;
    _radioFieldErrors[key] = false; // Clear error when a value is selected
    update(); // Update the UI
  }

  // Method to validate radio button selection
  bool validateRadioSelection(String key) {
    if (_selectedValues[key] == null) {
      _radioFieldErrors[key] = true;
      update(); // Update the UI
      return false;
    }
    _radioFieldErrors[key] = false;
    update(); // Update the UI
    return true;
  }
  List<String> splitSchoolLists = [];


  bool showBasicDetails = true; // For show Basic Details
  bool showDigiLabSchedule = false; // For show and hide DigiLab Schedule
  bool showTeacherCapacity = false; // For show and hide Teacher Capacity
  bool showSchoolRefresherTraining =
  false; // For show and hide School Refresher training
  bool showDigiLabClasses = false; // For show and hide DigiLab Classes
  bool showLibrary = false; // For show and hide Library

  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  bool checkboxValue5 = false;
  bool checkboxValue6 = false;
  bool checkboxValue7 = false;
  bool checkboxValue8 = false;

  bool checkBoxError = false; //for checkbox error

  String? selectedValue = ''; // For the UDISE code
  String? selectedValue2 = ''; // For the DigiLab timetable available
  String? selectedValue3 = ''; // For the class scheduled for 2 hours per week
  String? selectedValue4 = ''; // For the DigiLab admin appointed
  String? selectedValue5 = ''; // For the Digilab admin trained
  String? selectedValue6 = ''; // For the subject teacher trained
  String? selectedValue7 = ''; // For the subject teacher Ids been created
  String? selectedValue8 = ''; // For the teachers comfortable using the tabs
  String? selectedValue9 = ''; // For the practical demo given
  String? selectedValue10 = ''; // For the children comfortable using the tabs
  String? selectedValue11 =
      ''; // For the children able to understand the content
  String? selectedValue12 =
      ''; // For the post-tests being completed by children
  String? selectedValue13 =
      ''; // For the teachers able to help children resolve doubts
  String? selectedValue14 = ''; // For the digiLab logs being filled
  String? selectedValue15 = ''; // For the the logs being filled correctly
  String? selectedValue16 =
      ''; // For the the "Send Report" being done on each used tab
  String? selectedValue17 =
      ''; // For the the Facilitator App installed and functioning
  String? selectedValue18 = ''; // For the the Library timetable available
  String? selectedValue19 = ''; // For the the timetable being followed
  String? selectedValue20 = ''; // For the the Library register updated

  String? isResolved;


  void updateIsResolved(String? value) {
    isResolved = value;
    update(); // This will call the builder again to reflect changes
  }

  final TextEditingController dateController = TextEditingController();
  bool dateFieldError = false;




  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<InPersonQuantitativeRecords> _inPersonQuantitativeList = [];
  List<InPersonQuantitativeRecords> get inPersonQuantitative => _inPersonQuantitativeList;

  final List<XFile> _multipleImage = [];
  List<XFile> get multipleImage => _multipleImage;
  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;
  // This will hold the converted list of File objects
  List<File> _imageFiles = [];
  List<File> get imageFiles => _imageFiles;

  final List<XFile> _multipleImage2 = [];
  List<XFile> get multipleImage2 => _multipleImage2;
  List<String> _imagePaths2 = [];
  List<String> get imagePaths2 => _imagePaths2;
  List<File> _imageFiles2 = [];
  List<File> get imageFiles2 => _imageFiles2;


  // Convert a File to Base64 String
  Future<String> convertImagesToBase64() async {
    List<String> base64Images = [];

    for (var imageFile in _imageFiles) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images
        .join(','); // Return the combined Base64 strings with ',' as separator
  }



  // Convert a File to Base64 String
  Future<String> convertImagesToBase64_2() async {
    List<String> base64Images2 = [];

    for (var imageFile in _imageFiles2) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images2.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images2
        .join(','); // Return the combined Base64 strings with ',' as separator
  }


  Future<File?> processImage(File file) async {
    final img.Image? image = img.decodeImage(await file.readAsBytes());
    if (image == null) return null;

    // Resize the image to a smaller width while maintaining aspect ratio
    final img.Image resized =
    img.copyResize(image, width: 800); // Adjust width as needed
    final List<int> compressedImage =
    img.encodeJpg(resized, quality: 80); // Adjust quality as needed

    // Save the processed image to a new file
    final String newPath = file.path.replaceAll('.jpg', '_processed.jpg');
    final File newFile = File(newPath)..writeAsBytesSync(compressedImage);
    return newFile;
  }

  // Method to capture or pick photos with quality and processing
  Future<String> takePhoto(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages =
      await picker.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages != null) {
        for (XFile xfile in selectedImages) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage.add(xfile);
            _imagePaths.add(processedFile.path); // Use processed image path
            _imageFiles.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage.add(pickedImage);
            _imagePaths.add(processedFile.path); // Use processed image path
            _imageFiles.add(processedFile); // Add the processed file to the list
          }

          // Ask the user if they want to take another picture
          // You may need a UI/dialog here to continue or break the loop
          isTakingPictures = await askUserToContinueTakingPictures();
        } else {
          isTakingPictures = false; // Exit loop if no image is taken
        }
      }
    }

    update(); // Update the UI if necessary
    return _imagePaths.toString(); // Return the list of paths as a string
  }

// This method allows selecting from both the gallery and the camera with compression and processing
  Future<void> selectMultipleFromGalleryAndCamera({int imageQuality = 75}) async {
    // First, let the user pick from the gallery
    await takePhoto(ImageSource.gallery, imageQuality: imageQuality);

    // Then, allow the user to capture multiple images with the camera
    await takePhoto(ImageSource.camera, imageQuality: imageQuality);

    // Update UI if necessary after picking from both sources
    update();
  }

// Function to ask the user if they want to take more pictures from the camera
// You could show a dialog asking the user if they want to continue
  Future<bool> askUserToContinueTakingPictures() async {
    // Placeholder for your UI/dialog logic
    // Return true to continue taking pictures or false to stop
    return false; // Change this to actual logic for asking the user
  }



// Function to add padding to the Base64 string if needed
  String _addPadding(String base64) {
    int padding = base64.length % 4;
    if (padding > 0) {
      base64 += '=' * (4 - padding); // Add '=' characters for padding
    }
    return base64;
  }

  Future<String> takePhoto2(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker2 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages2 =
      await picker2.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages2 != null) {
        for (XFile xfile in selectedImages2) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage2.add(xfile);
            _imagePaths2.add(processedFile.path); // Use processed image path
            _imageFiles2.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker2.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage2.add(pickedImage);
            _imagePaths2.add(processedFile.path); // Use processed image path
            _imageFiles2.add(processedFile); // Add the processed file to the list
          }

          // Ask the user if they want to take another picture
          // You may need a UI/dialog here to continue or break the loop
          isTakingPictures = await askUserToContinueTakingPictures();
        } else {
          isTakingPictures = false; // Exit loop if no image is taken
        }
      }
    }

    update(); // Update the UI if necessary
    return _imagePaths2.toString(); // Return the list of paths as a string
  }

  void setSchool(String? value) {
    _schoolValue = value;

  }

  void setTour(String? value) {
    _tourValue = value;

  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.camera);
                  Get.back();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet2(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),

            ],
          ),
        ],
      ),
    );
  }


  void showImagePreview(String imagePath, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  void clearFields() {
    _tourValue = null;
    _schoolValue = null;
    remarksController.clear();
    noOfEnrolledStudentAsOnDateController.clear();
    remarksOnDigiLabSchedulingController.clear();
    digiLabAdminNameController.clear();
    digiLabAdminPhoneNumberController.clear();
    correctUdiseCodeController.clear();
    instructionProvidedRegardingClassSchedulingController.clear();
    staafAttendedTrainingController.clear();
    otherTopicsController.clear();
    reasonForNotGivenpracticalDemoController.clear();
    additionalCommentOnteacherCapacityController.clear();
    howOftenDataBeingSyncedController.clear();
    additionalObservationOnLibraryController.clear();
    writeIssueController.clear();
    writeResolutionController.clear();
    participantsNameController.clear();
    update();
  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    _inPersonQuantitativeList = await LocalDbController().fetchLocalInPersonQuantitativeRecords();
    isLoading = false;
    update();
  }
}