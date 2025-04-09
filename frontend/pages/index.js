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
