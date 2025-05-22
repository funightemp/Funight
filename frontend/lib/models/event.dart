class Event {
  final int id;
  final String title;
  final String? description;
  final String date;
  final String? location;
  final String? imageUrl;
  final double? price;
  final String? userId;
  final double? latitude;
  final double? longitude;
  final bool hasTicket;

  Event({
    required this.id,
    required this.title,
    required this.date,
    this.description,
    this.location,
    this.imageUrl,
    this.price,
    this.userId,
    this.latitude,
    this.longitude,
    this.hasTicket = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception('Campo "id" ausente ou null no JSON!');
    }

    return Event(
      id: json['id'],
      title: json['titulo'] ?? 'Sem título',
      description: json['descricao'],
      date: json['data_inicio'] ?? '',
      location: json['localizacao'],
      imageUrl: json['url_imagem'],
      price: json['preco'] != null ? double.tryParse(json['preco'].toString()) : null,
      userId: json['user_id'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
    );
  }

  /// Novo método copyWith para alterar campos de forma imutável
  Event copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    String? location,
    String? imageUrl,
    double? price,
    String? userId,
    double? latitude,
    double? longitude,
    bool? hasTicket,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      userId: userId ?? this.userId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      hasTicket: hasTicket ?? this.hasTicket,
    );
  }
}