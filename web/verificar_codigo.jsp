<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String  correoDestino  = (String)  request.getAttribute("correoDestino");
    String  error          = (String)  request.getAttribute("error");
    Boolean codigoEnviado  = (Boolean) request.getAttribute("codigoEnviado");
    String  codigoFallback = (String)  request.getAttribute("codigoFallback");
    Boolean reenvioOk      = (Boolean) request.getAttribute("reenvioOk");
    String  errorCorreo    = (String)  request.getAttribute("errorCorreo");
    if (correoDestino == null) correoDestino = "";

    boolean mostrarFallback = (codigoFallback != null && !codigoFallback.isEmpty());
    boolean mostrarReenvioOk = Boolean.TRUE.equals(reenvioOk);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Verificar correo</title>
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
                    <h2>Verifica tu correo</h2>
                    <p>Ingresa el código de 6 dígitos</p>
                </div>

                <%-- ── Código en pantalla (fallback: correo no enviado) ── --%>
                <% if (mostrarFallback) { %>
                <div class="fallback_box">
                    <div class="fallback_titulo">
                        <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                             fill="none" stroke="currentColor" stroke-width="2.5"
                             stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="10"/>
                            <line x1="12" y1="8" x2="12" y2="12"/>
                            <line x1="12" y1="16" x2="12.01" y2="16"/>
                        </svg>
                        El correo no pudo enviarse. Tu código es:
                    </div>
                    <div class="fallback_codigo"><%= codigoFallback %></div>
                    <div class="fallback_nota">
                        <% if (errorCorreo != null) { %>
                        <strong>Error:</strong> <%= errorCorreo %>
                        <% } else { %>
                        Configura las credenciales en <strong>EnviarCorreo.java</strong> para el envío real.
                        <% } %>
                    </div>
                </div>
                <% } %>

                <%-- ── Reenvío exitoso ── --%>
                <% if (mostrarReenvioOk) { %>
                <div class="login_alert login_exito">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"/>
                    </svg>
                    <span>Código reenviado. Revisa tu bandeja de entrada.</span>
                </div>
                <% } %>

                <%-- ── Error de código incorrecto ── --%>
                <% if (error != null) { %>
                <div class="login_alert login_error">
                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2"
                         stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="12"/>
                        <line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <span><%= error %></span>
                </div>
                <% } %>

                <%-- ── Destino del correo ── --%>
                <% if (!mostrarFallback) { %>
                <p class="verif_hint">
                    Enviamos un código a<br>
                    <span class="verif_correo"><%= correoDestino %></span>
                </p>
                <p class="verif_sub">Revisa también la carpeta de spam.</p>
                <% } else { %>
                <p class="verif_hint" style="margin-top:8px;">
                    Ingresa el código de arriba para verificar<br>
                    <span class="verif_correo"><%= correoDestino %></span>
                </p>
                <% } %>

                <%-- ── Formulario de 6 dígitos ── --%>
                <form method="post" action="Servlet_Verificar" id="formCodigo" novalidate>
                    <div class="codigo_wrapper">
                        <input class="codigo_digit" type="text" name="d1" id="d1"
                               maxlength="1" inputmode="numeric" pattern="[0-9]" autocomplete="one-time-code"/>
                        <input class="codigo_digit" type="text" name="d2" id="d2"
                               maxlength="1" inputmode="numeric" pattern="[0-9]"/>
                        <input class="codigo_digit" type="text" name="d3" id="d3"
                               maxlength="1" inputmode="numeric" pattern="[0-9]"/>
                        <input class="codigo_digit" type="text" name="d4" id="d4"
                               maxlength="1" inputmode="numeric" pattern="[0-9]"/>
                        <input class="codigo_digit" type="text" name="d5" id="d5"
                               maxlength="1" inputmode="numeric" pattern="[0-9]"/>
                        <input class="codigo_digit" type="text" name="d6" id="d6"
                               maxlength="1" inputmode="numeric" pattern="[0-9]"/>
                    </div>
                    <input type="submit" value="Verificar código" id="btnVerificar"/>
                </form>

                <%-- ── Reenviar código ── --%>
                <a href="Servlet_Verificar?action=reenviar" class="btn_reenviar" id="btnReenviar">
                    <svg xmlns="http://www.w3.org/2000/svg" width="15" height="15" viewBox="0 0 24 24"
                         fill="none" stroke="currentColor" stroke-width="2.5"
                         stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="23 4 23 10 17 10"/>
                        <path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"/>
                    </svg>
                    Reenviar código
                </a>
                <div id="timer_txt" style="display:none;"></div>

                <%-- ── Cambiar correo ── --%>
                <a href="Servlet_Verificar?action=cambiar" class="link_cambiar"
                   onclick="return confirm('¿Deseas cambiar el correo? Tu registro actual será eliminado.')">
                    ✏ Cambiar correo electrónico
                </a>

                <div class="auth_divider">o</div>
                <div class="auth_footer">
                    <a href="Servlet_Login">← Volver al inicio de sesión</a>
                </div>

            </div>
        </div>

        <div id="pie_pagina">
            <p>Sistema de Calificaciones</p>
        </div>

        <script>
        (function () {
            /* ── Cuadros de dígitos ─────────────────────────────────── */
            var inputs = ['d1','d2','d3','d4','d5','d6'].map(function(id) {
                return document.getElementById(id);
            });

            inputs[0].focus();

            inputs.forEach(function (inp, idx) {
                inp.addEventListener('keydown', function (e) {
                    if (e.key === 'Backspace') {
                        if (inp.value === '' && idx > 0) {
                            inputs[idx - 1].value = '';
                            inputs[idx - 1].classList.remove('filled');
                            inputs[idx - 1].focus();
                        }
                        inp.classList.remove('filled');
                    } else if (e.key === 'ArrowLeft'  && idx > 0) { inputs[idx-1].focus(); }
                      else if (e.key === 'ArrowRight' && idx < 5) { inputs[idx+1].focus(); }
                });

                inp.addEventListener('input', function () {
                    inp.value = inp.value.replace(/\D/g, '').slice(-1);
                    if (inp.value) {
                        inp.classList.add('filled');
                        if (idx < 5) inputs[idx + 1].focus();
                    } else {
                        inp.classList.remove('filled');
                    }
                });
            });

            /* Pegar código completo */
            inputs[0].addEventListener('paste', function (e) {
                var txt = (e.clipboardData || window.clipboardData).getData('text');
                var dig = txt.replace(/\D/g, '').slice(0, 6);
                if (dig.length > 0) {
                    e.preventDefault();
                    dig.split('').forEach(function (c, i) {
                        if (inputs[i]) { inputs[i].value = c; inputs[i].classList.add('filled'); }
                    });
                    inputs[Math.min(dig.length, 5)].focus();
                }
            });

            /* Validar antes de enviar */
            document.getElementById('formCodigo').addEventListener('submit', function (e) {
                var vacio = inputs.find(function (inp) { return inp.value === ''; });
                if (vacio) { e.preventDefault(); vacio.focus(); }
            });

            /* ── Temporizador del botón "Reenviar" ─────────────────── */
            var btn   = document.getElementById('btnReenviar');
            var timer = document.getElementById('timer_txt');
            var ESPERA = 60;   // segundos

            function iniciarTemporizador() {
                var restante = ESPERA;
                btn.style.pointerEvents = 'none';
                btn.style.opacity       = '0.45';
                timer.style.display     = 'block';

                var iv = setInterval(function () {
                    restante--;
                    timer.textContent = 'Puedes reenviar en ' + restante + ' s';
                    if (restante <= 0) {
                        clearInterval(iv);
                        btn.style.pointerEvents = '';
                        btn.style.opacity       = '';
                        timer.style.display     = 'none';
                    }
                }, 1000);
            }

            btn.addEventListener('click', function (e) {
                /* No bloquear si ya expiró */
                if (btn.style.pointerEvents === 'none') { e.preventDefault(); return; }
                iniciarTemporizador();
            });

            /* Si la página cargó justo tras un reenvío, iniciar contador */
            <% if (mostrarReenvioOk || mostrarFallback) { %>
            iniciarTemporizador();
            <% } %>
        })();
        </script>

    </body>
</html>
