<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="modelo.Usuario"%>
<%@page import="modelo.Alumno"%>
<%@page import="modelo.Materia"%>
<%@page import="modelo.Calificacion"%>
<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("\"", "&quot;")
                .replace("<", "&lt;").replace(">", "&gt;");
    }
%>
<%
    if (session == null || session.getAttribute("usuario") == null) {
        response.sendRedirect("Servlet_Login");
        return;
    }

    List<Usuario>      usuarios       = (List<Usuario>)      request.getAttribute("usuarios");
    List<Alumno>        alumnos        = (List<Alumno>)       request.getAttribute("alumnos");
    List<Materia>       materias       = (List<Materia>)      request.getAttribute("materias");
    List<Calificacion>  calificaciones = (List<Calificacion>) request.getAttribute("calificaciones");
    if (usuarios       == null) usuarios       = new ArrayList<>();
    if (alumnos        == null) alumnos        = new ArrayList<>();
    if (materias       == null) materias       = new ArrayList<>();
    if (calificaciones == null) calificaciones = new ArrayList<>();

    // Todos los alumnos se muestran junto con los usuarios en la bandeja de
    // solicitudes del profesor (con o sin correo registrado todavía).
    int totalSolicitudes = usuarios.size() + alumnos.size();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel de Administración</title>
        <link rel="stylesheet" href="style.css">
    </head>
    <body class="bg_admin">

        <div id="encabezado">
            <h1>Panel de Administración — Calificaciones</h1>
            <div id="session_bar">
                <span class="badge_activo on">&#9679; Admin</span>
                <span>
                    <%= session.getAttribute("nombre") != null ? session.getAttribute("nombre") : session.getAttribute("usuario") %>
                    &nbsp;<span style="opacity:.6;font-weight:400;">(@<%= session.getAttribute("usuario") %>)</span>
                </span>
                <form method="post" action="Servlet_Admin" style="display:inline;">
                    <input type="hidden" name="accion" value="Salir"/>
                    <button type="submit" id="btn_salir">Cerrar Sesión</button>
                </form>
            </div>
        </div>

        <div id="contenido_admin">

            <div class="admin_tabs">
                <button type="button" class="tab_btn active" data-tab="tab_usuarios">Solicitudes de usuarios</button>
                <button type="button" class="tab_btn" data-tab="tab_alumnos">Alumnos</button>
                <button type="button" class="tab_btn" data-tab="tab_materias">Materias</button>
                <button type="button" class="tab_btn" data-tab="tab_calificaciones">Calificaciones</button>
            </div>

            <%-- ══════════════════════════════════════════
                 SOLICITUDES DE USUARIOS
            ══════════════════════════════════════════ --%>
            <div class="tab_panel active" id="tab_usuarios">
            <div class="admin_section">
                <h2 class="admin_section_title">Solicitudes de usuarios <span class="badge_count"><%= totalSolicitudes %></span></h2>

                <% if (totalSolicitudes == 0) { %>
                <div class="admin_empty"><span>No hay solicitudes registradas.</span></div>
                <% } else { %>
                <div class="table_wrap">
                <table class="admin_tabla">
                    <colgroup>
                        <col style="width:10%"><col style="width:20%"><col style="width:21%">
                        <col style="width:9%"><col style="width:9%"><col style="width:7%">
                        <col style="width:24%">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>Usuario</th>
                            <th>Nombre</th>
                            <th>Correo</th>
                            <th>Validar</th>
                            <th>Status</th>
                            <th>Tipo</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Usuario u : usuarios) { %>
                        <tr>
                            <td>@<%= esc(u.getUsuario()) %></td>
                            <td style="white-space:normal;word-break:break-word;"><%= esc(u.getNombre()) %></td>
                            <td style="white-space:normal;word-break:break-word;"><%= esc(u.getCorreo()) %></td>
                            <td>
                                <% if (u.isValidar()) { %>
                                <span class="badge_est badge_verificado">&#10003; Verificado</span>
                                <% } else { %>
                                <span class="badge_est badge_no_verificado">Sin verificar</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("activo".equals(u.getStatus())) { %>
                                <span class="badge_est badge_est_activo">Activo</span>
                                <% } else if ("rechazado".equals(u.getStatus())) { %>
                                <span class="badge_est badge_est_rechazado">Rechazado</span>
                                <% } else { %>
                                <span class="badge_est badge_est_pendiente">Pendiente</span>
                                <% } %>
                            </td>
                            <td>Usuario</td>
                            <td>
                                <% if (!"activo".equals(u.getStatus())) { %>
                                <form method="post" action="Servlet_Admin" style="display:inline;">
                                    <input type="hidden" name="accion"  value="AceptarUsuario"/>
                                    <input type="hidden" name="usuario" value="<%= esc(u.getUsuario()) %>"/>
                                    <button type="submit" class="btn_admin btn_aceptar">Aceptar</button>
                                </form>
                                <% } %>
                                <% if (!"rechazado".equals(u.getStatus())) { %>
                                <form method="post" action="Servlet_Admin" style="display:inline;margin-left:5px;">
                                    <input type="hidden" name="accion"  value="RechazarUsuario"/>
                                    <input type="hidden" name="usuario" value="<%= esc(u.getUsuario()) %>"/>
                                    <button type="submit" class="btn_admin btn_rechazar">Rechazar</button>
                                </form>
                                <% } %>
                                <form method="post" action="Servlet_Admin" style="display:inline;margin-left:5px;"
                                      onsubmit="return confirm('¿Eliminar al usuario @<%= esc(u.getUsuario()) %>?');">
                                    <input type="hidden" name="accion"  value="EliminarUsuario"/>
                                    <input type="hidden" name="usuario" value="<%= esc(u.getUsuario()) %>"/>
                                    <button type="submit" class="btn_admin btn_rechazar">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                        <% for (Alumno a : alumnos) { %>
                        <tr>
                            <td><%= esc(a.getMatricula()) %></td>
                            <td style="white-space:normal;word-break:break-word;"><%= esc(a.getNombreCompleto()) %></td>
                            <td style="white-space:normal;word-break:break-word;"><%= a.getCorreo() != null ? esc(a.getCorreo()) : "—" %></td>
                            <td>
                                <% if (a.getCorreo() == null) { %>
                                <span style="color:var(--text-muted);">—</span>
                                <% } else if (a.isValidar()) { %>
                                <span class="badge_est badge_verificado">&#10003; Verificado</span>
                                <% } else { %>
                                <span class="badge_est badge_no_verificado">Sin verificar</span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("activo".equals(a.getStatus())) { %>
                                <span class="badge_est badge_est_activo">Activo</span>
                                <% } else if ("rechazado".equals(a.getStatus())) { %>
                                <span class="badge_est badge_est_rechazado">Rechazado</span>
                                <% } else { %>
                                <span class="badge_est badge_est_pendiente">Pendiente</span>
                                <% } %>
                            </td>
                            <td>Alumno</td>
                            <td>
                                <% if (!"activo".equals(a.getStatus())) { %>
                                <form method="post" action="Servlet_Admin" style="display:inline;">
                                    <input type="hidden" name="accion"    value="AceptarAlumno"/>
                                    <input type="hidden" name="matricula" value="<%= esc(a.getMatricula()) %>"/>
                                    <button type="submit" class="btn_admin btn_aceptar">Aceptar</button>
                                </form>
                                <% } %>
                                <% if (!"rechazado".equals(a.getStatus())) { %>
                                <form method="post" action="Servlet_Admin" style="display:inline;margin-left:5px;">
                                    <input type="hidden" name="accion"    value="RechazarAlumno"/>
                                    <input type="hidden" name="matricula" value="<%= esc(a.getMatricula()) %>"/>
                                    <button type="submit" class="btn_admin btn_rechazar">Rechazar</button>
                                </form>
                                <% } %>
                                <form method="post" action="Servlet_Admin" style="display:inline;margin-left:5px;"
                                      onsubmit="return confirm('¿Eliminar al alumno <%= esc(a.getMatricula()) %>? También se borrarán sus calificaciones.');">
                                    <input type="hidden" name="accion"    value="EliminarAlumno"/>
                                    <input type="hidden" name="matricula" value="<%= esc(a.getMatricula()) %>"/>
                                    <button type="submit" class="btn_admin btn_rechazar">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                </div>
                <% } %>
            </div>
            </div>

            <%-- ══════════════════════════════════════════
                 ALUMNOS
            ══════════════════════════════════════════ --%>
            <div class="tab_panel" id="tab_alumnos">
            <div class="admin_section">
                <h2 class="admin_section_title">Alumnos <span class="badge_count"><%= alumnos.size() %></span></h2>
                <div style="padding:18px 24px;">
                    <form method="post" action="Servlet_Admin" style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:8px;">
                        <input type="hidden" name="accion" value="AgregarAlumno">
                        <input type="text" name="tfMatricula" placeholder="Matrícula" required style="flex:1;min-width:110px;padding:9px 12px;border:1.5px solid var(--border);border-radius:8px;">
                        <input type="text" name="tfNombre"    placeholder="Nombre"    required style="flex:1;min-width:130px;padding:9px 12px;border:1.5px solid var(--border);border-radius:8px;">
                        <input type="text" name="tfPaterno"   placeholder="Apellido paterno" required style="flex:1;min-width:130px;padding:9px 12px;border:1.5px solid var(--border);border-radius:8px;">
                        <input type="text" name="tfMaterno"   placeholder="Apellido materno" style="flex:1;min-width:130px;padding:9px 12px;border:1.5px solid var(--border);border-radius:8px;">
                        <button type="submit" class="btn_admin btn_aceptar">Agregar</button>
                    </form>
                </div>
                <div class="table_wrap">
                <table class="admin_tabla">
                    <colgroup>
                        <col style="width:12%"><col style="width:22%"><col style="width:21%">
                        <col style="width:14%"><col style="width:31%">
                    </colgroup>
                    <thead><tr><th>Matrícula</th><th>Nombre completo</th><th>Correo</th><th>Verificado</th><th>Acciones</th></tr></thead>
                    <tbody>
                        <% for (Alumno a : alumnos) { %>
                        <tr>
                            <td><%= esc(a.getMatricula()) %></td>
                            <td><%= esc(a.getNombreCompleto()) %></td>
                            <td class="td_clip"><%= a.getCorreo() != null ? esc(a.getCorreo()) : "—" %></td>
                            <td>
                                <% if (a.getCorreo() == null) { %>
                                <span style="color:var(--text-muted);">—</span>
                                <% } else if (a.isValidar()) { %>
                                <span class="badge_est badge_verificado">&#10003; Verificado</span>
                                <% } else { %>
                                <span class="badge_est badge_no_verificado">Sin verificar</span>
                                <% } %>
                            </td>
                            <td>
                                <button type="button" class="btn_admin"
                                        style="background:linear-gradient(135deg,#f59e0b,#d97706);color:#fff;"
                                        data-matricula="<%= esc(a.getMatricula()) %>"
                                        data-nombre="<%= esc(a.getNombre()) %>"
                                        data-paterno="<%= esc(a.getPaterno()) %>"
                                        data-materno="<%= esc(a.getMaterno()) %>"
                                        onclick="abrirEditarAlumno(this)">Editar</button>
                                <form method="post" action="Servlet_Admin" style="display:inline;margin-left:5px;"
                                      onsubmit="return confirm('¿Eliminar al alumno <%= esc(a.getMatricula()) %>? También se borrarán sus calificaciones.');">
                                    <input type="hidden" name="accion" value="EliminarAlumno">
                                    <input type="hidden" name="matricula" value="<%= esc(a.getMatricula()) %>">
                                    <button type="submit" class="btn_admin btn_rechazar">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                </div>
            </div>
            </div>

            <%-- ══════════════════════════════════════════
                 MATERIAS
            ══════════════════════════════════════════ --%>
            <div class="tab_panel" id="tab_materias">
            <div class="admin_section">
                <h2 class="admin_section_title">Materias <span class="badge_count"><%= materias.size() %></span></h2>
                <div style="padding:18px 24px;">
                    <form method="post" action="Servlet_Admin" style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:16px;">
                        <input type="hidden" name="accion" value="AgregarMateria">
                        <input type="text" name="tfClave"         placeholder="Clave"   required style="flex:1;min-width:110px;padding:9px 12px;border:1.5px solid var(--border);border-radius:8px;">
                        <input type="text" name="tfNombreMateria" placeholder="Nombre"  required style="flex:2;min-width:160px;padding:9px 12px;border:1.5px solid var(--border);border-radius:8px;">
                        <button type="submit" class="btn_admin btn_aceptar">Agregar</button>
                    </form>
                </div>
                <% if (materias.isEmpty()) { %>
                <div class="admin_empty"><span>No hay materias registradas.</span></div>
                <% } else { %>
                <div class="materias_grid">
                    <% for (Materia m : materias) { %>
                    <div class="materia_card">
                        <span class="materia_card_clave"><%= esc(m.getClave()) %></span>
                        <span class="materia_card_nombre"><%= esc(m.getNombre()) %></span>
                        <form method="post" action="Servlet_Admin"
                              onsubmit="return confirm('¿Eliminar la materia <%= esc(m.getClave()) %>? También se borrarán sus calificaciones.');">
                            <input type="hidden" name="accion" value="EliminarMateria">
                            <input type="hidden" name="clave" value="<%= esc(m.getClave()) %>">
                            <button type="submit" class="btn_admin btn_rechazar">Eliminar</button>
                        </form>
                    </div>
                    <% } %>
                </div>
                <% } %>
            </div>
            </div>

            <%-- ══════════════════════════════════════════
                 CALIFICACIONES
            ══════════════════════════════════════════ --%>
            <div class="tab_panel" id="tab_calificaciones">
            <div class="admin_section">
                <h2 class="admin_section_title">
                    Calificaciones <span class="badge_count"><%= calificaciones.size() %></span>
                </h2>
                <div style="padding:18px 24px;">
                    <form method="post" action="Servlet_Admin">
                        <input type="hidden" name="accion" value="GenerarCalificaciones">
                        <button type="submit" class="btn_admin btn_aceptar">Generar Calificaciones</button>
                        <span style="font-size:12px;color:var(--text-muted);margin-left:10px;">
                            Crea la fila de calificación (0, 0, 0) para cada alumno y materia que aún no la tenga.
                            Vuelve a presionarlo cada vez que agregues un alumno o una materia nueva.
                        </span>
                    </form>
                </div>

                <% if (materias.isEmpty()) { %>
                <div class="admin_empty"><span>Registra una materia primero.</span></div>
                <% } else { %>
                <div class="materias_menu">
                    <button type="button" class="materia_tab vista_general" data-materia="__general__">Vista general (todas)</button>
                    <% for (Materia m : materias) { %>
                    <button type="button" class="materia_tab" data-materia="<%= esc(m.getClave()) %>"><%= esc(m.getNombre()) %></button>
                    <% } %>
                </div>
                <div class="parciales_menu" id="parciales_menu">
                    <span class="lbl">Parcial:</span>
                    <button type="button" class="parcial_tab active" data-parcial="p1">Parcial 1</button>
                    <button type="button" class="parcial_tab" data-parcial="p2">Parcial 2</button>
                    <button type="button" class="parcial_tab" data-parcial="p3">Parcial 3</button>
                </div>
                <% } %>

                <div class="admin_empty" id="calif_placeholder"><span>Selecciona una materia para ver sus calificaciones, o "Vista general" para verlas todas.</span></div>

                <% if (calificaciones.isEmpty()) { %>
                <div class="admin_empty" id="calif_vacio" style="display:none;"><span>No hay calificaciones todavía. Usa el botón "Generar Calificaciones".</span></div>
                <% } else { %>

                <div class="table_wrap" id="calif_table_wrap" style="display:none;">
                <table class="admin_tabla" id="calif_tabla">
                    <thead>
                        <tr>
                            <th style="width:11%;">Matrícula</th>
                            <th>Alumno</th>
                            <th style="width:16%;">Materia</th>
                            <th class="col_p1" style="width:8%;">P1</th>
                            <th class="col_p2" style="width:8%;">P2</th>
                            <th class="col_p3" style="width:8%;">P3</th>
                            <th style="width:8%;">Prom</th>
                            <th style="width:18%;">Acciones</th>
                        </tr>
                    </thead>
                    <tbody id="calif_tbody">
                        <% for (Calificacion c : calificaciones) { %>
                        <tr data-materia="<%= esc(c.getMateriaClave()) %>">
                            <td><%= esc(c.getMatricula()) %></td>
                            <td class="td_clip"><%= esc(c.getAlumnoNombre()) %></td>
                            <td><%= esc(c.getMateriaNombre()) %></td>
                            <td class="col_p1"><input type="number" class="tf_p1" value="<%= c.getP1() %>" min="0" max="10" step="0.1" style="width:64px;padding:5px 6px;border:1.5px solid var(--border);border-radius:6px;"></td>
                            <td class="col_p2"><input type="number" class="tf_p2" value="<%= c.getP2() %>" min="0" max="10" step="0.1" style="width:64px;padding:5px 6px;border:1.5px solid var(--border);border-radius:6px;"></td>
                            <td class="col_p3"><input type="number" class="tf_p3" value="<%= c.getP3() %>" min="0" max="10" step="0.1" style="width:64px;padding:5px 6px;border:1.5px solid var(--border);border-radius:6px;"></td>
                            <td class="td_prom"><%= String.format("%.2f", c.calcProm()) %></td>
                            <td>
                                <button type="button" class="btn_admin btn_aceptar btn_guardar_calif" data-id="<%= c.getId() %>">Guardar</button>
                                <span class="calif_guardar_estado" style="font-size:11px;margin-left:4px;"></span>
                                <form method="post" action="Servlet_Admin" style="display:inline;margin-left:5px;"
                                      onsubmit="return confirm('¿Eliminar esta calificación?');">
                                    <input type="hidden" name="accion" value="EliminarCalificacion">
                                    <input type="hidden" name="id" value="<%= c.getId() %>">
                                    <button type="submit" class="btn_admin btn_rechazar">Eliminar</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
                </div>

                <%-- Vista general: una tabla de solo lectura por materia, en grid.
                     Aquí no hay inputs ni botones — editar solo se permite entrando
                     a la materia específica en el submenú de arriba. --%>
                <div class="calif_general_grid" id="calif_vista_general" style="display:none;">
                    <% for (Materia m : materias) { %>
                    <div class="materia_calif_card">
                        <h3 class="materia_calif_card_title"><%= esc(m.getNombre()) %></h3>
                        <table class="admin_tabla">
                            <thead><tr><th>Matrícula</th><th>Alumno</th><th>P1</th><th>P2</th><th>P3</th><th>Prom</th></tr></thead>
                            <tbody>
                                <% boolean tieneFilas = false;
                                   for (Calificacion c : calificaciones) {
                                       if (!c.getMateriaClave().equals(m.getClave())) continue;
                                       tieneFilas = true;
                                %>
                                <tr>
                                    <td><%= esc(c.getMatricula()) %></td>
                                    <td class="td_clip"><%= esc(c.getAlumnoNombre()) %></td>
                                    <td><%= c.getP1() %></td>
                                    <td><%= c.getP2() %></td>
                                    <td><%= c.getP3() %></td>
                                    <td><%= String.format("%.2f", c.calcProm()) %></td>
                                </tr>
                                <% } if (!tieneFilas) { %>
                                <tr><td colspan="6" style="text-align:center;color:var(--text-muted);">Sin calificaciones</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                    <% } %>
                </div>

                <% } %>
            </div>
            </div>

        </div>

        <%-- ══════════════════════════════════════════
             MODAL: Editar Alumno
        ══════════════════════════════════════════ --%>
        <div id="modal_editar_alumno" class="modal_overlay" style="display:none;"
             onclick="if(event.target===this)cerrarEditarAlumno()">
            <div class="modal_card">
                <div class="modal_header">
                    <h3>Editar Alumno</h3>
                    <button type="button" class="modal_close" onclick="cerrarEditarAlumno()" aria-label="Cerrar">&times;</button>
                </div>
                <form method="post" action="Servlet_Admin">
                    <div class="modal_body">
                        <div class="modal_field">
                            <label for="em_tfMatricula">Matrícula</label>
                            <div class="input_wrapper">
                                <input type="text" name="tfMatricula" id="em_tfMatricula" required
                                       style="padding:11px 14px;border:1.5px solid var(--border);border-radius:8px;width:100%;">
                            </div>
                            <span class="modal_hint">Si la cambias, el correo se actualiza a la nueva matrícula@utrng.edu.mx y el alumno queda sin verificar otra vez.</span>
                        </div>
                        <input type="hidden" name="accion" value="EditarAlumno">
                        <input type="hidden" name="tfMatriculaOld" id="em_tfMatriculaOld">

                        <div class="modal_field">
                            <label for="em_tfNombre">Nombre</label>
                            <div class="input_wrapper">
                                <input type="text" name="tfNombre" id="em_tfNombre" required
                                       style="padding:11px 14px;border:1.5px solid var(--border);border-radius:8px;width:100%;">
                            </div>
                        </div>
                        <div class="modal_field">
                            <label for="em_tfPaterno">Apellido paterno</label>
                            <div class="input_wrapper">
                                <input type="text" name="tfPaterno" id="em_tfPaterno" required
                                       style="padding:11px 14px;border:1.5px solid var(--border);border-radius:8px;width:100%;">
                            </div>
                        </div>
                        <div class="modal_field">
                            <label for="em_tfMaterno">Apellido materno</label>
                            <div class="input_wrapper">
                                <input type="text" name="tfMaterno" id="em_tfMaterno"
                                       style="padding:11px 14px;border:1.5px solid var(--border);border-radius:8px;width:100%;">
                            </div>
                        </div>
                    </div>
                    <div class="modal_footer">
                        <button type="button" class="btn_modal_cancel" onclick="cerrarEditarAlumno()">Cancelar</button>
                        <button type="submit" class="btn_modal_save">Guardar cambios</button>
                    </div>
                </form>
            </div>
        </div>

        <div id="pie_pagina">
            <p>Sistema de Calificaciones</p>
        </div>

        <script>
        (function () {
            var tabBtns   = document.querySelectorAll('.tab_btn');
            var tabPanels = document.querySelectorAll('.tab_panel');

            tabBtns.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    tabBtns.forEach(function (b) { b.classList.remove('active'); });
                    tabPanels.forEach(function (p) { p.classList.remove('active'); });
                    btn.classList.add('active');
                    document.getElementById(btn.dataset.tab).classList.add('active');
                });
            });

            var materiaBtns   = document.querySelectorAll('.materia_tab');
            var parcialBtns   = document.querySelectorAll('.parcial_tab');
            var parcialesMenu = document.getElementById('parciales_menu');
            var placeholder   = document.getElementById('calif_placeholder');
            var vacio         = document.getElementById('calif_vacio');
            var tableWrap     = document.getElementById('calif_table_wrap');
            var vistaGeneral  = document.getElementById('calif_vista_general');

            function aplicarFiltroParcial() {
                var activo = document.querySelector('.parcial_tab.active');
                var parcial = activo ? activo.dataset.parcial : null;
                ['p1', 'p2', 'p3'].forEach(function (p) {
                    var mostrar = !parcial || p === parcial;
                    document.querySelectorAll('#tab_calificaciones .col_' + p).forEach(function (el) {
                        el.style.display = mostrar ? '' : 'none';
                    });
                });
            }

            materiaBtns.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    materiaBtns.forEach(function (b) { b.classList.remove('active'); });
                    btn.classList.add('active');

                    var clave = btn.dataset.materia;
                    var esGeneral = clave === '__general__';

                    placeholder.style.display = 'none';

                    // Vista general: solo lectura, en tablas separadas por materia.
                    // Nunca muestra la tabla editable.
                    if (esGeneral) {
                        if (parcialesMenu) parcialesMenu.classList.remove('show');
                        if (tableWrap) tableWrap.style.display = 'none';
                        if (vistaGeneral) {
                            vistaGeneral.style.display = 'grid';
                            if (vacio) vacio.style.display = 'none';
                        } else if (vacio) {
                            vacio.style.display = '';
                        }
                        return;
                    }

                    // Materia específica: única tabla editable, filtrada por materia y parcial.
                    if (vistaGeneral) vistaGeneral.style.display = 'none';
                    if (parcialesMenu) parcialesMenu.classList.add('show');
                    aplicarFiltroParcial();

                    var filas = tableWrap ? tableWrap.querySelectorAll('tbody tr') : [];
                    var hayFilas = false;
                    filas.forEach(function (tr) {
                        var mostrar = tr.dataset.materia === clave;
                        tr.style.display = mostrar ? '' : 'none';
                        if (mostrar) hayFilas = true;
                    });

                    if (tableWrap && hayFilas) {
                        tableWrap.style.display = '';
                        if (vacio) vacio.style.display = 'none';
                    } else {
                        if (tableWrap) tableWrap.style.display = 'none';
                        if (vacio) vacio.style.display = '';
                    }
                });
            });

            parcialBtns.forEach(function (btn) {
                btn.addEventListener('click', function () {
                    parcialBtns.forEach(function (b) { b.classList.remove('active'); });
                    btn.classList.add('active');
                    aplicarFiltroParcial();
                });
            });

            // Al entrar a la pestaña de Calificaciones, mostrar "Vista general" de una vez.
            var vistaGeneralBtn = document.querySelector('.materia_tab.vista_general');
            if (vistaGeneralBtn) vistaGeneralBtn.click();

            /* ── Guardar calificación por AJAX: no recarga ni redirige,
                 solo actualiza el promedio de esa fila. ─────────────── */
            document.querySelectorAll('.btn_guardar_calif').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var tr     = btn.closest('tr');
                    var id     = btn.dataset.id;
                    var p1     = tr.querySelector('.tf_p1').value;
                    var p2     = tr.querySelector('.tf_p2').value;
                    var p3     = tr.querySelector('.tf_p3').value;
                    var estado = tr.querySelector('.calif_guardar_estado');

                    btn.disabled = true;
                    fetch('Servlet_Admin', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: 'accion=GuardarCalificacion&ajax=1&id=' + encodeURIComponent(id)
                            + '&p1=' + encodeURIComponent(p1)
                            + '&p2=' + encodeURIComponent(p2)
                            + '&p3=' + encodeURIComponent(p3)
                    })
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            btn.disabled = false;
                            if (data.ok) {
                                var promCell = tr.querySelector('.td_prom');
                                if (promCell) promCell.textContent = data.prom;
                                if (estado) {
                                    estado.style.color = '#16a34a';
                                    estado.textContent = '✓ Guardado';
                                    setTimeout(function () { estado.textContent = ''; }, 2000);
                                }
                            } else if (estado) {
                                estado.style.color = 'var(--danger)';
                                estado.textContent = 'Error al guardar';
                            }
                        })
                        .catch(function () {
                            btn.disabled = false;
                            if (estado) {
                                estado.style.color = 'var(--danger)';
                                estado.textContent = 'Error al guardar';
                            }
                        });
                });
            });

        })();

        function abrirEditarAlumno(btn) {
            document.getElementById('em_tfMatricula').value    = btn.dataset.matricula;
            document.getElementById('em_tfMatriculaOld').value = btn.dataset.matricula;
            document.getElementById('em_tfNombre').value       = btn.dataset.nombre;
            document.getElementById('em_tfPaterno').value      = btn.dataset.paterno;
            document.getElementById('em_tfMaterno').value      = btn.dataset.materno;
            document.getElementById('modal_editar_alumno').style.display = 'flex';
        }
        function cerrarEditarAlumno() {
            document.getElementById('modal_editar_alumno').style.display = 'none';
        }
        </script>

    </body>
</html>
