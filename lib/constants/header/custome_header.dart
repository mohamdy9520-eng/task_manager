import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Monday", style: TextStyle(color: Colors.grey)),
          Text("25 October",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
      Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: const Icon(Icons.search),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150?img=3"),
          ),
        ],
      )
    ],
  );
}