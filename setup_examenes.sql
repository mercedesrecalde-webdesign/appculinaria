-- 1. Crear la tabla para registrar las notas de los exámenes interactivos
CREATE TABLE IF NOT EXISTS public.entregas_evaluacion (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    evaluacion_id BIGINT NOT NULL REFERENCES public.evaluaciones(id) ON DELETE CASCADE,
    alumno_id UUID NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
    nota INTEGER NOT NULL,
    aprobado BOOLEAN NOT NULL DEFAULT false,
    respuestas JSONB,
    fecha_entrega TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(evaluacion_id, alumno_id)
);

-- 2. Habilitar Seguridad (RLS)
ALTER TABLE public.entregas_evaluacion ENABLE ROW LEVEL SECURITY;

-- 3. Políticas de acceso (Limpiar previas si existen)
DROP POLICY IF EXISTS "Lectura Pública" ON public.entregas_evaluacion;
DROP POLICY IF EXISTS "Permitir Entregas" ON public.entregas_evaluacion;

-- Todos pueden leer (para que la app pueda mostrar estadísticas o notas)
CREATE POLICY "Lectura Pública" ON public.entregas_evaluacion 
    FOR SELECT USING (true);

-- Todos pueden insertar (para que los alumnos puedan enviar su examen)
CREATE POLICY "Permitir Entregas" ON public.entregas_evaluacion 
    FOR INSERT WITH CHECK (true);
