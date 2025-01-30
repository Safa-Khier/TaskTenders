/// Order model
/// * [id]: The order's unique identifier
/// * [gigId]: The order's gig ID
/// * [clientId]: The order's client ID
/// * [taskerId]: The order's tasker ID
/// * [status]: The order's status
/// * [orderDate]: The date the order was created
/// * [completionDate]: The date the order was completed
class Order {
  String id;
  String gigId;
  String clientId;
  String taskerId;
  String status;
  DateTime orderDate;
  DateTime completionDate;

  Order({
    required this.id,
    required this.gigId,
    required this.clientId,
    required this.taskerId,
    required this.status,
    required this.orderDate,
    required this.completionDate,
  });
}
