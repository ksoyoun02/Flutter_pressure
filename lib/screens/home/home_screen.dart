import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Main Header
          Container(
            height: MediaQuery.of(context).size.height * 0.1, // 10% of the screen height
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              'Main Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Tab View
          Expanded(
            child: DefaultTabController(
              length: 3, // Number of tabs
              child: Column(
                children: [
                  // Tab Bar
                  Container(
                    color: Colors.blue.shade100,
                    child: TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: 'Tab 1'),
                        Tab(text: 'Tab 2'),
                        Tab(text: 'Tab 3'),
                      ],
                    ),
                  ),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(child: Text('Content for Tab 1')),
                        Center(child: Text('Content for Tab 2')),
                        Center(child: Text('Content for Tab 3')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}