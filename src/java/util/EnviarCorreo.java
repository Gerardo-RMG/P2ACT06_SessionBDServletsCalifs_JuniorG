package util;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;

public class EnviarCorreo {

    // ══════════════════════════════════════════════════════════════════════
    //  Elige UN bloque, pon tus datos y comenta los demás
    // ══════════════════════════════════════════════════════════════════════

    // ── OPCIÓN A: Gmail ───────────────────────────────────────────────────
    // Requiere: Verificación en 2 pasos activa + contraseña de aplicación
    //   myaccount.google.com → Seguridad → Contraseñas de aplicaciones
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_USER = "TU_CORREO@gmail.com";
    private static final String SMTP_PASS = "TU_APP_PASSWORD";

    // ── OPCIÓN B: Outlook / Hotmail ───────────────────────────────────────
    // Sin verificación en 2 pasos: usa tu contraseña normal de Outlook
    // Con verificación en 2 pasos: genera app password en account.microsoft.com
//  private static final String SMTP_HOST = "smtp-mail.outlook.com";
//  private static final String SMTP_USER = "TU_CORREO@outlook.com";
//  private static final String SMTP_PASS = "TU_CONTRASEÑA";

    // ── OPCIÓN C: Yahoo ───────────────────────────────────────────────────
    // Requiere: app password en myaccount.yahoo.com → Seguridad → Contraseñas de app
//  private static final String SMTP_HOST = "smtp.mail.yahoo.com";
//  private static final String SMTP_USER = "TU_CORREO@yahoo.com";
//  private static final String SMTP_PASS = "xxxx xxxx xxxx xxxx"; // 16 caracteres de Yahoo

    // ══════════════════════════════════════════════════════════════════════

    public static boolean enviar(String destinatario, String asunto, String cuerpoHtml) {
        Properties props = new Properties();
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            "587");
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(SMTP_USER, "Sistema de Calificaciones"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            msg.setSubject(asunto);
            msg.setContent(cuerpoHtml, "text/html; charset=utf-8");
            Transport.send(msg);
            return true;
        } catch (Exception ex) {
            System.err.println("[Correo] Error al enviar a " + destinatario + ": " + ex.getMessage());
            return false;
        }
    }

    public static String cuerpoCodigoVerificacion(String nombre, String codigo) {
        return "<!DOCTYPE html><html><head><meta charset='UTF-8'></head><body "
             + "style='font-family:Arial,sans-serif;background:#f0f4f8;margin:0;padding:20px;'>"
             + "<div style='max-width:480px;margin:0 auto;background:#fff;border-radius:12px;"
             + "box-shadow:0 4px 16px rgba(0,0,0,.1);overflow:hidden;'>"
             + "<div style='background:linear-gradient(135deg,#8b1538,#c0392b);padding:28px;text-align:center;'>"
             + "<h1 style='color:#fff;margin:0;font-size:22px;'>Sistema de Calificaciones</h1></div>"
             + "<div style='padding:32px;'>"
             + "<p style='color:#1a202c;font-size:16px;margin:0 0 8px;'>Hola, <strong>" + nombre + "</strong></p>"
             + "<p style='color:#4a5568;font-size:14px;line-height:1.6;margin:0 0 24px;'>"
             + "Usa el siguiente código para verificar tu correo electrónico:</p>"
             + "<div style='text-align:center;margin-bottom:28px;'>"
             + "<div style='display:inline-block;background:#f7f7f7;border:2px dashed #c0392b;"
             + "border-radius:12px;padding:18px 36px;'>"
             + "<span style='font-size:40px;font-weight:900;letter-spacing:12px;color:#8b1538;"
             + "font-family:monospace;'>" + codigo + "</span></div></div>"
             + "<p style='color:#4a5568;font-size:13px;text-align:center;margin:0 0 20px;'>"
             + "Ingresa este código en la página de verificación.</p>"
             + "<p style='color:#a0aec0;font-size:12px;text-align:center;margin:0;'>"
             + "Si no creaste esta cuenta, ignora este mensaje.</p>"
             + "</div></div></body></html>";
    }
}
