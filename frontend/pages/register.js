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
