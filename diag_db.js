const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://dukgjrhyhyxvdqzhthje.supabase.co';
const SUPABASE_KEY = 'sb_publishable_hdrC91CO7zGc3uoO2MsMVA_6K_CQmgd';

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function diagnose() {
    console.log('--- DIAGNÓSTICO DE DATOS ---');
    
    // Cursos
    const { data: cursos, error: errC } = await supabase.from('cursos').select('id, nombre').limit(5);
    if (errC) console.error('Error cursos:', errC);
    else console.log('Cursos encontrados:', cursos);

    // Usuarios (Docentes/Admin)
    const { data: usuarios, error: errU } = await supabase.from('usuarios').select('id, nombre, rol').in('rol', ['docente', 'admin']).limit(3);
    if (errU) console.error('Error usuarios:', errU);
    else console.log('Usuarios (Docente/Admin):', usuarios);

    process.exit(0);
}

diagnose();
