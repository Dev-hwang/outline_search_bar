library outline_search_bar;

import 'package:flutter/material.dart';
import 'package:simple_text_field/simple_text_field.dart';

/// The minimum height of the search bar.
const double _kSearchBarMinimumHeight = 48.0;

/// The size of action buttons, such as search and clear buttons.
const Size _kActionButtonSize = const Size(36.0, 36.0);

/// An enumeration that defines the location of the search button.
enum SearchButtonPosition {
  /// The search button will be located on the left.
  leading,

  /// The search button will be located on the right.
  trailing
}

/// A widget that implements an outline search bar.
class OutlineSearchBar extends StatefulWidget {
  /// The keyword of [OutlineSearchBar] can be controlled with a [TextEditingController].
  final TextEditingController? textEditingController;

  /// Set keyboard type.
  /// Default value is [TextInputType.text].
  final TextInputType keyboardType;

  /// Set keyboard action.
  /// Default value is [TextInputAction.search].
  final TextInputAction textInputAction;

  /// Set the maximum height of [OutlineSearchBar].
  final double? maxHeight;

  /// Set the icon of [OutlineSearchBar].
  final Icon? icon;

  /// Set the color of [OutlineSearchBar].
  /// Default value is `Theme.of(context).scaffoldBackgroundColor`.
  final Color? backgroundColor;

  /// Set the border color of [OutlineSearchBar].
  /// If value is null and theme brightness is light, use primaryColor, if dark, use accentColor.
  final Color? borderColor;

  /// Set the border thickness of [OutlineSearchBar].
  /// Default value is `1.0`.
  final double borderWidth;

  /// Set the border radius of [OutlineSearchBar].
  /// Default value is `const BorderRadius.all(const Radius.circular(4.0))`.
  final BorderRadius borderRadius;

  /// Set the margin value of [OutlineSearchBar].
  /// Default value is `const EdgeInsets.only()`.
  final EdgeInsetsGeometry margin;

  /// Set the padding value of [OutlineSearchBar].
  /// Default value is `const EdgeInsets.symmetric(horizontal: 5.0)`.
  final EdgeInsetsGeometry padding;

  /// Set the text padding value of [OutlineSearchBar].
  /// Default value is `const EdgeInsets.symmetric(horizontal: 5.0)`.
  final EdgeInsetsGeometry textPadding;

  /// Set the elevation of [OutlineSearchBar].
  /// Default value is `0.0`.
  final double elevation;

  /// Set the keyword to be initially entered.
  /// If initial text is set in [textEditingController], this value is ignored.
  final String? initText;

  /// Set the text to be displayed when the keyword is empty.
  final String? hintText;

  /// Set the input text style.
  final TextStyle? textStyle;

  /// Set the style of [hintText].
  final TextStyle? hintStyle;

  /// Set the maximum length of text to be entered.
  final int? maxLength;

  /// Set the color of cursor.
  final Color? cursorColor;

  /// Set the width of cursor.
  /// Default value is `2.0`.
  final double cursorWidth;

  /// Set the height of cursor.
  final double? cursorHeight;

  /// Set the radius of cursor.
  final Radius? cursorRadius;

  /// Set the background color of the clear button.
  /// Default value is `const Color(0xFFDDDDDD)`.
  final Color clearButtonColor;

  /// Set the icon color inside the clear button.
  /// Default value is `const Color(0xFFFEFEFE)`.
  final Color clearButtonIconColor;

  /// Set the splash color that appears when the search button is pressed.
  final Color? searchButtonSplashColor;

  /// Set the icon color inside the search button.
  /// If value is null and theme brightness is light, use primaryColor, if dark, use accentColor.
  final Color? searchButtonIconColor;

  /// Set the position of the search button.
  /// Default value is [SearchButtonPosition.trailing].
  final SearchButtonPosition searchButtonPosition;

  /// Whether to use autoCorrect option.
  /// Default value is `false`.
  final bool autoCorrect;

  /// Whether to hide the search button.
  /// Default value is `false`.
  final bool hideSearchButton;

  /// Whether to ignore input of white space.
  /// Default value is `false`.
  final bool ignoreWhiteSpace;

  /// Whether to ignore input of special characters.
  /// Default value is `false`.
  final bool ignoreSpecialChar;

  /// Called when [OutlineSearchBar] is tapped.
  final GestureTapCallback? onTap;

  /// Called whenever a keyword is changed.
  final ValueChanged<String>? onKeywordChanged;

  /// When the clear button is pressed, it is called with the previous keyword.
  final ValueChanged<String>? onClearButtonPressed;

  /// When the search button is pressed, it is called with the entered keyword.
  final ValueChanged<String>? onSearchButtonPressed;

  const OutlineSearchBar({
    Key? key,
    this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.search,
    this.maxHeight,
    this.icon,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(const Radius.circular(4.0)),
    this.margin = const EdgeInsets.only(),
    this.padding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.textPadding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.elevation = 0.0,
    this.initText,
    this.hintText,
    this.textStyle,
    this.hintStyle,
    this.maxLength,
    this.cursorColor,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.clearButtonColor = const Color(0xFFDDDDDD),
    this.clearButtonIconColor = const Color(0xFFFEFEFE),
    this.searchButtonSplashColor,
    this.searchButtonIconColor,
    this.searchButtonPosition = SearchButtonPosition.trailing,
    this.autoCorrect = false,
    this.hideSearchButton = false,
    this.ignoreWhiteSpace = false,
    this.ignoreSpecialChar = false,
    this.onTap,
    this.onKeywordChanged,
    this.onClearButtonPressed,
    this.onSearchButtonPressed
  })  : assert(borderWidth >= 0.0),
        assert(elevation >= 0.0),
        assert(cursorWidth >= 0.0),
        super(key: key);

  @override
  _OutlineSearchBarState createState() => _OutlineSearchBarState();
}

class _OutlineSearchBarState extends State<OutlineSearchBar>
    with TickerProviderStateMixin {
  late TextEditingController _textEditingController;
  late AnimationController _animationController;
  late Animation<double> _curvedAnimation;
  bool _isShowingClearButton = false;

  late Color _themeColor;

  void _textEditingControllerListener() {
    if (_textEditingController.text.isEmpty && _isShowingClearButton) {
      _isShowingClearButton = false;
      _animationController.reverse();
    } else if (_textEditingController.text.isNotEmpty
        && !_isShowingClearButton) {
      _isShowingClearButton = true;
      _animationController.forward();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 200)
    );

    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn
    );

    _animationController.reverse();

    _textEditingController = widget.textEditingController
        ?? TextEditingController();
    _textEditingController.addListener(_textEditingControllerListener);

    if (_textEditingController.text.isEmpty
        && (widget.initText != null && widget.initText!.isNotEmpty))
      _textEditingController.text = widget.initText!;
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_textEditingControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light)
      _themeColor = Theme.of(context).primaryColor;
    else
      _themeColor = Theme.of(context).accentColor;

    final children = <Widget>[];
    children.add(Expanded(child: _buildTextField()));
    children.add(
        FadeTransition(opacity: _curvedAnimation, child: _buildClearButton()));

    if (widget.hideSearchButton == false) {
      if (widget.searchButtonPosition == SearchButtonPosition.leading)
        children.insert(0, _buildSearchButton());
      else
        children.insert(children.length, _buildSearchButton());
    }

    return Padding(
      padding: widget.margin,
      child: Material(
        elevation: widget.elevation,
        borderRadius: widget.borderRadius,
        color: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: _kSearchBarMinimumHeight,
            maxHeight: widget.maxHeight ?? double.infinity
          ),
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor
                ?? Theme.of(context).scaffoldBackgroundColor,
            border: Border.all(
              color: widget.borderColor ?? _themeColor,
              width: widget.borderWidth
            ),
            borderRadius: widget.borderRadius
          ),
          child: Row(children: children)
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return SimpleTextField(
      controller: _textEditingController,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      style: widget.textStyle,
      maxLength: widget.maxLength,
      cursorColor: widget.cursorColor,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      autocorrect: widget.autoCorrect,
      ignoreWhiteSpace: widget.ignoreWhiteSpace,
      ignoreSpecialChar: widget.ignoreSpecialChar,
      decoration: SimpleInputDecoration(
        icon: widget.icon,
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        counterText: '',
        contentPadding: widget.textPadding,
        // isDense: true,
        // removeBorder: true,
        simpleBorder: true,
        borderWidth: 0.0,
        focusedBorderWidth: 0.0,
        borderColor: Colors.transparent,
        errorBorderColor: Colors.transparent,
        focusedBorderColor: Colors.transparent,
        focusedErrorBorderColor: Colors.transparent
      ),
      onTap: widget.onTap,
      onChanged: (String value) {
        if (widget.onKeywordChanged != null)
          widget.onKeywordChanged!(value);
      },
      onSubmitted: (String value) {
        if (widget.onSearchButtonPressed != null)
          widget.onSearchButtonPressed!(value);
      },
    );
  }

  Widget _buildClearButton() {
    final clearIcon = Icon(Icons.clear,
        size: 18.0, color: widget.clearButtonIconColor);

    return ConstrainedBox(
      constraints: BoxConstraints.tight(_kActionButtonSize),
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: widget.clearButtonColor,
            borderRadius: BorderRadius.circular(clearIcon.size!)
          ),
          child: clearIcon
        ),
        onTap: () async {
          if (widget.onClearButtonPressed != null)
            widget.onClearButtonPressed!(_textEditingController.text);

          await Future.microtask(_textEditingController.clear);

          if (widget.onKeywordChanged != null)
            widget.onKeywordChanged!('');
        },
      ),
    );
  }

  Widget _buildSearchButton() {
    final searchIcon = Icon(Icons.search,
        size: 30.0, color: widget.searchButtonIconColor ?? _themeColor);

    return ConstrainedBox(
      constraints: BoxConstraints.tight(_kActionButtonSize),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: widget.searchButtonSplashColor,
          borderRadius: BorderRadius.circular(searchIcon.size!),
          child: searchIcon,
          onTap: () {
            if (widget.onSearchButtonPressed != null) {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onSearchButtonPressed!(_textEditingController.text);
            }
          },
        ),
      ),
    );
  }
}
