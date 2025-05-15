import 'package:flutter/material.dart';

/// A reusable dropdown widget that uses Flutter's built-in DropdownButton.
///
/// This widget provides a customizable dropdown with similar functionality to the previous implementation.
/// It supports both string lists and custom object lists.
class AppDropdown<T> extends StatelessWidget {
  /// List of items to display in the dropdown
  final List<T> items;

  /// Hint text to display when no item is selected
  final String hintText;

  /// Initial selected item (optional)
  final T? initialItem;

  /// Callback function when an item is selected
  final ValueChanged<T> onChanged;

  /// Border radius of the dropdown (default: 12)
  final double borderRadius;

  /// Width of the dropdown border (default: 1)
  final double borderWidth;

  /// Color of the dropdown border (default: Colors.grey)
  final Color borderColor;

  /// Background color of the dropdown (default: Colors.white)
  final Color? fillColor;

  /// Text style for the dropdown items
  final TextStyle? textStyle;

  /// Height of the dropdown field (default: 55)
  final double fieldHeight;

  /// Width of the dropdown field (default: double.infinity)
  final double fieldWidth;

  /// Icon for the dropdown (default: Icons.arrow_drop_down)
  final IconData? icon;

  /// Color of the dropdown icon (default: Colors.grey)
  final Color? iconColor;

  /// Whether the dropdown is enabled (default: true)
  final bool enabled;

  /// Whether to show a search field (default: false)
  final bool searchable;

  /// Validator function for form validation
  final String? Function(T?)? validator;

  const AppDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.initialItem,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.borderColor = Colors.grey,
    this.fillColor,
    this.textStyle,
    this.fieldHeight = 55,
    this.fieldWidth = double.infinity,
    this.icon,
    this.iconColor,
    this.enabled = true,
    this.searchable = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = textStyle ?? theme.textTheme.bodyMedium;
    final hintStyle =
        defaultTextStyle?.copyWith(color: Colors.grey) ??
        theme.textTheme.bodyMedium?.copyWith(color: Colors.grey);

    // Create a FormField to handle validation
    return SizedBox(
      width: fieldWidth,
      child: FormField<T>(
        initialValue: initialItem,
        validator: validator,
        builder: (FormFieldState<T> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: fieldHeight,
                decoration: BoxDecoration(
                  color: fillColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: state.hasError ? Colors.red : borderColor,
                    width: borderWidth,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<T>(
                      isExpanded: true,
                      value: state.value,
                      icon: Icon(
                        icon ?? Icons.arrow_drop_down,
                        color: iconColor ?? Colors.grey,
                      ),
                      iconSize: 24,
                      elevation: 16,
                      style: defaultTextStyle,
                      hint: Text(hintText, style: hintStyle),
                      onChanged:
                          enabled
                              ? (T? newValue) {
                                state.didChange(newValue);
                                if (newValue != null) {
                                  onChanged(newValue);
                                }
                              }
                              : null,
                      items:
                          items.map<DropdownMenuItem<T>>((T item) {
                            return DropdownMenuItem<T>(
                              value: item,
                              child: Text(
                                item.toString(),
                                style: defaultTextStyle,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Text(
                    state.errorText ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// A multi-select dropdown widget using Flutter's built-in components.
///
/// This widget allows selecting multiple items from a dropdown list.
class MultiSelectAnimatedDropdown<T> extends StatefulWidget {
  /// List of items to display in the dropdown
  final List<T> items;

  /// Hint text to display when no items are selected
  final String hintText;

  /// Initial selected items (optional)
  final List<T>? initialItems;

  /// Callback function when items are selected
  final ValueChanged<List<T>> onChanged;

  /// Border radius of the dropdown (default: 12)
  final double borderRadius;

  /// Width of the dropdown border (default: 1)
  final double borderWidth;

  /// Color of the dropdown border (default: Colors.grey)
  final Color borderColor;

  /// Background color of the dropdown (default: Colors.white)
  final Color? fillColor;

  /// Text style for the dropdown items
  final TextStyle? textStyle;

  /// Height of the dropdown field (default: 55)
  final double fieldHeight;

  /// Width of the dropdown field (default: double.infinity)
  final double fieldWidth;

  /// Icon for the dropdown (default: Icons.arrow_drop_down)
  final IconData? icon;

  /// Color of the dropdown icon (default: Colors.grey)
  final Color? iconColor;

  /// Whether the dropdown is enabled (default: true)
  final bool enabled;

  /// Whether to show a search field (default: false)
  final bool searchable;

  /// Validator function for form validation
  final String? Function(List<T>?)? validator;

  const MultiSelectAnimatedDropdown({
    Key? key,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.initialItems,
    this.borderRadius = 12,
    this.borderWidth = 1,
    this.borderColor = Colors.grey,
    this.fillColor,
    this.textStyle,
    this.fieldHeight = 55,
    this.fieldWidth = double.infinity,
    this.icon,
    this.iconColor,
    this.enabled = true,
    this.searchable = false,
    this.validator,
  }) : super(key: key);

  @override
  State<MultiSelectAnimatedDropdown<T>> createState() =>
      _MultiSelectAnimatedDropdownState<T>();
}

class _MultiSelectAnimatedDropdownState<T>
    extends State<MultiSelectAnimatedDropdown<T>> {
  List<T> _selectedItems = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialItems != null) {
      _selectedItems = List.from(widget.initialItems!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = widget.textStyle ?? theme.textTheme.bodyMedium;
    final hintStyle =
        defaultTextStyle?.copyWith(color: Colors.grey) ??
        theme.textTheme.bodyMedium?.copyWith(color: Colors.grey);

    return SizedBox(
      width: widget.fieldWidth,
      child: FormField<List<T>>(
        initialValue: _selectedItems,
        validator: widget.validator,
        builder: (FormFieldState<List<T>> state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap:
                    widget.enabled
                        ? () {
                          setState(() {
                            _isOpen = !_isOpen;
                          });
                        }
                        : null,
                child: Container(
                  height: widget.fieldHeight,
                  decoration: BoxDecoration(
                    color: widget.fillColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: state.hasError ? Colors.red : widget.borderColor,
                      width: widget.borderWidth,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child:
                            _selectedItems.isEmpty
                                ? Text(widget.hintText, style: hintStyle)
                                : Text(
                                  _selectedItems
                                      .map((e) => e.toString())
                                      .join(', '),
                                  style: defaultTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                      ),
                      Icon(
                        widget.icon ?? Icons.arrow_drop_down,
                        color: widget.iconColor ?? Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isOpen)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: widget.borderColor,
                      width: widget.borderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      final isSelected = _selectedItems.contains(item);

                      return ListTile(
                        dense: true,
                        title: Text(item.toString(), style: defaultTextStyle),
                        trailing:
                            isSelected
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedItems.remove(item);
                            } else {
                              _selectedItems.add(item);
                            }
                            widget.onChanged(_selectedItems);
                            state.didChange(_selectedItems);
                          });
                        },
                      );
                    },
                  ),
                ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 8),
                  child: Text(
                    state.errorText ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
