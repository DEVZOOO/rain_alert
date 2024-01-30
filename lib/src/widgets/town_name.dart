
import 'package:flutter/material.dart';

/// 동네명
class TownName extends StatelessWidget {
  const TownName(this._text, this._isSelect, this._clickHandler, this._deleteHandler);

  final String _text;
  final bool _isSelect;
  final Function() _clickHandler;
  final Function() _deleteHandler;

  @override
  Widget build(BuildContext context) {
    return _isSelect ? FilledButton(
      onPressed: _clickHandler,
      onLongPress: _deleteHandler,
      child: Text(_text),
    )
    : FilledButton.tonal(onPressed: _clickHandler, onLongPress: _deleteHandler, child: Text(_text),);

    /*
    return Padding(
      padding: const EdgeInsets.all(5),
      // text에 click 이벤트 바인딩할 경우
      child: RichText(
        text: TextSpan(
          text: _text,
          style: _isSelect ? TextStyle(decoration: TextDecoration.underline, color: Colors.black) : TextStyle(color: Colors.black),
          recognizer: TapGestureRecognizer()
          ..onTap = () {
            _clickHandler.call();
          },
        ),
      ),
    );
    */
  }
}