class SendEmail {
  late String to;
  late String subject;
  late String body;
  SendEmail(this.to, this.subject, this.body);
  Map toJson() => {'to': to, 'subject': subject, 'body': body};
}
