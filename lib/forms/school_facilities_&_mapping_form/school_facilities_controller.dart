import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/school_facilities_&_mapping_form/school_facilities_modals.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:get/get.dart';
import '../../base_client/baseClient_controller.dart';

class SchoolFacilitiesController extends GetxController with BaseController {
  var counterText = ''.obs;
  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;
  final TextEditingController noOfEnrolledStudentAsOnDateController = TextEditingController();
  final TextEditingController noOfFunctionalClassroomController = TextEditingController();
  final TextEditingController nameOfLibrarianController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();



  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<SchoolFacilitiesRecords> _schoolFacilitiesList = [];
  List<SchoolFacilitiesRecords> get schoolFacilitiesList => _schoolFacilitiesList;

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


  // Method to process and compress an image file
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
  // Convert a File to Base64 String, joining multiple images with commas
  // Convert a File to a short Base64 String (less than 50 characters), joining multiple images with commas
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

// Function to add padding to the Base64 string if needed
  String _addPadding(String base64) {
    int padding = base64.length % 4;
    if (padding > 0) {
      base64 += '=' * (4 - padding); // Add '=' characters for padding
    }
    return base64;
  }



// Method to capture or pick photos
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




  void setSchool(String? value) {
    _schoolValue = value;

  }

  void setTour(String? value) {
    _tourValue = value;

  }



  List<String> splitSchoolLists = [];
  String? selectedDesignation;

  // Start of Showing Fields
  bool showBasicDetails = true; // For show Basic Details
  bool showSchoolFacilities = false; //For show and hide School Facilities
  bool showLibrary = false; //For show and hide Library
  // End of Showing Fields

  bool validateRegister = false;
  bool isImageUploaded = false;

  bool validateRegister2 = false;
  bool isImageUploaded2 = false;


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
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.gallery);
                  Get.back();
                },
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
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
                  await takePhoto2(ImageSource.camera);
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.gallery);
                  Get.back();
                },
                child: const Text(
                  'Gallery',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
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
 void showImagePreview2(String imagePath2, BuildContext context) {
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
                File(imagePath2),
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
    correctUdiseCodeController.clear();
    noOfFunctionalClassroomController.clear();
    noOfEnrolledStudentAsOnDateController.clear();
    nameOfLibrarianController.clear();
    correctUdiseCodeController.clear();

  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    _schoolFacilitiesList = await LocalDbController().fetchLocalSchoolFacilitiesRecords();
    isLoading = false;
    update();
  }
}