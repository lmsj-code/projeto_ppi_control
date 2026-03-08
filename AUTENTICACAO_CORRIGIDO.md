# 🐛 Corrigido: Problemas de Autenticação - Rodada 2

## 🔴 PROBLEMAS ENCONTRADOS

### 1. **Hashes Inválidos em migrations/001_users.sql**
- Arquivo tinha hashes `$2a$10$X5wFWML...` (fake/placeholder)
- Não correspondia aos hashes válidos em `init.ts`
- Causava falha silenciosa de autenticação (demora no bcrypt ao validar hash inválido)

### 2. **Discrepância de Versão bcrypt**
- migrations: `$2a$10$` (versão antiga - não roda em bcryptjs)
- init.ts: `$2b$10$` (versão correta - bcryptjs 5.0+)
- Se migrations rodava depois de init.ts, sobrescrevia com hashes inválidos

### 3. **Sem Transações em init.ts**
- Múltiplas queries sem `BEGIN/COMMIT`
- Se uma query falhasse, deixava banco em estado inconsistente
- Sem rollback automático

### 4. **seed.sql Apagava Usuários**
- `TRUNCATE CASCADE` não incluía users (por acaso)
- Mas seed.sql não reinseria usuários
- Deixava banco sem credenciais de teste

## ✅ CORREÇÕES IMPLEMENTADAS

### 1. **migrations/001_users.sql - Hashes Corrigidos**
```sql
-- Antes:
$2a$10$X5wFWMLGZqVKrCQqJQJQJOK9J8K9K9K9K9K9K9K9K9K9K9K9K9K9

-- Depois:
$2b$10$FRgjXEoeuc.BeVbs6ypOU.rHCOtVV.Mz/VD1CQ8R7XEpDrajGsx5u (admin123)
$2b$10$Jwrnukzn6UGfJaLMuAZpC.Z/Y/QBTwPckdvASqMyOYsnImlRrYWu2 (demo123)
```

### 2. **init.ts - Transações Adicionadas**
```typescript
try {
  await client.query('BEGIN');
  // ... todas as queries
  await client.query('COMMIT');
} catch (error) {
  await client.query('ROLLBACK');
  throw error;
} finally {
  client.release();
}
```

### 3. **seed.sql - Usuários Restaurados**
```sql
TRUNCATE TABLE ... CASCADE;

-- Restaurar usuários
INSERT INTO users (name, email, password, role, created_at, updated_at)
VALUES 
  ('Administrador', 'admin@ppi.control', '$2b$10$...', 'admin', NOW(), NOW()),
  ('Usuário Demo', 'demo@ppi.control', '$2b$10$...', 'user', NOW(), NOW())
ON CONFLICT (email) DO NOTHING;
```

## 🚀 COMO USAR

### Opção 1: Reset Total do Banco (Recomendado se erro persistir)

**Windows:**
```bash
reset-database.bat
```

Ou manual:
```sql
DROP DATABASE ppi_control;
CREATE DATABASE ppi_control;
```

Depois reiniciar servidor.

**Linux/Mac:**
```bash
chmod +x reset-database.sh
./reset-database.sh
```

### Opção 2: Docker Compose Reset
```bash
docker-compose down -v  # Remove volumes
docker-compose up       # Recria tudo
```

### Opção 3: Seed com Dados de Teste
```bash
psql postgresql://ppi_user:ppi_password@localhost:5432/ppi_control < backend/seed.sql
```

## ✅ TESTAR AUTENTICAÇÃO

1. Acesse: http://localhost:5173
2. Credenciais padrão:
   - Email: `admin@ppi.control`
   - Senha: `admin123`

## 📊 RESUMO DAS MUDANÇAS

| Arquivo | Mudança |
|---------|---------|
| `migrations/001_users.sql` | Replaced placeholder hashes com valores válidos `$2b$` |
| `backend/src/db/init.ts` | Added BEGIN/COMMIT/ROLLBACK transactions |
| `backend/seed.sql` | Added user reinsertion após TRUNCATE |
| `reset-database.sh` | New - Linux/Mac reset script |
| `reset-database.bat` | New - Windows reset script |

## 🔐 CREDENCIAIS DE TESTE

**Admin:**
- Email: `admin@ppi.control`
- Senha: `admin123`

**Demo:**
- Email: `demo@ppi.control`
- Senha: `demo123`

## 📝 PRÓXIMOS PASSOS

```bash
git add .
git commit -m "fix: corrigir hashes de senha, adicionar transações ao DB, restaurar seed"
git push
```

Render buildará automaticamente. Testes devem passar agora!

## 🐛 Se Ainda Tiver Erro

1. Verificar logs:
   ```bash
   docker logs ppi-backend
   docker logs ppi-postgres
   ```

2. Resetar banco usando scripts fornecidos

3. Verificar se JWT_SECRET está definido:
   ```bash
   echo $JWT_SECRET  # Linux/Mac
   echo %JWT_SECRET%  # Windows
   ```
