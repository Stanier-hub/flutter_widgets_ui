import 'package:flutter/material.dart';

/// Um widget personalizado que exibe um campo de seleção com um rótulo, ícone de prefixo e uma lista de itens.
///
/// Parâmetros:
///
/// - `rotulo`: O texto do rótulo exibido acima do campo de seleção.
/// - `iconePrefixo`: O ícone exibido no início do campo de seleção.
/// - `valor`: O valor atualmente selecionado no campo de seleção.
/// - `itens`: A lista de itens que podem ser selecionados.
/// - `aoMudar`: Callback que é chamado quando o valor selecionado muda.
/// - `descricao`: Função que retorna a descrição de um item para exibição no menu suspenso.
class CampoSelecao<T> extends StatelessWidget {
  final String rotulo;
  final IconData iconePrefixo;
  final T valor;
  final List<T> itens;
  final ValueChanged<T?> aoMudar;
  final String Function(T) descricao;

  const CampoSelecao({
    super.key,
    required this.rotulo,
    required this.iconePrefixo,
    required this.valor,
    required this.itens,
    required this.aoMudar,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: rotulo,
        prefixIcon: Icon(iconePrefixo),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      value: valor,
      items: itens.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(descricao(item)),
        );
      }).toList(),
      onChanged: aoMudar,
    );
  }
}
