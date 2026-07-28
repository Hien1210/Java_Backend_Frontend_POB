package org.example.utils;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtil {
    private static final String host = ConfigUtil.get("mail.host", "smtp-relay.brevo.com");
    private static final String port = ConfigUtil.get("mail.port", "587");
    private static final String username = ConfigUtil.get("mail.username", null);
    private static final String password = ConfigUtil.get("mail.password", null);
    private static final String senderEmail = ConfigUtil.get("mail.sender", null);


    public static void sendEmail(String toAddress, String subject, String body) throws MessagingException, java.io.UnsupportedEncodingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(senderEmail));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
        message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
        message.setContent(body, "text/html; charset=UTF-8");

        Transport.send(message);
    }
}