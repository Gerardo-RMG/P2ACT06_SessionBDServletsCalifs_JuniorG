package control;

import dao.DAOUsuario;
import util.EnviarCorreo;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

public class Servlet_Registro extends HttpServlet {

    private static final String DOMINIO_INSTITUCIONAL = "@utrng.edu.mx";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("1".equals(request.getParameter("enviado"))) {
            request.setAttribute("registrado", Boolean.TRUE);
        }
        RequestDispatcher rd = request.getRequestDispatcher("/registro.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nombre   = request.getParameter("tfNombre").trim();
        String correo   = request.getParameter("tfCorreo").trim();
        String usuario  = request.getParameter("tfUsuario").trim();
        String clave    = request.getParameter("tfClave");
        String clave2    = request.getParameter("tfClave2");

        String error = null;

        if (nombre.isEmpty() || correo.isEmpty() || usuario.isEmpty() || clave.isEmpty()) {
            error = "Todos los campos son obligatorios.";
        } else if (!correo.toLowerCase().endsWith(DOMINIO_INSTITUCIONAL)) {
            error = "Debes usar tu correo institucional (" + DOMINIO_INSTITUCIONAL + ").";
        } else if (!clave.equals(clave2)) {
            error = "Las contraseñas no coinciden.";
        } else if (clave.length() < 8) {
            error = "La contraseña debe tener al menos 8 caracteres.";
        } else {
            DAOUsuario dao = new DAOUsuario();
            if (dao.existeUsuario(usuario)) {
                error = "El nombre de usuario <strong>" + usuario + "</strong> ya está en uso.";
            } else if (dao.existeCorreo(correo)) {
                error = "El correo <strong>" + correo + "</strong> ya está registrado.";
            } else {
                String codigo = String.format("%06d", new Random().nextInt(1000000));

                HttpSession sess = request.getSession();
                sess.setAttribute("pendiente_correo",  correo);
                sess.setAttribute("pendiente_nombre",  nombre);
                sess.setAttribute("pendiente_usuario", usuario);
                sess.setAttribute("pendiente_clave",   clave);
                sess.setAttribute("pendiente_codigo",  codigo);

                boolean enviado = false;
                String errorCorreo = null;
                try {
                    String cuerpo = EnviarCorreo.cuerpoCodigoVerificacion(nombre, codigo);
                    enviado = EnviarCorreo.enviar(correo, "Tu código de verificación — Sistema de Calificaciones", cuerpo);
                } catch (Throwable t) {
                    errorCorreo = t.getClass().getSimpleName() + ": " + t.getMessage();
                    System.err.println("[Correo] " + errorCorreo);
                }
                sess.setAttribute("pendiente_codigo_enviado", enviado);
                sess.setAttribute("pendiente_error_correo",  errorCorreo);

                response.sendRedirect("Servlet_Verificar");
                return;
            }
        }

        request.setAttribute("error",   error);
        request.setAttribute("nombre",  nombre);
        request.setAttribute("correo",  correo);
        request.setAttribute("usuario", usuario);
        RequestDispatcher rd = request.getRequestDispatcher("/registro.jsp");
        rd.forward(request, response);
    }
}
