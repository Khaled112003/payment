import 'package:checkout_payment_ui/Features/checkout/data/models/emphemeral_key_model/emphemeral_key/emphemeral_key.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/init_payment_sheet_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:checkout_payment_ui/core/utils/api_keys.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  final ApiService _apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await _apiService.post(
      body: paymentIntentInputModel.tojson(),
      url: 'https://api.stripe.com/v1/payment_intents',
      token: ApiKeys.secretKey,
      contentType: Headers.formUrlEncodedContentType,
    );
    return PaymentIntentModel.fromJson(response.data);
  }

  Future initPaymentsheet(
      {required InitPaymentSheetModel initPaymentSheetModel}) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret:
          initPaymentSheetModel.paymentIntentClientSecret,
      customerEphemeralKeySecret: initPaymentSheetModel.emphemeralKey,
      customerId: initPaymentSheetModel.customerId,
      merchantDisplayName: 'Flutter Stripe Store',
    ));
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var emphemeralKeyModel = await createEmphemeralKeyModel(
        customerId: paymentIntentInputModel.customerId);
    var paymentItentModel = await createPaymentIntent(paymentIntentInputModel);
    var initPaymentSheetModel = InitPaymentSheetModel(
        customerId: paymentIntentInputModel.customerId,
        paymentIntentClientSecret: paymentItentModel.clientSecret!,
        emphemeralKey: emphemeralKeyModel.secret!);
    await initPaymentsheet(initPaymentSheetModel: initPaymentSheetModel);
    await displayPaymentSheet();
  }

  Future<EmphemeralKeyModel> createEmphemeralKeyModel({required String customerId}) async {
    try {
      // Log the customerId for debugging purposes
      print('Creating ephemeral key for customer ID: $customerId');

      var response = await _apiService.post(
        body: {'customer': customerId},
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        token: ApiKeys.secretKey,
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          "Authorization": "Bearer ${ApiKeys.secretKey}",
          "Stripe-Version": "2024-12-18.acacia"
        },
      );

      // Log the response data for debugging purposes
      print('Response data: ${response.data}');

      return EmphemeralKeyModel.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print('DioException [bad response]: ${e.message}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Unexpected error: $e');
      }
      rethrow;
    }
  }
}


// before save card


// class StripeService {
// final ApiService _apiService = ApiService();
// Future<PaymentIntentModel> createPaymentIntent(PaymentIntentInputModel paymentIntentInputModel)
//  async {
//   var response = await _apiService.post(
//     body: paymentIntentInputModel.tojson(),
//     url: 'https://api.stripe.com/v1/payment_intents',
//     token: ApiKeys.secretKey,);
//   return PaymentIntentModel.fromJson(response.data);

// }
// Future initPaymentsheet({required String paymentIntentClientSecret}) async {
//   await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
//     paymentIntentClientSecret: paymentIntentClientSecret,
//     merchantDisplayName: 'Flutter Stripe Store',
//   ));
// }
// Future displayPaymentSheet() async {
//   await Stripe.instance.presentPaymentSheet();
// }

// Future makePayment({ required PaymentIntentInputModel paymentIntentInputModel}) async {
//  var paymentItentModel =await createPaymentIntent(paymentIntentInputModel);
//   await initPaymentsheet(paymentIntentClientSecret:paymentItentModel.clientSecret!);
//   await displayPaymentSheet();
// } }
