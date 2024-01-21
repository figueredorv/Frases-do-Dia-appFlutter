import 'dart:async'; // Importe a biblioteca dart:async para lidar com operações assíncronas
import 'package:flutter/material.dart';
import 'frases.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Versiculo versiculoAtual = Versiculo("", ""); // Inicialize com valores padrão

  @override
  void initState() {
    super.initState();
    carregarVersiculo();
  }

  Future<void> carregarVersiculo() async {
    try {
      final versiculo = await Frases.gerarVersiculo();
      setState(() {
        versiculoAtual = versiculo;
      });
    } catch (e) {
      print('Erro ao carregar versículo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Build chamado");

    return Scaffold(
      appBar: AppBar(
        title: Text("FRASES DO DIA", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset('images/logo.png'),
              ),
              Padding(
                padding: EdgeInsets.all(1),
                
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          versiculoAtual.texto,
                          style: TextStyle(fontSize: 25),
                        ),
                        subtitle: Text(
                          versiculoAtual.referencia,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ButtonBar(
                        children: <Widget>[
                          Ink(
                            decoration: ShapeDecoration(
                              color: Colors.transparent,
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {
                                print('Compartilhando...');
                                exibirSnackbar(context);
                              },
                              color: Colors.black,
                              
                            ),
                          ),
                          Ink(
                            decoration: ShapeDecoration(
                              color: const Color.fromARGB(0, 251, 250, 250),
                              shape: CircleBorder(),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.favorite),
                              onPressed: () {
                                print('Favoritado!');
                                exibirSnackbar(context);
                              },
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
               SizedBox(height: 15), // Adiciona espaçamento entre o Card e o botão
              Tooltip(
                message: 'Clique para gerar uma frase',
                child: ElevatedButton(
                  onPressed: () {
                    carregarVersiculo();
                    print("Frase gerada");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.green,
                    ),
                  ),
                  child: Text(
                    "Clique aqui",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
               SizedBox(height: 15), // Adiciona espaçamento após o botão
            ],
          ),
        ),
      ),
    );
  }
}

void exibirSnackbar(BuildContext context) {
    // Cria uma instância de Snackbar
    final snackbar = SnackBar(
      content: Text('Recurso em breve!'),
      duration: Duration(seconds: 3), // Defina a duração da mensagem
      
    );

    // Exibe a Snackbar na tela
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }