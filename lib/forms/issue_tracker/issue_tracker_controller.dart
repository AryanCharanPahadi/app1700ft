import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';

import 'package:app17000ft_new/helper/database_helper.dart';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';


import '../../base_client/baseClient_controller.dart';

import 'package:app17000ft_new/forms/issue_tracker/issue_tracker_modal.dart';
import 'package:app17000ft_new/forms/issue_tracker/lib_issue_modal.dart';

import 'package:app17000ft_new/forms/issue_tracker/playground_issue.dart';

import 'package:flutter/cupertino.dart';

import 'alexa_issue.dart';
import 'digilab_issue.dart';
import 'furniture_issue.dart';

class IssueTrackerController extends GetxController with BaseController {
  var counterText = ''.obs;

  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController libraryDescriptionController = TextEditingController();
  final TextEditingController playgroundDescriptionController = TextEditingController();
  final TextEditingController digiLabDescriptionController = TextEditingController();
  final TextEditingController classroomDescriptionController = TextEditingController();
  final TextEditingController alexaDescriptionController = TextEditingController();
  final TextEditingController otherSolarDescriptionController = TextEditingController();
  final TextEditingController tabletNumberController = TextEditingController();
  final TextEditingController dotDeviceMissingController = TextEditingController();
  final TextEditingController dotDeviceNotConfiguredController = TextEditingController();
  final TextEditingController dotDeviceNotConnectingController = TextEditingController();
  final TextEditingController dotDeviceNotChargingController = TextEditingController();
  final TextEditingController dotOtherIssueController = TextEditingController();
  final TextEditingController tabletNumber3Controller = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController dateController2 = TextEditingController();
  final TextEditingController dateController3 = TextEditingController();
  final TextEditingController dateController4 = TextEditingController();
  final TextEditingController dateController5 = TextEditingController();
  final TextEditingController dateController6 = TextEditingController();
  final TextEditingController dateController7 = TextEditingController();
  final TextEditingController dateController8 = TextEditingController();
  final TextEditingController dateController9 = TextEditingController();
  final TextEditingController dateController10 = TextEditingController();


  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<IssueTrackerRecords> _issueTrackerList = [];
  List<IssueTrackerRecords> get issueTrackerList => _issueTrackerList;


  // Lib issue list
  List<LibIssue> _libIssueList = [];
  List<LibIssue> get libIssueList => _libIssueList;

  // Play issue list
  List<PlaygroundIssue> _playgroundIssueList = [];
  List<PlaygroundIssue> get playgroundIssueList => _playgroundIssueList;

  //digilab issue list
  List<DigiLabIssue> _digiLabIssueList = [];
  List<DigiLabIssue> get digiLabIssueList => _digiLabIssueList;

  //furniture issue list
  List<FurnitureIssue> _furnitureIssueList = [];
  List<FurnitureIssue> get furnitureIssueList => _furnitureIssueList;

  //alexa issue list
  List<AlexaIssue> _alexaIssueList = [];
  List<AlexaIssue> get alexaIssueList => _alexaIssueList;


  List<String> _staffNames = [];
  List<String> get staffNames => _staffNames;


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


  final List<XFile> _multipleImage3 = [];
  List<XFile> get multipleImage3 => _multipleImage3;
  List<String> _imagePaths3 = [];
  List<String> get imagePaths3 => _imagePaths3;
  List<File> _imageFiles3 = [];
  List<File> get imageFiles3 => _imageFiles3;

  final List<XFile> _multipleImage4 = [];
  List<XFile> get multipleImage4 => _multipleImage4;
  List<String> _imagePaths4 = [];
  List<String> get imagePaths4 => _imagePaths4;
  List<File> _imageFiles4 = [];
  List<File> get imageFiles4 => _imageFiles4;


  final List<XFile> _multipleImage5 = [];
  List<XFile> get multipleImage5 => _multipleImage5;
  List<String> _imagePaths5 = [];
  List<String> get imagePaths5 => _imagePaths5;
  List<File> _imageFiles5 = [];
  List<File> get imageFiles5 => _imageFiles5;

  // Function to add padding to the Base64 string if needed
  String _addPadding(String base64) {
    int padding = base64.length % 4;
    if (padding > 0) {
      base64 += '=' * (4 - padding); // Add '=' characters for padding
    }
    return base64;
  }



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




  // Convert a File to Base64 String
  Future<String> convertImagesToBase64_3() async {
    List<String> base64Images3 = [];

    for (var imageFile in _imageFiles3) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images3.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images3
        .join(','); // Return the combined Base64 strings with ',' as separator
  }

// Convert a File to Base64 String
  // Convert a File to Base64 String
  Future<String> convertImagesToBase64_4() async {
    List<String> base64Images4 = [];

    for (var imageFile in _imageFiles4) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images4.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images4
        .join(','); // Return the combined Base64 strings with ',' as separator
  }

  // Convert a File to Base64 String
  // Convert a File to Base64 String
  Future<String> convertImagesToBase64_5() async {
    List<String> base64Images5 = [];

    for (var imageFile in _imageFiles5) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images5.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images5
        .join(','); // Return the combined Base64 strings with ',' as separator
  }


  // Method to capture or pick photos

// Method to capture or pick photos
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
// Method to capture or pick photos

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

  Future<String> takePhoto3(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker3 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages3 =
      await picker3.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages3 != null) {
        for (XFile xfile in selectedImages3) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage3.add(xfile);
            _imagePaths3.add(processedFile.path); // Use processed image path
            _imageFiles3.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker3.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage3.add(pickedImage);
            _imagePaths3.add(processedFile.path); // Use processed image path
            _imageFiles3.add(processedFile); // Add the processed file to the list
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
    return _imagePaths3.toString(); // Return the list of paths as a string
  }

  Future<String> takePhoto4(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker4 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages4 =
      await picker4.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages4 != null) {
        for (XFile xfile in selectedImages4) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage4.add(xfile);
            _imagePaths4.add(processedFile.path); // Use processed image path
            _imageFiles4.add(
                processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker4.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage4.add(pickedImage);
            _imagePaths4.add(processedFile.path); // Use processed image path
            _imageFiles4.add(
                processedFile); // Add the processed file to the list
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
    return _imagePaths4.toString(); // Return the list of paths as a string

  }

// Method to capture or pick photos
  Future<String> takePhoto5(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker5 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages5 =
      await picker5.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages5 != null) {
        for (XFile xfile in selectedImages5) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage5.add(xfile);
            _imagePaths5.add(processedFile.path); // Use processed image path
            _imageFiles5.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker5.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage5.add(pickedImage);
            _imagePaths5.add(processedFile.path); // Use processed image path
            _imageFiles5.add(processedFile); // Add the processed file to the list
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
    return _imagePaths5.toString(); // Return the list of paths as a string
  }




  void setSchool(String? value) {
    _schoolValue = value;
    update();
  }

  void setTour(String? value) {
    _tourValue = value;
    update();
  }





  Widget bottomSheet(BuildContext context) {
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
                  await takePhoto(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet3(BuildContext context) {
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
                  await takePhoto3(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto3(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet4(BuildContext context) {
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
                  await takePhoto4(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto4(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet5(BuildContext context) {
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
                  await takePhoto5(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto5(ImageSource.gallery);
                  Get.back();
                },
                child: const Text('Gallery', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
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
              child: Image.file(File(imagePath), fit: BoxFit.contain),
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
              child: Image.file(File(imagePath2), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview3(String imagePath3, BuildContext context) {
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
              child: Image.file(File(imagePath3), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview4(String imagePath4, BuildContext context) {
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
              child: Image.file(File(imagePath4), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview5(String imagePath5, BuildContext context) {
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
              child: Image.file(File(imagePath5), fit: BoxFit.contain),
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
    libraryDescriptionController.clear();
    dateController.clear();
    dateController2.clear();
    _multipleImage.clear();
    _imagePaths.clear();
    _multipleImage2.clear();
    _imagePaths2.clear();
    update();
  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    _issueTrackerList = await LocalDbController().fetchLocalIssueTrackerRecords();
    _libIssueList = await LocalDbController().fetchLocalLibIssueRecords();
    _furnitureIssueList = await LocalDbController().fetchLocalFurnitureIssue();
    _playgroundIssueList = await LocalDbController().fetchLocalPlaygroundIssue();
    _digiLabIssueList = await LocalDbController().fetchLocalDigiLabIssue();
    _alexaIssueList = await LocalDbController().fetchLocalAlexaIssue();

    // _libIssueList = await LocalDbController().fetchLocalLibIssue();
    // _playIssueList = await LocalDbController().fetchLocalPlayIssue();
    isLoading = false;
    update();
  }



}

