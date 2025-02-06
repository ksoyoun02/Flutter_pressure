import 'package:flutter/material.dart';
import 'package:pressure_flutter/screens/pressure/pressure_list_main.dart';
import 'package:pressure_flutter/screens/pressure/pressure_main.dart';
import 'package:pressure_flutter/screens/setting/setting_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  final List<String> _headerTitles = [
    '혈압 / 맥박 측정',
    '혈압 / 맥박 기록',
    '설정',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Text(
                _headerTitles[_selectedTabIndex],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
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
                      onTap: (index) {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      tabs: [
                        Tab(text: '측정'),
                        Tab(text: '기록'),
                        Tab(text: '설정'),
                      ],
                    ),
                  ),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      children: [
                        const PressureMain(),
                        const PressureListMain(),
                        const SettingMain(),
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
