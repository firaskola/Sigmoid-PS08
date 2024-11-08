import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mediassist/ngrokurl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _isLoading = false;
  List<Map<String, String>> _reports = [];

  // Method to fetch the list of reports
  Future<void> fetchReports() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie =
          prefs.getString('session'); // Get session from shared preferences

      if (sessionCookie == null) {
        // If session is expired, prompt user to login again
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
        return;
      }

      var response = await http.get(
        Uri.parse(
            '${ConfigUrl.baseUrl}/get_reports'), // Replace with actual server URL
        headers: {'cookie': sessionCookie ?? ''},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _reports = data
              .map((report) => {
                    'id': report['id'].toString(),
                    'report_name': report['report_name'].toString(),
                    'report_image': report['report_image'].toString(),
                  })
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch reports.')),
        );
      }
    } catch (e) {
      print('Error fetching reports: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while fetching reports.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Method to delete a report
  Future<void> deleteReport(String reportId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionCookie =
          prefs.getString('session'); // Get session from shared preferences

      if (sessionCookie == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session expired. Please login again.')),
        );
        return;
      }

      var response = await http.delete(
        Uri.parse(
            '${ConfigUrl.baseUrl}/delete_report/$reportId'), // Replace with actual URL
        headers: {'cookie': sessionCookie ?? ''},
      );

      if (response.statusCode == 200) {
        setState(() {
          _reports.removeWhere(
              (report) => report['id'] == reportId); // Remove report from list
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report deleted successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete report.')),
        );
      }
    } catch (e) {
      print('Error deleting report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while deleting the report.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReports(); // Fetch reports when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reports'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reports.isEmpty
              ? const Center(child: Text('No reports available.'))
              : ListView.builder(
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return ListTile(
                      title: Text(report['report_name'] ?? 'No Name'),
                      leading: report['report_image']?.isNotEmpty ?? false
                          ? GestureDetector(
                              onTap: () {
                                // Navigate to full-screen view when tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImageScreen(
                                      imageUrl: report['report_image']!,
                                    ),
                                  ),
                                );
                              },
                              child: Image.network(
                                report['report_image']!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.image),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Confirm before deleting the report
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this report?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      deleteReport(report['id'] ?? '');
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class FullScreenImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Screen Image'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the full-screen view on tap
          },
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}
