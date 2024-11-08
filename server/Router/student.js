import dotenv from 'dotenv';
dotenv.config();
import express from 'express';
import jwt from 'jsonwebtoken';
import passport from 'passport';
import Student from '../Schema/Student.js';

const secret = process.env.JWT_SECRETE;
const router = express.Router();
const getMonthlyActivity = (dailyActivity) => {
  const now = new Date();
  const startOfMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const endOfMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0);

  const daysInMonth = endOfMonth.getDate();
  const activityArray = new Array(daysInMonth).fill(0); // Default array of 0s for each day

  // Populate the array with the activeLevel from dailyActivity
  dailyActivity.forEach((log) => {
    const logDate = new Date(log.date);
    if (logDate >= startOfMonth && logDate <= endOfMonth) {
      const dayIndex = logDate.getDate() - 1; // getDate() returns 1 for 1st of the month, so subtract 1 for array index
      activityArray[dayIndex] = log.activeLevel;
    }
  });

  return activityArray;
};
 // Use environment variable in production

// POST route to register a new student
router.post('/register', async (req, res) => {
  const { name, email, password, username, gurdianEmail} = req.body;
  try {
    let student = await Student.findOne({ email });
    if (student) {
      return res.status(400).json({ message: 'Student with this email already exists.' });
    }

    student = new Student({
      name,
      email,
      password,
      username,
      gurdianEmail
    });
    
    await student.save();

    const payload = { id: student.id, name: student.name };
    const token = jwt.sign(payload, secret, { expiresIn: '1d' });

    res.status(201).json({ token: token });;
  } catch (error) {
    console.log(error)
    res.status(500).json({ error: 'Failed to register student' });
  }
});

// POST route to login and generate JWT token
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  try {
    const student = await Student.findOne({ email });
    if (!student) {
      return res.status(400).json({ message: 'Student not found' });
    }

    const isMatch = await student.comparePassword(password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const payload = { id: student.id, name: student.name };
    const token = jwt.sign(payload, secret, { expiresIn: '1d' });

    res.json({ token: token });
  } catch (error) {
    res.status(500).json({ error: 'Failed to login' });
  }
});

// Route to get user's profile and activity
router.get('/profile', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const studentId = req.user._id; // Get the authenticated user's ID

  try {
      const student = await Student.findById(studentId).select('-password -_id -createdAt -updatedAt -__v');

      if (!student) {
        return res.status(404).json({ message: 'Student not found' });
      }

      const scoresSummary = {
        science: student.attemptedQuiz.science.map(quiz => quiz.totalResult),
        maths: student.attemptedQuiz.maths.map(quiz => quiz.totalResult),
        alpha: student.attemptedQuiz.alpha.map(quiz => quiz.totalResult),
        word: student.attemptedQuiz.word.map(quiz => quiz.totalResult)
    };


      // Get current month and activity data
      const now = new Date();
      const monthName = now.toLocaleString('default', { month: 'long' }); // Get current month name (e.g., November)
      const monthlyActivityArray = getMonthlyActivity(student.dailyActivity);

      // Create a response object with student data and additional info
      const responseData = {
        ...student.toObject(),  // Converts Mongoose document to plain JS object
        month: monthName,
        activityArray: monthlyActivityArray,
        quizData: scoresSummary,
      };
      delete responseData.dailyActivity;
      delete responseData.attemptedQuiz;
      // Send response
      res.json(responseData);

  } catch (error) {
    console.log(error)
    res.status(500).json( error );
  }
});

// Route to increase activity level
router.get('/activity', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const studentId = req.user._id; // Get the authenticated user's ID
  const today = new Date().setHours(0, 0, 0, 0); // Get today's date without time

  try {
    const student = await Student.findById(studentId);
    const activityLog = student.dailyActivity.find((log) => new Date(log.date).getTime() === today);

    if (activityLog) {
      // If activity log exists, increase the active level
      activityLog.activeLevel += 1; // Increment the active level
    } else {
      // Otherwise, create a new entry for today
      student.dailyActivity.push({ date: today, activeLevel: 1 });
    }

    await student.save();
    res.json(student);
  } catch (error) {
    res.status(500).json({ message: 'Error updating activity level' });
  }
});

// Route to calculate streaks
router.get('/streak', passport.authenticate('jwt', { session: false }), async (req, res) => {
  const studentId = req.user._id; // Get the authenticated user's ID

  try {
    const student = await Student.findById(studentId);
    let streak = 0;
    const today = new Date().setHours(0, 0, 0); // Get today's date without time

    for (let i = student.dailyActivity.length - 1; i >= 0; i--) {
      const log = student.dailyActivity[i];
      const logDate = new Date(log.date).setHours(0, 0, 0); // Reset time for comparison

      // Check if the log is for today or consecutive days
      if (today - logDate === streak * (24 * 60 * 60 * 1000) && log.activeLevel > 0) {
        streak++;
      } else if (logDate < today) {
        break; // If we find a non-consecutive day, stop
      }
    }

    res.json({ streak });
  } catch (error) {
    res.status(500).json({ message: 'Error calculating streak' });
  }
});
export default router;
