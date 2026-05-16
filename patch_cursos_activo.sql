-- ==========================================
-- PATCH: Activar cursos que se crearon sin activo=true
-- y agregar DEFAULT true para futuros cursos
-- ==========================================

-- 1. Activar todos los cursos que se crearon sin el flag activo
UPDATE public.cursos SET activo = true WHERE activo IS NULL;

-- 2. Asegurar que la columna activo tenga DEFAULT true para futuros inserts
ALTER TABLE public.cursos ALTER COLUMN activo SET DEFAULT true;
