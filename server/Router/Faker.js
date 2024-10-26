import { Router } from 'express';
const router = Router();
import { faker } from '@faker-js/faker';
import Student from '../Schema/Student.js'; // Assuming the Student model is in the models folder

// Helper function to generate random daily activity using faker
const generateDailyActivity = () => {
  const activity = [];
  const now = new Date();
  for (let i = 0; i < 365; i++) {
    const date = new Date(now);
    date.setDate(now.getDate() - i);

    activity.push({
      date: date,
      activeLevel: Math.floor(Math.random() * 5) + 1 // Random active level between 1 and 5
    });
  }
  return activity;
};

// Helper function to generate random quiz results using faker
const generateQuizResults = () => {
  const topics = ['Science', 'Math', 'Language', 'History'];
  const quizResults = [];
  const now = new Date();

  for (let i = 0; i < 50; i++) { // Assume 50 quizzes over the year
    const date = new Date(now);
    date.setDate(now.getDate() - Math.floor(Math.random() * 365));

    quizResults.push({
      topic: faker.helpers.arrayElement(topics), // Random topic from the array
      score: faker.number.int({ min: 1, max: 100 }), // Random score between 1 and 100
      date: date
    });
  }
  return quizResults;
};

// POST route to create a dummy student user with Faker.js
router.get('/', async (req, res) => {
  try {
    const dummyStudent = new Student({
      name: faker.person.fullName(), // Generate random name
      email: faker.internet.email(), // Generate random email
      password: 'password123', // In real scenarios, the password should be hashed before saving
      username : faker.person.firstName(),
      gurdianEmail: faker.internet.email(), // Generate a random teacher's name
      dailyActivity: generateDailyActivity(), // Daily activity for the past year
      quizResults: generateQuizResults() // Random quiz results
    });

    // await dummyStudent.save();
    res.status(201).json({
      message: 'Dummy student created successfully',
      student: dummyStudent
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error creating dummy student',
      error: error.message
    });
  }
});

export default router;
