import { Router } from 'express';
const router = Router();
import { faker } from '@faker-js/faker';
import Student from '../Schema/Student.js'; // Assuming the Student model is in the models folder


const ids = [
  { _id: '671e35e4fb4c4e1bafae356a' },
  { _id: '671e35e4fb4c4e1bafae356b' },
  { _id: '671e35e4fb4c4e1bafae356c' },
  { _id: '671e35e4fb4c4e1bafae356d' },
  { _id: '671e35e4fb4c4e1bafae356e' },
  { _id: '671e35e4fb4c4e1bafae356f' },
  { _id: '671e35e4fb4c4e1bafae3570' },
  { _id: '671e35e4fb4c4e1bafae3571' },
  { _id: '671e35e4fb4c4e1bafae3572' },
  { _id: '671e35e4fb4c4e1bafae3573' },
  { _id: '671e35e4fb4c4e1bafae3574' },
  { _id: '671e35e4fb4c4e1bafae3575' },
  { _id: '671e35e4fb4c4e1bafae3576' },
  { _id: '671e35e4fb4c4e1bafae3577' },
  { _id: '671e35e4fb4c4e1bafae3578' },
  { _id: '671e35e4fb4c4e1bafae3579' },
  { _id: '671e35e4fb4c4e1bafae357a' },
  { _id: '671e35e4fb4c4e1bafae357b' },
  { _id: '671e35e4fb4c4e1bafae357c' },
  { _id: '671e35e4fb4c4e1bafae357d' },
  { _id: '671e35e4fb4c4e1bafae357e' },
  { _id: '671e35e4fb4c4e1bafae357f' },
  { _id: '671e35e4fb4c4e1bafae3580' },
  { _id: '671e35e4fb4c4e1bafae3581' },
  { _id: '671e35e4fb4c4e1bafae3582' },
  { _id: '671e35e4fb4c4e1bafae3583' },
  { _id: '671e35e4fb4c4e1bafae3584' },
  { _id: '671e35e4fb4c4e1bafae3585' },
  { _id: '671e35e4fb4c4e1bafae3586' },
  { _id: '671e35e4fb4c4e1bafae3587' },
  { _id: '671e35e7fb4c4e1bafae358a' },
  { _id: '671e35e7fb4c4e1bafae358b' },
  { _id: '671e35e7fb4c4e1bafae358c' },
  { _id: '671e35e7fb4c4e1bafae358d' },
  { _id: '671e35e7fb4c4e1bafae358e' },
  { _id: '671e35e7fb4c4e1bafae358f' },
  { _id: '671e35e7fb4c4e1bafae3590' },
  { _id: '671e35e7fb4c4e1bafae3591' },
  { _id: '671e35e7fb4c4e1bafae3592' },
  { _id: '671e35e7fb4c4e1bafae3593' },
  { _id: '671e35e7fb4c4e1bafae3594' },
  { _id: '671e35e7fb4c4e1bafae3595' },
  { _id: '671e35e7fb4c4e1bafae3596' },
  { _id: '671e35e7fb4c4e1bafae3597' },
  { _id: '671e35e7fb4c4e1bafae3598' },
  { _id: '671e35e7fb4c4e1bafae3599' },
  { _id: '671e35e7fb4c4e1bafae359a' },
  { _id: '671e35e7fb4c4e1bafae359b' },
  { _id: '671e35e7fb4c4e1bafae359c' },
  { _id: '671e35e7fb4c4e1bafae359d' },
  { _id: '671e35e7fb4c4e1bafae359e' },
  { _id: '671e35e7fb4c4e1bafae359f' },
  { _id: '671e35e7fb4c4e1bafae35a0' },
  { _id: '671e35e7fb4c4e1bafae35a1' },
  { _id: '671e35e7fb4c4e1bafae35a2' },
  { _id: '671e35e7fb4c4e1bafae35a3' },
  { _id: '671e35e7fb4c4e1bafae35a4' },
  { _id: '671e35e7fb4c4e1bafae35a5' },
  { _id: '671e35e7fb4c4e1bafae35a6' },
  { _id: '671e35e7fb4c4e1bafae35a7' },
  { _id: '671e35e7fb4c4e1bafae35a9' },
  { _id: '671e35e7fb4c4e1bafae35aa' },
  { _id: '671e35e7fb4c4e1bafae35ab' },
  { _id: '671e35e7fb4c4e1bafae35ac' },
  { _id: '671e35e7fb4c4e1bafae35ad' },
  { _id: '671e35e7fb4c4e1bafae35ae' },
  { _id: '671e35e7fb4c4e1bafae35af' },
  { _id: '671e35e7fb4c4e1bafae35b0' },
  { _id: '671e35e7fb4c4e1bafae35b1' },
  { _id: '671e35e7fb4c4e1bafae35b2' },
  { _id: '671e35e7fb4c4e1bafae35b3' },
  { _id: '671e35e7fb4c4e1bafae35b4' },
  { _id: '671e35e7fb4c4e1bafae35b5' },
  { _id: '671e35e7fb4c4e1bafae35b6' },
  { _id: '671e35e7fb4c4e1bafae35b7' },
  { _id: '671e35e7fb4c4e1bafae35b8' },
  { _id: '671e35e7fb4c4e1bafae35b9' },
  { _id: '671e35e7fb4c4e1bafae35ba' },
  { _id: '671e35e7fb4c4e1bafae35bb' },
  { _id: '671e35e7fb4c4e1bafae35bc' },
  { _id: '671e35e7fb4c4e1bafae35bd' },
  { _id: '671e35e7fb4c4e1bafae35be' },
  { _id: '671e35e7fb4c4e1bafae35bf' },
  { _id: '671e35e7fb4c4e1bafae35c0' },
  { _id: '671e35e7fb4c4e1bafae35c1' },
  { _id: '671e35e7fb4c4e1bafae35c2' },
  { _id: '671e35e7fb4c4e1bafae35c3' },
  { _id: '671e35e7fb4c4e1bafae35c4' },
  { _id: '671e35e7fb4c4e1bafae35c5' },
  { _id: '671e35e7fb4c4e1bafae35c6' },
  { _id: '671e35e7fb4c4e1bafae35c8' },
  { _id: '671e35e7fb4c4e1bafae35c9' },
  { _id: '671e35e7fb4c4e1bafae35ca' },
  { _id: '671e35e7fb4c4e1bafae35cb' },
  { _id: '671e35e7fb4c4e1bafae35cc' },
  { _id: '671e35e7fb4c4e1bafae35cd' },
  { _id: '671e35e7fb4c4e1bafae35ce' },
  { _id: '671e35e7fb4c4e1bafae35cf' },
  { _id: '671e35e7fb4c4e1bafae35d0' },
  { _id: '671e35e7fb4c4e1bafae35d1' }
]


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
function generateAttemptedQuiz() {
    // Array of possible question IDs
    const allQuestionIds = ids;

    // Helper function to get random question IDs
    function getRandomQuestionIds(num) {
        const shuffled = allQuestionIds.sort(() => 0.5 - Math.random());
        return shuffled.slice(0, num);
    }

    // Helper function to generate a quiz object
    function generateQuiz() {
        return {
          attemptedQuestions: getRandomQuestionIds(10),
            totalResult: Math.floor(Math.random() * 11) // Random score between 0 and 10
        };
    }

    // Generating the attemptedQuiz object
    const attemptedQuiz = {
        science: Array.from({ length: Math.floor(Math.random() * 5) + 1 }, generateQuiz),
        maths: Array.from({ length: Math.floor(Math.random() * 5) + 1 }, generateQuiz),
        alpha: Array.from({ length: Math.floor(Math.random() * 5) + 1 }, generateQuiz),
        word: Array.from({ length: Math.floor(Math.random() * 5) + 1 }, generateQuiz)
    };
    // console.log(attemptedQuiz)
    return attemptedQuiz;
}



// POST route to create a dummy student user with Faker.js
router.get('/', async (req, res) => {
  try {
    const dummyStudent = new Student({
      name: faker.person.fullName(), // Generate random name
      email: faker.internet.email(), // Generate random email
      password: 'Password123', // In real scenarios, the password should be hashed before saving
      username : faker.person.firstName(),
      gurdianEmail: faker.internet.email(), // Generate a random teacher's name
      dailyActivity: generateDailyActivity(), // Daily activity for the past year
      attemptedQuiz: generateAttemptedQuiz() // Random quiz results
    });

    await dummyStudent.save();
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
