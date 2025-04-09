
# Crear estructura de carpetas
mkdir -p frontend/components
mkdir -p frontend/pages

# Crear Navbar.js
cat > frontend/components/Navbar.js << 'EOF'
import Link from 'next/link';

export default function Navbar() {
  return (
    <nav className="bg-gray-800 text-white p-4 flex justify-between items-center">
      <div className="text-lg font-bold">App de Hábitos</div>
      <div className="space-x-4">
        <Link href="/" className="hover:underline">Inicio</Link>
        <Link href="/login" className="hover:underline">Login</Link>
        <Link href="/register" className="hover:underline">Register</Link>
      </div>
    </nav>
  );
}
EOF

# Crear login.js
cat > frontend/pages/login.js << 'EOF'
import { useState } from 'react';
import { useRouter } from 'next/router';
import Navbar from '../components/Navbar';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await fetch('http://localhost:4000/api/auth/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });

    const data = await res.json();
    if (data.token) {
      localStorage.setItem('token', data.token);
      router.push('/');
    } else {
      alert('Credenciales inválidas');
    }
  };

  return (
    <>
      <Navbar />
      <div className="p-4">
        <h1 className="text-2xl mb-4">Iniciar Sesión</h1>
        <form onSubmit={handleSubmit} className="space-y-4">
          <input type="email" placeholder="Correo" value={email} onChange={e => setEmail(e.target.value)} className="w-full p-2 border rounded" />
          <input type="password" placeholder="Contraseña" value={password} onChange={e => setPassword(e.target.value)} className="w-full p-2 border rounded" />
          <button type="submit" className="bg-blue-500 text-white px-4 py-2 rounded">Entrar</button>
        </form>
      </div>
    </>
  );
}
EOF

# Crear register.js
cat > frontend/pages/register.js << 'EOF'
import { useState } from 'react';
import { useRouter } from 'next/router';
import Navbar from '../components/Navbar';

export default function Register() {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const router = useRouter();

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await fetch('http://localhost:4000/api/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, email, password })
    });

    if (res.ok) {
      alert('Registro exitoso');
      router.push('/login');
    } else {
      alert('Error al registrarse');
    }
  };

  return (
    <>
      <Navbar />
      <div className="p-4">
        <h1 className="text-2xl mb-4">Registrarse</h1>
        <form onSubmit={handleSubmit} className="space-y-4">
          <input type="text" placeholder="Nombre de usuario" value={username} onChange={e => setUsername(e.target.value)} className="w-full p-2 border rounded" />
          <input type="email" placeholder="Correo" value={email} onChange={e => setEmail(e.target.value)} className="w-full p-2 border rounded" />
          <input type="password" placeholder="Contraseña" value={password} onChange={e => setPassword(e.target.value)} className="w-full p-2 border rounded" />
          <button type="submit" className="bg-green-500 text-white px-4 py-2 rounded">Registrarse</button>
        </form>
      </div>
    </>
  );
}
EOF

# Crear index.js
cat > frontend/pages/index.js << 'EOF'
import { useEffect, useState } from 'react';
import Navbar from '../components/Navbar';

export default function Home() {
  const [habits, setHabits] = useState([]);

  const fetchHabits = async () => {
    const res = await fetch('http://localhost:4000/api/habits', {
      headers: {
        'Authorization': 'Bearer ' + localStorage.getItem('token')
      }
    });
    const data = await res.json();
    setHabits(data);
  };

  const markAsDone = async (id) => {
    await fetch(\`http://localhost:4000/api/habits/\${id}/done\`, {
      method: 'PUT',
      headers: {
        'Authorization': 'Bearer ' + localStorage.getItem('token')
      }
    });
    fetchHabits();
  };

  useEffect(() => {
    fetchHabits();
  }, []);

  return (
    <>
      <Navbar />
      <div className="p-4">
        <h1 className="text-2xl mb-4">Tus Hábitos</h1>
        {habits.map(habit => (
          <div key={habit._id} className="border p-4 mb-4 rounded shadow">
            <h2 className="text-lg font-bold">{habit.name}</h2>
            <p>Racha: {habit.streak} días</p>
            <div className="w-full bg-gray-300 h-4 rounded overflow-hidden my-2">
              <div
                className="h-4"
                style={{
                  width: \`\${Math.min((habit.streak / 66) * 100, 100)}%\`,
                  backgroundColor: habit.streak >= 66 ? 'green' : habit.streak >= 21 ? 'orange' : 'red'
                }}
              />
            </div>
            <button
              onClick={() => markAsDone(habit._id)}
              className="bg-blue-500 text-white px-4 py-1 rounded mt-2"
            >
              Done
            </button>
          </div>
        ))}
      </div>
    </>
  );
}
EOF

echo "✅ Proyecto frontend completo creado: Navbar, login, registro, hábitos con botón Done y barra de progreso."
