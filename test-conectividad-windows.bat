@echo off

::===============================================================
:: Ejecuta varias pruebas para determinar si hay conectividad.
:: De NO haberla, intenta determinar dónde está el fallo.
:: 
:: Codificación de texto: DOS CP 437
::===============================================================

:: Estableciendo algunas variables necesarias

	:: Variables modificables

set ip_router=192.168.0.1
set dns_operador=213.60.205.175
set dump_file=%USERPROFILE%\Desktop\prueba-de-conexion.txt

	:: Variables para el control del flujo

set check_quality=0

::===============================================================
:: Inicio del flujo de trabajo
::===============================================================

	:: Metemos la fecha de sistema en el archivo dump, para reducir líos al revisarlo

echo. >> %dump_file%
echo ========================================================== >> %dump_file%
echo ==================== FECHA %date% ==================== >> %dump_file%
echo ========================================================== >> %dump_file%
echo. >> %dump_file%

:: Bienvenida al usuario

echo.
echo Este script probará la conectividad de tu equipo.
echo El resultado se mostrará en pantalla y en un archivo localizado en %dump_file%
echo.


:: Probando la conectividad entre el equipo y el router

Ping %ip_router% -n 1 -w 1000 >> %dump_file%

if errorlevel 1 (echo NO hay conectividad entre el PC y el Router & set check_quality=0) else (echo SI hay conectividad entre el PC y el Router & set check_quality=1)

:: Probando la conectividad entre el router y el CPD del operador
:: En este caso se usan las DNS del operador

Ping %dns_operador% -n 1 -w 1000 >> %dump_file%

if errorlevel 1 (echo NO hay conectividad entre el Router y el CPD del Operador & set check_quality=0) else (echo SI hay conectividad entre el Router y el CPD del Operador & set check_quality=1)

:: Probando conectividad fuera de la red del operador

	:: Probando las DNS de Google

Ping 8.8.8.8 -n 1 -w 1000 >> %dump_file%

if errorlevel 1 (echo NO Hay conectividad con las DNS de Google & set check_quality=0) else (echo SI Hay conectividad con las DNS de Google & set check_quality=1)

	:: Probando con las DNS de Cloudflare (Puede dar problemas con algunos operadores)

Ping 1.1.1.1 -n 1 -w 1000 >> %dump_file%

if errorlevel 1 (echo NO Hay conectividad con las DNS de Cloudflare & set check_quality=0) else (echo SI Hay conectividad con las DNS de Cloudflare & set check_quality=1)

	:: Probando resolución de dominios

Ping google.es -n 1 -w 1000 >> %dump_file%

if errorlevel 1 (echo NO se resuelven dominios & set check_quality=0) else (echo SI se resuelven dominios & set check_quality=1)


:: Probando cuántos paquetes se pierden contra el CPD del operador
:: Sólo se ejecuta si todas las demás pruebas han sido positivas.

if %check_quality% == 1 (

echo.
echo ==========================================
echo Probaremos la calidad de la conexión ahora
echo.
echo.
echo Esto puede tardar un rato. Cuando finalice,
echo el programa te lo hará saber.
echo ==========================================
echo.

Ping %dns_operador% -n 100 >> %dump_file%

echo.
echo.
echo.
echo Prueba finalizada.
echo.
echo Recuerda que el archivo se encuentra en %dump_file%
echo.

)

:: Esperamos a que el usuario presione una tecla
pause
