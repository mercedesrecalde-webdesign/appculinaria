CREATE POLICY "Permitir inserción anónima" ON public.encuestas_meta_analisis
    FOR INSERT WITH CHECK (true);

-- Política para lectura (Dashboard)
CREATE POLICY "Lectura pública dashboard" ON public.encuestas_meta_analisis
    FOR SELECT USING (true);
-- Crear tabla para encuestas de Meta-Análisis (Anónimas)
DROP TABLE IF EXISTS public.encuestas_satisfaccion CASCADE;

CREATE TABLE IF NOT EXISTS public.encuestas_meta_analisis (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    importancia_formacion INTEGER, -- 1-10
    impacto_profesional TEXT,
    autonomia_tecnica INTEGER, -- 1-10
    comprension_conceptos TEXT,
    ritmo_dificultad TEXT,
    aplicabilidad_real INTEGER, -- 1-10
    claridad_materiales INTEGER, -- 1-10
    innovacion_programa INTEGER, -- 1-10
    probabilidad_recomendacion INTEGER, -- 1-10
    comentarios_cualitativos TEXT
);

-- Habilitar RLS
ALTER TABLE public.encuestas_meta_analisis ENABLE ROW LEVEL SECURITY;

-- Política para permitir inserciones anónimas
