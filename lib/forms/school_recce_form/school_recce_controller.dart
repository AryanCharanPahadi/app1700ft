
import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';

import 'package:app17000ft_new/forms/school_recce_form/school_recce_modal.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_client/baseClient_controller.dart';
class SchoolRecceController extends GetxController with BaseController{

  String? _tourValue;
  String? get tourValue => _tourValue;

  //school Value
  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  List<String> splitSchoolLists = [];



  final TextEditingController remarksController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController nameOfHoiController = TextEditingController();
  final TextEditingController hoiPhoneNumberController = TextEditingController();
  final TextEditingController hoiEmailController = TextEditingController();
  final TextEditingController totalTeachingStaffController = TextEditingController();
  final TextEditingController totalNonTeachingStaffController = TextEditingController();
  final TextEditingController totalStaffController = TextEditingController();
  final TextEditingController nameOfSmcController = TextEditingController();
  final TextEditingController smcPhoneNumberController = TextEditingController();
  final TextEditingController totalnoOfSmcMemController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noClassroomsController = TextEditingController();
  final TextEditingController measurnment1Controller = TextEditingController();
  final TextEditingController measurnment2Controller = TextEditingController();
  final TextEditingController specifyOtherController = TextEditingController();
  final TextEditingController supportingNgoController = TextEditingController();
  final TextEditingController keyPointsController = TextEditingController();
  final TextEditingController QualSpecifyController = TextEditingController();
  final TextEditingController freSpecifyController = TextEditingController();


  // Start of show Details
  bool showBasicDetails = true; // For show Basic Details
  bool showStaffDetails = false; // For show showStaffDetails
  bool showSmcVecDetails = false; // For show showStaffDetails
  bool showSchoolInfra = false; // For show showStaffDetails
  bool showSchoolStrngth = false; // For show showStaffDetails
  bool showGrade1 = false; // For show showStaffDetails
  bool showGrade2 = false; // For show showStaffDetails
  bool showGrade3 = false; // For show showStaffDetails
  bool showOtherInfo = false; // For show showStaffDetails
  // End of show Details
  void updateTotalStaff() {
    final totalTeachingStaff =
        int.tryParse(totalTeachingStaffController.text) ?? 0;
    final totalNonTeachingStaff =
        int.tryParse(totalNonTeachingStaffController.text) ?? 0;
    final totalStaff = totalTeachingStaff + totalNonTeachingStaff;

    totalStaffController.text = totalStaff.toString();
  }

  @override
  void dispose() {
   totalTeachingStaffController.dispose();
    totalNonTeachingStaffController.dispose();
    totalStaffController.dispose();
    super.dispose();
  }

  String? selectedYear;
  String? selectedDesignation;
  String? selectedQualification;
  String? selectedMeetings;


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

  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  bool checkboxValue5 = false;
  bool checkboxValue6 = false;
  bool checkboxValue7 = false;
  bool checkboxValue8 = false;
  bool checkboxValue9 = false;
  bool checkboxValue10 = false;
  bool checkboxValue11 = false;
  bool checkboxValue12 = false;
  bool checkboxValue13 = false;
  bool checkboxValue14 = false;
  bool checkboxValue15 = false;
  bool checkboxValue16 = false;
  bool checkboxValue17 = false;
  bool checkboxValue18 = false;
  bool checkboxValue19 = false;
  bool checkboxValue20 = false;
  bool checkboxValue21 = false;
  bool checkboxValue22 = false;
  bool checkboxValue23 = false;
  bool checkboxValue24 = false;
  bool checkboxValue25 = false;

  bool checkBoxError = false; //for checkbox error
  bool checkBoxError2 = false; //for checkbox error
  bool checkBoxError3 = false; //for checkbox error
  bool checkBoxError4 = false; //for checkbox error

  // For the image
  bool validateSchoolBoard = false; // for the nursery timetable
  final bool isImageUploadedSchoolBoard = false; // for the nursery timetable


  bool validateSchoolBuilding = false; // for the LKG timetable
  final bool isImageUploadedSchoolBuilding = false; // for the LKG timetable


  bool validateTeacherRegister = false; // for the LKG timetable
  final bool isImageUploadedTeacherRegister = false; // for the LKG timetable

  bool validateSmartClass = false; // for the LKG timetable
  final bool isImageUploadedSmartClass = false; // for the LKG timetable

  bool validateProjector = false; // for the LKG timetable
  final bool isImageUploadedProjector = false; // for the LKG timetable

  bool validateComputer = false; // for the LKG timetable
  final bool isImageUploadedComputer = false; // for the LKG timetable

  bool validateExisitingLibrary = false; // for the LKG timetable
  final bool isImageUploadedExisitingLibrary = false; // for the LKG timetable

  bool validateAvailabaleSpace = false; // for the LKG timetable
  final bool isImageUploadedAvailabaleSpace = false; // for the LKG timetable

  bool validateEnrollement = false; // for the LKG timetable
  final bool isImageUploadedEnrollement = false; // for the LKG timetable

  bool validateDlInstallation = false; // for the LKG timetable
  final bool isImageUploadedDlInstallation = false; // for the LKG timetable


   bool validateLibrarySetup = false; // for the LKG timetable
  final bool isImageUploadedLibrarySetup = false; // for the LKG timetable


  //Focus nodes
  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get  tourIdFocusNode => _tourIdFocusNode;
  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get  schoolFocusNode => _schoolFocusNode;

  List<SchoolRecceModal> _schoolRecceList =[];
  List<SchoolRecceModal> get schoolRecceList => _schoolRecceList;

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


  final List<XFile> _multipleImage6 = [];
  List<XFile> get multipleImage6 => _multipleImage6;
  List<String> _imagePaths6 = [];
  List<String> get imagePaths6 => _imagePaths6;
  List<File> _imageFiles6 = [];
  List<File> get imageFiles6 => _imageFiles6;



  final List<XFile> _multipleImage7 = [];
  List<XFile> get multipleImage7 => _multipleImage7;
  List<String> _imagePaths7 = [];
  List<String> get imagePaths7 => _imagePaths7;
  List<File> _imageFiles7 = [];
  List<File> get imageFiles7 => _imageFiles7;

  final List<XFile> _multipleImage8 = [];
  List<XFile> get multipleImage8 => _multipleImage8;
  List<String> _imagePaths8 = [];
  List<String> get imagePaths8 => _imagePaths8;
  List<File> _imageFiles8 = [];
  List<File> get imageFiles8 => _imageFiles8;


  final List<XFile> _multipleImage9 = [];
  List<XFile> get multipleImage9 => _multipleImage9;
  List<String> _imagePaths9 = [];
  List<String> get imagePaths9 => _imagePaths9;
  List<File> _imageFiles9 = [];
  List<File> get imageFiles9 => _imageFiles9;


  final List<XFile> _multipleImage10 = [];
  List<XFile> get multipleImage10 => _multipleImage10;
  List<String> _imagePaths10 = [];
  List<String> get imagePaths10 => _imagePaths10;
  List<File> _imageFiles10 = [];
  List<File> get imageFiles10 => _imageFiles10;



  final List<XFile> _multipleImage11 = [];
  List<XFile> get multipleImage11 => _multipleImage11;
  List<String> _imagePaths11 = [];
  List<String> get imagePaths11 => _imagePaths11;
  List<File> _imageFiles11 = [];
  List<File> get imageFiles11 => _imageFiles11;



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

  Future<String> takePhoto6(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker6 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages6 =
      await picker6.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages6 != null) {
        for (XFile xfile in selectedImages6) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage6.add(xfile);
            _imagePaths6.add(processedFile.path); // Use processed image path
            _imageFiles6.add(
                processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker6.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage6.add(pickedImage);
            _imagePaths6.add(processedFile.path); // Use processed image path
            _imageFiles6.add(
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
    return _imagePaths6.toString(); // Return the list of paths as a string
  }

  Future<String> takePhoto7(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker7 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages7 =
      await picker7.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages7 != null) {
        for (XFile xfile in selectedImages7) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage7.add(xfile);
            _imagePaths7.add(processedFile.path); // Use processed image path
            _imageFiles7.add(
                processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker7.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage7.add(pickedImage);
            _imagePaths7.add(processedFile.path); // Use processed image path
            _imageFiles7.add(
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
    return _imagePaths7.toString(); // Return the list of paths as a string
  }


  Future<String> takePhoto8(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker8 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages8 =
      await picker8.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages8 != null) {
        for (XFile xfile in selectedImages8) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage8.add(xfile);
            _imagePaths8.add(processedFile.path); // Use processed image path
            _imageFiles8.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker8.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage8.add(pickedImage);
            _imagePaths8.add(processedFile.path); // Use processed image path
            _imageFiles8.add(processedFile); // Add the processed file to the list
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
    return _imagePaths8.toString(); // Return the list of paths as a string
  }


  Future<String> takePhoto9(ImageSource source, {int imageQuality = 75}) async {
    final ImagePicker picker9 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages9 =
      await picker9.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages9 != null) {
        for (XFile xfile in selectedImages9) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage9.add(xfile);
            _imagePaths9.add(processedFile.path); // Use processed image path
            _imageFiles9.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker9.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage9.add(pickedImage);
            _imagePaths9.add(processedFile.path); // Use processed image path
            _imageFiles9.add(processedFile); // Add the processed file to the list
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
    return _imagePaths9.toString(); // Return the list of paths as a string
  }

  Future<String> takePhoto10(ImageSource source, {int imageQuality = 70}) async {
    final ImagePicker picker10 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages10 =
      await picker10.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages10 != null) {
        for (XFile xfile in selectedImages10) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage10.add(xfile);
            _imagePaths10.add(processedFile.path); // Use processed image path
            _imageFiles10.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker10.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage10.add(pickedImage);
            _imagePaths10.add(processedFile.path); // Use processed image path
            _imageFiles10.add(processedFile); // Add the processed file to the list
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
    return _imagePaths10.toString(); // Return the list of paths as a string
  }


  Future<String> takePhoto11(ImageSource source, {int imageQuality = 70}) async {
    final ImagePicker picker11 = ImagePicker();

    if (source == ImageSource.gallery) {
      // Pick multiple images from the gallery
      final List<XFile>? selectedImages11 =
      await picker11.pickMultiImage(imageQuality: imageQuality);
      if (selectedImages11 != null) {
        for (XFile xfile in selectedImages11) {
          final File file = File(xfile.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage11.add(xfile);
            _imagePaths11.add(processedFile.path); // Use processed image path
            _imageFiles11.add(processedFile); // Add the processed file to the list
          }
        }
      }
    } else if (source == ImageSource.camera) {
      // Let the user take multiple images from the camera
      bool isTakingPictures = true;

      while (isTakingPictures) {
        final XFile? pickedImage =
        await picker11.pickImage(source: source, imageQuality: imageQuality);
        if (pickedImage != null) {
          final File file = File(pickedImage.path);
          final processedFile = await processImage(file); // Process the image
          if (processedFile != null) {
            _multipleImage11.add(pickedImage);
            _imagePaths11.add(processedFile.path); // Use processed image path
            _imageFiles11.add(processedFile); // Add the processed file to the list
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
    return _imagePaths11.toString(); // Return the list of paths as a string
  }


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

  // Convert a File to Base64 String
  // Convert a File to Base64 String
  Future<String> convertImagesToBase64_6() async {
    List<String> base64Images6 = [];

    for (var imageFile in _imageFiles6) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images6.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images6
        .join(','); // Return the combined Base64 strings with ',' as separator
  }

  // Convert a File to Base64 String
  // Convert a File to Base64 String
  Future<String> convertImagesToBase64_7() async {
    List<String> base64Images7 = [];

    for (var imageFile in _imageFiles7) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images7.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images7
        .join(','); // Return the combined Base64 strings with ',' as separator
  }

  Future<String> convertImagesToBase64_8() async {
    List<String> base64Images8 = [];

    for (var imageFile in _imageFiles8) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images8.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images8
        .join(','); // Return the combined Base64 strings with ',' as separator
  }


  Future<String> convertImagesToBase64_9() async {
    List<String> base64Images9 = [];

    for (var imageFile in _imageFiles9) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images9.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images9
        .join(','); // Return the combined Base64 strings with ',' as separator
  }

  Future<String> convertImagesToBase64_10() async {
    List<String> base64Images10 = [];

    for (var imageFile in _imageFiles10) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images10.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images10
        .join(','); // Return the combined Base64 strings with ',' as separator
  }


  Future<String> convertImagesToBase64_11() async {
    List<String> base64Images11 = [];

    for (var imageFile in _imageFiles11) {
      if (await imageFile.exists()) {
        // Check if the file exists
        final bytes = await imageFile.readAsBytes(); // Read the file as bytes
        final base64String = base64Encode(bytes); // Encode the bytes to Base64

        // Ensure the Base64 string is valid and properly padded
        if (base64String.isNotEmpty) {
          // Add padding if necessary
          final paddedBase64String = _addPadding(base64String);

          // Add to the list with a comma as the separator
          base64Images11.add(paddedBase64String);
        }
      } else {
        print("File ${imageFile.path} does not exist.");
      }
    }

    // Join all Base64 strings with a comma as the separator
    return base64Images11
        .join(','); // Return the combined Base64 strings with ',' as separator
  }

  setSchool(value)
  {
    _schoolValue = value;
    // update();
  }

  setTour(value){
    _tourValue = value;
    // update();

  }
  Widget bottomSheet(BuildContext context) {
    String? imagePicked;
    PickedFile? imageFile;
    final ImagePicker picker = ImagePicker();
    XFile? image;
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
              // ignore: deprecated_member_use
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(ImageSource.camera);

                  // uploadFile(userdata.read('customerID'));
                  Get.back();
                  //  update();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(
                      fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),

            ],
          )
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


  Widget bottomSheet6(BuildContext context) {
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
                  await takePhoto6(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto6(ImageSource.gallery);
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


  Widget bottomSheet7(BuildContext context) {
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
                  await takePhoto7(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto7(ImageSource.gallery);
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


  Widget bottomSheet8(BuildContext context) {
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
                  await takePhoto8(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto8(ImageSource.gallery);
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

  Widget bottomSheet9(BuildContext context) {
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
                  await takePhoto9(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto9(ImageSource.gallery);
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

  Widget bottomSheet10(BuildContext context) {
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
                  await takePhoto10(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto10(ImageSource.gallery);
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

  Widget bottomSheet11(BuildContext context) {
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
                  await takePhoto11(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto11(ImageSource.gallery);
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


  void showImagePreview6(String imagePath6, BuildContext context) {
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
              child: Image.file(File(imagePath6), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview7(String imagePath7, BuildContext context) {
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
              child: Image.file(File(imagePath7), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview8(String imagePath8, BuildContext context) {
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
              child: Image.file(File(imagePath8), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }


  void showImagePreview9(String imagePath9, BuildContext context) {
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
              child: Image.file(File(imagePath9), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview10(String imagePath10, BuildContext context) {
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
              child: Image.file(File(imagePath10), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  void showImagePreview11(String imagePath11, BuildContext context) {
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
              child: Image.file(File(imagePath11), fit: BoxFit.contain),
            ),
          ),
        );
      },
    );
  }

  //Clear fields
  void clearFields() {

    correctUdiseCodeController.clear();
    remarksController.clear();
    nameOfHoiController.clear();
    hoiPhoneNumberController.clear();
    hoiEmailController.clear();
    totalTeachingStaffController.clear();
    totalNonTeachingStaffController.clear();
    totalStaffController.clear();
    nameOfSmcController.clear();
    smcPhoneNumberController.clear();
    totalnoOfSmcMemController.clear();
    descriptionController.clear();
    noClassroomsController.clear();
    measurnment1Controller.clear();
    measurnment2Controller.clear();
    specifyOtherController.clear();
    supportingNgoController.clear();
    keyPointsController.clear();
    freSpecifyController.clear();
    QualSpecifyController.clear();





    update();
  }

  fetchData() async {
    isLoading = true;

    _schoolRecceList = [];
    _schoolRecceList = await LocalDbController().fetchLocalSchoolRecceModal();

    update();
  }

//

//Update the UI


}