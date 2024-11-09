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
  File? _imageFile;
  String _reportName = '';

  Future<void> uploadReport(File imageFile, String reportName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var sessionCookie = prefs.getString('session');

      if (sessionCookie == null) {
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

      request.files.add(
          await http.MultipartFile.fromPath('report_image', imageFile.path));
      request.fields['report_name'] = reportName;

      var response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report uploaded successfully')),
        );
        setState(() {
          _imageFile = null; // Reset after upload
          _reportName = '';
        });
      } else {
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

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _showReportNameDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Report Name'),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _reportName = value;
                });
              },
              decoration: const InputDecoration(hintText: "Report Name"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (_imageFile != null && _reportName.isNotEmpty) {
                  uploadReport(_imageFile!, _reportName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Please select an image and provide a report name.')),
                  );
                }
              },
              child: const Text('Upload'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _imageFile == null
                                ? const Text('No image selected',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _imageFile!,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width -
                                      32, // Set a fixed width for both buttons
                                  height:
                                      50, // Set a fixed height for both buttons
                                  child: ElevatedButton(
                                    onPressed: _pickImage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text('Pick an Image'),
                                  ),
                                ),
                                const SizedBox(
                                    height: 20), // Space between buttons
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width -
                                      32, // Same width as the first button
                                  height: 50, // Same height as the first button
                                  child: ElevatedButton(
                                    onPressed: _showReportNameDialog,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text('Enter Report Name'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
