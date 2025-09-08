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
  final bool loading;

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
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        side: BorderSide(color: borderColor ?? Colors.transparent, width: borderWidth ?? 2.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 8.0)),
      ),
      onPressed: loading ? null : () => funcaoBotao.call(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (loading)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor ?? CoresPadraoUi.whiteSmoke),
                ),
              ),
            ),
          Text(
            textoBotao,
            style: TextStyle(color: textColor ?? CoresPadraoUi.whiteSmoke, fontSize: tamanhoLentra ?? 14.0),
          ),
        ],
      ),
    );
  }
}
