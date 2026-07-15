<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    boolean registrado = Boolean.TRUE.equals(request.getAttribute("registrado"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Solicitar Acceso</title>
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
                        <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/>
                        <circle cx="9" cy="7" r="4"/>
                        <line x1="19" y1="8" x2="19" y2="14"/>
                        <line x1="22" y1="11" x2="16" y2="11"/>
                    </svg>
                    <h2><%= registrado ? "¡Solicitud enviada!" : "Solicitar Acceso" %></h2>
                    <p><%= registrado ? "Revisa los pasos a continuación" : "Tu solicitud será revisada por el profesor" %></p>
                </div>

                <% if (registrado) { %>
                <div class="registro_ok_panel">

                    <div class="registro_ok_icon">
                        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2"
                             stroke-linecap="round" stroke-linejoin="round">
                            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
                            <polyline points="22 4 12 14.01 9 11.01"/>
                        </svg>
                    </div>

                    <p class="registro_ok_msg">
                        Tu correo fue verificado y tu solicitud quedó registrada.
                    </p>
                    <p class="registro_ok_sub">
                        El profesor (administrador) revisará tu solicitud y decidirá si te da acceso.
                    </p>

                    <div class="registro_ok_pasos">
                        <div class="paso"><span class="paso_num paso_done">1</span><span>Registro</span></div>
                        <div class="paso_linea"></div>
                        <div class="paso"><span class="paso_num paso_done">2</span><span>Correo verificado</span></div>
                        <div class="paso_linea"></div>
                        <div class="paso"><span class="paso_num">3</span><span>Revisión del profesor</span></div>
                    </div>

                    <a href="Servlet_Login" class="link_volver">← Volver al inicio de sesión</a>
                </div>

                <% } else { %>

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

                <form method="post" action="Servlet_Registro" id="formRegistro" novalidate>

                    <div class="login_field" id="field_nombre">
                        <label for="tfNombre">Nombre completo</label>
                        <div class="input_wrapper">
                            <svg class="field_icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                            <input type="text" id="tfNombre" name="tfNombre"
                                   placeholder="Nombre completo" required autofocus
                                   value="<%= request.getAttribute("nombre") != null ? request.getAttribute("nombre") : "" %>"/>
                        </div>
                    </div>

                    <div class="login_field" id="field_correo">
                        <label for="tfCorreo">Correo electrónico</label>
                        <div class="input_wrapper">
                            <svg class="field_icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="2" y="4" width="20" height="16" rx="2"/>
                                <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                            </svg>
                            <input type="email" id="tfCorreo" name="tfCorreo"
                                   placeholder="correo@utrng.edu.mx" required
                                   pattern=".+@utrng\.edu\.mx$" title="Debe ser tu correo institucional (@utrng.edu.mx)"
                                   value="<%= request.getAttribute("correo") != null ? request.getAttribute("correo") : "" %>"/>
                        </div>
                        <div class="campo_feedback" id="fb_correo"></div>
                    </div>

                    <div class="login_field" id="field_usuario">
                        <label for="tfUsuario">Nombre de usuario</label>
                        <div class="input_wrapper">
                            <svg class="field_icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="8" r="4"/>
                                <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"/>
                            </svg>
                            <input type="text" id="tfUsuario" name="tfUsuario"
                                   placeholder="Elige un usuario" required
                                   value="<%= request.getAttribute("usuario") != null ? request.getAttribute("usuario") : "" %>"/>
                        </div>
                        <div class="campo_feedback" id="fb_usuario"></div>
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
                                   placeholder="Mínimo 8 caracteres" required/>
                            <button type="button" class="pwd_toggle" onclick="togglePwd('tfClave',this)" tabindex="-1" aria-label="Mostrar contraseña">
                                <svg class="icon_eye" xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                <svg class="icon_eye_off" xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                            </button>
                        </div>
                    </div>

                    <div class="login_field">
                        <label for="tfClave2">Confirmar contraseña</label>
                        <div class="input_wrapper has_toggle">
                            <svg class="field_icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
                            </svg>
                            <input type="password" id="tfClave2" name="tfClave2"
                                   placeholder="Repite tu contraseña" required/>
                            <button type="button" class="pwd_toggle" onclick="togglePwd('tfClave2',this)" tabindex="-1" aria-label="Mostrar contraseña">
                                <svg class="icon_eye" xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                <svg class="icon_eye_off" xmlns="http://www.w3.org/2000/svg" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="display:none"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>
                            </button>
                        </div>
                    </div>

                    <input type="submit" value="Enviar solicitud"/>

                </form>

                <div class="auth_divider">o</div>
                <div class="auth_footer">
                    ¿Ya tienes cuenta? <a href="Servlet_Login">Inicia sesión</a>
                </div>

                <% } %>

            </div>
        </div>

        <div id="pie_pagina">
            <p>Sistema de Calificaciones</p>
        </div>

        <% if (!registrado) { %>
        <script>
        function togglePwd(id, btn) {
            var inp  = document.getElementById(id);
            var hide = inp.type === 'password';
            inp.type = hide ? 'text' : 'password';
            btn.querySelector('.icon_eye')    .style.display = hide ? 'none' : '';
            btn.querySelector('.icon_eye_off').style.display = hide ? ''     : 'none';
            btn.setAttribute('aria-label', hide ? 'Ocultar contraseña' : 'Mostrar contraseña');
        }

        function verificarExistencia(tipo, valor, fieldId, msgExiste) {
            var field = document.getElementById(fieldId);
            var fb = field.querySelector('.campo_feedback');
            if (!valor) { fb.textContent = ''; return; }
            fetch('Servlet_Validar?tipo=' + tipo + '&valor=' + encodeURIComponent(valor))
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    fb.className = 'campo_feedback ' + (data.existe ? 'fb_error' : 'fb_ok');
                    fb.textContent = data.existe ? msgExiste : '';
                })
                .catch(function () { fb.textContent = ''; });
        }

        document.getElementById('tfCorreo').addEventListener('blur', function () {
            verificarExistencia('correo', this.value.trim(), 'field_correo', 'Este correo ya está registrado.');
        });
        document.getElementById('tfUsuario').addEventListener('blur', function () {
            verificarExistencia('usuario', this.value.trim(), 'field_usuario', 'Este nombre de usuario ya está en uso.');
        });
        </script>
        <% } %>

    </body>
</html>
