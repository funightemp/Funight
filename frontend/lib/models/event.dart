class Event {
  final String eventId;
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final double? price;
  final String? description;
  final double? latitude;
  final double? longitude;
  final String? userId;

  Event({
    required this.eventId,
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.userId,
    this.price,
    this.description,
    this.latitude,
    this.longitude,
  });
}
