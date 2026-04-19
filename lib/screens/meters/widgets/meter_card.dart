import 'package:flutter/material.dart';
import '../../../models/meter.dart';

class MeterCard extends StatelessWidget {
  final Meter meter;

  const MeterCard({super.key, required this.meter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: meter.type.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              meter.type.icon,
              color: meter.type.iconColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meter.type.displayName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Meter #${meter.number}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meter.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Last: ${meter.formattedReading}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (meter.isOverdue)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'OVERDUE',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (meter.isOverdue) const SizedBox(height: 4),
              Text(
                meter.dueText,
                style: TextStyle(
                  fontSize: 12,
                  color: meter.isOverdue ? Colors.red : Colors.grey,
                  fontWeight: meter.isOverdue ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined),
                color: const Color(0xFF1E3A8A),
                onPressed: () {
                  // TODO: Open camera for meter reading
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

