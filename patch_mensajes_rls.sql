-- ==========================================
-- SCRIPT DE CORRECCIÓN: MENSAJES / NOTIFICACIONES
-- ==========================================

-- 1. POLÍTICAS DE ACTUALIZACIÓN Y BORRADO
-- Estas políticas permiten que la app pueda "marcar como leído" o "borrar" notificaciones
DO $$ 
BEGIN
    CREATE POLICY "Permitir Actualizar Notificaciones" ON public.notificaciones FOR UPDATE USING (true);
    CREATE POLICY "Permitir Borrar Notificaciones" ON public.notificaciones FOR DELETE USING (true);
EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;
