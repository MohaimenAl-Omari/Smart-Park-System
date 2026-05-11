import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/OwnerReservationsController.dart';


class MyReservationScreen extends StatelessWidget {
  MyReservationScreen({super.key});

  final controller = Get.put(OwnerReservationsController());

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F45),
        foregroundColor: Colors.white,
        title: Text('my_reservations'.tr),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reservations.isEmpty) {
          return Center(
            child: Text(
              'no_reservations'.tr,
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reservations.length,
          itemBuilder: (context, index) {
            final item = controller.reservations[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.14),
                    Colors.white.withOpacity(0.06),
                  ],
                ),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Padding(
                padding: EdgeInsets.all(w * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 👤 User name
                    Text(
                      item['car_owner']?['name'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _infoRow(Icons.calendar_today, item['reservation_date']),
                    _infoRow(Icons.access_time,
                        "${item['start_time']} - ${item['end_time']}"),
                    _infoRow(Icons.local_parking,
                        "${'spots'.tr}: ${item['number_of_spots']}"),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Text(
                          '${'status'.tr}: ',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          item['status'],
                          style: TextStyle(
                            color: _statusColor(item['status']),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ✅ Accept / Reject buttons
                    if (item['status'] == 'pending')
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showDialog(
                                context,
                                item['id'],
                                'accepted',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              child: Text('accept'.tr),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _showDialog(
                                context,
                                item['id'],
                                'rejected',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text('reject'.tr),
                            ),
                          ),
                        ],
                      )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showDialog(BuildContext context, int id, String status) {
    final noteController = TextEditingController();

    Get.defaultDialog(
      title: status == 'accepted' ? 'accept'.tr : 'reject'.tr,
      content: Column(
        children: [
          TextField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: 'optional_note'.tr,
            ),
          ),
        ],
      ),
      textConfirm: 'confirm'.tr,
      textCancel: 'cancel'.tr,
      onConfirm: () {
        Get.back();
        controller.respond(id, status, noteController.text);
      },
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2EC4B6), size: 18),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}