//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';

class CustomTabView extends StatefulWidget {
  final List<String> titles;
  final List<Widget> tabViews;

  const CustomTabView({
    @required this.titles,
    @required this.tabViews,
  });

  @override
  _CustomTabViewState createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: widget.titles.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: UIHelper.barHeight,
          decoration: BoxDecoration(
            color: UIHelper.themeColor,
            borderRadius: UIHelper.customBorderRadius,
          ),
          child: TabBar(
            indicator: BoxDecoration(
              color: Colors.white,
              borderRadius: UIHelper.customBorderRadius,
              border: Border.all(color: UIHelper.themeColor),
            ),
            unselectedLabelColor: Colors.white,
            labelColor: UIHelper.themeColor,
            unselectedLabelStyle: Theme.of(context).textTheme.button,
            labelStyle: Theme.of(context).textTheme.button,
            controller: _tabController,
            tabs: List.generate(
              widget.titles.length,
              (index) => Tab(
                text: widget.titles[index],
              ),
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: List.generate(widget.tabViews.length, (index) => widget.tabViews[index]),
          ),
        ),
      ],
    );
  }
}
