-- ==========================================
-- SCRIPT DE SEGURIDAD (RLS) - TABLAS FALTANTES
-- ==========================================

-- 1. ACTIVAR RLS EN LAS TABLAS FALTANTES
ALTER TABLE IF EXISTS public.asistencias ENABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS public.calificaciones_modulares ENABLE ROW LEVEL SECURITY;

-- 2. POLÍTICAS DE LECTURA (Permite que la app siga leyendo los datos)
DO $$ 
BEGIN
    CREATE POLICY "Lectura Pública" ON public.asistencias FOR SELECT USING (true);
    CREATE POLICY "Lectura Pública" ON public.calificaciones_modulares FOR SELECT USING (true);
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;

-- 3. POLÍTICAS DE ESCRITURA (Permitir inserción y actualización para el uso de la app)
-- Ambas tablas usan .upsert() desde el frontend, por lo que necesitan poltícias de insert y update.
DO $$ 
BEGIN
    CREATE POLICY "Permitir Insert Asistencias" ON public.asistencias FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Asistencias" ON public.asistencias FOR UPDATE USING (true);

    CREATE POLICY "Permitir Insert Calificaciones Modulares" ON public.calificaciones_modulares FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Calificaciones Modulares" ON public.calificaciones_modulares FOR UPDATE USING (true);
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;
