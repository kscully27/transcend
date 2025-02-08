import 'package:flutter/material.dart';
import 'package:trancend/src/pages/demo.dart';

class TopicListView extends StatefulWidget {
  const TopicListView({super.key});

  @override
  _TopicListViewState createState() => _TopicListViewState();
}

class _TopicListViewState extends State<TopicListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.water_drop),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DemoPage()),
            ),
          ),
        ],
      ),
    );
  }
} 