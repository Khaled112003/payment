import 'dart:developer';

import 'package:checkout_payment_ui/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/amount_model/details.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/items_list/item.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/items_list/items_list.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/manger/cubit/stripe_payment_cubit.dart';
import 'package:checkout_payment_ui/Features/checkout/presentation/views/thank_you_view.dart';
import 'package:checkout_payment_ui/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class CustomBottonBlocConsumer extends StatelessWidget {
  const CustomBottonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StripePaymentCubit, StripePaymentState>(
      listener: (context, state) {
        if (state is StripePaymentSuccsess) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ThankYouView()));
        }
        if (state is StripePaymentFailure) {
          Navigator.of(context).pop();
          log(state.message);

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return CustomButton(
            onTap: () {
              // PaymentIntentInputModel paymentIntentInputModel =
              //     PaymentIntentInputModel(
              //         amount: "100", currency: 'usd', customerId: "cus_RfGUCQdfD4fLY2");
              // context
              //     .read<StripePaymentCubit>()
              //     .makePayment(paymentIntentInputModel);
              var amount = AmountModel(
                  total: "100",
                  currency: "usd",
                  details: Details(
                      subtotal: "100", shipping: "0", shippingDiscount: 0));
              List<Item> itemsList = [
                Item(
                    currency: "usd",
                    name: "Apple",
                    price: "5",
                    quantity: 4), 
                Item(
                    currency: "usd",
                    name: "Pineapple",
                    price: "10",
                    quantity: 5)
              ];
              var items = ItemsList(items: itemsList);

              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PaypalCheckoutView(
                  sandboxMode: true,
                  clientId: "",
                  secretKey: "",
                  transactions: [
                    {
                      "amount": amount.toJson(),
                      "description": "The payment transaction description.",
                      // "payment_options": {
                      //   "allowed_payment_method":
                      //       "INSTANT_FUNDING_SOURCE"
                      // },
                      "item_list": items.toJson()
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    print("onSuccess: $params");
                  },
                  onError: (error) {
                    print("onError: $error");
                    Navigator.pop(context);
                  },
                  onCancel: () {
                    print('cancelled:');
                  },
                ),
              ));
            },
            isLoading: state is StripePaymentLoading ? true : false,
            text: 'Continue');
      },
    );
  }
}
