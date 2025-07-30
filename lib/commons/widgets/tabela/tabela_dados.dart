import 'package:flutter/material.dart';

// Definindo o tipo TabelaLinha para ser uma função que retorna um TableRow
typedef TabelaLinha<T> = List<TabelaCelula> Function(BuildContext context, T item);

// Componente TabelaDados - Aceita listas de TabelaColuna e TabelaLinha, com dados em células.
class TabelaDados<T> extends StatelessWidget {
  final List<T> dados; // Lista de dados genéricos (T)
  final List<TabelaColuna>
  colunas; // Lista de TabelaColuna, para definir o cabeçalho da tabela
  final TabelaLinha<T> linhaDados; // Função para construir cada linha
  final String textoTabelaVazia;
  final bool ehCarregando;
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
              
              // border: const TableBorder(

              //   horizontalInside: BorderSide(
              //     width: 1,
              //     style: BorderStyle.solid,
              //     color: Colors.black,
              //   ),
              // ),
                columnWidths: {
                for (int i = 0; i < colunas.length; i++) 
                  i: FlexColumnWidth(tamanhosColunas.isNotEmpty && i < tamanhosColunas.length ? tamanhosColunas[i] : 1),
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
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
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
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
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
        offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      children: colunas,
    );
  }
}
