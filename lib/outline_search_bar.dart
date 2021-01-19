library outline_search_bar;

import 'package:flutter/material.dart';
import 'package:simple_text_field/simple_text_field.dart';

/// Search Bar default height.
const double SearchBarDefaultHeight = 48.0;

/// Action Button(Clear, Search) default size.
const double ActionButtonDefaultSize = 36.0;

/// A widget that implements an outlined search bar.
class OutlineSearchBar extends StatefulWidget {
  /// The keyword of [OutlineSearchBar] can be controlled with a [TextEditingController].
  final TextEditingController textEditingController;

  /// Set the color of [OutlineSearchBar].
  /// Default value is Color(0xFFFEFEFE)
  final Color backgroundColor;

  /// Set the border color of [OutlineSearchBar].
  /// If value is null and theme brightness is light, use primaryColor, if dark, use accentColor.
  final Color borderColor;

  /// Set the border thickness of [OutlineSearchBar].
  /// Default value is 1.0
  final double borderWidth;

  /// Set the border radius of [OutlineSearchBar].
  /// Default value is BorderRadius.all(Radius.circular(4.0))
  final BorderRadius borderRadius;

  /// Set the margin value of [OutlineSearchBar].
  /// Default value is EdgeInsets.only()
  final EdgeInsetsGeometry margin;

  /// Set the padding value of [OutlineSearchBar].
  /// Default value is EdgeInsets.only(left: 10.0, right: 4.0)
  final EdgeInsetsGeometry padding;

  /// Set the elevation of [OutlineSearchBar].
  /// Default value is 0.0
  final double elevation;

  /// Set the keyword to be initially entered.
  /// If initial text is set in [textEditingController], this value is ignored.
  final String initText;

  /// Set the text to be displayed when the keyword is empty.
  final String hintText;

  /// Set the input text style.
  final TextStyle textStyle;

  /// Set the style of [hintText].
  final TextStyle hintStyle;

  /// Set the maximum length of text to be entered.
  final int maxLength;

  /// Set the color of cursor.
  final Color cursorColor;

  /// Set the width of cursor.
  /// Default value is 2.0
  final double cursorWidth;

  /// Set the height of cursor.
  final double cursorHeight;

  /// Set the radius of cursor.
  final Radius cursorRadius;

  /// Set the background color of the clear button.
  /// Default value is Color(0xFFDDDDDD)
  final Color clearButtonColor;

  /// Set the icon color inside the clear button.
  /// Default value is Color(0xFFFEFEFE)
  final Color clearButtonIconColor;

  /// Set the splash color that appears when the search button is pressed.
  final Color searchButtonSplashColor;

  /// Set the icon color inside the search button.
  /// If value is null and theme brightness is light, use primaryColor, if dark, use accentColor.
  final Color searchButtonIconColor;

  /// Whether to use autoCorrect option.
  /// Default value is false
  final bool autoCorrect;

  /// Whether to hide the search button.
  /// Default value is false
  final bool hideSearchButton;

  /// Whether to ignore input of white space.
  /// Default value is false
  final bool ignoreWhiteSpace;

  /// Whether to ignore input of special characters.
  /// Default value is false
  final bool ignoreSpecialChar;

  /// Called whenever a keyword is entered.
  final ValueChanged<String> onKeywordChanged;

  /// When you press the search button, it is called with the entered keyword.
  final ValueChanged<String> onSearchButtonPressed;

  OutlineSearchBar({
    Key key,
    this.textEditingController,
    this.backgroundColor = const Color(0xFFFEFEFE),
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.margin = const EdgeInsets.only(),
    this.padding = const EdgeInsets.only(left: 10.0, right: 4.0),
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
    this.autoCorrect = false,
    this.hideSearchButton = false,
    this.ignoreWhiteSpace = false,
    this.ignoreSpecialChar = false,
    this.onKeywordChanged,
    this.onSearchButtonPressed
  })  : assert(borderWidth != null && elevation >= 0.0),
        assert(elevation != null && elevation >= 0.0),
        assert(cursorWidth != null && cursorWidth >= 0.0),
        assert(hideSearchButton != null),
        assert(ignoreWhiteSpace != null),
        assert(ignoreSpecialChar != null),
        super(key: key);

  @override
  _OutlineSearchBarState createState() => _OutlineSearchBarState();
}

/// Class to control the state of [OutlineSearchBar].
class _OutlineSearchBarState extends State<OutlineSearchBar> with TickerProviderStateMixin {
  TextEditingController _textEditingController;

  AnimationController _animationController;
  Animation<double> _curvedAnimation;
  bool _isShowingClearButton = false;

  Color _themeColor;

  @override
  void initState() {
    super.initState();
    _textEditingController = widget.textEditingController;
    if (_textEditingController == null)
      _textEditingController = TextEditingController();

    if (_textEditingController.text.isEmpty && widget.initText != null)
      _textEditingController.text = widget.initText;

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
  }

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.light)
      _themeColor = Theme.of(context).primaryColor;
    else
      _themeColor = Theme.of(context).accentColor;

    return Padding(
      padding: widget.margin,
      child: Material(
        elevation: widget.elevation,
        borderRadius: widget.borderRadius,
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: SearchBarDefaultHeight,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor ?? _themeColor,
              width: widget.borderWidth
            ),
            borderRadius: widget.borderRadius
          ),
          child: Row(
            children: [
              Expanded(child: _buildTextField()),
              FadeTransition(
                opacity: _curvedAnimation,
                child: _buildClearButton()
              ),
              (widget.hideSearchButton)
                  ? SizedBox()
                  : _buildSearchButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return SimpleTextField(
      controller: _textEditingController,
      textInputAction: TextInputAction.search,
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
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        counterText: '',
        contentPadding: const EdgeInsets.only(),
        isDense: true,
        removeBorder: true
      ),
      onChanged: (String value) {
        if (value.isEmpty && _isShowingClearButton) {
          _isShowingClearButton = false;
          _animationController.reverse();
        } else if (value.isNotEmpty && !_isShowingClearButton) {
          _isShowingClearButton = true;
          _animationController.forward();
        }

        if (widget.onKeywordChanged != null)
          widget.onKeywordChanged(value);
      },
      onSubmitted: (String value) {
        if (widget.onSearchButtonPressed != null)
          widget.onSearchButtonPressed(value);
      },
    );
  }

  Widget _buildClearButton() {
    final clearIcon = Icon(Icons.clear,
        size: 18.0, color: widget.clearButtonIconColor);

    return SizedBox(
      width: ActionButtonDefaultSize,
      height: ActionButtonDefaultSize,
      child: InkWell(
        child: Container(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: widget.clearButtonColor,
            borderRadius: BorderRadius.circular(clearIcon.size)
          ),
          child: clearIcon
        ),
        onTap: () {
          Future.microtask(_textEditingController.clear);
          _isShowingClearButton = false;
          _animationController.reverse();

          if (widget.onKeywordChanged != null)
            widget.onKeywordChanged('');
        }
      ),
    );
  }

  Widget _buildSearchButton() {
    final searchIcon = Icon(Icons.search,
        size: 30.0, color: widget.searchButtonIconColor ?? _themeColor);

    return SizedBox(
      width: ActionButtonDefaultSize,
      height: ActionButtonDefaultSize,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: widget.searchButtonSplashColor,
          borderRadius: BorderRadius.circular(searchIcon.size),
          child: searchIcon,
          onTap: () {
            if (widget.onSearchButtonPressed != null) {
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onSearchButtonPressed(_textEditingController.text);
            }
          }
        ),
      ),
    );
  }
}