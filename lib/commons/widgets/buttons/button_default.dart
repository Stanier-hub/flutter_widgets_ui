import 'package:flutter/material.dart';
import 'package:flutter_widgets_ui/commons/cores_padrao_ui.dart';

class ButtonDefault extends StatelessWidget {
  final String textoBotao;
  final Function funcaoBotao;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final Color? textColor;
  final double? borderRadius;
  final double? tamanhoLentra;

  const ButtonDefault({
    super.key,
    required this.textoBotao,
    required this.funcaoBotao,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.textColor,
    this.borderRadius,
    this.tamanhoLentra,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: borderWidth ?? 2.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        ),
      ),
      onPressed: () {
        funcaoBotao.call();
      },
      child: Text(
        textoBotao,
        style: TextStyle(
            color: textColor ?? CoresPadraoUi.whiteSmoke,
          fontSize: tamanhoLentra ?? 14.0,
        ),
      ),
    );
  }
}
