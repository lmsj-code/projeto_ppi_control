# 🐛 Corrigido: Problemas de Autenticação

## ✅ Alterações Implementadas

### 1. **JWT_SECRET Configurado**
- Backend agora usa `JWT_SECRET` do arquivo `.env`
- `docker-compose.yml` inclui `JWT_SECRET` na configuração
- `render.yaml` gera `JWT_SECRET` automaticamente em produção

### 2. **Hashes de Senha Válidos**
Os usuários de teste agora funcionam com hashes bcrypt válidos:
- **Admin**: `admin@ppi.control` / `admin123`
- **Demo**: `demo@ppi.control` / `demo123`

### 3. **CORS Seguro**
- Removido `origin: '*'` (inseguro)
- Agora usa `FRONTEND_URL` específica
- Adicionado `credentials: true` para cookies

### 4. **Axios Centralizado**
- Criado `frontend/src/api/axiosInstance.ts`
- Configurado com `baseURL` automático
- Interceptadores para token JWT
- Redirecionamento automático para login ao expirar

### 5. **Login.tsx e AuthContext.tsx Atualizados**
- Agora usam `axiosInstance` ao invés de `axios`
- URLs relativas: `/auth/login` ao invés de `/api/auth/login`
- Token é incluído automaticamente em headers

## 🚀 Como Testar Localmente

### 1. Instalar Dependências
```bash
# Backend
cd backend
npm install

# Frontend
cd ../frontend
npm install
```

### 2. Iniciar Docker Compose
```bash
cd ..
docker-compose up
```

### 3. Acessar Aplicação
- **Frontend**: http://localhost:5173
- **Backend**: http://localhost:3001
- **Database**: postgresql://localhost:5432/ppi_control

### 4. Login com Credenciais Padrão
- Email: `admin@ppi.control`
- Senha: `admin123`

OU

- Email: `demo@ppi.control`
- Senha: `demo123`

### 5. Criar Nova Conta
- Clique em "Registrar"
- Preencha nome, email e senha
- Clique em "Registrar"
- Nova conta será criada com role `user`

## 📝 Variáveis de Ambiente

### Backend `.env`
```env
PORT=3001
DATABASE_URL=postgresql://ppi_user:ppi_password@postgres:5432/ppi_control
NODE_ENV=development
JWT_SECRET=ppi-control-jwt-secret-key-2024-dev
FRONTEND_URL=http://localhost:5173
```

### Frontend `.env`
```env
VITE_API_URL=http://localhost:3001
```

## 🔐 Segurança em Produção

### Importante!
1. **Mudar `JWT_SECRET`** em produção (Render gera automaticamente)
2. **Verificar `FRONTEND_URL`** no Render
3. **Banco de dados** criar novos usuários via interface, não via seed

## 📊 Fluxo de Autenticação

```
1. Usuário clica "Login" ou "Registrar"
   ↓
2. Login.tsx faz POST para axiosInstance
   ↓
3. axiosInstance resolve URL com VITE_API_URL
   ↓
4. Backend valida credenciais e cria JWT
   ↓
5. Token armazenado em localStorage
   ↓
6. AuthContext adiciona token em headers automáticamente
   ↓
7. Usuário autenticado em todas as requisições futuras
   ↓
8. Se token expirar, axiosInstance redireciona para /login
```

## 🐛 Troubleshooting

### "Falha na autenticação" ao registrar
- Verificar se backend está rodando: `curl http://localhost:3001/api/health`
- Verificar logs do backend: `docker logs ppi-backend`
- Verificar console do navegador (F12) para erros de rede

### CORS Error
- Verificar `FRONTEND_URL` no backend
- Verificar `VITE_API_URL` no frontend
- Verificar porta do frontend (deve ser 5173)

### Token não persiste
- Verificar localStorage: F12 → Application → Local Storage
- Verificar se token está no header: F12 → Network → selecionar requisição → Headers
