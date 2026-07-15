<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Iniciar Sesión</title>
        <link rel="stylesheet" href="style.css">
    </head>
    <body class="bg_auth">

        <div id="encabezado">
            <h1>Sistema de Calificaciones</h1>
        </div>

        <div id="login_wrapper">
            <div id="login_card">

                <div id="login_header">
                    <svg xmlns="http://www.w3.org/2000/svg" width="44" height="44" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="1.8"
                         stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="8" r="4"/>
                        <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
                    </svg>
                    <h2>Iniciar Sesión</h2>
                    <p>Ingresa tus credenciales para continuar</p>
                </div>

                <%-- Error de login --%>
                <% if (request.getAttribute("error") != null) { %>
                <div class="login_alert login_error">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <span><%= request.getAttribute("error") %></span>
                </div>
                <% } %>

                <form method="post" action="Servlet_Login">

                    <div class="login_field">
                        <label for="tfUsuario">Usuario</label>
                        <div class="input_wrapper">
                            <svg class="field_icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="8" r="4"/>
                                <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
                            </svg>
                            <input type="text" id="tfUsuario" name="tfUsuario"
                                   placeholder="Tu nombre de usuario" required autofocus
                                   value="<%= request.getParameter("tfUsuario") != null ? request.getParameter("tfUsuario") : "" %>"/>
                        </div>
                    </div>

                    <div class="login_field">
                        <label for="tfClave">Contraseña</label>
                        <div class="input_wrapper has_toggle">
                            <svg class="field_icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                            <input type="password" id="tfClave" name="tfClave"
                                   placeholder="Tu contraseña" required/>
                            <button type="button" class="pwd_toggle" onclick="togglePwd('tfClave',this)" tabindex="-1" aria-label="Mostrar contraseña">
                                <svg class="icon_eye" xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                <svg class="icon_eye_off" xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                            </button>
                        </div>
                    </div>

                    <input type="submit" value="Entrar"/>

                </form>

                <script>
                function togglePwd(id, btn) {
                    var inp = document.getElementById(id);
                    var hide = inp.type === 'password';
                    inp.type = hide ? 'text' : 'password';
                    btn.querySelector('.icon_eye')    .style.display = hide ? 'none' : '';
                    btn.querySelector('.icon_eye_off').style.display = hide ? ''     : 'none';
                    btn.setAttribute('aria-label', hide ? 'Ocultar contraseña' : 'Mostrar contraseña');
                }
                </script>

                <div class="auth_divider">o</div>
                <div class="auth_footer">
                    ¿Necesitas una cuenta? <a href="Servlet_Registro">Solicita acceso aquí</a><br/>
                    ¿Eres alumno? <a href="Servlet_AlumnoRegistro">Valida tu correo aquí</a>
                </div>

            </div>
        </div>

        <div id="pie_pagina">
            <p>Base de datos MySQL con JSP &amp; Servlet</p>
        </div>

    </body>
</html>
