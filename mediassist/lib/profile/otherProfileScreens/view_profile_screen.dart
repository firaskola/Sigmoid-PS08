import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  String? selectedGender;
  double verticalAgePosition = 16.0; // Adjust as needed
  double verticalGenderPosition = 19.0; // Adjust as needed
  double verticalDistance = 26.0; // Initial vertical distance
  bool hasGSTNumber = false;
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: const Color(0xFFB090DD),
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              // title: const Text(
              //   'SliverAppBar',
              //   style: TextStyle(color: Colors.white),
              // ),
              background: Stack(
                children: [
                  // Profile Picture
                  Positioned(
                    top: 70,
                    right: 130,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 75,
                        child: Icon(
                          Icons.person,
                          size: 75, // Adjust the size of the icon as needed
                          color: Colors
                              .white, // Adjust the color of the icon as needed
                        ),
                      ),
                    ),
                  ),
                  // Gradient Circle
                  Positioned(
                    right: 130,
                    top: 180,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3.0,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFB090DD),
                            Color(0xFF5151B7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Edit Button
                  Positioned(
                    right: 120,
                    top: 170,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () {
                        // Add onPressed logic for editing profile picture
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  color: const Color(0xFFB090DD),
                  height: 20,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Details
                      Text(
                        'Name',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Enter your name',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Age and Gender row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Age',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black.withOpacity(0.75),
                                    ),
                                  ),
                                  SizedBox(height: verticalAgePosition = 1),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Enter your age',
                                          border: InputBorder.none,
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 15, top: 0),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black.withOpacity(0.75),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  padding: const EdgeInsets.only(left: 16),
                                  margin: EdgeInsets.only(
                                      top: verticalGenderPosition = 0),
                                  child: Container(
                                    height: 49,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: DropdownButtonFormField<String>(
                                        value: selectedGender,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedGender = newValue;
                                          });
                                        },
                                        items: ['Male', 'Female']
                                            .map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Grey line below the first section
                      Container(
                        height: 2,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 5),
                      ),
                      // Start of the new section
                      // Call icon, Contact Details text, and another horizontal line
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.call,
                              size: 24,
                              color: Color(0xFF7F3CDE),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Contact Details',
                              style: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.75),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Horizontal line below "Contact Details"
                      Container(
                        height: 2,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 25),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    print(number.phoneNumber);
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },
                                  selectorConfig: const SelectorConfig(
                                    selectorType: PhoneInputSelectorType.DIALOG,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      const TextStyle(color: Colors.black),
                                  textStyle:
                                      const TextStyle(color: Colors.black),
                                  initialValue: PhoneNumber(isoCode: 'IN'),
                                  textFieldController: phoneNumberController,
                                  inputDecoration: const InputDecoration(
                                    labelText: 'Mobile Number',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              // Adjusted the width here
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 1),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Email ID',
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Checkbox(
                              value: hasGSTNumber,
                              onChanged: (bool? value) {
                                setState(() {
                                  hasGSTNumber = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              'I have GST Number',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      if (hasGSTNumber) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GSTIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter GSTIN',
                                      hintStyle: TextStyle(
                                          color:
                                              Colors.black.withOpacity(0.75)),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Registered Name',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter Registered Name',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.75),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'GST State',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black.withOpacity(0.75),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: 'Enter GST State',
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.75),
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Container(
                        height: 2,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your save changes logic here
                            },
                            style: ButtonStyle(
                              foregroundColor:
                                  WidgetStateProperty.all(Colors.transparent),
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.all(0)),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFB090DD),
                                    Color(0xFF5151B7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 88.0,
                                  minHeight: 46.0,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Save Changes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
