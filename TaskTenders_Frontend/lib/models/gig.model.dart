/// Model class for Gig
/// * [id] is the unique identifier of the gig
/// * [userId] is the unique identifier of the user who created the gig
/// * [title] is the title of the gig
/// * [description] is the description of the gig
/// * [categoryId] is the unique identifier of the category the gig belongs to
/// * [createdAt] is the date the gig was created
class Gig {
  String id;
  String userId;
  String title;
  String description;
  String categoryId;
  String createdAt;

  Gig({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.createdAt,
  });
}
