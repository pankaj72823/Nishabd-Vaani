import dotenv from 'dotenv';
dotenv.config();
import mongoose from 'mongoose';
import Quiz from '../Schema/Quiz.js';

const secret = process.env.DB;
console.log(secret)
mongoose.connect(secret, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('MongoDB connected!'))
  .catch(err => console.error('MongoDB connection error:', err));

// Function to generate random quizzes
const generateQuizzes = (moduleName) => {
  const quizzes = [];
  const sampleQuestions = [
    'What is the capital of India?',
    'What is 2 + 2?',
    'Define photosynthesis.',
    'What is the chemical symbol for water?',
    'Explain the theory of relativity.',
    // Add more sample questions as needed
  ];

  for (let i = 0; i < 30; i++) {
    const question = sampleQuestions[Math.floor(Math.random() * sampleQuestions.length)];
    const options = [`Option 1 for ${question}`, `Option 2 for ${question}`, `Option 3 for ${question}`, `Option 4 for ${question}`];
    const correctAnswer = options[Math.floor(Math.random() * options.length)];
    const difficulty = Math.floor(Math.random() * 3) + 1; // Difficulty levels from 1 to 3

    quizzes.push({
      question,
      options,
      correctAnswer,
      difficulty,
      module: moduleName,
    });
  }

  return quizzes;
};

// Save quizzes to the database
const saveQuizzes = async () => {
  const modules = ['science', 'maths', 'alpha', 'word'];
  
  for (const module of modules) {
    const quizzes = generateQuizzes(module);
    await Quiz.insertMany(quizzes);
    console.log(`30 quizzes for ${module} module saved successfully.`);
  }

  mongoose.connection.close();
};

// Execute the save function
saveQuizzes().catch(err => console.error('Error saving quizzes:', err));
