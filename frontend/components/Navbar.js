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
