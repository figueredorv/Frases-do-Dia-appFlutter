import 'dart:convert';
import 'package:http/http.dart' as http;

class Versiculo {
  final String texto;
  final String referencia;

  Versiculo(this.texto, this.referencia);
}

class Frases {
  static List<Versiculo> _versiculos = [];

  static Future<void> carregarVersiculos() async {
    try {
      final response = await http.get(
        Uri.parse('https://bible-api.com/?random=verse&translation=almeida'),
      );

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is Map && data.containsKey('text')) {
          final versiculo = Versiculo(data['text'], data['reference']);
          _versiculos.add(versiculo);
        } else {
          throw Exception('Formato de dados inválido na resposta da API.');
        }
      } else {
        throw Exception('Erro ao carregar versículo bíblico. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar versículo bíblico: $e');
    }
  }

  static void limparVersiculos() {
    _versiculos.clear();
  }

  static Future<Versiculo> gerarVersiculo() async {
    if (_versiculos.isEmpty) {
      try {
        await carregarVersiculos();
      } catch (e) {
        print('Erro ao carregar versículos: $e');
        return Versiculo("Erro ao carregar versículos", "");
      }
    }

    if (_versiculos.isNotEmpty) {
      return _versiculos.removeAt(0);
    } else {
      // Se a lista ainda estiver vazia, tenta carregar novamente
      try {
        await carregarVersiculos();
      } catch (e) {
        print('Erro ao carregar versículos: $e');
        return Versiculo("Erro ao carregar versículos", "");
      }

      // Verifica se há versículos agora na lista
      if (_versiculos.isNotEmpty) {
        return _versiculos.removeAt(0);
      } else {
        // Se ainda estiver vazia, retorna um versículo padrão
        return Versiculo("Não há versículo disponível no momento.", "");
      }
    }
  }
}
