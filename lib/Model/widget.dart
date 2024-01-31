import 'package:flutter/material.dart';

class CustomWidget extends StatelessWidget {
  final IconData icon;
  final String name;

  CustomWidget({required this.icon, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0,left: 20,right: 20),
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(
              name,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic
              ),
            ),
            Icon(
              icon,
              size: 20.0,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}