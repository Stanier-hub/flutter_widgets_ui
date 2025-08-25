import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter_widgets_ui/commons/cores_padrao_ui.dart';
import 'package:flutter_widgets_ui/commons/models/mensagem_erro_request.dart';
import 'package:flutter_widgets_ui/commons/models/model.dart';
import 'package:flutter_widgets_ui/service/servico_padrao.dart';
import 'package:flutter_widgets_ui/commons/widgets/Base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Callback que retorna um bool opcional, usada para ações especiais antes do salvamento.
/// Se retornar false, impede que o salvamento continue.
typedef AcaoEspecialCallBack<T> = bool? Function();

/// Callback opcional para executar uma ação personalizada usando o serviço e o modelo.
/// Pode ser usada, por exemplo, para chamar métodos do serviço além de criar/atualizar.
typedef AcaoServicoPersonalizada<T extends Model, S extends SevicePadrao> = Future<void> Function(S servico, T? modelo);

/// Callback que retorna um modelo [T] opcional, usada para buscar um modelo existente.
typedef BuscarModeloCallBack<T> = T? Function();

/// Callback para construir os dados que serão enviados para criação ou atualização,
/// deve retornar um mapa com os pares chave/valor correspondentes aos dados do formulário.
typedef ConstruirDadosCallback = Map<String, dynamic> Function();

/// Callback chamada ao concluir a operação de salvar (criar ou atualizar).
typedef AoConcluirCallBack<T> = void Function(T? modelo);

/// Callback que retorna um booleano para permitir ou não salvar (ex: validação extra).
typedef OnPodeSalvar = bool Function();

/// Widget genérico para formulários que manipulem modelos [T] e usem serviços [S].
///
/// Este widget permite construir um formulário flexível e reutilizável que pode criar ou atualizar
/// modelos que estendam [Model], usando um serviço que implemente [SevicePadrao].
///
/// O formulário exibe campos personalizados, botões e lida com validações e feedback visual.
///
/// Parâmetros:
/// - `modelo`: Instância do modelo [T] que será editado. Se nulo, o formulário criará um novo modelo.
/// - `acaoEspecialCallBack`: Callback que pode executar uma ação especial antes do salvamento. Retornar
///    false cancela o salvamento.
/// - `acaoServicoPersonalizada`: Callback opcional para executar uma ação personalizada usando o serviço e o modelo.
/// - `buscaModelo`: Callback para retornar uma instância do modelo [T], caso `modelo` seja nulo.
/// - `servico`: Serviço responsável por criar e atualizar o modelo. Deve implementar [SevicePadrao].
/// - `campos`: Lista de widgets que compõem os campos do formulário.
/// - `textoBotao`: Texto exibido no botão de salvar. Padrão é 'Salvar'.
/// - `construirDados`: Função que retorna um mapa com os dados que serão usados para criar ou atualizar o modelo.
/// - `aoConcluir`: Callback executado após o término do processo de salvar, independentemente do sucesso.
/// - `onPodeSalvar`: Callback que retorna um booleano para permitir ou bloquear o salvamento (ex: validações adicionais).
/// - `backgroundColor`: Cor de fundo do botão salvar.
/// - `corTextoBotaoSalvar`: Cor do texto do botão salvar.
///
/// Exemplo básico de uso:
/// ```dart
/// FormularioGenerico<Cliente, ClienteService>(
///   modelo: clienteExistente,
///   servico: clienteService,
///   campos: [
///     TextFormField(...),
///     // outros campos
///   ],
///   construirDados: () => {
///     'nome': nomeController.text,
///     'idade': idadeController.text,
///   },
///   aoConcluir: (modeloSalvo) {
///     // ação após salvar
///   },
/// );
/// ```

class FormularioGenerico<T extends Model, S extends SevicePadrao> extends StatefulWidget {
  /// Modelo atual que será editado ou salvo.
  final T? modelo;

  /// Callback executado antes do salvamento para executar alguma ação especial.
  /// Se retornar false, o salvamento é cancelado.
  final AcaoEspecialCallBack? acaoEspecialCallBack;

  /// Callback opcional para executar uma ação personalizada usando o serviço e o modelo.
  /// Pode ser usada, por exemplo, para chamar métodos do serviço além de criar/atualizar.
  final AcaoServicoPersonalizada<T, S>? acaoServicoPersonalizada;

  /// Callback para buscar o modelo caso `modelo` seja null.
  final BuscarModeloCallBack<T>? buscaModelo;

  /// Serviço responsável por criar e atualizar o modelo.
  final S? servico;

  /// Lista de campos (widgets) que compõem o formulário.
  final List<Widget> campos;

  /// Texto exibido no botão de salvar. Padrão: 'Salvar'.
  final String? textoBotao;

  /// Função que retorna os dados que serão usados para criar/atualizar o modelo.
  final ConstruirDadosCallback construirDados;

  /// Callback chamado ao concluir o processo de salvar.
  final AoConcluirCallBack<T>? aoConcluir;

  /// Callback que indica se é possível salvar ou não. Pode ser usado para validações extras.
  final OnPodeSalvar? onPodeSalvar;

  /// Cor de fundo do botão salvar.
  final Color? backgroundColor;

  /// Cor do texto do botão salvar.
  final Color? corTextoBotaoSalvar;

  const FormularioGenerico({
    super.key,
    this.modelo,
    this.acaoEspecialCallBack,
    this.acaoServicoPersonalizada,
    this.buscaModelo,
    required this.servico,
    required this.campos,
    this.textoBotao,
    required this.construirDados,
    this.aoConcluir,
    this.onPodeSalvar,
    this.backgroundColor,
    this.corTextoBotaoSalvar,
  });

  @override
  State<FormularioGenerico<T, S>> createState() => _FormularioGenericoState<T, S>();
}

class _FormularioGenericoState<T extends Model, S extends SevicePadrao> extends State<FormularioGenerico<T, S>> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPrimeiroErro() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final erroElements = <FormFieldState>[];

      void collectErrors(Element element) {
        if (element.widget is FormField && element is StatefulElement) {
          final state = element.state as FormFieldState;
          if (state.hasError) {
            erroElements.add(state);
          }
        }
        element.visitChildren(collectErrors);
      }

      _formKey.currentContext?.visitChildElements(collectErrors);

      if (erroElements.isNotEmpty && _scrollController.hasClients) {
        final firstError = erroElements.first;
        final renderObject = firstError.context.findRenderObject();
        if (renderObject != null && renderObject is RenderBox) {
          final scrollableBox = _scrollController.position.context.storageContext.findRenderObject();
          if (scrollableBox is RenderBox) {
            final offset = RenderAbstractViewport.of(renderObject).getOffsetToReveal(renderObject, 0.1).offset;
            _scrollController.animateTo(
              offset.clamp(_scrollController.position.minScrollExtent, _scrollController.position.maxScrollExtent),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Base(
      paddingBase: const EdgeInsets.only(top: 10),
      componente: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [...widget.campos.map((campo) => Padding(padding: const EdgeInsets.all(10), child: campo))],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    _scrollToPrimeiroErro();
                    return; // Se o formulário não for válido, não prossegue.
                  }

                  final bool podeContinuar = widget.acaoEspecialCallBack?.call() ?? true;
                  if (!podeContinuar) return;

                  final T? modelo = widget.modelo ?? widget.buscaModelo?.call();
                  final S? servico = widget.servico;

                  try {
                    if (servico != null) {
                      if (widget.acaoServicoPersonalizada != null) {
                        await widget.acaoServicoPersonalizada!.call(servico, modelo);
                        return;
                      }
                      if (modelo == null) {
                        final T novoModelo = await servico.criar(dados: widget.construirDados());
                        _Mensagem.exibir<T>(context: context, modelo: novoModelo, tipo: 'criada');
                        widget.aoConcluir?.call(novoModelo ?? modelo);
                      } else {
                        final Map<String, dynamic> dados = widget.construirDados();

                        final T? modeloAtualizado = await servico.atualizar(
                          modelo: modelo,
                          dados: dados.isEmpty ? modelo.toJson() : dados,
                        );

                        _Mensagem.exibir<T>(context: context, modelo: modeloAtualizado ?? modelo, tipo: 'atualizada');
                        widget.aoConcluir?.call(modeloAtualizado ?? modelo);
                      }
                      return;
                    }
                  } on HttpException catch (e) {
                    final MensagemErroRequest erro = MensagemErroRequest.fromJson(jsonDecode(e.message));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(erro.mensagem), backgroundColor: Colors.red));
                  } catch (erro, stackTrace) {
                    if (kDebugMode) {
                      print('Erro genérico: "$erro".');
                      print('Stack trace:\n$stackTrace');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: widget.backgroundColor ?? CoresPadraoUi.ascent),
                child: Text(
                  widget.textoBotao ?? 'Salvar',
                  style: TextStyle(color: widget.corTextoBotaoSalvar ?? CoresPadraoUi.whiteSmoke),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Helper para exibir mensagens de sucesso após criar/atualizar modelos.
///
/// Exibe um [SnackBar] com mensagem apropriada com base no nome do modelo e tipo de ação.
class _Mensagem {
  static void exibir<T extends Model>({
    required BuildContext context,
    required T? modelo,
    Color cor = Colors.green,
    String? mensagem,
    required String tipo,
  }) {
    late final String texto;
    if (modelo == null) {
      texto = mensagem ?? '';
    } else {
      texto =
          "${modelo.modeloString} ${modelo.modeloString.endsWith('a') ? tipo : tipo.replaceFirst(RegExp(r'.$'), 'o')} com sucesso";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto), backgroundColor: cor));
  }
}
