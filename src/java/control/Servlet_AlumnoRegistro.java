package control;

import dao.DAOAlumno;
import modelo.Alumno;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/** Autorregistro público de correo para alumnos ya dados de alta por el profesor. */
public class Servlet_AlumnoRegistro extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("1".equals(request.getParameter("enviado"))) {
            request.setAttribute("registrado", Boolean.TRUE);
        }
        RequestDispatcher rd = request.getRequestDispatcher("/alumno_registro.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String matricula = request.getParameter("tfMatricula");
        String correo    = request.getParameter("tfCorreo");

        String error = null;

        if (matricula == null || matricula.trim().isEmpty() || correo == null || correo.trim().isEmpty()) {
            error = "Ingresa tu matrícula y tu correo institucional.";
        } else {
            matricula = matricula.trim();
            correo = correo.trim();

            Alumno a = new DAOAlumno().buscarPorMatricula(matricula);
            if (a == null) {
                error = "No encontramos esa matrícula. Contacta al profesor para que te dé de alta.";
            } else {
                HttpSession session = request.getSession(false);
                Object correoVerificado = session != null ? session.getAttribute("alumno_correo_verificado") : null;

                if (!correo.equals(correoVerificado)) {
                    error = "Primero verifica tu correo con el código antes de confirmar.";
                } else {
                    new DAOAlumno().actualizarCorreo(matricula, correo);
                    session.removeAttribute("alumno_correo_verificado");
                    response.sendRedirect("Servlet_AlumnoRegistro?enviado=1");
                    return;
                }
            }
        }

        request.setAttribute("error", error);
        request.setAttribute("matricula", matricula);
        RequestDispatcher rd = request.getRequestDispatcher("/alumno_registro.jsp");
        rd.forward(request, response);
    }
}
