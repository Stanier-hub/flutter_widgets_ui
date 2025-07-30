import 'package:flutter/material.dart';
import 'package:flutter_widgets_ui/commons/cores_padrao_ui.dart';
import 'package:flutter_widgets_ui/commons/widgets/buttons/button_default.dart';

class CampoData extends StatefulWidget {
  final ValueChanged<DateTime>? onChanged;
  final bool ehCompetencia; // Parâmetro para definir se é mês/ano ou calendário

  const CampoData({
    super.key,
    this.onChanged,
    this.ehCompetencia =
        false, // Se for true, exibe o modal para seleção de mês/ano
  });

  @override
  _CampoDataState createState() => _CampoDataState();
}

class _CampoDataState extends State<CampoData> {
  // Inicializa ValueNotifiers para mês e ano
  final ValueNotifier<int> mesSelecionadoNotifier = ValueNotifier<int>(
    DateTime.now().month,
  );
  final ValueNotifier<int> anoSelecionadoNotifier = ValueNotifier<int>(
    DateTime.now().year,
  );
  final ValueNotifier<DateTime> dataSelecionadaNotifier =
      ValueNotifier<DateTime>(DateTime.now());

  // Método para exibir o calendário completo
  Future<void> _abrirCalendario(BuildContext context) async {
    
    final DateTime? dataEscolhida = await showDatePicker(
      context: context,
      initialDate: dataSelecionadaNotifier.value,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2101, 12),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataEscolhida != null) {
      dataSelecionadaNotifier.value = dataEscolhida;

      // Chama o onChanged, caso tenha sido passado
      if (widget.onChanged != null) {
        widget.onChanged!(dataSelecionadaNotifier.value);
      }
    }
  }

  // Método para exibir o modal de seleção de mês e ano
  Future<void> _abrirModalMesAno(BuildContext context) async {
    final List<String> mesesEmPortugues = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez',
    ];

    // Armazenar o valor atual da data
    final DateTime dataOriginal = DateTime(
      anoSelecionadoNotifier.value,
      mesSelecionadoNotifier.value,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceBetween,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.all(10),
          title: const Text("Selecione Mês e Ano"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Seletor de ano com ValueListenableBuilder
              ValueListenableBuilder<int>(
                valueListenable: anoSelecionadoNotifier,
                builder: (context, anoSelecionado, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () {
                          anoSelecionadoNotifier.value -= 1;
                        },
                      ),
                      Text(
                        anoSelecionado.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {
                          anoSelecionadoNotifier.value += 1;
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              // Usando Wrap para exibir os meses com ValueListenableBuilder
              ValueListenableBuilder<int>(
                valueListenable: mesSelecionadoNotifier,
                builder: (context, mesSelecionado, child) {
                  return Column(
                    children: [
                      // Gerar 3 linhas, cada uma com 4 meses
                      for (int i = 0; i < 3; i++)
                        Row(
                          children: List.generate(4, (index) {
                            int mesIndex = i * 4 + index;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  mesSelecionadoNotifier.value = mesIndex + 1;
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Card(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color:
                                            mesSelecionado == mesIndex + 1
                                                ? CoresPadraoUi.primary
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          mesesEmPortugues[mesIndex],
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                mesSelecionado == mesIndex + 1
                                                    ? Colors.grey[100]
                                                    : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            ButtonDefault(
              backgroundColor: CoresPadraoUi.ascent,
              funcaoBotao: () {
                final novaData = DateTime(
                  anoSelecionadoNotifier.value,
                  mesSelecionadoNotifier.value,
                );
                dataSelecionadaNotifier.value = novaData;

                if (widget.onChanged != null) {
                  widget.onChanged!(novaData);
                }

                Navigator.of(context).pop();
              },
              textoBotao: "Confirmar",
            ),
            ButtonDefault(
              funcaoBotao: () {
                // Restaurar a data original se o usuário cancelar
                anoSelecionadoNotifier.value = dataOriginal.year;
                mesSelecionadoNotifier.value = dataOriginal.month;

                Navigator.of(context).pop();
              },
              backgroundColor: CoresPadraoUi.error600,
              textoBotao: "Cancelar",
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      widget.onChanged!(dataSelecionadaNotifier.value);
    }
  }

  @override
  void dispose() {
    // Limpa os ValueNotifiers ao sair da tela
    mesSelecionadoNotifier.dispose();
    anoSelecionadoNotifier.dispose();
    dataSelecionadaNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: dataSelecionadaNotifier,
      builder: (_, value, __) {
        final String dataFormatada = widget.ehCompetencia
            ? "${dataSelecionadaNotifier.value.month.toString().padLeft(2, '0')}/${dataSelecionadaNotifier.value.year}"
            : "${dataSelecionadaNotifier.value.day.toString().padLeft(2, '0')}/${dataSelecionadaNotifier.value.month.toString().padLeft(2, '0')}/${dataSelecionadaNotifier.value.year}";
        return GestureDetector(
          onTap: () {
            if (widget.ehCompetencia) {
              // Se for para selecionar somente mês e ano, exibe o modal
              _abrirModalMesAno(context);
            } else {
              // Caso contrário, exibe o calendário completo
              _abrirCalendario(context);
            }
          },
          child: InputDecorator(
            decoration:  InputDecoration(
              labelText: widget.ehCompetencia ?  'Competência (Mês/Ano)': 'Data',
              border: OutlineInputBorder(),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    dataFormatada, // Exibe o mês e ano
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Colors.blue,
                ), // Ícone do calendário
              ],
            ),
          ),
        );
      },
    );
  }
}
