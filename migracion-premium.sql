-- ======================================================
-- MIGRACIÓN: ACTUALIZACIÓN PARA FUNCIONES PREMIUM
-- RAINERO CULINARIA 4.0
-- ======================================================

-- 1. Actualizar tabla de NOTIFICACIONES para rastrear el emisor
ALTER TABLE public.notificaciones 
ADD COLUMN IF NOT EXISTS emisor_id UUID REFERENCES public.usuarios(id) ON DELETE SET NULL;

-- 2. Actualizar tabla de EVALUACIONES para agendamiento automático
ALTER TABLE public.evaluaciones 
ADD COLUMN IF NOT EXISTS disponible_desde TIMESTAMPTZ,
ADD COLUMN IF NOT EXISTS disponible_hasta TIMESTAMPTZ;

-- Comentario de actualización
COMMENT ON COLUMN public.notificaciones.emisor_id IS 'ID del usuario que originó el mensaje/notificación';
COMMENT ON COLUMN public.evaluaciones.disponible_desde IS 'Fecha de apertura automática de la evaluación';
COMMENT ON COLUMN public.evaluaciones.disponible_hasta IS 'Fecha de cierre automático de la evaluación';

-- Avisar que la migración fue exitosa
DO $$ 
BEGIN 
    RAISE NOTICE 'Base de datos actualizada correctamente para RAINERO CULINARIA 4.0';
END $$;
