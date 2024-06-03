import 'package:debook/themes.dart';
import 'package:flutter/material.dart';

class RecentBook extends StatelessWidget {
  const RecentBook({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: borderColorRecentBook),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: semiBoldText14.copyWith(color: blackColor2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Image.asset(
            image,
            width: 90,
          ),
        ],
      ),
    );
  }
}
