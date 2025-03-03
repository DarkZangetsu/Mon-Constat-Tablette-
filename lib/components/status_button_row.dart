import 'package:flutter/material.dart';
import '../constants/status_constants.dart';

class StatusButtonRow extends StatelessWidget {
  final String selectedStatus;
  final Function(String) onStatusChanged;

  const StatusButtonRow({
    Key? key,
    required this.selectedStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: StatusConstants.allStatuses.map((status) {
        return Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _buildStatusButton(status, StatusConstants.getStatusColor(status)),
        );
      }).toList(),
    );
  }

  Widget _buildStatusButton(String status, Color color) {
    bool isSelected = selectedStatus == status;

    return ElevatedButton(
      onPressed: () {
        onStatusChanged(status);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? color : color.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        status,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }
}