package control;

import dao.DAOUsuario;
import modelo.Usuario;
import util.EnviarCorreo;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

public class Servlet_Verificar extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String correo = (session != null) ? (String) session.getAttribute("pendiente_correo") : null;

        if (correo == null) {
            response.sendRedirect("Servlet_Registro");
            return;
        }

        String action = request.getParameter("action");

        if ("reenviar".equals(action)) {
            String nombre = (String) session.getAttribute("pendiente_nombre");
            if (nombre == null) nombre = "";

            String nuevoCodigo = String.format("%06d", new Random().nextInt(1000000));
            session.setAttribute("pendiente_codigo", nuevoCodigo);

            boolean enviado = false;
            String errorReenvio = null;
            try {
                String cuerpo = EnviarCorreo.cuerpoCodigoVerificacion(nombre, nuevoCodigo);
                enviado = EnviarCorreo.enviar(correo,
                        "Tu código de verificación — Sistema de Calificaciones", cuerpo);
            } catch (Throwable t) {
                errorReenvio = t.getClass().getSimpleName() + ": " + t.getMessage();
                System.err.println("[Correo reenvío] " + errorReenvio);
            }

            session.setAttribute("pendiente_codigo_enviado", enviado);
            session.setAttribute("pendiente_reenvio_ok",     enviado);
            session.setAttribute("pendiente_error_correo",   errorReenvio);

            response.sendRedirect("Servlet_Verificar");
            return;
        }

        if ("cambiar".equals(action)) {
            limpiarSesion(session);
            response.sendRedirect("Servlet_Registro");
            return;
        }

        Boolean enviado        = (Boolean) session.getAttribute("pendiente_codigo_enviado");
        Boolean reenvioOk      = (Boolean) session.getAttribute("pendiente_reenvio_ok");
        String  errorCorreo    = (String)  session.getAttribute("pendiente_error_correo");
        String  codigoFallback = Boolean.FALSE.equals(enviado)
                ? (String) session.getAttribute("pendiente_codigo") : null;

        if (reenvioOk != null) session.removeAttribute("pendiente_reenvio_ok");

        request.setAttribute("correoDestino",  correo);
        request.setAttribute("codigoEnviado",  enviado);
        request.setAttribute("codigoFallback", codigoFallback);
        request.setAttribute("reenvioOk",      reenvioOk);
        request.setAttribute("errorCorreo",    errorCorreo);
        RequestDispatcher rd = request.getRequestDispatcher("/verificar_codigo.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String correo = (session != null) ? (String) session.getAttribute("pendiente_correo") : null;

        if (correo == null) {
            response.sendRedirect("Servlet_Registro");
            return;
        }

        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= 6; i++) {
            String d = request.getParameter("d" + i);
            sb.append(d != null ? d.trim() : "");
        }
        String codigoIngresado = sb.toString();

        if (codigoIngresado.length() != 6) {
            request.setAttribute("error", "Ingresa los 6 dígitos del código.");
            request.setAttribute("correoDestino", correo);
            pasarAtributosSesion(request, session);
            RequestDispatcher rd = request.getRequestDispatcher("/verificar_codigo.jsp");
            rd.forward(request, response);
            return;
        }

        String codigoSesion = (String) session.getAttribute("pendiente_codigo");

        if (codigoIngresado.equals(codigoSesion)) {
            String nombre  = (String) session.getAttribute("pendiente_nombre");
            String usuario = (String) session.getAttribute("pendiente_usuario");
            String clave   = (String) session.getAttribute("pendiente_clave");

            Usuario u = new Usuario();
            u.setNombre(nombre);
            u.setCorreo(correo);
            u.setUsuario(usuario);
            u.setClave(clave);

            DAOUsuario dao = new DAOUsuario();
            if (dao.registrar(u)) {
                limpiarSesion(session);
                response.sendRedirect("Servlet_Registro?enviado=1");
            } else {
                request.setAttribute("error", "Error al guardar tu solicitud. Intenta de nuevo.");
                request.setAttribute("correoDestino", correo);
                pasarAtributosSesion(request, session);
                RequestDispatcher rd = request.getRequestDispatcher("/verificar_codigo.jsp");
                rd.forward(request, response);
            }
        } else {
            request.setAttribute("error", "Código incorrecto. Revisa tu correo e intenta de nuevo.");
            request.setAttribute("correoDestino", correo);
            pasarAtributosSesion(request, session);
            RequestDispatcher rd = request.getRequestDispatcher("/verificar_codigo.jsp");
            rd.forward(request, response);
        }
    }

    private void pasarAtributosSesion(HttpServletRequest request, HttpSession session) {
        Boolean enviado = (Boolean) session.getAttribute("pendiente_codigo_enviado");
        String codigoFallback = Boolean.FALSE.equals(enviado)
                ? (String) session.getAttribute("pendiente_codigo") : null;
        request.setAttribute("codigoEnviado",  enviado);
        request.setAttribute("codigoFallback", codigoFallback);
    }

    private void limpiarSesion(HttpSession session) {
        session.removeAttribute("pendiente_correo");
        session.removeAttribute("pendiente_nombre");
        session.removeAttribute("pendiente_usuario");
        session.removeAttribute("pendiente_clave");
        session.removeAttribute("pendiente_codigo");
        session.removeAttribute("pendiente_codigo_enviado");
        session.removeAttribute("pendiente_reenvio_ok");
    }
}
