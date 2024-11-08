import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:mediassist/screens/home/ad_section.dart';
import 'package:mediassist/screens/home/heart_rate.dart'; // Heart rate graph widget
import 'package:mediassist/screens/home/upcoming_appointments.dart'; // Upcoming appointments widget
import 'package:mediassist/screens/home/categories/categories.dart'; // Categories screen widget
import 'package:mediassist/nav_bar/bottom_navbar.dart';
import 'package:mediassist/screens/medications/medications_screen.dart';
import 'package:mediassist/screens/reports/reports_screen.dart';
import 'package:mediassist/profile/profileBody.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MedicationsScreen(),
    const ReportsScreen(),
    const ProfileBody(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigation(
        selectedPage: _selectedPage,
        onPageChanged: _onPageChanged,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<HealthDataPoint> heartRateData = [];
  bool isLoading = true;
  int totalSteps = 0;
  List<HealthDataPoint> stepData = [];

  @override
  void initState() {
    super.initState();
    fetchHealthData();
  }

  // Function to fetch health data (Heart Rate & Steps)
  Future<void> fetchHealthData() async {
    final HealthFactory health = HealthFactory();
    final types = [HealthDataType.HEART_RATE, HealthDataType.STEPS];

    // Request permissions
    bool permissionGranted = await health.requestAuthorization(types);
    if (!permissionGranted) {
      print("Authorization not granted");
      return;
    }

    // Define time range for data retrieval
    DateTime startDate = DateTime.now().subtract(Duration(days: 1));
    DateTime endDate = DateTime.now();

    // Fetch health data
    List<HealthDataPoint> data =
        await health.getHealthDataFromTypes(startDate, endDate, types);
    List<HealthDataPoint> heartRateDataPoints =
        data.where((e) => e.type == HealthDataType.HEART_RATE).toList();
    List<HealthDataPoint> stepDataPoints =
        data.where((e) => e.type == HealthDataType.STEPS).toList();

    setState(() {
      heartRateData = HealthFactory.removeDuplicates(heartRateDataPoints);
      stepData = stepDataPoints;
      totalSteps = stepDataPoints.fold(
        0,
        (previousValue, element) => previousValue + (element.value.toInt()),
      );
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.bell_fill),
          ),
          const SizedBox(width: 15),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Upcoming Appointments",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 210,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6, // Number of appointments you want to display
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: UpcomingAppointments(),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Text(
                "Getting Started",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // Row with Looking for Roommates and Steps Today
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Looking for Roommates card
                  Expanded(
                    child: LookingRoomatesCard(),
                  ),
                  const SizedBox(width: 16), // Space between the two widgets
                  // Step Counter in Square Container
                  if (!isLoading)
                    Container(
                      width: MediaQuery.sizeOf(context).width *
                          0.30, // Set the width of the square container
                      height: MediaQuery.sizeOf(context).width *
                          0.5, // Set the height of the square container
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary, // Background color
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Steps Today",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "$totalSteps", // Display the total steps
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Heart rate section
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Heart Rate Data",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            HeartRateGraph(heartRateData: heartRateData),

            // Upcoming Appointments
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Categories(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
