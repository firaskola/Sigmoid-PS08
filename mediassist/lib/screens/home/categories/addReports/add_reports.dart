import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mediassist/ngrokurl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReports extends StatefulWidget {
  const AddReports({super.key});

  @override
  _AddReportsState createState() => _AddReportsState();
}

class _AddReportsState extends State<AddReports> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Method to upload the report
  Future<void> uploadReport(File imageFile, String reportName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Retrieve session cookie from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sessionCookie = prefs.getString('session'); // Get the session cookie

      if (sessionCookie == null) {
        // If the session cookie is not available, prompt the user to login
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
        return;
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ConfigUrl.baseUrl}/upload_report'),
      );
      request.headers['cookie'] = sessionCookie;

      // Attach the image file
      request.files.add(
          await http.MultipartFile.fromPath('report_image', imageFile.path));

      // Add report name in the form body
      request.fields['report_name'] = reportName;

      // Send the request
      var response = await request.send();
      if (response.statusCode == 201) {
        // Report uploaded successfully
        print('Report uploaded successfully');
      } else {
        print('Failed to upload report');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload report.')),
        );
      }
    } catch (e) {
      print('Error uploading report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred while uploading.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Method to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String reportName =
          'Sample Report'; // You can replace this with a user input field

      // Upload the image to the server
      uploadReport(File(pickedFile.path), reportName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Medical Reports')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Upload Report'),
                ),
                // You can uncomment this if you're displaying a list of reports
                // Expanded(
                //   child: ReportList(), // Display the list of reports here
                // ),
              ],
            ),
    );
  }
}
