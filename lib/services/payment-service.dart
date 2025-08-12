// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stripe_payment/stripe_payment.dart';
//
// class StripeTransactionResponse {
//   String message;
//   bool success;
//   StripeTransactionResponse({this.message, this.success});
// }
//
// class StripeService {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
//   static String secret =
//       'sk_test_51IN2IzCOjsikW1onnHc8MZhbHI4VSglHy5tr9bvMYPwwFntOyNsnepdULcEj1D78bQZwZbZEhqTar3SsFyQANNh400hZCwICdd';
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${StripeService.secret}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//   static init() {
//     StripePayment.setOptions(StripeOptions(
//         publishableKey:
//             "pk_test_51IN2IzCOjsikW1onkwL3obNwntKNNuXe7YbIaEFRCd1Pf2xytb1zSK284sOsyST18WeEnj63QzwIFuWnaQD396US004mW2vVqP",
//         merchantId: "Test",
//         androidPayMode: 'test'));
//   }
//
//   // static Future<StripeTransactionResponse> payViaExistingCard({String amount, String currency, CreditCard card}) async{
//   //   try {
//   //     var paymentMethod = await StripePayment.createPaymentMethod(
//   //         PaymentMethodRequest(card: card)
//   //     );
//   //     var paymentIntent = await StripeService.createPaymentIntent(
//   //         amount,
//   //         currency
//   //     );
//   //     var response = await StripePayment.confirmPaymentIntent(
//   //         PaymentIntent(
//   //             clientSecret: paymentIntent['client_secret'],
//   //             paymentMethodId: paymentMethod.id
//   //         )
//   //     );
//   //     if (response.status == 'succeeded') {
//   //       return new StripeTransactionResponse(
//   //           message: 'Transaction successful',
//   //           success: true
//   //       );
//   //     } else {
//   //       return new StripeTransactionResponse(
//   //           message: 'Transaction failed',
//   //           success: false
//   //       );
//   //     }
//   //   } on PlatformException catch(err) {
//   //     return StripeService.getPlatformExceptionErrorResult(err);
//   //   } catch (err) {
//   //     return new StripeTransactionResponse(
//   //         message: 'Transaction failed: ${err.toString()}',
//   //         success: false
//   //     );
//   //   }
//   // }
//
//   // static Future<StripeTransactionResponse> payWithNewCard({String amount, String currency}) async {
//   //   try {
//   //     var paymentMethod = await StripePayment.paymentRequestWithCardForm(
//   //         CardFormPaymentRequest()
//   //     );
//   //     var paymentIntent = await StripeService.createPaymentIntent(
//   //         amount,
//   //         currency
//   //     );
//   //     var response = await StripePayment.confirmPaymentIntent(
//   //         PaymentIntent(
//   //             clientSecret: paymentIntent['client_secret'],
//   //             paymentMethodId: paymentMethod.id
//   //         )
//   //     );
//   //     if (response.status == 'succeeded') {
//   //       return new StripeTransactionResponse(
//   //           message: 'Transaction successful',
//   //           success: true
//   //       );
//   //     } else {
//   //       return new StripeTransactionResponse(
//   //           message: 'Transaction failed',
//   //           success: false
//   //       );
//   //     }
//   //   } on PlatformException catch(err) {
//   //     return StripeService.getPlatformExceptionErrorResult(err);
//   //   } catch (err) {
//   //     return new StripeTransactionResponse(
//   //         message: 'Transaction failed: ${err.toString()}',
//   //         success: false
//   //     );
//   //   }
//   // }
//
//   static Future<StripeTransactionResponse> payWithNewCard(
//       {String amount, String currency}) async {
//     try {
//       var paymentMethod = await StripePayment.paymentRequestWithCardForm(
//         CardFormPaymentRequest(),
//       );
//       // print(jsonEncode(paymentMethod));
//       var paymentIntent =
//           await StripeService.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(
//         PaymentIntent(
//             clientSecret: paymentIntent['client_secret'],
//             paymentMethodId: paymentMethod.id),
//       );
//       if (response.status == 'succeeded') {
//         return new StripeTransactionResponse(
//             message: 'Transaction Successful', success: true);
//       } else {
//         return new StripeTransactionResponse(
//             message: 'Transaction Failure', success: false);
//       }
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction Failed: ${err.toString()}', success: false);
//     }
//   }
//
//   static Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       var response = await http.post(StripeService.paymentApiUrl,
//           body: body, headers: StripeService.headers);
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('error charging user: ${err.toString()}');
//     }
//     return null;
//   }
// }
