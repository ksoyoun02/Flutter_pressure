import 'package:flutter/material.dart';

class MovingBarWidget extends StatelessWidget {
  final double sp;
  final double dp;
  final double min;
  final double max;
  final double barWidth;

  const MovingBarWidget({
    super.key,
    required this.sp,
    required this.dp,
    this.min = 50,
    this.max = 200,
    this.barWidth = 400,
  });

  String getBloodPressureCategory(double sp, double dp) {
    if (sp <= 90 || dp <= 60) {
      return "저혈압";
    } else if (sp < 120 && dp < 80) {
      return "정상 혈압";
    } else if ((sp >= 120 && sp <= 129) && dp < 80) {
      return "주의 혈압";
    } else if ((sp >= 130 && sp <= 139) || (dp >= 80 && dp <= 89)) {
      return "고혈압 전단계";
    } else if ((sp >= 140 && sp <= 159) || (dp >= 90 && dp <= 99)) {
      return "고혈압 1기";
    } else if (sp >= 160 || dp >= 100) {
      return "고혈압 2기";
    }
    return "알 수 없음";
  }

  @override
  Widget build(BuildContext context) {
    double arrowPosition = ((sp - min) / (max - min)) * barWidth;

    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              // 3구역으로 나눈 막대 바
              Row(
                children: [
                  Expanded(
                    flex: 1, // 첫 번째 구역
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1, // 두 번째 구역
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1, // 세 번째 구역
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 눈금 & 숫자 표시
              Positioned.fill(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double barWidth = constraints.maxWidth;
                    int divisions = 14; // 눈금 개수
                    double step = barWidth / divisions;
                    double minValue = 60;
                    double maxValue = 200;
                    double stepValue =
                        (maxValue - minValue) / divisions; // 값 증가 단위

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(divisions + 1, (index) {
                        return Column(
                          children: [
                            Container(
                              width: 2,
                              height: 10,
                              color: Colors.black26, // 눈금 선
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${(minValue + (index * stepValue)).toInt()}', // 60, 74, 88 ... 200
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                ),
              ),
              // 화살표 위치
              Positioned(
                left: arrowPosition - 10, // 중앙 정렬을 위해 조정
                top: -19,
                child: Column(
                  children: [
                    Icon(Icons.arrow_drop_down, size: 40, color: Colors.red),
                  ],
                ),
              ),
            ],
          ),
          Text(
            getBloodPressureCategory(sp, dp),
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
