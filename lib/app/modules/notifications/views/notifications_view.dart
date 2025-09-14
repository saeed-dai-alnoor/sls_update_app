import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {},
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                'Clear all',
                style: TextStyle(fontSize: 18, color: Color(0xFF76a5c3)),
              ),
            ),
          ),
          Card(margin: const EdgeInsets.all(50.0)),
        ],
      ),
    );
  }
}
