import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/data_manager.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 167, 247),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 80, 21, 90),
        title: _buildHeader(),
        centerTitle: true,
        toolbarHeight: 90,
      ),
      body: Consumer<DataManager>(
        builder: (context, dataManager, child) {
          final stats = {
            'Total': dataManager.allBooks.length,
            'Read': dataManager.readBooks.length,
            'To Read': dataManager.toReadBooks.length,
            'Favorites': dataManager.favoriteBooks.length,
          };

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Enjoy Your Learning Journey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Small Transparent Cards Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9, // ✅ More compact
                  children: stats.entries.map((entry) {
                    return _buildTransparentCard(
                      entry.key,
                      entry.value.toString(),
                    );
                  }).toList(),
                ),

                SizedBox(height: 20),

                // Progress in same style
                _buildTransparentProgressCard(
                  dataManager.allBooks.length,
                  dataManager.readBooks.length,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ✅ Small Transparent Card
  Widget _buildTransparentCard(String title, String value) {
    Color color = _getColorForTitle(title);
    IconData icon = _getIconForTitle(title);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // ✅ Transparent
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color), // ✅ Icon
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.8), // ✅ Light text
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Transparent Progress Card
  Widget _buildTransparentProgressCard(int total, int read) {
    double progress = total > 0 ? (read / total) * 100 : 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // ✅ Transparent
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, size: 20, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$read/$total',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '${progress.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColorForTitle(String title) {
    switch (title) {
      case 'Total':
        return Colors.white;
      case 'Read':
        return Colors.green;
      case 'To Read':
        return Colors.blue;
      case 'Favorites':
        return Colors.pink;
      default:
        return Colors.white;
    }
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Total':
        return Icons.library_books;
      case 'Read':
        return Icons.check_circle;
      case 'To Read':
        return Icons.bookmark;
      case 'Favorites':
        return Icons.favorite;
      default:
        return Icons.book;
    }
  }

  // ✅ SIMPLE HEADER
  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          '📊 Reading Stats',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your reading journey at a glance',
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
        ),
        SizedBox(height: 16),
        Divider(color: Colors.white.withOpacity(0.3), height: 1),
      ],
    );
  }
}
