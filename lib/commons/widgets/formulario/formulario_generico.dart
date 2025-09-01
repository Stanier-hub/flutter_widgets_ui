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
typedef AcaoServicoPersonalizada<T extends Model, S> = Future<void> Function(S servico, T? modelo);

/// Callback que retorna um modelo [T] opcional, usada para buscar um modelo existente.
typedef BuscarModeloCallBack<T> = T? Function();

/// Callback para construir os dados que serão enviados para criação ou atualização,
/// deve retornar um mapa com os pares chave/valor correspondentes aos dados do formulário.
typedef ConstruirDadosCallback = Map<String, dynamic> Function();

/// Callback chamada ao concluir a operação de salvar (criar ou atualizar).
typedef AoConcluirCallBack<T> = void Function(T? modelo);

/// Callback que retorna um booleano para permitir ou não salvar (ex: validação extra).
typedef OnPodeSalvar = bool Function();

/// Callback para criação customizada quando o serviço não for [SevicePadrao].
typedef OnCriarCustom<T extends Model> = Future<T> Function(Map<String, dynamic> dados);

/// Callback para atualização customizada quando o serviço não for [SevicePadrao].
typedef OnAtualizarCustom<T extends Model> = Future<T> Function(T modelo, Map<String, dynamic> dados);

/// Widget genérico para formulários que manipulem modelos [T] e usem serviços [S].
///
/// Este widget permite construir um formulário flexível e reutilizável que pode criar ou atualizar
/// modelos que estendam [Model], usando:
/// - Um serviço que implemente [SevicePadrao] (fluxo padrão com `criar` e `atualizar`);
/// - Ou um serviço customizado, passando `onCriar` e `onAtualizar`.
///
/// O formulário exibe campos personalizados, botões e lida com validações e feedback visual.
///
/// Parâmetros:
/// - `modelo`: Instância do modelo [T] que será editado. Se nulo, o formulário criará um novo modelo.
/// - `acaoEspecialCallBack`: Callback que pode executar uma ação especial antes do salvamento. Retornar
///    false cancela o salvamento.
/// - `acaoServicoPersonalizada`: Callback opcional para executar uma ação personalizada usando o serviço e o modelo.
/// - `buscaModelo`: Callback para retornar uma instância do modelo [T], caso `modelo` seja nulo.
/// - `servico`: Serviço responsável por criar e atualizar o modelo. Pode ser padrão ou customizado.
/// - `onCriar`: Função customizada para criação de modelo (usada se `servico` não for [SevicePadrao]).
/// - `onAtualizar`: Função customizada para atualização de modelo (usada se `servico` não for [SevicePadrao]).
/// - `campos`: Lista de widgets que compõem os campos do formulário.
/// - `textoBotao`: Texto exibido no botão de salvar. Padrão é 'Salvar'.
/// - `construirDados`: Função que retorna um mapa com os dados que serão usados para criar ou atualizar o modelo.
/// - `aoConcluir`: Callback executado após o término do processo de salvar, independentemente do sucesso.
/// - `onPodeSalvar`: Callback que retorna um booleano para permitir ou bloquear o salvamento (ex: validações adicionais).
/// - `backgroundColor`: Cor de fundo do botão salvar.
/// - `corTextoBotaoSalvar`: Cor do texto do botão salvar.
///
/// Exemplo com serviço padrão:
/// ```dart
/// FormularioGenerico<Cliente, ClienteService>(
///   modelo: clienteExistente,
///   servico: clienteService,
///   campos: [
///     TextFormField(...),
///   ],
///   construirDados: () => {
///     'nome': nomeController.text,
///   },
///   aoConcluir: (modeloSalvo) {
///     print("Cliente salvo: ${modeloSalvo?.toJson()}");
///   },
/// );
/// ```
///
/// Exemplo com serviço customizado:
/// ```dart
/// FormularioGenerico<Usuario, MeuServicoCustom>(
///   servico: MeuServicoCustom(),
///   onCriar: (dados) async => Usuario.fromJson(await api.post("/usuarios", body: dados)),
///   onAtualizar: (usuario, dados) async => Usuario.fromJson(await api.put("/usuarios/${usuario.id}", body: dados)),
///   campos: [
///     TextFormField(...),
///   ],
///   construirDados: () => {
///     "email": emailController.text,
///   },
///   aoConcluir: (usuario) => print("Usuário salvo: ${usuario?.toJson()}"),
/// );
/// ```

/// Widget genérico para formulários que manipulem modelos [T] e usem serviços [S].
///
/// Este widget permite construir um formulário flexível e reutilizável que pode criar ou atualizar
/// modelos que estendam [Model], usando:
/// - Um serviço que implemente [SevicePadrao] (fluxo padrão com `criar` e `atualizar`);
/// - Ou um serviço customizado, passando `onCriar` e `onAtualizar`.
///
/// O formulário exibe campos personalizados, botões e lida com validações e feedback visual.
///
/// Parâmetros:
/// - `modelo`: Instância do modelo [T] que será editado. Se nulo, o formulário criará um novo modelo.
/// - `acaoEspecialCallBack`: Callback que pode executar uma ação especial antes do salvamento. Retornar
///    false cancela o salvamento.
/// - `acaoServicoPersonalizada`: Callback opcional para executar uma ação personalizada usando o serviço e o modelo.
/// - `buscaModelo`: Callback para retornar uma instância do modelo [T], caso `modelo` seja nulo.
/// - `servico`: Serviço responsável por criar e atualizar o modelo. Pode ser padrão ou customizado.
/// - `onCriar`: Função customizada para criação de modelo (usada se `servico` não for [SevicePadrao]).
/// - `onAtualizar`: Função customizada para atualização de modelo (usada se `servico` não for [SevicePadrao]).
/// - `campos`: Lista de widgets que compõem os campos do formulário.
/// - `textoBotao`: Texto exibido no botão de salvar. Padrão é 'Salvar'.
/// - `construirDados`: Função que retorna um mapa com os dados que serão usados para criar ou atualizar o modelo.
/// - `aoConcluir`: Callback executado após o término do processo de salvar, independentemente do sucesso.
/// - `onPodeSalvar`: Callback que retorna um booleano para permitir ou bloquear o salvamento (ex: validações adicionais).
/// - `backgroundColor`: Cor de fundo do botão salvar.
/// - `corTextoBotaoSalvar`: Cor do texto do botão salvar.
///
/// Exemplo com serviço padrão:
/// ```dart
/// FormularioGenerico<Cliente, ClienteService>(
///   modelo: clienteExistente,
///   servico: clienteService,
///   campos: [
///     TextFormField(...),
///   ],
///   construirDados: () => {
///     'nome': nomeController.text,
///   },
///   aoConcluir: (modeloSalvo) {
///     print("Cliente salvo: \\${modeloSalvo?.toJson()}");
///   },
/// );
/// ```
///
/// Exemplo com serviço customizado:
/// ```dart
/// FormularioGenerico<Usuario, MeuServicoCustom>(
///   servico: MeuServicoCustom(),
///   onCriar: (dados) async => Usuario.fromJson(await api.post("/usuarios", body: dados)),
///   onAtualizar: (usuario, dados) async => Usuario.fromJson(await api.put("/usuarios/\\${usuario.id}", body: dados)),
///   campos: [
///     TextFormField(...),
///   ],
///   construirDados: () => {
///     "email": emailController.text,
///   },
///   aoConcluir: (usuario) => print("Usuário salvo: \\${usuario?.toJson()}"),
/// );
/// ```
class FormularioGenerico<T extends Model, S> extends StatefulWidget {
  final T? modelo;
  final AcaoEspecialCallBack? acaoEspecialCallBack;
  final AcaoServicoPersonalizada<T, S>? acaoServicoPersonalizada;
  final BuscarModeloCallBack<T>? buscaModelo;
  final S? servico;
  final OnCriarCustom<T>? onCriar;
  final OnAtualizarCustom<T>? onAtualizar;
  final List<Widget> campos;
  final String? textoBotao;
  final ConstruirDadosCallback? construirDados;
  final AoConcluirCallBack<T>? aoConcluir;
  final OnPodeSalvar? onPodeSalvar;
  final Color? backgroundColor;
  final Color? corTextoBotaoSalvar;

  /// Construtor privado: só usado pelas fábricas
  const FormularioGenerico._({
    super.key,
    this.modelo,
    this.acaoEspecialCallBack,
    this.acaoServicoPersonalizada,
    this.buscaModelo,
    this.servico,
    this.onCriar,
    this.onAtualizar,
    required this.campos,
    this.textoBotao,
    this.construirDados,
    this.aoConcluir,
    this.onPodeSalvar,
    this.backgroundColor,
    this.corTextoBotaoSalvar,
  });

  /// para serviços que estendem [SevicePadrao].
  factory FormularioGenerico.comServicoPadrao({
    Key? key,
    T? modelo,
    required S servico,
    required List<Widget> campos,
    ConstruirDadosCallback? construirDados,
    AoConcluirCallBack<T>? aoConcluir,
    AcaoEspecialCallBack? acaoEspecialCallBack,
    AcaoServicoPersonalizada<T, S>? acaoServicoPersonalizada,
    BuscarModeloCallBack<T>? buscaModelo,
    String? textoBotao,
    Color? backgroundColor,
    Color? corTextoBotaoSalvar,
  }) {
    if (servico is! SevicePadrao) {
      throw ArgumentError("O serviço precisa implementar SevicePadrao");
    }
    return FormularioGenerico._(
      key: key,
      modelo: modelo,
      servico: servico,
      campos: campos,
      construirDados: construirDados,
      aoConcluir: aoConcluir,
      acaoEspecialCallBack: acaoEspecialCallBack,
      acaoServicoPersonalizada: acaoServicoPersonalizada,
      buscaModelo: buscaModelo,
      textoBotao: textoBotao,
      backgroundColor: backgroundColor,
      corTextoBotaoSalvar: corTextoBotaoSalvar,
    );
  }

  /// 🏭 Fábrica para cenários customizados (sem [SevicePadrao]).
  factory FormularioGenerico.comServicoCustom({
    Key? key,
    T? modelo,
    required List<Widget> campos,
    required OnCriarCustom<T> onCriar,
    required OnAtualizarCustom<T> onAtualizar,
    ConstruirDadosCallback? construirDados,
    AoConcluirCallBack<T>? aoConcluir,
    BuscarModeloCallBack<T>? buscaModelo,
    String? textoBotao,
    Color? backgroundColor,
    Color? corTextoBotaoSalvar,
  }) {
    return FormularioGenerico._(
      key: key,
      modelo: modelo,
      campos: campos,
      onCriar: onCriar,
      onAtualizar: onAtualizar,
      construirDados: construirDados,
      aoConcluir: aoConcluir,
      buscaModelo: buscaModelo,
      textoBotao: textoBotao,
      backgroundColor: backgroundColor,
      corTextoBotaoSalvar: corTextoBotaoSalvar,
    );
  }

  /// 🏭 Fábrica para modo somente visualização.
  factory FormularioGenerico.visualizacao({
    Key? key,
    required List<Widget> campos,
    AoConcluirCallBack<T>? aoConcluir,
  }) {
    return FormularioGenerico._(
      key: key,
      campos: campos,
      aoConcluir: aoConcluir,
      construirDados: null,
      textoBotao: null, // sem botão
    );
  }

  @override
  State<FormularioGenerico<T, S>> createState() => _FormularioGenericoState<T, S>();
}

class _FormularioGenericoState<T extends Model, S> extends State<FormularioGenerico<T, S>> {
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
                  final dados = widget.construirDados != null ? widget.construirDados!() : <String, dynamic>{};

                  try {
                    T? resultado;

                    if (servico is SevicePadrao) {
                      // Caso seja um serviço padrão
                      if (widget.acaoServicoPersonalizada != null) {
                        await widget.acaoServicoPersonalizada!.call(servico, modelo);
                        return;
                      }
                      if (modelo == null) {
                        resultado = await servico.criar(dados: dados);
                        if (!context.mounted) return;
                        _Mensagem.exibir<T>(context, modelo: resultado, tipo: 'criada');
                      } else {
                        resultado = await servico.atualizar(
                          modelo: modelo,
                          dados: dados.isEmpty ? modelo.toJson() : dados,
                        );
                        if (!context.mounted) return;
                        _Mensagem.exibir<T>(context, modelo: resultado ?? modelo, tipo: 'atualizada');
                      }
                    } else {
                      // Caso seja serviço customizado
                      if (modelo == null) {
                        if (widget.onCriar == null) {
                          throw Exception("Você precisa fornecer 'onCriar' ao usar um serviço customizado");
                        }
                        resultado = await widget.onCriar!(dados);
                        if (!context.mounted) return;
                        _Mensagem.exibir<T>(context, modelo: resultado, tipo: 'criada');
                      } else {
                        if (widget.onAtualizar == null) {
                          throw Exception("Você precisa fornecer 'onAtualizar' ao usar um serviço customizado");
                        }
                        resultado = await widget.onAtualizar!(modelo, dados);
                        if (!context.mounted) return;
                        _Mensagem.exibir<T>(context, modelo: resultado, tipo: 'atualizada');
                      }
                    }

                    if (resultado != null) {
                      widget.aoConcluir?.call(resultado);
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
  static void exibir<T extends Model>(
    BuildContext context, {
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
