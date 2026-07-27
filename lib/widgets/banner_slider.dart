import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int currentIndex = 0;

  final List<Map<String, dynamic>> banners = [
    {
      "title": "Engine Oil",
      "subtitle": "Best Quality Oil Available",
      "icon": Icons.oil_barrel,
      "color": Colors.red,
    },
    {
      "title": "Battery",
      "subtitle": "Amaron & Exide Batteries",
      "icon": Icons.battery_charging_full,
      "color": Colors.green,
    },
    {
      "title": "Brake Parts",
      "subtitle": "Safe Ride, Better Brake",
      "icon": Icons.car_repair,
      "color": Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: banners.length,
          options: CarouselOptions(
            height: 170,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.95,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = banners[index];

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: banner["color"],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            banner["title"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            banner["subtitle"],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      banner["icon"],
                      color: Colors.white,
                      size: 70,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: currentIndex == index ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    currentIndex == index ? Colors.green : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
