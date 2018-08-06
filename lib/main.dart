import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/NewsListPage.dart';
import 'pages/TweetsListPage.dart';
import 'pages/DiscoveryPage.dart';
import 'pages/MyInfoPage.dart';
import 'widgets/MyDrawer.dart';

void main() {
  runApp(new MyOSCClient());
}

// MyOSCClient是一个有状态的组件，因为页面标题，页面内容和页面底部Tab都会改变
class MyOSCClient extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MyOSCClientState();
}

class MyOSCClientState extends State<MyOSCClient> {
  // 默认选中底部状态栏 0 - 资讯
  int _tabIndex = 0;
  // 选中颜色和未选中颜色
  final tabTextStyleNormal = new TextStyle(color: const Color(0xff969696));
  final tabTextStyleSelected = new TextStyle(color: const Color(0xff63ca6c));

  // 页面底部TabItem上的图标数组
  var tabImages;
  var _body;
  // 页面顶部的大标题（也是TabItem上的文本）
  var appBarTitles = ['资讯', '动弹', '发现', '我的'];

  // 传入图片路径，返回一个Image组件
  Image getTabImage(path) {
    return new Image.asset(path, width: 20.0, height: 20.0);
  }

  // 数据初始化，包括TabIcon数据和页面内容数据
  void initData() {
    if (tabImages == null) {
      tabImages = [
        [
          getTabImage('images/ic_nav_news_normal.png'),
          getTabImage('images/ic_nav_news_actived.png')
        ],
        [
          getTabImage('images/ic_nav_tweet_normal.png'),
          getTabImage('images/ic_nav_tweet_actived.png')
        ],
        [
          getTabImage('images/ic_nav_discover_normal.png'),
          getTabImage('images/ic_nav_discover_actived.png')
        ],
        [
          getTabImage('images/ic_nav_my_normal.png'),
          getTabImage('images/ic_nav_my_pressed.png')
        ]
      ];
    }
    // 各个页面
    _body = new IndexedStack(
      children: <Widget>[
        new NewsListPage(),
        new TweetsListPage(),
        new DiscoveryPage(),
        new MyInfoPage()
      ],
      index: _tabIndex,
    );
  }

  // 根据索引值确定Tab是选中状态的样式还是非选中状态的样式
  TextStyle getTabTextStyle(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabTextStyleSelected;
    }
    return tabTextStyleNormal;
  }

  // 根据索引值确定TabItem的icon是选中还是非选中
  Image getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabImages[curIndex][1];
    }
    return tabImages[curIndex][0];
  }

  // 根据索引值返回页面顶部标题
  Text getTabTitle(int curIndex) {
    return new Text(appBarTitles[curIndex], style: getTabTextStyle(curIndex));
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return new MaterialApp(
      theme: new ThemeData(
          // 设置页面的主题色
          primaryColor: const Color(0xFF63CA6C)
      ),
      home: new Scaffold(
        appBar: new AppBar(
            // 设置AppBar标题 // 设置AppBar上文本的样式
            title: new Text(appBarTitles[_tabIndex], style: new TextStyle(color: Colors.white)),
            // 设置AppBar上图标的样式
            iconTheme: new IconThemeData(color: Colors.white)
        ),
        body: _body,
        // CupertinoTabBar是Flutter内置的iOS风格的选项卡，用于在页面底部显示几个Tab
        bottomNavigationBar: new CupertinoTabBar(
          items: <BottomNavigationBarItem>[
            new BottomNavigationBarItem(
                icon: getTabIcon(0),
                title: getTabTitle(0)),
            new BottomNavigationBarItem(
                icon: getTabIcon(1),
                title: getTabTitle(1)),
            new BottomNavigationBarItem(
                icon: getTabIcon(2),
                title: getTabTitle(2)),
            new BottomNavigationBarItem(
                icon: getTabIcon(3),
                title: getTabTitle(3)),
          ],
          currentIndex: _tabIndex,
          onTap: (index) {
            // 底部TabItem的点击事件处理，点击时改变当前选择的Tab的索引值，则页面会自动刷新
            setState((){
              _tabIndex = index;
            });
          },
        ),
        // drawer属性用于为当前页面添加一个侧滑菜单
//        drawer: new Drawer(
//          child: new Center(
//            child: new Text("this is a drawer"),
//          ),
//        ),
        drawer: new MyDrawer(),
      ),
    );
  }
}
