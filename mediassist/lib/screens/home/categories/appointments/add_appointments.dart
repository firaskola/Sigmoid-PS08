import 'package:flutter/material.dart';

class AddAppointments extends StatefulWidget {
  const AddAppointments({super.key});

  @override
  _AddAppointmentsState createState() => _AddAppointmentsState();
}

class _AddAppointmentsState extends State<AddAppointments> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('add appointments'),
    );
  }
}
