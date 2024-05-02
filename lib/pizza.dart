class Pizza {
  final String id;
  final String name;
  final double price;
  final List<String> ingredients;
  final String image;
  

  const Pizza({
    required this.name,
    required this.id,
    required this.price,
    required this.ingredients,
    required this.image,
    
  });

  factory Pizza.fromJson(Map<String, dynamic> json) => Pizza(
        name: json['name'] as String,
        id: json['id'] as String,
        price: json['price'] as double,
        ingredients: List<String>.from(json['ingredients']),
        image: json['image'] as String,
        
      );
}

