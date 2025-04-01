import 'dart:convert';
import 'dart:io';

import '../constants/app_constants.dart';

class JsonHelper {
  const JsonHelper._internal();

  static Future<Map<String, dynamic>> readJson() async {
    try {
      File file = File(AppConstants.jsonFilePath);
      if (!await file.exists()) {
        throw ('There is no file in this path');
      }
      String jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    } catch (error) {
      print('There error form read Json is $error');
      throw ('There is no File here');
    }
  }

  static Future<void> writeJson(Map<String, dynamic> json) async {
    // Get the file path from constants
    File file = File(AppConstants.jsonFilePath);

    try {
      // Check if the file exists, create if it doesn't
      bool fileExists = await file.exists();
      if (!fileExists) {
        print('File does not exist. Creating file...');
        await file.create(recursive: true); // Create the file and necessary directories
      }

      // Encode the JSON data
      String jsonString = jsonEncode(json);

      // Write the JSON string to the file
      await file.writeAsString(jsonString, flush: true);
      print('Data written successfully to ${AppConstants.jsonFilePath}');
    } catch (error) {
      // Handle any error that occurs during the file operation
      print('Error writing JSON file: $error');
    }
  }
}
