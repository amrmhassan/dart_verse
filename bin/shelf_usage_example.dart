import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

String email = 'amrhassanpersonal@gmail.com';
String password = 'xjii wpdm lioh hvsc';
var testSmtpServer = gmail(email, password);
void main() async {
  // var sendReport = await send(message, server);
  // print(sendReport);
}
var testMessage = Message()
  ..from = Address('555-security@a7a.com', 'Kosom Elde7k')
  ..recipients.add('amrmhassanmarsafa@gmail.com')
  ..subject = 'This is the subject'
  ..bccRecipients.add(Address('amrmhassanmarsafa@gmail.com'))
  ..text = 'This is the text of the mail';
