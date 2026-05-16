-- ==========================================
-- PATCH: Políticas INSERT/UPDATE faltantes
-- ==========================================
-- Este script agrega las políticas de escritura que faltan
-- en las tablas que tienen RLS activado pero solo SELECT.
-- NO modifica ni borra políticas existentes.

DO $$ 
BEGIN
    -- CURSOS
    CREATE POLICY "Permitir Insert Cursos" ON public.cursos FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Cursos" ON public.cursos FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Cursos" ON public.cursos FOR DELETE USING (true);

    -- RECETAS
    CREATE POLICY "Permitir Insert Recetas" ON public.recetas FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Recetas" ON public.recetas FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Recetas" ON public.recetas FOR DELETE USING (true);

    -- EVALUACIONES
    CREATE POLICY "Permitir Insert Evaluaciones" ON public.evaluaciones FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Evaluaciones" ON public.evaluaciones FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Evaluaciones" ON public.evaluaciones FOR DELETE USING (true);

    -- EVENTOS
    CREATE POLICY "Permitir Insert Eventos" ON public.eventos FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Eventos" ON public.eventos FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Eventos" ON public.eventos FOR DELETE USING (true);

    -- TRABAJOS PRÁCTICOS
    CREATE POLICY "Permitir Insert TPs" ON public.trabajos_practicos FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update TPs" ON public.trabajos_practicos FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete TPs" ON public.trabajos_practicos FOR DELETE USING (true);

    -- CONTENIDO TEÓRICO
    CREATE POLICY "Permitir Insert Contenido" ON public.contenido_teorico FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Contenido" ON public.contenido_teorico FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Contenido" ON public.contenido_teorico FOR DELETE USING (true);

    -- LIBRO DE TEMAS
    CREATE POLICY "Permitir Insert Libro" ON public.libro_temas FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Libro" ON public.libro_temas FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Libro" ON public.libro_temas FOR DELETE USING (true);

    -- CONFIGURACIÓN
    CREATE POLICY "Permitir Insert Config" ON public.configuracion FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Config" ON public.configuracion FOR UPDATE USING (true);

    -- TAREAS DE EVENTO
    CREATE POLICY "Permitir Insert Tareas Evento" ON public.tareas_evento FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Tareas Evento" ON public.tareas_evento FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Tareas Evento" ON public.tareas_evento FOR DELETE USING (true);

    -- INSCRIPCIONES EVENTO
    CREATE POLICY "Permitir Insert Inscripcion Evento" ON public.inscripciones_evento FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Inscripcion Evento" ON public.inscripciones_evento FOR UPDATE USING (true);
    CREATE POLICY "Permitir Delete Inscripcion Evento" ON public.inscripciones_evento FOR DELETE USING (true);

    -- NOTAS
    CREATE POLICY "Permitir Insert Notas" ON public.notas FOR INSERT WITH CHECK (true);
    CREATE POLICY "Permitir Update Notas" ON public.notas FOR UPDATE USING (true);

    -- USUARIOS (faltaba UPDATE)
    CREATE POLICY "Permitir Update Usuarios" ON public.usuarios FOR UPDATE USING (true);

    -- INSCRIPCIONES (faltaba UPDATE)
    CREATE POLICY "Permitir Update Inscripciones" ON public.inscripciones FOR UPDATE USING (true);

    -- ENTREGAS TP (faltaba UPDATE)
    CREATE POLICY "Permitir Update Entregas" ON public.entregas_tp FOR UPDATE USING (true);

    -- NOTIFICACIONES (faltaba UPDATE)
    CREATE POLICY "Permitir Update Notificaciones" ON public.notificaciones FOR UPDATE USING (true);

EXCEPTION
    WHEN duplicate_object THEN NULL;
END $$;
