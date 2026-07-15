package control;

import dao.DAOAlumno;
import dao.DAOUsuario;
import modelo.Alumno;
import util.EnviarCorreo;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Random;

public class Servlet_Validar extends HttpServlet {

    private static final String DOMINIO_INSTITUCIONAL = "@utrng.edu.mx";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store");

        String tipo = request.getParameter("tipo");
        PrintWriter out = response.getWriter();

        if ("buscar_alumno".equals(tipo)) {
            buscarAlumno(request, out);
            return;
        }
        if ("enviar_codigo_alumno".equals(tipo)) {
            enviarCodigoAlumno(request, out);
            return;
        }
        if ("verificar_codigo_alumno".equals(tipo)) {
            verificarCodigoAlumno(request, out);
            return;
        }

        DAOUsuario dao = new DAOUsuario();
        boolean existe = false;

        if ("usuario".equals(tipo)) {
            String valor = request.getParameter("valor");
            if (valor != null && !valor.trim().isEmpty())
                existe = dao.existeUsuario(valor.trim());

        } else if ("correo".equals(tipo)) {
            String valor = request.getParameter("valor");
            if (valor != null && !valor.trim().isEmpty())
                existe = dao.existeCorreo(valor.trim());
        }

        out.print("{\"existe\":" + existe + "}");
    }

    /** Busca al alumno por matrícula para el autorregistro de correo; devuelve todos sus datos si existe. */
    private void buscarAlumno(HttpServletRequest request, PrintWriter out) {
        String matricula = request.getParameter("matricula");
        if (matricula == null || matricula.trim().isEmpty()) {
            out.print("{\"existe\":false}");
            return;
        }
        Alumno a = new DAOAlumno().buscarPorMatricula(matricula.trim());
        if (a == null) {
            out.print("{\"existe\":false}");
        } else {
            String correo = a.getCorreo() != null ? a.getCorreo() : (a.getMatricula() + DOMINIO_INSTITUCIONAL);
            out.print("{\"existe\":true"
                    + ",\"matricula\":\"" + escapeJson(a.getMatricula()) + "\""
                    + ",\"nombre\":\""    + escapeJson(a.getNombreCompleto()) + "\""
                    + ",\"paterno\":\""   + escapeJson(a.getPaterno()) + "\""
                    + ",\"materno\":\""   + escapeJson(a.getMaterno()) + "\""
                    + ",\"correo\":\""    + escapeJson(correo) + "\""
                    + ",\"validar\":"     + a.isValidar()
                    + ",\"status\":\""    + escapeJson(a.getStatus()) + "\""
                    + "}");
        }
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    /** Genera un código de 6 dígitos, lo guarda en sesión y lo envía al correo del alumno. */
    private void enviarCodigoAlumno(HttpServletRequest request, PrintWriter out) {
        String correo = request.getParameter("correo");
        String nombre = request.getParameter("nombre");
        if (correo == null || correo.trim().isEmpty()) {
            out.print("{\"enviado\":false,\"error\":\"correo_vacio\"}");
            return;
        }
        correo = correo.trim();

        if (!correo.toLowerCase().endsWith(DOMINIO_INSTITUCIONAL)) {
            out.print("{\"enviado\":false,\"error\":\"dominio_invalido\"}");
            return;
        }

        String codigo = String.format("%06d", new Random().nextInt(1000000));
        HttpSession session = request.getSession();
        session.setAttribute("alumno_verif_correo", correo);
        session.setAttribute("alumno_verif_codigo", codigo);
        session.removeAttribute("alumno_correo_verificado");

        boolean enviado;
        try {
            String cuerpo = EnviarCorreo.cuerpoCodigoVerificacion(
                    nombre != null && !nombre.trim().isEmpty() ? nombre.trim() : "Alumno", codigo);
            enviado = EnviarCorreo.enviar(correo, "Tu código de verificación — Sistema de Calificaciones", cuerpo);
        } catch (Throwable t) {
            System.err.println("[Correo alumno] " + t.getClass().getSimpleName() + ": " + t.getMessage());
            enviado = false;
        }
        out.print("{\"enviado\":" + enviado + "}");
    }

    /** Compara el código ingresado con el guardado en sesión para ese correo. */
    private void verificarCodigoAlumno(HttpServletRequest request, PrintWriter out) {
        String correo  = request.getParameter("correo");
        String codigo  = request.getParameter("codigo");
        HttpSession session = request.getSession(false);

        String correoSesion = session != null ? (String) session.getAttribute("alumno_verif_correo") : null;
        String codigoSesion = session != null ? (String) session.getAttribute("alumno_verif_codigo") : null;

        boolean valido = correo != null && codigo != null && session != null
                && correo.trim().equals(correoSesion) && codigo.trim().equals(codigoSesion);

        if (valido) {
            session.setAttribute("alumno_correo_verificado", correoSesion);
            session.removeAttribute("alumno_verif_codigo");
        }
        out.print("{\"valido\":" + valido + "}");
    }
}
