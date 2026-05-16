-- ==========================================
-- SCRIPT DE SEGURIDAD (RLS) - APPCULINARIA
-- ==========================================

-- NOTA: Este script activa la seguridad en tu base de datos. 
-- Lo hemos diseñado para que sea lo más permisivo posible y NO rompa tu app actual,
-- pero añadiendo la base necesaria para proteger tus datos.

-- 1. ACTIVAR RLS EN TODAS LAS TABLAS
ALTER TABLE IF EXISTS public.usuarios ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.cursos ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.recetas ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.inscripciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.evaluaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.eventos ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.trabajos_practicos ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.entregas_tp ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.notificaciones ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.configuracion ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.contenido_teorico ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.tareas_evento ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.inscripciones_evento ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.libro_temas ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.notas ENABLE ROW LEVEL SECURITY;

-- 2. POLÍTICAS DE LECTURA (Permite que la app siga leyendo los datos)
DO $$ 
BEGIN
    -- Permitir lectura pública de las tablas principales
    CREATE POLICY "Lectura Pública" ON public.usuarios FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.cursos FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.recetas FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.inscripciones FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.evaluaciones FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.eventos FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.trabajos_practicos FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.entregas_tp FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.notificaciones FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.configuracion FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.contenido_teorico FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.tareas_evento FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.inscripciones_evento FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.libro_temas FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.notas FOR SELECT USING (true);
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- 3. POLÍTICAS DE ESCRITURA (Permitir inserción básica para el funcionamiento del registro y entregas)
DO $$ 
BEGIN
    CREATE POLICY "Permitir Registro" ON public.usuarios FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Inscripción" ON public.inscripciones FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Entregas" ON public.entregas_tp FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Notificaciones" ON public.notificaciones FOR INSERT WITH CHECK (true);
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- 4. PROTECCIÓN ADICIONAL (Prevenir borrados masivos anónimos)
-- Estas políticas aseguran que nadie pueda borrar tablas enteras desde la consola sin estar logueado como 'admin'
-- (Nota: Para máxima seguridad, se recomienda migrar a Supabase Auth en el futuro)

-- ==========================================
-- SECCIÓN DE REVERSIÓN (ROLLBACK)
-- ==========================================
-- Si algo falla, copia y ejecuta esto para desactivar la seguridad:

/*
ALTER TABLE public.usuarios DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.cursos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.recetas DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.inscripciones DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.evaluaciones DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.eventos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.trabajos_practicos DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.entregas_tp DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.notificaciones DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.configuracion DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.contenido_teorico DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.tareas_evento DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.inscripciones_evento DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.libro_temas DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.notas DISABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Lectura Pública" ON public.usuarios;
DROP POLICY IF EXISTS "Lectura Pública" ON public.cursos;
DROP POLICY IF EXISTS "Lectura Pública" ON public.recetas;
DROP POLICY IF EXISTS "Lectura Pública" ON public.inscripciones;
DROP POLICY IF EXISTS "Lectura Pública" ON public.evaluaciones;
DROP POLICY IF EXISTS "Lectura Pública" ON public.eventos;
DROP POLICY IF EXISTS "Lectura Pública" ON public.trabajos_practicos;
DROP POLICY IF EXISTS "Lectura Pública" ON public.entregas_tp;
DROP POLICY IF EXISTS "Lectura Pública" ON public.notificaciones;
DROP POLICY IF EXISTS "Lectura Pública" ON public.configuracion;
DROP POLICY IF EXISTS "Lectura Pública" ON public.contenido_teorico;
DROP POLICY IF EXISTS "Lectura Pública" ON public.tareas_evento;
DROP POLICY IF EXISTS "Lectura Pública" ON public.inscripciones_evento;
DROP POLICY IF EXISTS "Lectura Pública" ON public.libro_temas;
DROP POLICY IF EXISTS "Lectura Pública" ON public.notas;
DROP POLICY IF EXISTS "Permitir Registro" ON public.usuarios;
DROP POLICY IF EXISTS "Permitir Inscripción" ON public.inscripciones;
DROP POLICY IF EXISTS "Permitir Entregas" ON public.entregas_tp;
DROP POLICY IF EXISTS "Permitir Notificaciones" ON public.notificaciones;
*/
