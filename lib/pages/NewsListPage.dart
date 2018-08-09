import 'package:flutter/material.dart';
import 'NewsDetailPage.dart';
import '../widgets/SlideView.dart';
import '../util/NetUtils.dart';
import '../api/Api.dart';
import 'dart:async';
import 'dart:convert';

// 资讯列表页面
class NewsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new NewsListPageState();

}


class NewsListPageState extends State<NewsListPage> {

  // 轮播图数据
  var slideData;
  // 列表数据
  var listData;
  var curPage = 1;
  var listTotalSize = 0;
  //controller就是为了监听列表滚动事件而传入的，它是一个ScrollController对象，我们在NewsListPageState类中定义这个变量并初始化
  ScrollController _controller = new ScrollController();
  // 列表中资讯标题的样式
  TextStyle titleStyle = new TextStyle(fontSize: 15.0);
  // 时间文本的样式
  TextStyle subtitleStyle = new TextStyle(
    color: const Color(0xFFB5BDC0),
    fontSize: 12.0
  );

  NewsListPageState() {
    //监听列表是否滚动到底的事件
    _controller.addListener(() {
      // 表示列表的最大滚动距离
      var maxScroll = _controller.position.maxScrollExtent;
      // 表示当前列表已向下滚动的距离
      var pixels = _controller.position.pixels;
      // 如果两个值相等，表示滚动到底，并且如果列表没有加载完所有数据
      if (maxScroll == pixels && listData.length < listTotalSize) {
        // 当前页索引加1
        curPage++;
        // 获取下一页数据
        getNewsList(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    //无数据时，显示Loading
    if (listData == null) {
      return new Center(
        // CircularProgressIndicator是一个圆形的Loading进度条
        child: new CircularProgressIndicator(),
      );
    } else {
      // 有数据，显示ListView
      Widget listView = new ListView.builder(
          itemCount: listData.length * 2 + 1,
          itemBuilder: (context, i) => renderRow(i),
          controller: _controller,
      );
      return new RefreshIndicator(child: listView, onRefresh: _pullToRefresh);
    }
  }

  @override
  void initState() {
    super.initState();
    getNewsList(false);
  }

  Future<Null> _pullToRefresh() async {
    curPage = 1;
    getNewsList(false);
    return null;
  }
  // 从网络获取数据，isLoadMore表示是否是加载更多数据
  getNewsList(bool isLoadMore) {
    String url = Api.NEWS_LIST;
    url += "?pageIndex=$curPage&pageSize=10";
    print("newsListUrl: $url");
    NetUtils.get(url).then((data) {
      if (data != null) {
        Map<String, dynamic> map = json.decode(data);
        if (map['code'] == 0) {
          var msg = map['msg'];
          listTotalSize = msg['news']['total'];
          var _listData = msg['news']['data'];
          var _slideData = msg['slide'];
          setState(() {
            if (!isLoadMore) {
              listData = _listData;
              slideData = _slideData;
            } else {
              List list1 = new List();
              list1.addAll(listData);
              list1.addAll(_listData);
              if (list1.length >= listTotalSize) {
                list1.add("COMPLETE");
              }
              listData = list1;

              slideData = _slideData;
            }
          });
        }
      }
    });
  }


  // 渲染列表item
  Widget renderRow(i) {
    // i为0时渲染轮播图
    if (i == 0) {
      return new Container(
        height: 180.0,
        child: new SlideView(slideData),
      );
    }

    // i > 0时
    i -= 1;
    // i为奇数，渲染分割线
    if (i.isOdd) {
      return new Divider(height: 1.0);
    }
    // 将i取整
    i = i ~/ 2;
    // 得到列表item的数据
    var itemData = listData[i];
    // 代表列表item中的标题这一行
    var titleRow = new Row(
      children: <Widget>[
        // 标题充满一整行，所以用Expanded组件包裹
        new Expanded(
          child: new Text(itemData['title'], style: titleStyle),
        )
      ],
    );

    // 时间这一行包含了作者头像、时间、评论数这几个
    var timeRow = new Row(
      children: <Widget>[

        // 这是作者头像，使用了圆形头像
        new Container(
          width: 20.0,
          height: 20.0,
          decoration: new BoxDecoration(
            // 通过指定shape属性设置图片为圆形
            shape: BoxShape.circle,
            color: const Color(0xFFECECEC),
            image: new DecorationImage(
              image: new NetworkImage(itemData['authorImg']),
              fit: BoxFit.cover
            ),
            border: new Border.all(
              color: const Color(0xFFECECEC),
              width: 2.0
            ),
          ),
        ),

        // 这是时间文本
        new Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: new Text(
            itemData['timeStr'],
            style: subtitleStyle,
          ),
        ),

        // 这是评论数，评论数由一个评论图标和具体的评论数构成，所以是一个Row组件
        new Expanded(
          flex: 1,
          child: new Row(
            // 为了让评论数显示在最右侧，所以需要外面的Expanded和这里的MainAxisAlignment.end
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Text("${itemData['commCount']}", style: subtitleStyle),
              new Image.asset('./images/ic_comment.png', width: 16.0, height: 16.0),
            ],
          )
        )
      ],
    );

    var thumbImgUrl = itemData['thumb'];
    // 这是item右侧的资讯图片，先设置一个默认的图片
    var thumbImg = new Container(
      margin: const EdgeInsets.all(10.0),
      width: 60.0,
      height: 60.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFECECEC),
        image: new DecorationImage(
            image: new ExactAssetImage('./images/ic_img_default.jpg'),
            fit: BoxFit.cover),
        border: new Border.all(
          color: const Color(0xFFECECEC),
          width: 2.0,
        ),
      ),
    );

    // 如果上面的thumbImgUrl不为空，就把之前thumbImg默认的图片替换成网络图片
    if (thumbImgUrl != null && thumbImgUrl.length > 0) {
      thumbImg = new Container(
        margin: const EdgeInsets.all(10.0),
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFECECEC),
          image: new DecorationImage(
              image: new NetworkImage(thumbImgUrl), fit: BoxFit.cover),
          border: new Border.all(
            color: const Color(0xFFECECEC),
            width: 2.0,
          ),
        ),
      );
    }

    // 这里的row代表了一个ListItem的一行
    var row = new Row(
      children: <Widget>[
        // 左边是标题，时间，评论数等信息
        new Expanded(
          flex: 1, 
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                titleRow,
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: timeRow,
                )
              ],
            ),
          ),
        ),

        // 右边是资讯图片
        new Padding(
          padding: const EdgeInsets.all(6.0),
          child: new Container(
            width: 100.0,
            height: 80.0,
            color: const Color(0xFFECECEC),
            child:  new Center(
              child: thumbImg,
            ),
          ),
        )
      ],
    );

    // 用InkWell包裹row，让row可以点击
    return new InkWell(
      child: row,
      onTap: () {

      },
    );
  }
}