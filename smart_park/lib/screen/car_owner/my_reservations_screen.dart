import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/reservation_controller.dart';
import '../../models/reservation_model.dart';

class MyReservationsScreen extends StatelessWidget {
  MyReservationsScreen({super.key});

  final ReservationController controller = Get.put(ReservationController());

  final Color accentColor = const Color(0xFF2EC4B6);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.greenAccent;
      case 'pending':
        return Colors.orangeAccent;
      case 'rejected':
        return Colors.redAccent;
      case 'cancelled':
        return Colors.grey;
      case 'completed':
        return Colors.blueAccent;
      default:
        return Colors.white70;
    }
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.tr,
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _reservationCard(
      BuildContext context,
      ReservationModel item, {
        bool showCancel = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.garageName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _statusBadge(item.status),
            ],
          ),

          const SizedBox(height: 12),

          if (item.garageLocation != null &&
              item.garageLocation!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _infoRow(
                Icons.location_on_outlined,
                item.garageLocation!,
              ),
            ),

          _infoRow(
            Icons.calendar_month_outlined,
            item.reservationDate,
          ),
          const SizedBox(height: 8),

          _infoRow(
            Icons.access_time,
            "${item.startTime} - ${item.endTime}",
          ),
          const SizedBox(height: 8),

          _infoRow(
            Icons.local_parking_outlined,
            "${'number_of_spots'.tr}: ${item.numberOfSpots}",
          ),
          const SizedBox(height: 8),

          _infoRow(
            Icons.monetization_on_outlined,
            "${'total_cost'.tr}: ${item.totalCost ?? 0}",
          ),

          /// 🔸 Cancel Reason
          if (item.cancelReason != null &&
              item.cancelReason!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              "${'cancel_reason'.tr}: ${item.cancelReason}",
              style: const TextStyle(color: Colors.redAccent),
            ),
          ],

          /// 🔸 Owner Note
          if (item.ownerResponseNote != null &&
              item.ownerResponseNote!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              "${'owner_note'.tr}: ${item.ownerResponseNote}",
              style: const TextStyle(color: Colors.white70),
            ),
          ],

          /// 🔻 Cancel Button
          if (showCancel &&
              (item.status == 'pending' ||
                  item.status == 'accepted')) ...[
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Get.defaultDialog(
                    backgroundColor: const Color(0xFF203A43),
                    title: 'cancel_reservation'.tr,
                    titleStyle: const TextStyle(color: Colors.white),
                    content: Column(
                      children: [
                        TextField(
                          controller:
                          controller.cancelReasonController,
                          style: const TextStyle(color: Colors.white),
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText:
                            'enter_cancel_reason_optional'.tr,
                            hintStyle:
                            const TextStyle(color: Colors.white54),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.2)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    textCancel: 'close'.tr,
                    textConfirm: 'confirm'.tr,
                    confirmTextColor: Colors.white,
                    onConfirm: () async {
                      Get.back();
                      await controller
                          .cancelReservation(item.id);
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'cancel_reservation'.tr,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _emptyState(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchUpcomingReservations();
    controller.fetchPreviousReservations();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            'my_reservations'.tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),

        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F2027),
                Color(0xFF203A43),
                Color(0xFF2C5364),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                TabBar(
                  indicatorColor: accentColor,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(text: 'upcoming'.tr),
                    Tab(text: 'previous'.tr),
                  ],
                ),

                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    return TabBarView(
                      children: [
                        controller.upcomingReservations.isEmpty
                            ? _emptyState(
                            'no_upcoming_reservations'.tr)
                            : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller
                              .upcomingReservations.length,
                          itemBuilder: (context, index) {
                            final item = controller
                                .upcomingReservations[index];
                            return _reservationCard(
                              context,
                              item,
                              showCancel: true,
                            );
                          },
                        ),

                        controller.previousReservations.isEmpty
                            ? _emptyState(
                            'no_previous_reservations'.tr)
                            : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller
                              .previousReservations.length,
                          itemBuilder: (context, index) {
                            final item = controller
                                .previousReservations[index];
                            return _reservationCard(
                                context, item);
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}