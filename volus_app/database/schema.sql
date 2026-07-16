-- ========================================================
-- VOLUTS TETO - BANCO DE DADOS POSTGRESQL (SUPABASE)
-- SCRIPT DE CRIAÇÃO E POVOAMENTO INICIAL (SCHEMA & SEEDS)
-- ========================================================

-- 1. TABELA DE USUÁRIOS
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(50) DEFAULT 'voluntario', -- 'voluntario' ou 'admin'
    nucleus VARCHAR(100) DEFAULT 'Núcleo SP',
    photo_url TEXT,
    birth_date DATE DEFAULT '1995-08-15',
    cpf VARCHAR(14) DEFAULT '123.456.789-00',
    emergency_contact VARCHAR(255) DEFAULT '(11) 98765-4321 - Mãe',
    is_available BOOLEAN DEFAULT true,
    unavailable_reason VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. TABELA DE PROJETOS ATIVOS
CREATE TABLE IF NOT EXISTS public.projects (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL, -- 'construcao', 'reforma', 'captacao', 'pesquisa'
    status VARCHAR(50) NOT NULL,    -- 'em_andamento', 'planejamento', 'captacao'
    location VARCHAR(255) NOT NULL,
    progress_percentage INT DEFAULT 0,
    target_amount NUMERIC(10, 2) DEFAULT 0,
    raised_amount NUMERIC(10, 2) DEFAULT 0,
    start_date DATE,
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. TABELA DE EVENTOS
CREATE TABLE IF NOT EXISTS public.events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    location VARCHAR(255) NOT NULL,
    event_date DATE NOT NULL,
    start_time VARCHAR(20) NOT NULL,
    end_time VARCHAR(20) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. TABELA DE ESCALAS DE VOLUNTÁRIOS
CREATE TABLE IF NOT EXISTS public.escalas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID REFERENCES public.events(id) ON DELETE CASCADE,
    volunteer_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'pendente', -- 'pendente', 'confirmado', 'presente', 'indisponivel', 'troca_solicitada'
    swap_requested BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. TABELA DE DEPOIMENTOS
CREATE TABLE IF NOT EXISTS public.testimonials (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_name VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'pendente', -- 'pendente', 'aprovado', 'rejeitado'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. TABELA DE AVISOS URGENTES
CREATE TABLE IF NOT EXISTS public.announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'media', -- 'alta', 'media', 'baixa'
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ========================================================
-- HABILITAR PERMISSÕES DE LEITURA E ESCRITA PÚBLICA (RLS)
-- ========================================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.escalas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.testimonials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.announcements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Acesso total publico users" ON public.users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total publico projects" ON public.projects FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total publico events" ON public.events FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total publico escalas" ON public.escalas FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total publico testimonials" ON public.testimonials FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Acesso total publico announcements" ON public.announcements FOR ALL USING (true) WITH CHECK (true);

-- ========================================================
-- DADOS INICIAIS DE EXEMPLO (SEEDS)
-- ========================================================

-- Inserir Usuários
INSERT INTO public.users (name, email, role, nucleus, is_available) VALUES
('João Silva', 'joao.silva@teto.org', 'voluntario', 'Núcleo SP', true),
('Ricardo Mendes', 'ricardo.mendes@teto.org', 'admin', 'Núcleo SP (Coordenador)', true),
('Ana Clara Souza', 'ana.clara@teto.org', 'voluntario', 'Núcleo SP', true),
('Bruno Martins', 'bruno.martins@teto.org', 'voluntario', 'Núcleo SP', true),
('Camila Ribeiro', 'camila.ribeiro@teto.org', 'voluntario', 'Núcleo SP', false),
('Diego Fernandes', 'diego.fernandes@teto.org', 'voluntario', 'Núcleo SP', true)
ON CONFLICT (email) DO NOTHING;

-- Inserir Projetos Ativos
INSERT INTO public.projects (title, category, status, location, progress_percentage, target_amount, raised_amount, start_date) VALUES
('Construção de Banheiros Sustentáveis', 'construcao', 'em_andamento', 'Comunidade Esperança, SP', 65, 30000, 19500, '2024-05-10'),
('Reforma da Sede Comunitária', 'reforma', 'planejamento', 'Jardim Ângela, SP', 10, 15000, 1500, '2024-10-15'),
('Coleta Nacional nas Ruas', 'captacao', 'captacao', 'São Paulo - Centro', 30, 50000, 15000, '2024-06-01')
ON CONFLICT DO NOTHING;

-- Inserir Evento e Escala de Teste
INSERT INTO public.events (id, title, category, location, event_date, start_time, end_time, description) VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Construção Comunitária - Vila Nova', 'Construção', 'Zona Sul, São Paulo', '2024-11-15', '08:00', '18:00', 'Ação presencial de construção de moradias emergenciais.')
ON CONFLICT DO NOTHING;

-- Inserir Depoimentos Iniciais
INSERT INTO public.testimonials (author_name, content, status) VALUES
('Maria Oliveira', 'Participar da construção na Vila Esperança mudou minha visão sobre impacto social!', 'pendente'),
('Carlos Santos', 'Excelente organização e energia incrível de toda a equipe de voluntários.', 'pendente')
ON CONFLICT DO NOTHING;

-- Inserir Avisos Urgentes
INSERT INTO public.announcements (title, description, priority) VALUES
('Alerta Meteorológico', 'Previsão de fortes chuvas para o próximo final de semana. Mantenha os equipamentos protegidos.', 'alta'),
('Reunião Geral de Alocação', 'Reunião de alocação de voluntários agendada para a próxima terça-feira às 19h via Meet.', 'media')
ON CONFLICT DO NOTHING;
