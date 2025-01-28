import 'package:checkout_payment_ui/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/amount_model/details.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/items_list/item.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/items_list/items_list.dart';

({AmountModel amount, ItemsList items}) getTransactions() {
   var amount = AmountModel(
                  total: "100",
                  currency: 'USD',
                  details: Details(
                      shipping: "0", shippingDiscount: 0, subtotal: '100'));
              List<Item> itemsList = [
                Item(
                  currency: 'USD',
                  name: 'Apple',
                  price: "4",
                  quantity: 10,
                ),
                Item(currency: 'USD', name: 'Apple', price: "5", quantity: 12)
              ];
              var items = ItemsList(items: itemsList);
              return (amount: amount, items: items);

}
