import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class StoreAnimatedList extends AnimatedList {
  final DataSetChangedListener dataSetChangedListener;
  final Key key;
  final int initialItemCount;
  final AnimatedListItemBuilder itemBuilder;
  final ScrollController controller;
  static bool callScrollUp = false;
  static bool callScrollDown = false;
  static double maxOffset = -1;
  static int itemCount = 3;
  final int itemHeight;
  static int lastIndex = -1;
  static int firstVisibleItemIndex;
  static double scrollOffsetStatic;

  const StoreAnimatedList(
      {this.dataSetChangedListener,
        this.key,
        this.itemHeight,
        this.initialItemCount,
        @required this.itemBuilder,
        this.controller})
      : super(
      key: key,
      initialItemCount: initialItemCount,
      itemBuilder: itemBuilder,
      controller: controller);



  registerControllerListener() {
    controller.addListener(scrollListener);
  }
  unregisterControllerListener() {
    controller.removeListener(scrollListener);
  }
  scrollListener() {
    if (controller.offset < controller.position.maxScrollExtent - itemHeight) {
      dataSetChangedListener.onOffsetChanged();
    }
    getFirstVisibleItem();
    getLastVisibleItem();
    if (maxOffset != controller.position.maxScrollExtent) {
      maxOffset = controller.position.maxScrollExtent;
      callScrollUp = true;
      callScrollDown = true;
    }
    if (controller.position.userScrollDirection == ScrollDirection.forward &&
        controller.offset <
            controller.position.minScrollExtent + (itemHeight * 5)) {
      if (callScrollUp) {
        callScrollUp = false;
        dataSetChangedListener.onScrollUp();
        log("up");
      }
    } else if (controller.position.userScrollDirection ==
        ScrollDirection.reverse &&
        controller.offset >
            controller.position.maxScrollExtent - (itemHeight * 5)) {
      if (callScrollDown) {
        callScrollDown = false;
        dataSetChangedListener.onScrollDown();
        log("down");
      }
    }
  }
  getFirstVisibleItem() {
    double scrollOffset = controller.offset /*scrollOffsetStatic*/;
    int firstVisibleItemIndex = scrollOffset < itemHeight
        ? 0
        : ((scrollOffset - itemHeight) / itemHeight).ceil();
    print(firstVisibleItemIndex);
  }
  getLastVisibleItem() {
    double scrollViewPort = controller.position.viewportDimension;
    double scrollOffset = controller.offset;
    int lastVisibleItemIndex =
    (((scrollOffset + scrollViewPort) - itemHeight) / itemHeight).ceil();
    print(lastVisibleItemIndex);
  }
  addData(int index) {
    itemCount++;
    lastIndex = itemCount > 0 ? itemCount - 1 : 0;
    GlobalKey<AnimatedListState> globalKey = key;
    globalKey.currentState.insertItem(index);
  }
  removeData(int index) {
    itemCount--;
    lastIndex = itemCount > 0 ? itemCount - 1 : 0;
    GlobalKey<AnimatedListState> globalKey = key;
    globalKey.currentState.insertItem(index);
  }
  setListState(function) {
    GlobalKey<AnimatedListState> globalKey = key;
    globalKey.currentState.setState(function);
  }
  scrollToPosition(double positiont) {
    controller.jumpTo(positiont);
  }
  scrollToPositionWithAnimation(double position) {
    controller.animateTo(position,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }
}
abstract class DataSetChangedListener {
  onScrollUp();
  onScrollDown();
  onOffsetChanged();
}