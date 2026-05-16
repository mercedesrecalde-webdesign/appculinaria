-- ==========================================
-- HABILITAR REALTIME EN NOTIFICACIONES
-- Ejecutar en Supabase SQL Editor
-- ==========================================

-- 1. Permitir que Realtime detecte cambios en filas individuales
ALTER TABLE notificaciones REPLICA IDENTITY FULL;

-- 2. Agregar la tabla a la publicación de Realtime (si no está)
-- Nota: también debés habilitar Realtime desde el Dashboard:
-- Table Editor → notificaciones → Enable Realtime (toggle)
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE notificaciones;
EXCEPTION
  WHEN duplicate_object THEN NULL;
END $$;
