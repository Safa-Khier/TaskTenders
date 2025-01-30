/// Reviews model
/// * [id]: The review's unique identifier
/// * [orderId]: The review's order ID
/// * [rating]: The review's rating
/// * [comment]: The review's comment
/// * [reviewDate]: The date the review was created
class Reviews {
  String? id;
  String jobId;
  int rating;
  String? comment;
  DateTime reviewDate;

  Reviews({
    this.id,
    required this.jobId,
    required this.rating,
    this.comment,
    required this.reviewDate,
  });

  toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'rating': rating,
      'comment': comment,
      'reviewDate': reviewDate,
    };
  }
}
