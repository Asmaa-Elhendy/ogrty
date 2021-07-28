import 'package:flutter/material.dart';

class EntryField extends StatefulWidget {
  final String hintText;
  final String suffixText;
  final Color hintColor;
  final String label;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final Function onTap;
  final Function onChange;
  final Function validation;
  final Function onComplete;
  final EdgeInsetsGeometry padding;
  final TextStyle hintStyle;
  final bool readOnly;
  final num width;
  final EdgeInsets labelFieldPadding;
  final String initialValue;
  final TextInputType textInputType;
  EntryField(
      {this.hintText,
      this.suffixText,
      this.hintColor,
      this.label,
      this.prefixIcon,
      this.padding,
      this.suffixIcon,
      this.onTap,
      this.hintStyle,
      this.readOnly,
      this.width,
      this.labelFieldPadding,
      this.initialValue,
      this.validation,
      this.onChange,
      this.onComplete,
      this.textInputType});

  @override
  _EntryFieldState createState() => _EntryFieldState();
}

class _EntryFieldState extends State<EntryField> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: widget.padding ?? EdgeInsets.all(14.0),
      child: SizedBox(
        width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
        height: 55,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.label != null
                ? Text(
                    widget.label,
                    style: theme.textTheme.subtitle2
                        .copyWith(color: theme.hintColor, fontSize: 12),
                  )
                : SizedBox.shrink(),
            TextFormField(
              onChanged: widget.onChange,
              keyboardType: widget.textInputType,
              onSaved: widget.onComplete,
              validator: widget.validation,
              style: theme.textTheme.subtitle2.copyWith(fontSize: 20),
              initialValue: widget.initialValue,
              readOnly: widget.readOnly ?? false,
              onTap: widget.onTap,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: widget.labelFieldPadding,
                prefixIcon: widget.prefixIcon,
                //counterText: 'hello',
                //prefixText: 'Hello',
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    theme.textTheme.subtitle2.copyWith(
                      color: widget.hintColor,
                    ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.hintColor, width: 0.5),
                ),
                suffixIcon: widget.suffixIcon ??
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        widget.suffixText ?? '',
                        style: theme.textTheme.subtitle2
                            .copyWith(color: theme.primaryColor, fontSize: 15),
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
