import 'package:flutter/material.dart';

enum DropDownType {
  FormField,
  PopUpMenu,
  Button,
}

class DropDown<T> extends StatefulWidget {
  final DropDownType dropDownType;
  final List<T> items;

  /// If needs to render custom widgets for dropdown items must provide values for customWidgets
  /// Also the customWidgets length have to be equals to items
  final List<Widget>? customWidgets;
  final T? initialValue;
  final Widget? hint;
  final Function(T?)? onChanged;
  final bool isExpanded;
  final Widget? icon;

  /// If need to clear dropdown currently selected value
  final bool isCleared;

  /// You can choose between show an underline at bottom or not
  final bool showUnderline;

  // Increase item height from default value
  final double increaseItemHeight;

  // Background color for dropdown view
  final Color? backgroundColor;

  DropDown({
    this.dropDownType = DropDownType.Button,
    required this.items,
    this.customWidgets,
    this.initialValue,
    this.hint,
    this.onChanged,
    this.isExpanded = false,
    this.icon,
    this.isCleared = false,
    this.showUnderline = true,
    this.increaseItemHeight = 0,
    this.backgroundColor,
  })  : assert(!(items is Widget)),
        assert((customWidgets != null)
            ? items.length == customWidgets.length
            : (customWidgets == null));

  @override
  _DropDownState<T> createState() => _DropDownState<T>();
}

class _DropDownState<T> extends State<DropDown<T>> {
  T? selectedValue;

  @override
  void initState() {
    selectedValue = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget dropdown;

    switch (widget.dropDownType) {
      case DropDownType.FormField:
        dropdown = SizedBox();
        break;
      case DropDownType.PopUpMenu:
        dropdown = SizedBox();
        break;
      // case DropDownType.Button: // Empty statement
      default:
        dropdown = DropdownButton<T>(
          dropdownColor: widget.backgroundColor,
          isExpanded: widget.isExpanded,
          onChanged: (T? value) {
            setState(() => selectedValue = value);
            widget.onChanged?.call(value);
          },
          value: widget.isCleared ? null : selectedValue,
          items: widget.items
              .map<DropdownMenuItem<T>>((item) => buildDropDownItem(item))
              .toList(),
          hint: widget.hint,
          itemHeight: kMinInteractiveDimension + widget.increaseItemHeight,
          icon: widget.icon ??
              Icon(
                Icons.expand_more,
              ),
        );
    }

    // Wrapping Dropdown in DropdownButtonHideUnderline removes the underline

    return widget.showUnderline
        ? dropdown
        : DropdownButtonHideUnderline(child: dropdown);
  }

  DropdownMenuItem<T> buildDropDownItem(T item) => DropdownMenuItem<T>(
        child: (widget.customWidgets != null)
            ? widget.customWidgets![widget.items.indexOf(item)]
            : Text(item.toString()),
        value: item,
      );
}
