-- =============================================
-- PONTO JUSTIFICADO v10 — Multi-tenant SaaS
-- Execute COMPLETO no SQL Editor do Supabase
-- =============================================

-- Apagar tabelas antigas se existirem
DROP TABLE IF EXISTS convocacoes CASCADE;
DROP TABLE IF EXISTS alertas CASCADE;
DROP TABLE IF EXISTS documentos CASCADE;
DROP TABLE IF EXISTS usuarios CASCADE;
DROP TABLE IF EXISTS setores CASCADE;
DROP TABLE IF EXISTS empresa CASCADE;
DROP TABLE IF EXISTS empresas CASCADE;

-- =============================================
-- TABELA CENTRAL: EMPRESAS (uma por cliente)
-- =============================================
CREATE TABLE empresas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome TEXT NOT NULL,
  cnpj TEXT,
  logo_data TEXT,
  codigo TEXT UNIQUE,  -- código de acesso ex: PREF-7X4K
  plano TEXT DEFAULT 'free',
  ativo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- SETORES (por empresa)
-- =============================================
CREATE TABLE setores (
  id SERIAL PRIMARY KEY,
  empresa_id UUID NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  UNIQUE(empresa_id, nome)
);

-- =============================================
-- USUÁRIOS (por empresa)
-- =============================================
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  empresa_id UUID NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  nome TEXT NOT NULL,
  email TEXT NOT NULL,
  senha TEXT NOT NULL,
  perfil TEXT NOT NULL CHECK (perfil IN ('adm','superior','funcionario')),
  setor TEXT,
  matricula TEXT,
  cargo TEXT,
  sig_data TEXT,
  sig_nome TEXT,
  sig_style INTEGER DEFAULT 0,
  ativo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(empresa_id, email)
);

-- =============================================
-- DOCUMENTOS (por empresa)
-- =============================================
CREATE TABLE documentos (
  id SERIAL PRIMARY KEY,
  empresa_id UUID NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  protocolo TEXT NOT NULL,
  func_email TEXT,
  func_nome TEXT,
  func_sig TEXT,
  setor TEXT,
  matricula TEXT,
  cargo TEXT,
  tipo TEXT,
  dias_rows JSONB,
  justif TEXT,
  sup_email TEXT,
  sup_nome TEXT,
  sup_sig TEXT,
  status TEXT DEFAULT 'aguardando_sup',
  decisao TEXT,
  motivo_indeferimento TEXT,
  data_hora TEXT,
  sup_data_hora TEXT,
  rh_recebido_em TEXT,
  anexo JSONB,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(empresa_id, protocolo)
);

-- =============================================
-- ALERTAS (por empresa)
-- =============================================
CREATE TABLE alertas (
  id TEXT PRIMARY KEY,
  empresa_id UUID NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  func_email TEXT,
  func_nome TEXT,
  mensagem TEXT,
  rh_email TEXT,
  lido BOOLEAN DEFAULT FALSE,
  data_hora TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- CONVOCAÇÕES (por empresa)
-- =============================================
CREATE TABLE convocacoes (
  id TEXT PRIMARY KEY,
  empresa_id UUID NOT NULL REFERENCES empresas(id) ON DELETE CASCADE,
  func_email TEXT,
  func_nome TEXT,
  dias JSONB,
  motivo TEXT,
  prazo TEXT,
  status TEXT DEFAULT 'aguardando',
  rh_email TEXT,
  doc_id INTEGER,
  data_hora TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- DESABILITAR RLS (acesso via anon key)
-- =============================================
ALTER TABLE empresas DISABLE ROW LEVEL SECURITY;
ALTER TABLE setores DISABLE ROW LEVEL SECURITY;
ALTER TABLE usuarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE documentos DISABLE ROW LEVEL SECURITY;
ALTER TABLE alertas DISABLE ROW LEVEL SECURITY;
ALTER TABLE convocacoes DISABLE ROW LEVEL SECURITY;

-- =============================================
-- ÍNDICES para performance
-- =============================================
CREATE INDEX idx_usuarios_empresa ON usuarios(empresa_id);
CREATE INDEX idx_empresas_codigo ON empresas(codigo);
CREATE INDEX idx_usuarios_email ON usuarios(empresa_id, email);
CREATE INDEX idx_documentos_empresa ON documentos(empresa_id);
CREATE INDEX idx_documentos_status ON documentos(empresa_id, status);
CREATE INDEX idx_alertas_func ON alertas(empresa_id, func_email);
CREATE INDEX idx_convocacoes_func ON convocacoes(empresa_id, func_email);

SELECT 'Multi-tenant v10 + código de empresa concluído! ✅' as resultado;
