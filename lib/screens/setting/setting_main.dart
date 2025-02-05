import 'package:flutter/material.dart';
import 'package:pressure_flutter/service/setting_service.dart';

class SettingMain extends StatefulWidget {
  const SettingMain({super.key});

  @override
  State<SettingMain> createState() => _SettingMainState();
}

class _SettingMainState extends State<SettingMain> {
  final SettingService settingService = SettingService();
  Map<String, String?> userInfo = {};

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    Map<String, String?> data = await settingService.getUserInfo();
    setState(() {
      userInfo = data; // 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> sendEmail() async {
      await settingService.sendEmail();
    }

    void showUserEditModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 키보드 올라올 때 조정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("사용자 정보 입력",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(labelText: "이름"),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "이메일"),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("저장"),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("사용자 정보",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => showUserEditModal(context),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildUserInfoRow("이름", "${userInfo['name']}"),
                _buildUserInfoRow("이메일", "hong@example.com"),
                _buildUserInfoRow("연락처", "010-1234-5678"),
                _buildUserInfoRow("주소", "서울특별시 강남구"),
              ],
            ),
          ),
          InkWell(
            onTap: () => sendEmail(),
            child: Container(
              height: 50,
              width: double.infinity,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                "메일 보내기",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(String title, String value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }
}
