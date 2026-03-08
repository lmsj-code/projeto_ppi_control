#!/bin/bash
# Script para limpar e resetar o banco de dados PPI Control

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}⚠️  AVISO: Este script vai DELETAR todas as dados do banco de dados!${NC}"
echo -e "${YELLOW}Banco: ppi_control${NC}"
echo ""
read -p "Digite 'DELETE' para confirmar: " confirm

if [ "$confirm" != "DELETE" ]; then
  echo "Cancelado."
  exit 1
fi

# Definir variáveis de conexão
DB_USER="${POSTGRES_USER:-ppi_user}"
DB_PASS="${POSTGRES_PASSWORD:-ppi_password}"
DB_HOST="${POSTGRES_HOST:-localhost}"
DB_PORT="${POSTGRES_PORT:-5432}"
DB_NAME="ppi_control"

echo -e "${YELLOW}Deletando banco de dados...${NC}"
PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "DROP DATABASE IF EXISTS $DB_NAME;"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Banco de dados deletado com sucesso${NC}"
else
  echo -e "${RED}❌ Erro ao deletar banco de dados${NC}"
  exit 1
fi

echo -e "${YELLOW}Criando novo banco de dados...${NC}"
PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Novo banco de dados criado com sucesso${NC}"
  echo ""
  echo -e "${GREEN}✅ Reset completo! O servidor reinicializará as tabelas automaticamente.${NC}"
  echo -e "${YELLOW}Credenciais de teste:${NC}"
  echo "  Email: admin@ppi.control"
  echo "  Senha: admin123"
  echo ""
  echo "  Email: demo@ppi.control"
  echo "  Senha: demo123"
else
  echo -e "${RED}❌ Erro ao criar novo banco de dados${NC}"
  exit 1
fi
