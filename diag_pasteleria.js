const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://dukgjrhyhyxvdqzhthje.supabase.co';
const SUPABASE_KEY = 'sb_publishable_hdrC91CO7zGc3uoO2MsMVA_6K_CQmgd';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function analyze() {
    console.log('--- ANÁLISIS CURSO: PASTELERÍA PROFESIONAL ---');
    
    // 1. Identificar Curso
    const { data: curso, error: errCurso } = await supabase
        .from('cursos')
        .select('id, nombre')
        .ilike('nombre', '%Pastelería Profesional%')
        .single();

    if (errCurso || !curso) {
        console.error('Error al encontrar el curso:', errCurso || 'No encontrado');
        process.exit(1);
    }
    const cursoId = curso.id;
    console.log(`Curso: ${curso.nombre} (ID: ${cursoId})`);

    // 2. Adhesión (Inscripciones)
    const { data: inscriptos, error: errIns } = await supabase
        .from('inscripciones')
        .select('alumno_id')
        .eq('curso_id', cursoId);
    
    const totalInscriptos = inscriptos ? inscriptos.length : 0;
    console.log(`Total Adhesión (Alumnos): ${totalInscriptos}`);

    // 3. Asistencia
    const { data: asistencias, error: errAsist } = await supabase
        .from('asistencias')
        .select('estado')
        .eq('curso_id', cursoId);
    
    if (asistencias && asistencias.length > 0) {
        const presentes = asistencias.filter(a => a.estado === 'presente').length;
        const totalAsist = asistencias.length;
        const promedioAsist = ((presentes / totalAsist) * 100).toFixed(1);
        console.log(`Asistencia Promedio: ${promedioAsist}% (${presentes}/${totalAsist} registros)`);
    } else {
        console.log('No hay registros de asistencia aún.');
    }

    // 4. Aprobación (Calificaciones Modulares)
    const { data: notas, error: errNotas } = await supabase
        .from('calificaciones_modulares')
        .select('promedio')
        .eq('curso_id', cursoId);
    
    if (notas && notas.length > 0) {
        // En este sistema, 7.0 o 70% suele ser el aprobado técnico según el historial
        const aprobados = notas.filter(n => n.promedio >= 7).length;
        const totalNotas = notas.length;
        const porcentajeAprob = ((aprobados / totalNotas) * 100).toFixed(1);
        console.log(`Porcentaje de Aprobación: ${porcentajeAprob}% (${aprobados}/${totalNotas} alumnos calificados)`);
    } else {
        console.log('No hay registros de calificaciones modulares aún.');
    }

    process.exit(0);
}

analyze();
