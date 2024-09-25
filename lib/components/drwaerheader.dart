import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/home/home_controller.dart';

class DrawerHeaderProfile extends StatelessWidget {
  const DrawerHeaderProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Container(
      color: AppColors.background,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Profile Picture
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.background,
                image: DecorationImage(
                  image: AssetImage('assets/check.png'),
                ),
              ),
              width: 80.0,
              height: 80.0,
            ),
            const SizedBox(height: 10),
            // Username (Updated dynamically using GetX)
            Obx(() => Text(
              homeController.username ?? 'Guest',
              style: const TextStyle(
                color: AppColors.onBackground,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )),
          ],
        ),
      ),
    );
  }
}
