import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/repo/stripe_repo.dart';
import 'package:checkout_payment_ui/core/errors/failures.dart';
import 'package:checkout_payment_ui/core/utils/stripe_service.dart';
import 'package:either_dart/src/either.dart';

class StripeRepoImplementation extends StripeRepo{
  final StripeService _stripeService = StripeService();
  @override
  Future<Either<Failure, void>> makePayment ({required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await _stripeService.makePayment(paymentIntentInputModel: paymentIntentInputModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
    
    
  }
}