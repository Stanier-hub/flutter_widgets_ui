import 'package:flutter/material.dart';

class Base extends StatefulWidget {
  final Widget componente;
  final EdgeInsetsGeometry? paddingBase;
  const Base({
    super.key,
    required this.componente,
    this.paddingBase,
  });

  @override
  _BaseState createState() => _BaseState();
}

class _BaseState extends State<Base> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.paddingBase ??
          const EdgeInsets.only(
            top: 10,
            left: 15,
            right: 15,
            bottom: 10,
          ),
      child: widget.componente,
    );
  }
}
