-- ============================================
-- PATCH: Visibilidad programada de contenidos
-- Ejecutar en Supabase SQL Editor
-- ============================================

-- 1. Contenido Teórico: disponible desde una fecha (sin hora, indefinido)
ALTER TABLE contenido_teorico ADD COLUMN IF NOT EXISTS disponible_desde date;

-- 2. Trabajos Prácticos: disponible desde/hasta (con fecha y hora)
ALTER TABLE trabajos_practicos ADD COLUMN IF NOT EXISTS disponible_desde timestamptz;
ALTER TABLE trabajos_practicos ADD COLUMN IF NOT EXISTS disponible_hasta timestamptz;
