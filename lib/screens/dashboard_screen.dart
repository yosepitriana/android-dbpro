import 'package:flutter/material.dart';
import '../widgets/metric_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.dark_mode_outlined)),
                  const Expanded(child: Center(child: Text('DBpro', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)))),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                children: [
                  const _ServerStatus(),
                  const MetricCard(title: 'CPU Usage', value: '—', subtitle: 'Realtime'),
                  const MetricCard(title: 'Memory Usage', value: '—', subtitle: 'Realtime'),
                  const MetricCard(title: 'Disk Space', value: '—', subtitle: 'Realtime'),
                  const MetricCard(title: 'Network I/O', value: '—', subtitle: 'Realtime'),
                  const _Section(title: 'SERVICE & CONTAINER', child: Text('Menunggu data server…')),
                  const _Section(title: 'RIWAYAT GANGGUAN', child: Text('Belum ada data gangguan')),
                  TextButton(onPressed: () {}, child: const Text('Keluar dari akun')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServerStatus extends StatelessWidget {
  const _ServerStatus();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Row(
      children: [
        const Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('DBpro Server', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
            Text('Menghubungkan…', style: TextStyle(fontSize: 12)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(30)),
          child: const Text('● LIVE', style: TextStyle(color: Color(0xFF16A34A), fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 18),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFE2E8F0)),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      const SizedBox(height: 14),
      child,
    ]),
  );
}
