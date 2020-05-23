import 'package:flutter/material.dart';
import 'package:food_deliver/src/values/colors.dart';

class CustomDropdown extends StatefulWidget {
  final String text;
  final List<LocationDropDownItem> items;

  const CustomDropdown({Key key, @required this.text, @required this.items}) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  GlobalKey actionKey;
  double height, width, xPosition, yPosition;
  bool isDropdownOpened = false;
  OverlayEntry floatingDropdown;

  @override
  void initState() {
    actionKey = LabeledGlobalKey(widget.text);
    super.initState();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext.findRenderObject();
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
    print(height);
    print(width);
    print(xPosition);
    print(yPosition);
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: xPosition,
        width: width,
        top: yPosition + height,
        height: 4 * height + 40,
        child: DropDown(
          items: widget.items,
          itemHeight: height,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        setState(() {
          if (isDropdownOpened) {
            floatingDropdown.remove();
          } else {
            findDropdownData();
            floatingDropdown = _createFloatingDropdown();
            Overlay.of(context).insert(floatingDropdown);
          }

          isDropdownOpened = !isDropdownOpened;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.MAIN_COLOR,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            Text(
              widget.text.toUpperCase(),
              style: TextStyle(color: AppColors.TEXT_WHITE,
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: AppColors.TEXT_WHITE,
            ),
          ],
        ),
      ),
    );
  }
}

class LocationDropDownItem{
  String userName;
  String location;

  LocationDropDownItem({@required this.userName, @required this.location });

}

class DropDown extends StatelessWidget {
  final double itemHeight;
  final List<LocationDropDownItem> items;

  const DropDown({Key key, this.itemHeight, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment(-0.85, 0),
          child: ClipPath(
            clipper: ArrowClipper(),
            child: Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(
                color: AppColors.MAIN_COLOR,
              ),
            ),
          ),
        ),
        Material(
          elevation: 20,
          child: Container(
            height: 3 * itemHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: this.items.map((item) {
                return DropDownItem(
                  name: item.userName,
                  location: item.location,
                  iconData: Icons.location_on,
                  isSelected: false,
                );
              }).toList(),
            ),
//            child: Column(
//              children: <Widget>[
//                DropDownItem.first(
//                  text: "Add new",
//                  iconData: Icons.add_circle_outline,
//                  isSelected: false,
//                ),
//                DropDownItem(
//                  text: "View Profile",
//                  iconData: Icons.person_outline,
//                  isSelected: false,
//                ),
//                DropDownItem(
//                  text: "Settings",
//                  iconData: Icons.settings,
//                  isSelected: false,
//                ),
//                DropDownItem.last(
//                  text: "Logout",
//                  iconData: Icons.exit_to_app,
//                  isSelected: true,
//                ),
//              ],
//            ),
          ),
        ),
      ],
    );
  }
}

class DropDownItem extends StatelessWidget {
  final String name;
  final String location;
  final IconData iconData;
  final bool isSelected;
  final bool isFirstItem;
  final bool isLastItem;

  const DropDownItem(
      {Key key, this.name, this.iconData, this.isSelected = false, this.isFirstItem = false, this.isLastItem = false, this.location})
      : super(key: key);

  factory DropDownItem.first(
      {String name, String location, IconData iconData, bool isSelected}) {
    return DropDownItem(
      name: name,
      location: location,
      iconData: iconData,
      isSelected: isSelected,
      isFirstItem: true,
    );
  }

  factory DropDownItem.last(
      {String name, String location, IconData iconData, bool isSelected}) {
    return DropDownItem(
      name: name,
      location: location,
      iconData: iconData,
      isSelected: isSelected,
      isFirstItem: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: isFirstItem ? Radius.circular(8) : Radius.zero,
          bottom: isLastItem ? Radius.circular(8) : Radius.zero,
        ),
        color: isSelected ? AppColors.BACK_WHITE_COLOR : AppColors.LIGHT_MAIN_COLOR,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name.toUpperCase(),
                    style: TextStyle(color: AppColors.DARK_TEXT_COLOR,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Text(
                    location,
                    style: TextStyle(color: AppColors.DARK_TEXT_COLOR,
                        fontSize: 12,
                        fontWeight: FontWeight.w100),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              iconData,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class ArrowShape extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => throw UnimplementedError();

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(rect.size);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {
  }

  @override
  ShapeBorder scale(double t) {
    throw UnimplementedError();
  }

  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);

    return path;
  }
}