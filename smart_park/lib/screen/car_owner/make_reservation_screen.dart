import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/reservation_controller.dart';

class MakeReservationScreen extends StatelessWidget {
  final int garageId;
  final String garageName;

  MakeReservationScreen({
    super.key,
    required this.garageId,
    required this.garageName,
  });

  final ReservationController controller = Get.put(ReservationController());

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController textController,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: textController,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label.tr,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F45),
        foregroundColor: Colors.white,
        title: Text('make_reservation'.tr),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1F45),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    garageName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'fill_reservation_information'.tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField(
              label: 'reservation_date',
              icon: Icons.calendar_today_outlined,
              textController: controller.reservationDateController,
              readOnly: true,
              onTap: () => controller.pickReservationDate(context),
            ),
            const SizedBox(height: 14),

            _buildTextField(
              label: 'start_time',
              icon: Icons.access_time,
              textController: controller.startTimeController,
              readOnly: true,
              onTap: () =>
                  controller.pickTime(context, controller.startTimeController),
            ),
            const SizedBox(height: 14),

            _buildTextField(
              label: 'end_time',
              icon: Icons.timelapse_outlined,
              textController: controller.endTimeController,
              readOnly: true,
              onTap: () =>
                  controller.pickTime(context, controller.endTimeController),
            ),
            const SizedBox(height: 14),

            _buildTextField(
              label: 'number_of_spots',
              icon: Icons.local_parking_outlined,
              textController: controller.numberOfSpotsController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () {
                    controller.createReservation(garageId: garageId);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isSubmitting.value
                      ? const CircularProgressIndicator()
                      : Text(
                    'confirm_reservation'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}