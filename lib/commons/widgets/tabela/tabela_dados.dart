import 'package:flutter/material.dart';

// Definindo o tipo TabelaLinha para ser uma função que retorna um TableRow
typedef TabelaLinha<T> =
    List<TabelaCelula> Function(BuildContext context, T item);

/// Componente genérico de tabela para exibir dados em linhas e colunas personalizáveis.
///
/// Este widget recebe uma lista de dados genéricos [T], uma lista de colunas do tipo [TabelaColuna],
/// e uma função [linhaDados] que constrói as células de cada linha a partir do dado.
///
/// Suporta exibição de mensagem quando a tabela está vazia, além de indicador de carregamento.
///
/// Parâmetros principais:
/// - `dados`: lista de dados a serem exibidos na tabela.
/// - `colunas`: lista das colunas que definem o cabeçalho da tabela.
/// - `linhaDados`: função que recebe o contexto e um item da lista e retorna a lista de células para aquela linha.
/// - `textoTabelaVazia`: texto a ser exibido quando não há dados (default: "Nenhum dado encontrado").
/// - `ehCarregando`: indica se a tabela está em estado de carregamento para mostrar o indicador.
/// - `tamanhosColunas`: lista de pesos para largura flexível de cada coluna.
///
/// O widget usa um [Table] interno para layout das células, permitindo estilização e responsividade.
class TabelaDados<T> extends StatelessWidget {
  /// Lista genérica de dados que serão exibidos na tabela.
  /// Cada item dessa lista será usado para construir uma linha da tabela.
  final List<T> dados;

  /// Lista de colunas que definem o cabeçalho da tabela.
  /// Cada coluna é representada por um widget [TabelaColuna].
  final List<TabelaColuna> colunas;

  /// Função que recebe o contexto e um item do tipo [T] e retorna a lista de células ([TabelaCelula])
  /// correspondentes àquela linha da tabela.
  /// Usada para construir dinamicamente o conteúdo de cada linha.
  final TabelaLinha<T> linhaDados;

  /// Texto exibido quando a tabela não contém nenhum dado.
  /// Valor padrão: "Nenhum dado encontrado".
  final String textoTabelaVazia;

  /// Indicador booleano que define se a tabela está em estado de carregamento.
  /// Quando verdadeiro, exibe um [CircularProgressIndicator].
  final bool ehCarregando;

  /// Lista de pesos flexíveis para definir as larguras relativas das colunas.
  /// Se vazia, todas as colunas terão peso 1 igual.
  final List<double> tamanhosColunas;

  const TabelaDados({
    super.key,
    required this.dados,
    required this.colunas,
    required this.linhaDados,
    this.ehCarregando = false,
    this.textoTabelaVazia = "Nenhum dado encontrado",
    this.tamanhosColunas = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Table(
              // TODO: Implementar bordas personalizaveis e genéricas
              // border: const TableBorder(

              //   horizontalInside: BorderSide(
              //     width: 1,
              //     style: BorderStyle.solid,
              //     color: Colors.black,
              //   ),
              // ),
              columnWidths: {
                for (int i = 0; i < colunas.length; i++)
                  i: FlexColumnWidth(
                    tamanhosColunas.isNotEmpty && i < tamanhosColunas.length
                        ? tamanhosColunas[i]
                        : 1,
                  ),
              },
              children: [
                // Cabeçalho da tabela
                Colunas.builder(colunas),
                // Gerando as linhas com base nos dados
                ...List.generate(dados.length, (index) {
                  final item = dados[index];
                  return TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    children: linhaDados(context, item),
                  );
                }),
              ],
            ),
            const SizedBox(height: 10),
            if (ehCarregando) const CircularProgressIndicator(),
            if (dados.isEmpty && !ehCarregando)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  textoTabelaVazia,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Componente TabelaColuna - Representa uma coluna no cabeçalho da tabela
class TabelaColuna extends StatelessWidget {
  final String texto;
  final bool center;
  final EdgeInsets? padding;
  final double tamanhoTexto;

  const TabelaColuna({
    super.key,
    required this.texto,
    this.center = false,
    this.padding,
    this.tamanhoTexto = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        texto,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: tamanhoTexto),
        textAlign: center ? TextAlign.center : TextAlign.start,
      ),
    );
  }
}

// Componente TabelaCelula - Cada célula da tabela
class TabelaCelula extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool herdarPaddingDaColunaNaCelula;
  final double tamanhoTexto;

  const TabelaCelula({
    super.key,
    required this.child,
    this.padding,
    this.herdarPaddingDaColunaNaCelula = false,
    this.tamanhoTexto = 12,
  });

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: child,
      ),
    );
  }
}

class Colunas {
  static TableRow builder(List<TabelaColuna> colunas) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[400]!)),
        borderRadius: BorderRadius.circular(40.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      children: colunas,
    );
  }
}
