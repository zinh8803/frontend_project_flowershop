abstract class OrderDetailEvent {}

class FetchOrderDetail extends OrderDetailEvent {
  final int orderId;
  FetchOrderDetail(this.orderId);
}

class UpdateOrderStatusToProcessing extends OrderDetailEvent {
  final int orderId;

  UpdateOrderStatusToProcessing(this.orderId);
}

class UpdateOrderStatusToCompleted extends OrderDetailEvent {
  final int orderId;

  UpdateOrderStatusToCompleted(this.orderId);
}
