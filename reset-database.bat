@echo off
REM Script para limpar e resetar o banco de dados PPI Control (Windows)

setlocal enabledelayedexpansion

echo.
echo ^^!^^!^^! AVISO: Este script vai DELETAR todas os dados do banco de dados ^^^!^^!^^!
echo Banco: ppi_control
echo.
set /p confirm="Digite 'DELETE' para confirmar: "

if /i not "%confirm%"=="DELETE" (
  echo Cancelado.
  goto :end
)

REM Definir variáveis de conexão
set DB_USER=ppi_user
set DB_PASS=ppi_password
set DB_HOST=localhost
set DB_PORT=5432
set DB_NAME=ppi_control

echo.
echo Deletando banco de dados...
set PGPASSWORD=%DB_PASS%
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -c "DROP DATABASE IF EXISTS %DB_NAME%;" >nul 2>&1

if %errorlevel% equ 0 (
  echo ✅ Banco de dados deletado com sucesso
) else (
  echo ❌ Erro ao deletar banco de dados
  goto :end
)

echo Criando novo banco de dados...
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -c "CREATE DATABASE %DB_NAME%;" >nul 2>&1

if %errorlevel% equ 0 (
  echo ✅ Novo banco de dados criado com sucesso
  echo.
  echo ✅ Reset completo! O servidor reinicializará as tabelas automaticamente.
  echo.
  echo Credenciais de teste:
  echo   Email: admin@ppi.control
  echo   Senha: admin123
  echo.
  echo   Email: demo@ppi.control
  echo   Senha: demo123
) else (
  echo ❌ Erro ao criar novo banco de dados
)

:end
set PGPASSWORD=
pause
