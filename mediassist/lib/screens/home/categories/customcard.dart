import 'package:flutter/material.dart';


class CustomCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const CustomCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: 16.0,
        bottom: 0.0,
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 24.0,
                bottom: 24.0,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                right: 16.0,
                bottom: 16.0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.black),
                    ),
                    onPressed: onButtonPressed,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
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

class CardListView extends StatelessWidget {
  const CardListView({super.key});

  @override
  Widget build(BuildContext context) {
    // List of data for cards
    final List<Map<String, dynamic>> cardData = [
      {
        'imagePath': 'assets/images/cardImages/1.jpeg',
        'title': 'Saved Data 1',
        'buttonText': 'View Data 1',
        'onPressed': () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const AppointmentsPage()),
          // );
        },
      },
      {
        'imagePath': 'assets/images/cardImages/2.jpg',
        'title': 'Saved Data 2',
        'buttonText': 'View Data 2',
        'onPressed': () {
          // Add navigation or functionality here
        },
      },
      {
        'imagePath': 'assets/images/cardImages/3.jpeg',
        'title': 'Saved Data 3',
        'buttonText': 'View Data 3',
        'onPressed': () {
          // Add navigation or functionality here
        },
      },
      // Add more card data as needed
    ];

    return Scaffold(
      
      body: ListView.builder(
        itemCount: cardData.length,
        itemBuilder: (context, index) {
          final data = cardData[index];
          return CustomCard(
            imagePath: data['imagePath'],
            title: data['title'],
            buttonText: data['buttonText'],
            onButtonPressed: data['onPressed'],
          );
        },
      ),
    );
  }
}
