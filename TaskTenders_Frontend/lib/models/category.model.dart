/// Category model
/// * [id]: The category's unique identifier
/// * [name]: The category's name
/// * [description]: The category's description
class Category {
  String id;
  String name;
  String description;

  Category({
    required this.id,
    required this.name,
    required this.description,
  });
}
