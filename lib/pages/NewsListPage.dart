import 'package:flutter/material.dart';
import 'NewsDetailPage.dart';

// 资讯列表页面
class NewsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new RaisedButton(
        child: new Text('go detail'), 
        onPressed: () {
          // 页面的跳转
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (ctx) {
                return new NewDetailPage();
              })
          );
        }
      ),
    );
  }
}