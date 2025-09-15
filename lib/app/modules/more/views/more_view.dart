import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/more_controller.dart';

class MoreView extends GetView<MoreController> {
  const MoreView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5e4eaf),
        title: Text(
          'more'.tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.person_outline, size: 28, color: Colors.white),

          onPressed: () {
            Get.toNamed('/person-info');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              size: 28,
              color: Colors.white,
            ),
            onPressed: () {
              Get.toNamed('/notifications');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Options List
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              // vertical: 32.0,
            ),
            decoration: BoxDecoration(
              // color: Colors.grey,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                _buildListTile(
                  'theme'.tr,
                  Icons.color_lens_outlined,
                  onTap: () {
                    Get.toNamed('/theme');
                  },
                ),
                _buildListTile(
                  'language'.tr,
                  Icons.language_outlined,
                  onTap: () {
                    Get.toNamed('/language');
                  },
                ),
                _buildListTile(
                  'terms'.tr,
                  Icons.description_outlined,
                  onTap: () {
                    // Handle terms & conditions
                  },
                ),
                _buildListTile(
                  'privacy'.tr,
                  Icons.privacy_tip_outlined,
                  onTap: () {
                    // Handle privacy policy
                  },
                ),
                const Divider(height: 32),
                _buildListTile(
                  'logout'.tr,
                  Icons.logout,

                  onTap: () {
                    // Handle logout
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('v2.0.8', style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                const Text(
                  'تُعَكُمْ لِلَّنَّة نَسَات',
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tamkeen Technologies',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    String title,
    IconData icon, {
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      leading: Icon(icon),
      title: Text(title, style: TextStyle(color: isLogout ? Colors.red : null)),
      trailing: const Icon(Icons.chevron_right, size: 32),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
    );
  }
}
