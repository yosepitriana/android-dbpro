import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 246,
    margin: const EdgeInsets.only(top: 12),
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: Border.all(color: const Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [BoxShadow(blurRadius: 8, offset: Offset(0, 2), color: Color(0x140F172A))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 12),
        const LinearProgressIndicator(value: 0),
        const Expanded(child: Center(child: Text('Grafik monitoring'))),
      ],
    ),
  );
}
