import 'package:flutter/material.dart';

class SlideView extends StatefulWidget {
  var data;// data表示轮播图中的数据

  SlideView(data) {
    this.data = data;
  }

  @override
  State<StatefulWidget> createState() {
    // 可以在构造方法中传参供SlideViewState使用
    // 或者也可以不传参数，直接在SlideViewState中通过this.widget.data访问SlideView中的data变量
    return new SlideViewState(data);
  }
}

class SlideViewState extends State<SlideView> with SingleTickerProviderStateMixin{
  // TabController为TabBarView组件的控制器
  TabController tabController;
  List slideData;

  SlideViewState(data) {
    slideData = data;
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 初始化控制器
    tabController = new TabController(
        length: slideData == null ? 0 : slideData.length,
        vsync: this
    );
  }

  @override
  void dispose() {
    // 销毁
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (slideData != null && slideData.length > 0) {
      for(var i = 0; i < slideData.length; i++) {
        var item = slideData[i];
        // 图片url
        var imgUrl = item['imgUrl'];
        // 资讯标题
        var title = item['title'];
        // 资讯详情url
        var detailUrl = item['detailUrl'];
        items.add(new GestureDetector(
          onTap: () {
            //点击跳转详情
          },
          // Stack组件用于将资讯标题文本放置到图片上面
          child: new Stack(
            children: <Widget>[
              // 加载网络图片
              new Image.network(imgUrl),
              new Container(
                // 标题容器宽度跟屏幕宽度一致
                width: MediaQuery.of(context).size.width,
                // 背景为黑色，加入透明度
                color: const Color(0x50000000),
                // 标题文本加入内边距
                child: new Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: new Text(title,
                    // 字体大小为15，颜色为白色
                    style: new TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              )
            ],
          ),
        ));
      }
    }

    return new TabBarView(
      //children表示这个组件中的各个页面
      children: items,
      //controller代表这个TabBarView的控制器
      controller: tabController,
    );
  }
}