import 'package:flutter/material.dart';

class StatusConstants {
  static const String neuf = 'NEUF';
  static const String bonEtat = 'BON ÉTAT';
  static const String etatUsage = 'ÉTAT D\'USAGE';
  static const String degrade = 'DÉGRADÉ';

  static const List<String> allStatuses = [neuf, bonEtat, etatUsage, degrade];

  static Color getStatusColor(String status) {
    switch (status) {
      case neuf:
        return Colors.blue;
      case bonEtat:
        return Colors.green;
      case etatUsage:
        return Colors.orange;
      case degrade:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}