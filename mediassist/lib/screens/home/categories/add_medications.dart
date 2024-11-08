import 'package:flutter/material.dart';

class AddMedicationsPage extends StatefulWidget {
  const AddMedicationsPage({super.key});

  @override
  _AddMedicationsPageState createState() => _AddMedicationsPageState();
}

class _AddMedicationsPageState extends State<AddMedicationsPage> {
  final List<TextEditingController> medicineControllers = [
    TextEditingController(),
  ]; // Starts with one controller for Medicine 1
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    // Dispose of all controllers
    for (var controller in medicineControllers) {
      controller.dispose();
    }
    nameController.dispose();
    ageController.dispose();
    doctorController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void addMedicineField() {
    if (medicineControllers.length < 5) {
      setState(() {
        medicineControllers.add(TextEditingController());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Patient",
          style: TextStyle(
            color: Colors.white, // primaryColorLight
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorLight,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.84),
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black.withOpacity(0.84),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.84),
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.84),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: doctorController,
                decoration: InputDecoration(
                  labelText: 'Doctor Consulted',
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.84),
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                style: TextStyle(
                  color: Colors.black.withOpacity(0.84),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.84),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Medicines:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Column(
                children: [
                  for (int i = 0; i < medicineControllers.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: medicineControllers[i],
                        decoration: InputDecoration(
                          labelText: 'Medicine ${i + 1}',
                          labelStyle: TextStyle(
                            color: Colors.black.withOpacity(0.84),
                            fontWeight: FontWeight.bold,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (medicineControllers.length < 5)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: addMedicineField,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  // Handle button press action here (e.g., print or validate)
                  print("Patient data ready for submission");
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
