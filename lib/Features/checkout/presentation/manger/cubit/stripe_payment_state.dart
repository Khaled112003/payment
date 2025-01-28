part of 'stripe_payment_cubit.dart';

@immutable
sealed class StripePaymentState {}

final class StripePaymentInitial extends StripePaymentState {}

final class StripePaymentLoading extends StripePaymentState {}

final class StripePaymentSuccsess extends StripePaymentState {}

final class StripePaymentFailure extends StripePaymentState {
  final String message;
  StripePaymentFailure(this.message);
}
