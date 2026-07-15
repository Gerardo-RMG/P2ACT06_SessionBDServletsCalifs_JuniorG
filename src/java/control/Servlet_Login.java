package control;

import dao.DAOUsuario;
import modelo.Usuario;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class Servlet_Login extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            response.sendRedirect("Servlet_Admin");
            return;
        }
        RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String usuario = request.getParameter("tfUsuario");
        String clave   = request.getParameter("tfClave");

        DAOUsuario dao = new DAOUsuario();
        Usuario u = dao.validarLogin(usuario, clave);

        if (u == null) {
            request.setAttribute("error",
                    "Usuario o contraseña incorrectos, o tu cuenta no tiene acceso de administrador.");
            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("usuario", u.getUsuario());
        session.setAttribute("nombre",  u.getNombre());
        response.sendRedirect("Servlet_Admin");
    }
}
