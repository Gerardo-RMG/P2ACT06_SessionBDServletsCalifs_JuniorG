package control;

import dao.DAOAlumno;
import dao.DAOCalificacion;
import dao.DAOMateria;
import dao.DAOUsuario;
import modelo.Alumno;
import modelo.Materia;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Locale;

public class Servlet_Admin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect("Servlet_Login");
            return;
        }

        String accion = request.getParameter("accion");

        if ("Salir".equals(accion)) {
            session.invalidate();
            response.sendRedirect("Servlet_Login");
            return;
        }

        // Guardado de calificación por AJAX: responde JSON y no navega a
        // ningún lado, para no perder la pestaña/materia que se estaba viendo.
        if ("GuardarCalificacion".equals(accion) && "1".equals(request.getParameter("ajax"))) {
            guardarCalificacionAjax(request, response);
            return;
        }

        if (accion != null && manejarAccion(accion, request)) {
            response.sendRedirect("Servlet_Admin");
            return;
        }

        request.setAttribute("usuarios",       new DAOUsuario().obtenerTodos());
        request.setAttribute("alumnos",        new DAOAlumno().listar());
        request.setAttribute("materias",       new DAOMateria().listar());
        request.setAttribute("calificaciones", new DAOCalificacion().listar());

        RequestDispatcher rd = request.getRequestDispatcher("/admin.jsp");
        rd.forward(request, response);
    }

    private void guardarCalificacionAjax(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store");

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            double p1 = Double.parseDouble(request.getParameter("p1"));
            double p2 = Double.parseDouble(request.getParameter("p2"));
            double p3 = Double.parseDouble(request.getParameter("p3"));

            boolean ok = new DAOCalificacion().actualizar(id, p1, p2, p3);
            String prom = String.format(Locale.US, "%.2f", (p1 + p2 + p3) / 3.0);

            response.getWriter().print("{\"ok\":" + ok + ",\"prom\":\"" + prom + "\"}");
        } catch (NumberFormatException ex) {
            response.getWriter().print("{\"ok\":false}");
        }
    }

    /** Devuelve true si la acción fue reconocida y procesada. */
    private boolean manejarAccion(String accion, HttpServletRequest request) {
        switch (accion) {
            case "AceptarUsuario":
                new DAOUsuario().aceptar(request.getParameter("usuario"));
                return true;
            case "RechazarUsuario":
                new DAOUsuario().rechazar(request.getParameter("usuario"));
                return true;
            case "EliminarUsuario":
                new DAOUsuario().eliminar(request.getParameter("usuario"));
                return true;

            case "AgregarAlumno": {
                // El profesor solo da de alta los datos básicos; el correo lo
                // registra y valida el propio alumno en Servlet_AlumnoRegistro.
                Alumno a = new Alumno();
                a.setMatricula(request.getParameter("tfMatricula"));
                a.setNombre(request.getParameter("tfNombre"));
                a.setPaterno(request.getParameter("tfPaterno"));
                a.setMaterno(request.getParameter("tfMaterno"));
                new DAOAlumno().agregar(a);
                return true;
            }
            case "EliminarAlumno":
                new DAOAlumno().eliminar(request.getParameter("matricula"));
                return true;
            case "AceptarAlumno":
                new DAOAlumno().aceptar(request.getParameter("matricula"));
                return true;
            case "RechazarAlumno":
                new DAOAlumno().rechazar(request.getParameter("matricula"));
                return true;

            case "AgregarMateria": {
                Materia m = new Materia();
                m.setClave(request.getParameter("tfClave"));
                m.setNombre(request.getParameter("tfNombreMateria"));
                new DAOMateria().agregar(m);
                return true;
            }
            case "EliminarMateria":
                new DAOMateria().eliminar(request.getParameter("clave"));
                return true;

            case "GenerarCalificaciones":
                new DAOCalificacion().generarFaltantes();
                return true;

            case "GuardarCalificacion": {
                int id = Integer.parseInt(request.getParameter("id"));
                double p1 = Double.parseDouble(request.getParameter("p1"));
                double p2 = Double.parseDouble(request.getParameter("p2"));
                double p3 = Double.parseDouble(request.getParameter("p3"));
                new DAOCalificacion().actualizar(id, p1, p2, p3);
                return true;
            }
            case "EliminarCalificacion":
                new DAOCalificacion().eliminar(Integer.parseInt(request.getParameter("id")));
                return true;

            default:
                return false;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
