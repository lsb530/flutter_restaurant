import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/const/colors.dart';
import 'package:flutter_restaurant/common/layout/default_layout.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '보기 딜리버리',
      child: Center(
        child: Text('Root Tab'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed, // shifting: 선택한 아이콘이 조금 더 커짐
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fastfood_outlined,
            ),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt_long_outlined,
            ),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
