import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  // Defina um modelo de dados para os eventos
  final String title;
  final String? imageUrl; // Agora é opcional, pode ser nulo
  final String date;
  final String location;
  final double? price; // Preço também pode ser nulo
  final String? description; // Adicionei descrição
  final VoidCallback? onBuyTicket; // Adiciona o callback para comprar bilhete
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;

  const EventCard({
    super.key,
    required this.title,
    this.imageUrl,
    required this.date,
    required this.location,
    this.price,
    this.description,
    this.onBuyTicket, // Inicializa o callback
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3, // Adiciona uma sombra ao card
      color: backgroundColor, // Usa a cor de fundo do card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Arredonda os cantos
      child: InkWell(
        // Permite que o card seja clicável
        onTap: () {
          // TODO: Implementar a navegação para a página de detalhes do evento
          // Você pode usar Navigator.push para navegar para uma nova página
          // que mostrará os detalhes completos do evento.
          print('Card do evento "${title}" clicado!'); // Apenas para teste
          _showEventDetails(context); // Chama a função para mostrar detalhes
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Imagem do Evento (se disponível)
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null && imageUrl!.isNotEmpty // Verifica se a URL não é nula nem vazia
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Tratamento de erro: exibe um ícone se a imagem não carregar
                            return const Center(
                                child: Icon(Icons.error_outline,
                                    color: Colors.grey));
                          },
                        )
                      : const Image(
                          //caso a imageUrl seja nula ou vazia
                          image: AssetImage(
                              'assets/event_placeholder.png'), // Use uma imagem local como placeholder
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 10),
              // Coluna com os detalhes do evento
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Usa a cor do texto
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Data: $date',
                      style: TextStyle(fontSize: 14, color: textColor), // Usa a cor do texto
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Local: $location',
                      style: TextStyle(fontSize: 14, color: textColor), // Usa a cor do texto
                      overflow: TextOverflow.ellipsis, // Adiciona esta linha
                    ),
                    const SizedBox(height: 5),
                    if (price != null) // Verifica se o preço não é nulo
                      Text(
                        'Preço: ${price.toString()} €', // Formata o preço com 2 casas decimais
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      )
                    else
                      const Text(
                        'Grátis',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.green),
                      ),
                  ],
                ),
              ),
              // Botão de Comprar Bilhete (se o callback onBuyTicket for fornecido)
              if (onBuyTicket != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10), // Adiciona padding ao botão
                  child: ElevatedButton(
                    onPressed: onBuyTicket,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Usa a cor primária
                      foregroundColor: textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Bilhete'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para mostrar os detalhes do evento em uma nova página
  void _showEventDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen( // Usa a nova tela
          title: title,
          imageUrl: imageUrl,
          date: date,
          location: location,
          price: price,
          description: description,
          backgroundColor: backgroundColor,
          textColor: textColor,
          primaryColor: primaryColor,
        ),
      ),
    );
  }
}

// Nova classe para a tela de detalhes do evento
class EventDetailsScreen extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String date;
  final String location;
  final double? price;
  final String? description; // Adiciona a descrição
  final Color backgroundColor;
  final Color textColor;
  final Color primaryColor;

  const EventDetailsScreen({
    super.key,
    required this.title,
    this.imageUrl,
    required this.date,
    required this.location,
    this.price,
    this.description, // Inclui no construtor
    required this.backgroundColor,
    required this.textColor,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: textColor)), // Usa a cor do texto
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // Permite scroll se o conteúdo for muito longo
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem do Evento
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                                child: Icon(Icons.error_outline,
                                    color: Colors.grey));
                          },
                        )
                      : const Image(
                          image: AssetImage('assets/event_placeholder.png'),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Título do Evento
              Text(
                title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor), // Usa a cor do texto
              ),
              const SizedBox(height: 10),
              // Data e Local
              Row(
                children: [
                  Icon(Icons.calendar_today, color: textColor), // Usa a cor do texto
                  const SizedBox(width: 5),
                  Text(
                    'Data: $date',
                    style: TextStyle(fontSize: 16, color: textColor), // Usa a cor do texto
                  ),
                  const SizedBox(width: 20),
                  Icon(Icons.location_on, color: textColor), // Usa a cor do texto
                  const SizedBox(width: 5),
                  Expanded( // Envolve o Text em um Expanded
                    child: Text(
                      'Local: $location',
                      style: TextStyle(fontSize: 16, color: textColor), // Usa a cor do texto
                      overflow: TextOverflow.ellipsis, // Adiciona esta linha
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Preço
              if (price != null)
                Text(
                  'Preço: ${price.toString()} €',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                )
              else
                const Text(
                  'Grátis',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.green),
                ),
              const SizedBox(height: 20),
              // Descrição
              Text(
                description ??
                    'Nenhuma descrição disponível.', // Usa a descrição, ou uma mensagem padrão se for nula
                style: TextStyle(fontSize: 16, color: textColor), // Usa a cor do texto
                textAlign: TextAlign.justify, //justifica o texto
              ),
              // Adicione mais detalhes conforme necessário (ex: mapa, organizador, etc.)
            ],
          ),
        ),
      ),
    );
  }
}

