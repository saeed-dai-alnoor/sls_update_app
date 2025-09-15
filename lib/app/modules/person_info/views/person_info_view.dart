import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/person_info_controller.dart';

class PersonInfoView extends GetView<PersonInfoController> {
  const PersonInfoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5e4eaf),
        elevation: 0,
        // toolbarHeight: 0, // No top bar
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),
            SizedBox(height: 20),
            Text(
              "Your info",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _infoTile(Icons.email, controller.email.value),
            _infoTile(Icons.phone, controller.phone.value),
            _infoTile(Icons.business, controller.department.value),
            _infoTile(Icons.work_off, "Remote Work Not Allowed"),
            _infoTile(Icons.public, controller.org.value),
            _infoTile(Icons.access_time, controller.workHours.value),
            Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Logout action
                },
                icon: Icon(Icons.logout, color: Colors.red),
                label: Text("Logout", style: TextStyle(color: Colors.red)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            controller.name.value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            controller.title.value,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(text, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
