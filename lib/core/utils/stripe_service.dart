import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
final ApiService _apiService = ApiService();
Future<PaymentIntentModel> createPaymentIntent(PaymentIntentInputModel paymentIntentInputModel)
 async {
  var response = await _apiService.post(
    body: paymentIntentInputModel.tojson(),
    url: 'https://api.stripe.com/v1/payment_intents',
    token: ApiKeys.secretKey,);
  return PaymentIntentModel.fromJson(response.data);

}
Future initPaymentsheet({required String paymentIntentClientSecret}) async {
  await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
    paymentIntentClientSecret: paymentIntentClientSecret,
    merchantDisplayName: 'Flutter Stripe Store',
  ));
}
Future displayPaymentSheet() async {
  await Stripe.instance.presentPaymentSheet();
}

Future makePayment({ required PaymentIntentInputModel paymentIntentInputModel}) async {
 var paymentItentModel =await createPaymentIntent(paymentIntentInputModel);
  await initPaymentsheet(paymentIntentClientSecret:paymentItentModel.clientSecret!);
  await displayPaymentSheet();
} }