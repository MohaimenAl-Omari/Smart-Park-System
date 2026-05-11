import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_park/controller/find_garages_controller.dart';

import 'make_reservation_screen.dart';

class FindGaragesScreen extends StatelessWidget {
  FindGaragesScreen({super.key});

  final FindGaragesController controller = Get.put(FindGaragesController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1F45),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'find_garages'.tr,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
            decoration: const BoxDecoration(
              color: Color(0xFF0B1F45),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: controller.searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'search_garages'.tr,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.10),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedCity.value,
                        dropdownColor: const Color(0xFF203A43),
                        iconEnabledColor: Colors.white,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.white),
                        items: controller.cities.map((city) {
                          return DropdownMenuItem<String>(
                            value: city,
                            child: Text(
                              city == 'all' ? 'all_cities'.tr : city,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedCity.value = value;
                            controller.applyFilters();
                          }
                        },
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredGarages.isEmpty) {
                return Center(
                  child: Text(
                    'no_garages_found'.tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchGarages,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredGarages.length,
                  itemBuilder: (context, index) {
                    final garage = controller.filteredGarages[index];
                    final availableSpots = garage['available_spots'] ?? 0;
                    final pricePerHour = garage['price_per_hour'] ?? 0;
                    final garageName =
                        garage['name']?.toString() ?? 'garage'.tr;
                    final location = garage['location']?.toString() ?? '';
                    final city = garage['city']?.toString() ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.14),
                            Colors.white.withOpacity(0.06),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2EC4B6).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.local_parking_rounded,
                                    color: Color(0xFF2EC4B6),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    garageName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                // ❤️ Favorite Icon
                                Obx(() {
                                  final isFav = controller.isFavorite(garage['id']);
                                  return IconButton(
                                    onPressed: () {
                                      controller.toggleFavorite(garage['id']);
                                    },
                                    icon: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? Colors.redAccent : Colors.white,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 14),
                            if (location.isNotEmpty)
                              _infoRow(Icons.location_on_outlined, location),
                            if (city.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: _infoRow(
                                  Icons.location_city_outlined,
                                  "${'city'.tr}: $city",
                                ),
                              ),
                            const SizedBox(height: 10),
                            _infoRow(
                              Icons.local_parking_outlined,
                              "${'available_spots'.tr}: $availableSpots",
                            ),
                            const SizedBox(height: 8),
                            _infoRow(
                              Icons.attach_money_outlined,
                              "${'price_per_hour'.tr}: $pricePerHour",
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: availableSpots > 0
                                    ? () async {
                                  await Get.to(() => MakeReservationScreen(
                                    garageId: garage['id'],
                                    garageName: garageName,
                                  ));
                                  await controller.refreshAfterReservation();
                                }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFC107),
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: Colors.grey.shade500,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  availableSpots > 0
                                      ? 'make_reservation'.tr
                                      : 'not_available'.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF2EC4B6), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}