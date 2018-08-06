import 'package:flutter/material.dart';

class NewDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("咨询详情", style: new TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: new Center(
        child: new Column(
          // 上面代码中的body部分返回的是一个Center组件，Center中装的是Column组件，如果你不为Column组件设置mainAxisAlignment: MainAxisAlignment.center，则页面上的组件只会在水平方向居中而不会在垂直方向上居中。
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("new detail"),
            new RaisedButton(
              child: new Text("Back"),
              onPressed: () {
                // 回到上一级
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }
}