import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snkr_stacks/providers/resources.dart' as Resources;

const GMAIL_SCHEMA = 'com.google.android.gm';

Future sendFailEmail(
  String shippingEmail,
  String imageUrl0,
  String title,
  String description,
  double price,
  String shippingName,
  String shippingAddress,
  String shippingZip,
  String shippingState,
  String shippingCity,
  String status,
  String size,
  String type,
) async {
  final serviceId = 'service_qo5sxve';
  final templateId = 'template_z1a8bnt';
  final userId = 'user_UbXTpUP7Z9m2advyqbyCf';
  final bccEmail = 'marcuswright55@gmail.com';

  double _tax = 0.0;
  _tax = price * Resources.TAXRATE;
  double _total = (price + _tax + Resources.SHIPPING);
  price = _total;

  print("imageURL => $imageUrl0");

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  await http.post(
    url,
    headers: {'origin': 'http://localhost/', 'Content-Type': 'application/json'},
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': shippingName,
        'user_email': shippingEmail,
        'bcc_email': bccEmail,
        'shippingName': shippingName,
        'shippingAddress': shippingAddress,
        'shippingCity': shippingCity,
        'shippingState': shippingState,
        'shippiingZip': shippingZip,
        'status': status,
        'size': size,
        'type': type,
        'price': price.toStringAsFixed(2),
        'image': imageUrl0,
        'user_subject': 'Unfortunate news from Vndy',
        'user_message':
            'We regret to inform you that the product $description is no longer available ,The charge for the amount of $_total will be refunded to your card of purchase. Please allow 7-10 Business days for the return to complete ',
        'team_name': 'Vndy Team',
      },
    }),
  );
  print('now leaving fail send');
}

sendConfirmEmail(
  String shippingEmail,
  String imageUrl0,
  String title,
  String description,
  double price,
  String shippingName,
  String shippingAddress,
  String shippingZip,
  String shippingState,
  String shippingCity,
  String status,
  String size,
  String type,
) async {
  final serviceId = 'service_qo5sxve';
  final templateId = 'template_5clu84d';
  final userId = 'user_UbXTpUP7Z9m2advyqbyCf';
  final bccEmail = 'marcuswright55@gmail.com';

  double _tax = 0.0;
  _tax = price * Resources.TAXRATE;
  double _total = (price + _tax + Resources.SHIPPING);
  price = _total;

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  await http.post(
    url,
    headers: {'origin': 'http://localhost/', 'Content-Type': 'application/json'},
    body: json.encode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': shippingName,
        'user_email': shippingEmail,
        'bcc_email': bccEmail,
        'shippingName': shippingName,
        'shippingAddress': shippingAddress,
        'shippingCity': shippingCity,
        'shippingState': shippingState,
        'shippiingZip': shippingZip,
        'status': status,
        'size': size,
        'type': type,
        'price': price.toStringAsFixed(2),
        'image': imageUrl0,
        'user_subject': 'Good news from Vndy',
        'user_message': 'Congratulations!!! $description, is available for purchase and has been secured for you. You will receive a receipt for the purchase and Tracking information via email.',
        'team_name': 'Vndy Team',
      },
    }),
  );

  print('now leaving confirm send');
}
