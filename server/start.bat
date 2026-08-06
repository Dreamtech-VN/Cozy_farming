@echo off
REM Chay game server - tu build neu chua co file .jar, tu dat bien moi truong DB
REM mac dinh neu chua khai bao san. Can Java 21+ va Maven da cai (chi luc build lan dau).
cd /d "%~dp0"

set "JARFILE="
for %%f in (target\game-server-*.jar) do (
    echo %%f | findstr /v "sources" >nul && set "JARFILE=%%f"
)

if not defined JARFILE (
    echo Chua co file build - dang chay mvn package...
    call mvn -q package -DskipTests
    if errorlevel 1 (
        echo Build that bai. Kiem tra loi o tren.
        exit /b 1
    )
    for %%f in (target\game-server-*.jar) do (
        echo %%f | findstr /v "sources" >nul && set "JARFILE=%%f"
    )
)

if not defined DB_URL set "DB_URL=jdbc:mysql://localhost:3306/game"
if not defined DB_USER set "DB_USER=root"
if not defined DB_PASSWORD set "DB_PASSWORD="
if not defined DB_POOL_SIZE set "DB_POOL_SIZE=10"
if not defined SERVER_PORT set "SERVER_PORT=8080"

echo Dang chay game server o cong %SERVER_PORT% (DB: %DB_URL%)...
java -Dserver.port=%SERVER_PORT% -jar "%JARFILE%"
