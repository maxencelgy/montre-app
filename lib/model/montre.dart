class Montre {
  final String title;
  final String image;
  final String price;
  final String description;

  const Montre({required this.title, required this.image, required this.price, required this.description});

  factory Montre.fromJson(Map<String, dynamic> json) {
    return Montre(
        title: json['title'],
        image: json['image'],
        price: json['image'],
        description: json['description'],
    );
  }
}