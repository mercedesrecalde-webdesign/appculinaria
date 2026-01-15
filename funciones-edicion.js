// ========== FUNCIONES DE EDICIÓN Y ELIMINACIÓN ==========

// Variables globales para edición
let currentEvaluacionId = null;
let currentEventoId = null;

// ========== EVALUACIONES ==========
async function eliminarEvaluacion(id) {
  if (!confirm('¿Estás segura de eliminar esta evaluación?')) return;

  try {
    const { error } = await db.from('evaluaciones').delete().eq('id', id);
    if (error) throw error;

    alert('✅ Evaluación eliminada');
    await renderEvaluaciones();
  } catch (e) {
    alert('❌ Error al eliminar: ' + e.message);
  }
}

async function editarEvaluacion(id) {
  const { data: eval } = await db.from('evaluaciones').select('*').eq('id', id).single();
  if (!eval) return alert('No se encontró la evaluación');

  currentEvaluacionId = id;
  document.getElementById('edit-eval-titulo').value = eval.titulo || '';
  document.getElementById('edit-eval-tipo').value = eval.tipo || 'google';
  document.getElementById('edit-eval-fecha').value = eval.fecha || '';
  document.getElementById('edit-eval-link').value = eval.link_externo || '';
  show('modal-edit-evaluacion');
}

async function guardarEditEvaluacion() {
  const titulo = document.getElementById('edit-eval-titulo').value;
  const tipo = document.getElementById('edit-eval-tipo').value;
  const fecha = document.getElementById('edit-eval-fecha').value;
  const link = document.getElementById('edit-eval-link').value;

  if (!titulo) return alert('Completá el título');

  await db.from('evaluaciones').update({
    titulo,
    tipo,
    fecha,
    link_externo: link
  }).eq('id', currentEvaluacionId);

  closeModal('edit-evaluacion');
  await renderEvaluaciones();
  alert('✅ Evaluación actualizada');
}

// ========== EVENTOS ==========
async function eliminarEvento(id) {
  if (!confirm('¿Estás segura de eliminar este evento?')) return;

  try {
    // Eliminar tareas del evento primero
    await db.from('tareas_evento').delete().eq('evento_id', id);
    // Eliminar el evento
    const { error } = await db.from('eventos').delete().eq('id', id);
    if (error) throw error;

    alert('✅ Evento eliminado');
    await renderEventos();
    await renderEventosPreview();
  } catch (e) {
    alert('❌ Error al eliminar: ' + e.message);
  }
}

async function editarEvento(id) {
  const { data: evento } = await db.from('eventos').select('*').eq('id', id).single();
  if (!evento) return alert('No se encontró el evento');

  currentEventoId = id;
  document.getElementById('edit-ev-nombre').value = evento.nombre || '';
  document.getElementById('edit-ev-fecha').value = evento.fecha || '';
  document.getElementById('edit-ev-cupo').value = evento.cupo_total || 10;
  document.getElementById('edit-ev-desc').value = evento.descripcion || '';

  // Cargar tareas
  const { data: tareas } = await db.from('tareas_evento').select('*').eq('evento_id', id);
  const tareasText = tareas?.map(t => `${t.nombre} - ${t.cupo}`).join('\n') || '';
  document.getElementById('edit-ev-tareas').value = tareasText;

  show('modal-edit-evento');
}

async function guardarEditEvento() {
  const nombre = document.getElementById('edit-ev-nombre').value;
  const fecha = document.getElementById('edit-ev-fecha').value;
  const cupo = parseInt(document.getElementById('edit-ev-cupo').value);
  const desc = document.getElementById('edit-ev-desc').value;
  const tareasText = document.getElementById('edit-ev-tareas').value;

  if (!nombre || !fecha) return alert('Completá nombre y fecha');

  // Actualizar evento
  await db.from('eventos').update({
    nombre,
    fecha,
    descripcion: desc,
    cupo_total: cupo
  }).eq('id', currentEventoId);

  // Actualizar tareas - eliminar las viejas y crear nuevas
  await db.from('tareas_evento').delete().eq('evento_id', currentEventoId);

  const tareas = tareasText.split('\n').filter(l => l.trim()).map(l => {
    const [n, c] = l.split('-').map(s => s.trim());
    return { evento_id: currentEventoId, nombre: n, cupo: parseInt(c) || 3 };
  });

  if (tareas.length) await db.from('tareas_evento').insert(tareas);

  closeModal('edit-evento');
  await renderEventos();
  await renderEventosPreview();
  alert('✅ Evento actualizado');
}

// ========== TRABAJOS PRÁCTICOS ==========
async function eliminarTrabajo(id) {
  if (!confirm('¿Estás segura de eliminar este trabajo práctico?')) return;

  try {
    const { error } = await db.from('trabajos_practicos').delete().eq('id', id);
    if (error) throw error;

    alert('✅ Trabajo eliminado');
    await renderTrabajos();
  } catch (e) {
    alert('❌ Error al eliminar: ' + e.message);
  }
}

let currentTrabajoId = null;

async function editarTrabajo(id) {
  const { data: trabajo } = await db.from('trabajos_practicos').select('*').eq('id', id).single();
  if (!trabajo) return alert('No se encontró el trabajo');

  currentTrabajoId = id;
  document.getElementById('edit-trabajo-titulo').value = trabajo.titulo || '';
  document.getElementById('edit-trabajo-desc').value = trabajo.descripcion || '';
  document.getElementById('edit-trabajo-fecha').value = trabajo.fecha_entrega || '';
  document.getElementById('edit-trabajo-puntos').value = trabajo.puntos || 10;
  document.getElementById('edit-trabajo-link').value = trabajo.link_externo || '';
  show('modal-edit-trabajo');
}

async function guardarEditTrabajo() {
  const titulo = document.getElementById('edit-trabajo-titulo').value;
  const desc = document.getElementById('edit-trabajo-desc').value;
  const fecha = document.getElementById('edit-trabajo-fecha').value;
  const puntos = parseInt(document.getElementById('edit-trabajo-puntos').value);
  const link = document.getElementById('edit-trabajo-link').value;

  if (!titulo) return alert('Completá el título');

  await db.from('trabajos_practicos').update({
    titulo,
    descripcion: desc,
    fecha_entrega: fecha,
    puntos,
    link_externo: link
  }).eq('id', currentTrabajoId);

  closeModal('edit-trabajo');
  await renderTrabajos();
  alert('✅ Trabajo actualizado');
}

// ========== CURSOS ==========
let currentCursoId = null;

async function crearCurso() {
  show('modal-crear-curso');
}

async function guardarNuevoCurso() {
  const nombre = document.getElementById('nuevo-curso-nombre').value;
  const desc = document.getElementById('nuevo-curso-desc').value;
  const icono = document.getElementById('nuevo-curso-icono').value;
  const color = document.getElementById('nuevo-curso-color').value;

  if (!nombre) return alert('Completá el nombre del curso');

  const { error } = await db.from('cursos').insert({
    nombre,
    descripcion: desc,
    icono: icono || '📚',
    color: color || 'turquesa',
    creador_id: usuario.id,
    publicado: true  // Publicación automática
  });

  if (error) return alert('❌ Error: ' + error.message);

  closeModal('crear-curso');
  alert('✅ Curso creado y publicado');

  // Limpiar formulario
  document.getElementById('nuevo-curso-nombre').value = '';
  document.getElementById('nuevo-curso-desc').value = '';
  document.getElementById('nuevo-curso-icono').value = '';

  // Recargar vista según el rol
  if (usuario.rol === 'docente') await showDocente();
  else await showAdmin();
}

async function editarCurso(id) {
  const { data: curso } = await db.from('cursos').select('*').eq('id', id).single();
  if (!curso) return alert('No se encontró el curso');

  currentCursoId = id;
  document.getElementById('edit-curso-nombre').value = curso.nombre || '';
  document.getElementById('edit-curso-desc').value = curso.descripcion || '';
  document.getElementById('edit-curso-icono').value = curso.icono || '📚';
  document.getElementById('edit-curso-color').value = curso.color || 'turquesa';
  show('modal-edit-curso');
}

async function guardarEditCurso() {
  const nombre = document.getElementById('edit-curso-nombre').value;
  const desc = document.getElementById('edit-curso-desc').value;
  const icono = document.getElementById('edit-curso-icono').value;
  const color = document.getElementById('edit-curso-color').value;

  if (!nombre) return alert('Completá el nombre del curso');

  await db.from('cursos').update({
    nombre,
    descripcion: desc,
    icono: icono || '📚',
    color
  }).eq('id', currentCursoId);

  closeModal('edit-curso');
  alert('✅ Curso actualizado');

  if (usuario.rol === 'docente') await showDocente();
  else await showAdmin();
}

async function eliminarCurso(id) {
  if (!confirm('⚠️ ¿Eliminar este curso? Se eliminarán todos los contenidos asociados.')) return;

  try {
    const { error } = await db.from('cursos').delete().eq('id', id);
    if (error) throw error;

    alert('✅ Curso eliminado');
    if (usuario.rol === 'docente') await showDocente();
    else await showAdmin();
  } catch (e) {
    alert('❌ Error al eliminar: ' + e.message);
  }
}

// ========== NOTIFICACIONES ==========
let notificaciones = [];

async function cargarNotificaciones() {
  const { data } = await db.from('notificaciones')
    .select('*')
    .eq('usuario_id', usuario.id)
    .order('fecha', { ascending: false })
    .limit(50);

  notificaciones = data || [];
  actualizarBadgeNotificaciones();
  return notificaciones;
}

function actualizarBadgeNotificaciones() {
  const noLeidas = notificaciones.filter(n => !n.leida).length;
  const badge = document.getElementById('notif-badge');
  if (badge) {
    badge.textContent = noLeidas;
    badge.style.display = noLeidas > 0 ? 'inline-block' : 'none';
  }
}

async function marcarComoLeida(id) {
  await db.from('notificaciones').update({ leida: true }).eq('id', id);
  await cargarNotificaciones();
}

async function marcarTodasLeidas() {
  await db.from('notificaciones')
    .update({ leida: true })
    .eq('usuario_id', usuario.id)
    .eq('leida', false);
  await cargarNotificaciones();
}

async function crearNotificacion(usuarioId, tipo, titulo, descripcion, link) {
  await db.from('notificaciones').insert({
    usuario_id: usuarioId,
    tipo,
    titulo,
    descripcion,
    link
  });
}

async function notificarAlumnos(cursoId, tipo, titulo, descripcion, link) {
  // Obtener todos los alumnos del curso
  const { data: inscritos } = await db.from('usuarios')
    .select('id')
    .eq('rol', 'alumno');

  if (!inscritos || inscritos.length === 0) return;

  // Crear notificación para cada alumno
  const notificaciones = inscritos.map(alumno => ({
    usuario_id: alumno.id,
    tipo,
    titulo,
    descripcion,
    link
  }));

  await db.from('notificaciones').insert(notificaciones);
}

// ========== DOCENTES ==========
async function eliminarDocente(id) {
  if (!confirm('⚠️ ¿Eliminar este docente? Se eliminarán también sus cursos asociados.')) return;

  try {
    // Primero actualizar cursos para quitar el creador_id
    await db.from('cursos').update({ creador_id: null }).eq('creador_id', id);
    // Luego eliminar el docente
    const { error } = await db.from('usuarios').delete().eq('id', id);
    if (error) throw error;

    alert('✅ Docente eliminado');
    await showAdmin();
  } catch (e) {
    alert('❌ Error al eliminar: ' + e.message);
  }
}

async function editarDocente(id) {
  const { data: docente } = await db.from('usuarios').select('*').eq('id', id).single();
  if (!docente) return alert('No se encontró el docente');

  const nuevoNombre = prompt('Nuevo nombre:', docente.nombre);
  const nuevoApellido = prompt('Nuevo apellido:', docente.apellido || '');
  const nuevoEmail = prompt('Nuevo email:', docente.email);

  if (!nuevoNombre || !nuevoEmail) return alert('Cancelado');

  await db.from('usuarios').update({
    nombre: nuevoNombre,
    apellido: nuevoApellido,
    email: nuevoEmail.toLowerCase()
  }).eq('id', id);

  alert('✅ Docente actualizado');
  await showAdmin();
}
