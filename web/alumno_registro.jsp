<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    boolean registrado = Boolean.TRUE.equals(request.getAttribute("registrado"));
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Validar Correo de Alumno</title>
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
                        <rect x="2" y="4" width="20" height="16" rx="2"/>
                        <path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/>
                    </svg>
                    <h2><%= registrado ? "¡Correo registrado!" : "Validar mi correo" %></h2>
                    <p><%= registrado ? "Tu solicitud fue enviada" : "Ingresa tu matrícula para continuar" %></p>
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
                    <p class="registro_ok_msg">Tu correo fue verificado y quedó registrado.</p>
                    <p class="registro_ok_sub">El profesor revisará tu solicitud para darte de alta.</p>

                    <div class="registro_ok_pasos">
                        <div class="paso"><span class="paso_num paso_done">1</span><span>Matrícula encontrada</span></div>
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

                <form method="post" action="Servlet_AlumnoRegistro" id="formAlumnoRegistro" novalidate>

                    <div class="login_field" id="field_matricula">
                        <label for="tfMatricula">Matrícula</label>
                        <div class="input_wrapper">
                            <svg class="field_icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                                 fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                                <circle cx="12" cy="7" r="4"/>
                            </svg>
                            <input type="text" id="tfMatricula" name="tfMatricula"
                                   placeholder="Tu matrícula" required autofocus
                                   value="<%= request.getAttribute("matricula") != null ? request.getAttribute("matricula") : "" %>"/>
                        </div>
                        <div class="campo_feedback" id="fb_matricula"></div>
                    </div>

                    <div>
                        <button type="button" id="btnBuscarMatricula" class="btn_admin"
                                style="background:linear-gradient(135deg,var(--primary),var(--accent));color:#fff;padding:9px 18px;">
                            Buscar
                        </button>
                    </div>

                    <div id="datosAlumno" style="display:none;background:#f8fafc;border:1px solid var(--border);border-radius:8px;padding:14px 16px;margin:4px 0;">
                        <div style="font-size:12px;color:var(--text-muted);margin-bottom:4px;">Matrícula</div>
                        <div id="datoMatricula" style="font-size:14px;font-weight:600;color:var(--text);margin-bottom:10px;"></div>
                        <div style="font-size:12px;color:var(--text-muted);margin-bottom:4px;">Nombre</div>
                        <div id="datoNombre" style="font-size:14px;font-weight:600;color:var(--text);margin-bottom:10px;"></div>
                        <div style="font-size:12px;color:var(--text-muted);margin-bottom:4px;">Correo institucional</div>
                        <div id="datoCorreo" style="font-size:14px;font-weight:600;color:var(--primary);"></div>
                    </div>
                    <input type="hidden" id="tfCorreo" name="tfCorreo">

                    <div id="bloqueEnviarCodigo" style="display:none;">
                        <button type="button" id="btnEnviarCodigo" class="btn_admin btn_aceptar" style="padding:9px 18px;">Enviar código a mi correo</button>
                    </div>

                    <div id="bloqueCodigo" style="display:none;gap:10px;flex-wrap:wrap;align-items:center;">
                        <input type="text" id="tfCodigo" placeholder="Código de 6 dígitos" maxlength="6" inputmode="numeric"
                               style="width:160px;padding:9px 12px;border:1.5px solid var(--border);border-radius:8px;">
                        <button type="button" id="btnVerificarCodigo" class="btn_admin btn_aceptar" style="margin-left:8px;">Verificar código</button>
                    </div>

                    <div class="campo_feedback" id="estadoGeneral" style="margin:6px 0 0;"></div>

                    <input type="submit" id="btnConfirmar" value="Confirmar registro" disabled style="opacity:.5;"/>

                </form>

                <div class="auth_divider">o</div>
                <div class="auth_footer">
                    <a href="Servlet_Login">← Volver al inicio de sesión</a>
                </div>

                <% } %>

            </div>
        </div>

        <div id="pie_pagina">
            <p>Sistema de Calificaciones</p>
        </div>

        <% if (!registrado) { %>
        <script>
        (function () {
            var tfMatricula   = document.getElementById('tfMatricula');
            var btnBuscar     = document.getElementById('btnBuscarMatricula');
            var fbMatricula   = document.getElementById('fb_matricula');
            var datosAlumno   = document.getElementById('datosAlumno');
            var datoMatricula = document.getElementById('datoMatricula');
            var datoNombre    = document.getElementById('datoNombre');
            var datoCorreo    = document.getElementById('datoCorreo');
            var tfCorreo      = document.getElementById('tfCorreo');
            var bloqueEnviar  = document.getElementById('bloqueEnviarCodigo');
            var btnEnviar     = document.getElementById('btnEnviarCodigo');
            var bloqueCodigo  = document.getElementById('bloqueCodigo');
            var tfCodigo      = document.getElementById('tfCodigo');
            var btnVerificar  = document.getElementById('btnVerificarCodigo');
            var estadoGeneral = document.getElementById('estadoGeneral');
            var btnConfirmar  = document.getElementById('btnConfirmar');
            var nombreEncontrado = '';

            function ocultarSiguientesPasos() {
                datosAlumno.style.display = 'none';
                tfCorreo.value = '';
                bloqueEnviar.style.display = 'none';
                bloqueCodigo.style.display = 'none';
                estadoGeneral.textContent  = '';
                btnConfirmar.disabled = true;
                btnConfirmar.style.opacity = '.5';
            }

            tfMatricula.addEventListener('input', ocultarSiguientesPasos);

            btnBuscar.addEventListener('click', function () {
                var matricula = tfMatricula.value.trim();
                if (!matricula) return;
                fbMatricula.className = 'campo_feedback fb_info';
                fbMatricula.textContent = 'Buscando…';

                fetch('Servlet_Validar?tipo=buscar_alumno&matricula=' + encodeURIComponent(matricula))
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data.existe) {
                            fbMatricula.className = 'campo_feedback fb_ok';
                            fbMatricula.textContent = '✓ Alumno encontrado';
                            nombreEncontrado = data.nombre;

                            datoMatricula.textContent = data.matricula;
                            datoNombre.textContent    = data.nombre;
                            datoCorreo.textContent    = data.correo;
                            tfCorreo.value = data.correo;
                            datosAlumno.style.display = 'block';
                            bloqueEnviar.style.display = 'block';
                        } else {
                            fbMatricula.className = 'campo_feedback fb_error';
                            fbMatricula.textContent = 'Matrícula no encontrada. Contacta al profesor.';
                            ocultarSiguientesPasos();
                        }
                    })
                    .catch(function () {
                        fbMatricula.className = 'campo_feedback fb_error';
                        fbMatricula.textContent = 'Error al buscar la matrícula.';
                    });
            });

            btnEnviar.addEventListener('click', function () {
                var correo = tfCorreo.value.trim();
                if (!correo) return;
                btnEnviar.disabled = true;
                btnEnviar.textContent = 'Enviando…';

                fetch('Servlet_Validar?tipo=enviar_codigo_alumno'
                        + '&correo=' + encodeURIComponent(correo)
                        + '&nombre=' + encodeURIComponent(nombreEncontrado))
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        btnEnviar.disabled = false;
                        btnEnviar.textContent = 'Enviar código';
                        if (data.enviado) {
                            bloqueCodigo.style.display = 'flex';
                            estadoGeneral.className = 'campo_feedback fb_info';
                            estadoGeneral.textContent = 'Código enviado. Revisa tu correo.';
                        } else if (data.error === 'dominio_invalido') {
                            estadoGeneral.className = 'campo_feedback fb_error';
                            estadoGeneral.textContent = 'Debes usar tu correo institucional (@utrng.edu.mx).';
                        } else {
                            estadoGeneral.className = 'campo_feedback fb_error';
                            estadoGeneral.textContent = 'No se pudo enviar el correo.';
                        }
                    })
                    .catch(function () {
                        btnEnviar.disabled = false;
                        btnEnviar.textContent = 'Enviar código';
                        estadoGeneral.className = 'campo_feedback fb_error';
                        estadoGeneral.textContent = 'Error al enviar el código.';
                    });
            });

            btnVerificar.addEventListener('click', function () {
                var correo = tfCorreo.value.trim();
                var codigo = tfCodigo.value.trim();
                if (codigo.length !== 6) {
                    estadoGeneral.className = 'campo_feedback fb_error';
                    estadoGeneral.textContent = 'Ingresa los 6 dígitos del código.';
                    return;
                }
                fetch('Servlet_Validar?tipo=verificar_codigo_alumno'
                        + '&correo=' + encodeURIComponent(correo)
                        + '&codigo=' + encodeURIComponent(codigo))
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data.valido) {
                            estadoGeneral.className = 'campo_feedback fb_ok';
                            estadoGeneral.textContent = '✓ Correo verificado. Ya puedes confirmar tu registro.';
                            tfCodigo.disabled = true;
                            btnVerificar.disabled = true;
                            btnConfirmar.disabled = false;
                            btnConfirmar.style.opacity = '1';
                        } else {
                            estadoGeneral.className = 'campo_feedback fb_error';
                            estadoGeneral.textContent = 'Código incorrecto.';
                        }
                    })
                    .catch(function () {
                        estadoGeneral.className = 'campo_feedback fb_error';
                        estadoGeneral.textContent = 'Error al verificar el código.';
                    });
            });
        })();
        </script>
        <% } %>

    </body>
</html>
