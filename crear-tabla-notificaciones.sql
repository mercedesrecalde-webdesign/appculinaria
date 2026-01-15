-- ========================================
-- RAINERO CULINARIA 4.0
-- Script para crear tabla de notificaciones (Versión Definitiva)
-- ========================================

-- 1. Crear la tabla si no existe
CREATE TABLE IF NOT EXISTS public.notificaciones (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  usuario_id UUID NOT NULL REFERENCES public.usuarios(id) ON DELETE CASCADE,
  emisor_id UUID REFERENCES public.usuarios(id) ON DELETE SET NULL, -- Nueva columna para el remitente
  tipo VARCHAR(50) NOT NULL, -- 'evaluacion', 'evento', 'trabajo', 'mensaje'
  titulo TEXT NOT NULL,
  descripcion TEXT,
  link TEXT,
  leida BOOLEAN DEFAULT false,
  fecha TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Crear índices
CREATE INDEX IF NOT EXISTS idx_notificaciones_usuario ON public.notificaciones(usuario_id);
CREATE INDEX IF NOT EXISTS idx_notificaciones_leida ON public.notificaciones(leida);
CREATE INDEX IF NOT EXISTS idx_notificaciones_fecha ON public.notificaciones(fecha DESC);

-- 3. Deshabilitar Seguridad (RLS) para compatibilidad con login personalizado
-- (Ya que no se usa Supabase Auth nativo, RLS con auth.uid() bloquea la vista)
ALTER TABLE public.notificaciones DISABLE ROW LEVEL SECURITY;

-- 4. Comentarios
COMMENT ON TABLE public.notificaciones IS 'Sistema de notificaciones para RAINERO CULINARIA';
