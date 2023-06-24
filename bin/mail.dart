import 'package:dart_verse/settings/server_settings/impl/default_auth_server_handlers.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import 'shelf_usage_example.dart';

void main() async {
  SmtpServer smtpServer = SmtpServer(
    'smtp.gmail.com',
    username: testSmtpServer.username,
    password: testSmtpServer.password,
    port: 587,
  );
  Message message = getEmailVerificationMessage(
    mailTo: 'amrmhassanmarsafa@gmail.com',
    from: 'Dart Verse',
    subject: 'Test Email Verification',
  );
  message.text = 'hello amr';
  PersistentConnection connection = PersistentConnection(smtpServer);
  print('sending...');
  await connection.send(message);
  print('message sent');
}
