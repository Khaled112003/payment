import 'package:bloc/bloc.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/repo/stripe_repo.dart';
import 'package:flutter/foundation.dart';

part 'stripe_payment_state.dart';

class StripePaymentCubit extends Cubit<StripePaymentState> {
  StripePaymentCubit(this.stripeRepo) : super(StripePaymentInitial());
  final StripeRepo stripeRepo;
  Future<void> makePayment(
      PaymentIntentInputModel paymentIntentInputModel) async {
    emit(StripePaymentLoading());
    final result = await stripeRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel);
    result.fold(
      (l) => emit(StripePaymentFailure(l.errMessage)),
      (r) => emit(StripePaymentSuccsess()),
    );
  }
}
