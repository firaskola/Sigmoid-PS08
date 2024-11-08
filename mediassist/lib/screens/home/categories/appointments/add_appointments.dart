import 'package:flutter/material.dart';

class AddAppointments extends StatefulWidget {
  const AddAppointments({Key? key}) : super(key: key);

  @override
  _AddAppointmentsState createState() => _AddAppointmentsState();
}

class _AddAppointmentsState extends State<AddAppointments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('add appointments'),
    );
  }
}
