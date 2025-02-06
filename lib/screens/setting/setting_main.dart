import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pressure_flutter/service/setting_service.dart';

class SettingMain extends StatefulWidget {
  const SettingMain({super.key});

  @override
  State<SettingMain> createState() => _SettingMainState();
}

class _SettingMainState extends State<SettingMain> {
  final SettingService settingService = SettingService();
  Map<String, String?> userInfo = {};

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController birthController;
  late TextEditingController addrController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    birthController = TextEditingController();
    addrController = TextEditingController();

    _loadUserInfo();
    // 리스너 추가: 입력값이 변경될 때마다 setState 호출
    nameController.addListener(() => setState(() {}));
    emailController.addListener(() => setState(() {}));
    phoneController.addListener(() => setState(() {}));
    birthController.addListener(() => setState(() {}));
    addrController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // 리스너 제거
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    birthController.dispose();
    addrController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    Map<String, String?> data = await settingService.getUserInfo();
    setState(() {
      userInfo = data;
      nameController.text = userInfo['name'] ?? "";
      emailController.text = userInfo['email'] ?? "";
      phoneController.text = userInfo['phone'] ?? "";
      birthController.text = userInfo['birth'] ?? "";
      addrController.text = userInfo['addr'] ?? "";
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        birthController.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void showUserEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("사용자 정보 입력",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "이름"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "이메일"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "연락처"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextField(
                controller: birthController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "생일",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
              ),
              TextField(
                controller: addrController,
                decoration: InputDecoration(labelText: "주소"),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      settingService.clearUserInfo(); // 입력값 초기화
                      Navigator.pop(context, true);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                    child: Text("초기화", style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await settingService.saveUserInfo(
                        nameController.text,
                        emailController.text,
                        phoneController.text,
                        birthController.text,
                        addrController.text,
                      );
                      Navigator.pop(context, true); // true 값 반환 후 모달 닫기
                    },
                    child: Text("저장"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ).then((value) {
      if (value == true) {
        _loadUserInfo(); // 모달 닫힌 후 이벤트 실행
      }
    });
  }

  Future<void> sendEmail() async {
    await settingService.sendEmail();
  }

  void shareFile() {
    settingService.shareFile();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: EdgeInsets.all(16),
              children: [
                _buildUserInfoRow("이름", nameController.text),
                _buildUserInfoRow("이메일", emailController.text),
                _buildUserInfoRow("연락처", phoneController.text),
                _buildUserInfoRow("생일", birthController.text),
                _buildUserInfoRow("주소", addrController.text),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => shareFile(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 117, 160, 253),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "데이터 공유하기",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => sendEmail(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 117, 160, 253),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "메일 보내기",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(String title, String? value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(value ?? "",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            ],
          ),
        ),
        Divider(color: Colors.grey.shade300),
      ],
    );
  }
}
