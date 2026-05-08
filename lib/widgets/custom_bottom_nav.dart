import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int transactionCount;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.transactionCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey[600],
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: transactionCount > 0
              ? Badge(
                  label: Text('$transactionCount'),
                  child: const Icon(Icons.history),
                )
              : const Icon(Icons.history),
          label: 'History',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Parties',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.currency_rupee),
          label: 'Profit',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz),
          label: 'More',
        ),
      ],
    );
  }
}
