-- PPI Control - Dados de Demonstração
-- Projeto: Residência Tecnológica em Software

-- Limpar dados existentes (mas não users)
TRUNCATE TABLE feed_logs, compliance_checks, risks, payments, purchases, channel_messages, documents, tasks, projects CASCADE;

-- Garantir que usuários de teste existem
INSERT INTO users (name, email, password, role, created_at, updated_at)
VALUES 
  ('Administrador', 'admin@ppi.control', '$2b$10$FRgjXEoeuc.BeVbs6ypOU.rHCOtVV.Mz/VD1CQ8R7XEpDrajGsx5u', 'admin', NOW(), NOW()),
  ('Usuário Demo', 'demo@ppi.control', '$2b$10$Jwrnukzn6UGfJaLMuAZpC.Z/Y/QBTwPckdvASqMyOYsnImlRrYWu2', 'user', NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- ============================================
-- PROJETOS (sem UUID fixo - PostgreSQL gera automaticamente)
-- ============================================

INSERT INTO projects (name, description, status, budget, start_date, end_date, created_at) VALUES
('Residência Tecnológica em Software - Edição 2024',
 'Programa de capacitação em desenvolvimento de software com foco em inovação tecnológica. Inclui bolsas de estudo, mentoria e projetos práticos.',
 'active',
 850000.00,
 '2024-01-15',
 '2024-12-31',
 NOW() - INTERVAL '2 months'),

('Plataforma de Inovação Aberta',
 'Desenvolvimento de plataforma digital para conectar startups, universidades e empresas em projetos colaborativos de P&D.',
 'active',
 420000.00,
 '2024-03-01',
 '2024-11-30',
 NOW() - INTERVAL '1 month'),

('Capacitação TIC64 - Backend',
 'Formação de desenvolvedores backend com foco em arquitetura de microsserviços, APIs RESTful e banco de dados.',
 'active',
 320000.00,
 '2024-02-01',
 '2024-08-31',
 NOW() - INTERVAL '3 weeks');

-- ============================================
-- TAREFAS (Kanban) - referenciando projetos criados
-- ============================================

-- Coluna: Novos
INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Pagamento de Bolsas - Março/2024', 'Processar pagamento mensal das 45 bolsas da residência tecnológica', 'new', 'high', NULL, '2024-03-05', NOW() - INTERVAL '2 days'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Aquisição de Licenças de Software', 'Comprar 30 licenças JetBrains para os residentes', 'new', 'medium', 'purchase', '2024-03-15', NOW() - INTERVAL '1 day'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Contratação de Consultoria UX/UI', 'Selecionar empresa de consultoria para redesign da plataforma', 'new', 'high', NULL, '2024-03-20', NOW()
FROM projects WHERE name LIKE '%Plataforma%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Renovação de Equipamentos do Lab', 'Comprar 15 notebooks para laboratório de desenvolvimento', 'new', 'high', 'purchase', '2024-03-10', NOW()
FROM projects WHERE name LIKE '%TIC64%';

-- Coluna: Alocados
INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Validação de Frequência - Fevereiro', 'Verificar registros de frequência dos 45 residentes do mês anterior', 'allocated', 'high', 'compliance', '2024-03-03', NOW() - INTERVAL '4 days'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Prestação de Contas - Trimestre 1', 'Preparar documentação para prestação de contas do primeiro trimestre', 'allocated', 'high', 'financial', '2024-04-05', NOW() - INTERVAL '1 week'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Integração com API de Pagamentos', 'Implementar gateway de pagamento na plataforma', 'allocated', 'medium', 'database', '2024-03-25', NOW() - INTERVAL '3 days'
FROM projects WHERE name LIKE '%Plataforma%';

-- Coluna: Em Andamento
INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Pagamento de Bolsas - Fevereiro/2024', 'Processar pagamento das 45 bolsas do mês de fevereiro', 'in_progress', 'high', 'financial', '2024-02-28', NOW() - INTERVAL '2 weeks'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Elaboração de Relatório Técnico', 'Preparar relatório parcial de atividades do TIC64', 'in_progress', 'medium', 'summary', '2024-03-01', NOW() - INTERVAL '1 week'
FROM projects WHERE name LIKE '%TIC64%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Desenvolvimento do Dashboard', 'Criar painel de métricas para usuários da plataforma', 'in_progress', 'medium', 'database', '2024-03-18', NOW() - INTERVAL '5 days'
FROM projects WHERE name LIKE '%Plataforma%';

-- Coluna: Concluídos
INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Seleção de Candidatos - Turma 2024', 'Processo seletivo com 180 candidatos para 45 vagas', 'completed', 'high', 'leader', '2024-01-10', NOW() - INTERVAL '2 months'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Pagamento de Bolsas - Janeiro/2024', 'Primeiro pagamento do programa de residência', 'completed', 'high', 'financial', '2024-02-05', NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO tasks (project_id, title, description, kanban_column, priority, assigned_agent, due_date, created_at)
SELECT id, 'Matrícula dos Alunos', 'Processo de matrícula dos 30 alunos do TIC64', 'completed', 'medium', 'messenger', '2024-02-10', NOW() - INTERVAL '6 weeks'
FROM projects WHERE name LIKE '%TIC64%';

-- ============================================
-- PAGAMENTOS / BOLSAS
-- ============================================

-- Janeiro - Pago
INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Ana Carolina Silva Santos', 1800.00, 'paid', '2024-02-05', 'bolsa', 'Bolsista - Desenvolvimento Backend', NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Bruno Oliveira Costa', 1800.00, 'paid', '2024-02-05', 'bolsa', 'Bolsista - Desenvolvimento Frontend', NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Carla Mendes Pereira', 1800.00, 'paid', '2024-02-05', 'bolsa', 'Bolsista - DevOps', NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Daniel Rodrigues Lima', 1800.00, 'paid', '2024-02-05', 'bolsa', 'Bolsista - QA/Testing', NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Eduarda Ferreira Alves', 1800.00, 'paid', '2024-02-05', 'bolsa', 'Bolsista - Data Science', NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%Residência%';

-- Fevereiro - Pendente
INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Ana Carolina Silva Santos', 1800.00, 'pending', NULL, 'bolsa', 'Bolsista - Desenvolvimento Backend', NOW() - INTERVAL '3 days'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Bruno Oliveira Costa', 1800.00, 'pending', NULL, 'bolsa', 'Bolsista - Desenvolvimento Frontend', NOW() - INTERVAL '3 days'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Carla Mendes Pereira', 1800.00, 'pending', NULL, 'bolsa', 'Bolsista - DevOps', NOW() - INTERVAL '3 days'
FROM projects WHERE name LIKE '%Residência%';

-- TIC64
INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Felipe Santos Araújo', 1500.00, 'paid', '2024-02-10', 'bolsa', 'Bolsista TIC64 - Backend', NOW() - INTERVAL '6 weeks'
FROM projects WHERE name LIKE '%TIC64%';

INSERT INTO payments (project_id, beneficiary, amount, status, payment_date, category, notes, created_at)
SELECT id, 'Gabriela Lima Souza', 1500.00, 'paid', '2024-02-10', 'bolsa', 'Bolsista TIC64 - Backend', NOW() - INTERVAL '6 weeks'
FROM projects WHERE name LIKE '%TIC64%';

-- ============================================
-- COMPRAS / COTAÇÕES
-- ============================================

INSERT INTO purchases (project_id, item, description, status, quotations, selected_quotation, created_at)
SELECT id, 'Licenças JetBrains IntelliJ IDEA', '30 licenças anuais para desenvolvimento Java/Kotlin', 'selected',
 '[{"supplier":"Distribuidor Tech Solutions","price":28500.00,"deadline":"5 dias úteis","notes":"Inclui suporte técnico"},{"supplier":"Software House Brasil","price":29400.00,"deadline":"7 dias úteis","notes":"Garantia de 2 anos"},{"supplier":"Revenda Autorizada JetBrains","price":31200.00,"deadline":"3 dias úteis","notes":"Suporte premium incluído"}]'::jsonb,
 0, NOW() - INTERVAL '2 days'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO purchases (project_id, item, description, status, quotations, selected_quotation, created_at)
SELECT id, 'Notebooks Dell Inspiron 15', '15 notebooks para laboratório - i7, 16GB RAM, 512GB SSD', 'ready_for_comparison',
 '[{"supplier":"Dell Brasil","price":82500.00,"deadline":"15 dias úteis","notes":"Garantia de 3 anos onsite"},{"supplier":"Magazine Empresas","price":79800.00,"deadline":"10 dias úteis","notes":"Garantia de 2 anos"},{"supplier":"Amazon Business","price":78200.00,"deadline":"8 dias úteis","notes":"Frete grátis"}]'::jsonb,
 NULL, NOW() - INTERVAL '1 day'
FROM projects WHERE name LIKE '%TIC64%';

INSERT INTO purchases (project_id, item, description, status, quotations, selected_quotation, created_at)
SELECT id, 'Consultoria UX/UI - Redesign Plataforma', 'Consultoria de 3 meses para redesign completo da interface', 'pending_quotations',
 '[]'::jsonb, NULL, NOW()
FROM projects WHERE name LIKE '%Plataforma%';

INSERT INTO purchases (project_id, item, description, status, quotations, selected_quotation, created_at)
SELECT id, 'Serviços de Cloud AWS', 'Créditos AWS para hospedagem da plataforma de inovação', 'completed',
 '[{"supplier":"AWS Direct","price":15000.00,"deadline":"Imediato","notes":"Créditos anuais"},{"supplier":"AWS Partner Network","price":14500.00,"deadline":"2 dias","notes":"Parceiro certificado"},{"supplier":"Cloud Services Brasil","price":16000.00,"deadline":"1 dia","notes":"Suporte 24/7"}]'::jsonb,
 1, NOW() - INTERVAL '2 weeks'
FROM projects WHERE name LIKE '%Residência%';

-- ============================================
-- DOCUMENTOS
-- ============================================

INSERT INTO documents (project_id, name, type, category, content, metadata, created_at)
SELECT id, 'Edital de Seleção 2024', 'pdf', 'compliance',
 'Documento oficial do processo seletivo para o programa de residência tecnológica...',
 '{"pages": 15, "version": "2.0", "approved_by": "Coordenação PPI"}'::jsonb, NOW() - INTERVAL '2 months'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO documents (project_id, name, type, category, content, metadata, created_at)
SELECT id, 'Lista de Bolsistas - Fevereiro 2024', 'spreadsheet', 'financial',
 'Nome,CPF,Valor_Bolsa,Data_Pagamento,Status
Ana Carolina Silva Santos,123.456.789-00,1800.00,05/02/2024,Pago
Bruno Oliveira Costa,234.567.890-11,1800.00,05/02/2024,Pago
Carla Mendes Pereira,345.678.901-22,1800.00,05/02/2024,Pago',
 '{"total_bolsistas": 45, "valor_total": 81000.00, "mes_referencia": "02/2024"}'::jsonb, NOW() - INTERVAL '3 weeks'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO documents (project_id, name, type, category, content, metadata, created_at)
SELECT id, 'Termo de Compromisso - Modelo', 'contract', 'compliance',
 'TERMO DE COMPROMISSO DE BOLSISTA
Programa Prioritário de Informática - PPI Softex
Residência Tecnológica em Software...',
 '{"template": true, "version": "3.1"}'::jsonb, NOW() - INTERVAL '2 months'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO documents (project_id, name, type, category, content, metadata, created_at)
SELECT id, 'Especificação Técnica - Plataforma', 'document', 'general',
 'Documento de especificação técnica da Plataforma de Inovação Aberta...',
 '{"pages": 45, "status": "em_revisao"}'::jsonb, NOW() - INTERVAL '3 weeks'
FROM projects WHERE name LIKE '%Plataforma%';

INSERT INTO documents (project_id, name, type, category, content, metadata, created_at)
SELECT id, 'Plano de Ensino - TIC64 Backend', 'document', 'general',
 'Plano de ensino do curso de capacitação em desenvolvimento backend...',
 '{"carga_horaria": 400, "modulos": 8}'::jsonb, NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%TIC64%';

INSERT INTO documents (project_id, name, type, category, content, metadata, created_at)
SELECT id, 'Nota Fiscal - AWS Credits', 'pdf', 'financial',
 'Nota fiscal referente à aquisição de créditos AWS...',
 '{"numero_nf": "123456", "valor": 14500.00, "data": "15/02/2024"}'::jsonb, NOW() - INTERVAL '2 weeks'
FROM projects WHERE name LIKE '%Residência%';

-- ============================================
-- RISCOS
-- ============================================

INSERT INTO risks (project_id, description, severity, status, mitigation, identified_at, resolved_at)
SELECT id, 'Atraso na validação de frequência pode impactar pagamento de bolsas', 'high', 'active',
 'Automatizar coleta de frequência e criar alertas com 5 dias de antecedência', NOW() - INTERVAL '1 week', NULL
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO risks (project_id, description, severity, status, mitigation, identified_at, resolved_at)
SELECT id, 'Documentação de prestação de contas incompleta para o trimestre', 'medium', 'active',
 'Designar responsável para compilar documentação até 25/03', NOW() - INTERVAL '3 days', NULL
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO risks (project_id, description, severity, status, mitigation, identified_at, resolved_at)
SELECT id, 'Possível glosa por falta de evidências de execução do projeto', 'high', 'active',
 'Solicitar relatórios de progresso semanais e armazenar no sistema', NOW() - INTERVAL '5 days', NULL
FROM projects WHERE name LIKE '%Plataforma%';

INSERT INTO risks (project_id, description, severity, status, mitigation, identified_at, resolved_at)
SELECT id, 'Equipamentos do laboratório com garantia vencendo', 'low', 'resolved',
 'Renovação de garantia contratada em 10/02/2024', NOW() - INTERVAL '1 month', NOW() - INTERVAL '2 weeks'
FROM projects WHERE name LIKE '%TIC64%';

INSERT INTO risks (project_id, description, severity, status, mitigation, identified_at, resolved_at)
SELECT id, 'Bolsista pode desistir durante o programa', 'medium', 'active',
 'Manter lista de candidatos em espera para reposição', NOW() - INTERVAL '2 weeks', NULL
FROM projects WHERE name LIKE '%Residência%';

-- ============================================
-- FEED / LOGS
-- ============================================

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'purchase', 'purchase', 'Cotação selecionada: Distribuidor Tech Solutions - R$ 28.500,00',
 '{"item": "Licenças JetBrains", "savings": 2700.00}'::jsonb, NOW() - INTERVAL '2 days'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'compliance', 'compliance', 'Iniciada validação de frequência - 45 bolsistas',
 '{"total": 45, "validados": 32}'::jsonb, NOW() - INTERVAL '1 day'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'financial', 'financial', 'Lote de pagamento criado - 45 bolsas de Fevereiro',
 '{"total": 81000.00, "bolsistas": 45}'::jsonb, NOW() - INTERVAL '3 days'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'leader', 'task', 'Tarefa concluída: Seleção de Candidatos - Turma 2024',
 '{"candidatos": 180, "aprovados": 45}'::jsonb, NOW() - INTERVAL '2 months'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'database', 'task', 'Desenvolvimento do Dashboard iniciado',
 '{"sprint": 3, "estimativa_dias": 15}'::jsonb, NOW() - INTERVAL '5 days'
FROM projects WHERE name LIKE '%Plataforma%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'summary', 'report', 'Relatório técnico parcial gerado',
 '{"paginas": 12, "modulo": "Backend APIs"}'::jsonb, NOW() - INTERVAL '1 week'
FROM projects WHERE name LIKE '%TIC64%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'compliance', 'risk', 'Risco identificado: Atraso na validação de frequência',
 '{"severity": "high", "impacto": "pagamento_bolsas"}'::jsonb, NOW() - INTERVAL '1 week'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'messenger', 'alert', 'Alerta: Tarefa "Pagamento de Bolsas - Março" vence em 5 dias',
 '{"task": "Pagamento de Bolsas - Março/2024"}'::jsonb, NOW() - INTERVAL '4 hours'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT NULL, 'leader', 'system', 'Relatório diário gerado automaticamente',
 '{"tarefas_concluidas": 3, "pagamentos_processados": 5, "riscos_mitigados": 1}'::jsonb, NOW() - INTERVAL '1 day';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'purchase', 'purchase', '3 cotações recebidas para Notebooks Dell',
 '{"menor_preco": 78200.00, "economia_potencial": 4300.00}'::jsonb, NOW() - INTERVAL '1 day'
FROM projects WHERE name LIKE '%TIC64%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'leader', 'task', 'Processo seletivo iniciado',
 '{"vagas": 45, "inscricoes": 180}'::jsonb, NOW() - INTERVAL '2 months'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'financial', 'financial', 'Pagamento processado: Janeiro/2024',
 '{"valor_total": 81000.00, "bolsistas": 45}'::jsonb, NOW() - INTERVAL '1 month'
FROM projects WHERE name LIKE '%Residência%';

INSERT INTO feed_logs (project_id, agent, category, action, details, created_at)
SELECT id, 'messenger', 'notification', 'Matrícula concluída para 30 alunos',
 '{"turma": "TIC64-2024"}'::jsonb, NOW() - INTERVAL '6 weeks'
FROM projects WHERE name LIKE '%TIC64%';

-- ============================================
-- CANAIS DE COMUNICAÇÃO (um por projeto)
-- ============================================

-- Canal: Email Coordenação (Residência)
INSERT INTO channel_messages (project_id, channel, direction, content, metadata, created_at)
SELECT id, 'email-coordenacao', 'outbound', 'Envio de relatório mensal de atividades para coordenação do PPI',
 '{"destinatario": "coordenacao@ppisoftex.org.br"}'::jsonb, NOW() - INTERVAL '1 week'
FROM projects WHERE name LIKE '%Residência%';

-- Canal: Slack Residência
INSERT INTO channel_messages (project_id, channel, direction, content, metadata, created_at)
SELECT id, 'slack-residencia', 'outbound', '📢 Lembrete: Prazo de submissão de projetos hoje às 18h',
 '{"canal": "#residencia-2024"}'::jsonb, NOW() - INTERVAL '3 days'
FROM projects WHERE name LIKE '%Residência%';

-- Canal: WhatsApp TIC64
INSERT INTO channel_messages (project_id, channel, direction, content, metadata, created_at)
SELECT id, 'whatsapp-tic64', 'outbound', '⚠️ Aula de amanhã remarcada para quinta-feira às 14h',
 '{"grupo": "TIC64 Backend 2024"}'::jsonb, NOW() - INTERVAL '2 days'
FROM projects WHERE name LIKE '%TIC64%';

-- Canal: Email Stakeholders (Plataforma)
INSERT INTO channel_messages (project_id, channel, direction, content, metadata, created_at)
SELECT id, 'email-stakeholders', 'outbound', 'Convite para reunião de acompanhamento trimestral',
 '{"data": "15/03/2024", "hora": "10:00"}'::jsonb, NOW() - INTERVAL '5 days'
FROM projects WHERE name LIKE '%Plataforma%';

-- Resposta no canal
INSERT INTO channel_messages (project_id, channel, direction, content, metadata, created_at)
SELECT id, 'slack-residencia', 'inbound', 'Bolsista solicitou alteração de projeto',
 '{"bolsista": "Ana Carolina", "novo_projeto": "Plataforma de Inovação"}'::jsonb, NOW() - INTERVAL '4 days'
FROM projects WHERE name LIKE '%Residência%';

-- ============================================
-- COMPLIANCE CHECKS
-- ============================================

INSERT INTO compliance_checks (project_id, document_id, check_type, status, issues, checked_at)
SELECT p.id, d.id, 'document_verification', 'passed', '{"issues": []}'::jsonb, NOW() - INTERVAL '2 months'
FROM projects p, documents d
WHERE p.name LIKE '%Residência%' AND d.name = 'Edital de Seleção 2024';

INSERT INTO compliance_checks (project_id, document_id, check_type, status, issues, checked_at)
SELECT p.id, d.id, 'payment_verification', 'passed', '{"issues": [], "bolsistas_validados": 45}'::jsonb, NOW() - INTERVAL '3 weeks'
FROM projects p, documents d
WHERE p.name LIKE '%Residência%' AND d.name LIKE '%Lista de Bolsistas%';

INSERT INTO compliance_checks (project_id, document_id, check_type, status, issues, checked_at)
SELECT p.id, d.id, 'document_verification', 'failed', '{"issues": ["Especificação técnica desatualizada", "Faltam diagramas de arquitetura"]}'::jsonb, NOW() - INTERVAL '1 week'
FROM projects p, documents d
WHERE p.name LIKE '%Plataforma%' AND d.name LIKE '%Especificação%';

INSERT INTO compliance_checks (project_id, document_id, check_type, status, issues, checked_at)
SELECT id, NULL, 'frequency_validation', 'pending', '{"issues": [], "bolsistas_verificados": 32, "total": 45}'::jsonb, NOW() - INTERVAL '1 day'
FROM projects WHERE name LIKE '%Residência%';

-- ============================================
-- FIM DO SEED
-- ============================================
