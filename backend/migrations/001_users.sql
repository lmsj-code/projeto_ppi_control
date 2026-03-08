-- Adicionar tabela de usuários
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  avatar VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir usuário admin padrão (senha: admin123)
INSERT INTO users (name, email, password, role, created_at, updated_at)
VALUES ('Administrador', 'admin@ppi.control', '$2b$10$FRgjXEoeuc.BeVbs6ypOU.rHCOtVV.Mz/VD1CQ8R7XEpDrajGsx5u', 'admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (email) DO NOTHING;

-- Criar usuário de demonstração (senha: demo123)
INSERT INTO users (name, email, password, role, created_at, updated_at)
VALUES ('Usuário Demo', 'demo@ppi.control', '$2b$10$Jwrnukzn6UGfJaLMuAZpC.Z/Y/QBTwPckdvASqMyOYsnImlRrYWu2', 'user', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT (email) DO NOTHING;
