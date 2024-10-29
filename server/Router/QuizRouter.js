import express from 'express';
import Student from '../Schema/Student.js';
import Quiz from '../Schema/Quiz.js';
import passport from 'passport';
import wrapAsync from '../Utils/wrapAsync.js';

const router = express.Router();
const loadedQuestions = {};
const attemptedQuestions = {};
const streaks = {};

// Initialize data for a student's quiz session
function initializeQuestionLoading(req, studentID, module) {
  loadedQuestions[studentID] = {};
  attemptedQuestions[studentID] = [];
  streaks[studentID] = {};

  req.session.currentDifficulty = { [studentID]: 1 };
  req.session.questionIndexes = { [studentID]: { 1: 0, 2: 0, 3: 0 } };
  req.session.score = { [studentID]: 0 };
  req.session.questionNumber = { [studentID]: 1 };  // Initialize question number

}

// Load unattempted questions by difficulty and store in `loadedQuestions`
async function loadUnattemptedQuestions(req,student, module) {
  const attemptedQuestions = student.attemptedQuiz[module]
    ? student.attemptedQuiz[module].flatMap(quiz => quiz.attemptedQuestions)
    : [];
  const questionsByDifficulty = {};

  for (let difficulty = 1; difficulty <= 3; difficulty++) {
    const questions = await Quiz.aggregate([
      { $match: { difficulty, module, _id: { $nin: attemptedQuestions } } },
      { $sample: { size: parseInt(req.session.number_of_que[student._id]) } }
    ]);
    questionsByDifficulty[difficulty] = questions;
  }
  loadedQuestions[student._id] = questionsByDifficulty;
  return questionsByDifficulty;
}

// Update streak and difficulty based on correct/incorrect answers
function updateStreakAndDifficulty(req, student, module, correct) {

  const studentID = student._id;
  const streakKey = `${module}_${req.session.currentDifficulty[studentID]}`;
  if (!streaks[studentID][streakKey]) streaks[studentID][streakKey] = { correct: 0, incorrect: 0 };

  if (correct) {

    req.session.score[studentID] += 1;
    streaks[studentID][streakKey].correct += 1;
    streaks[studentID][streakKey].incorrect = 0;

    if (streaks[studentID][streakKey].correct === 2) {
      req.session.currentDifficulty[studentID] = Math.min(req.session.currentDifficulty[studentID] + 1, 3);
      streaks[studentID][streakKey].correct = 0;
    }
  } else {
    streaks[studentID][streakKey].incorrect += 1;
    streaks[studentID][streakKey].correct = 0;

    if (streaks[studentID][streakKey].incorrect === 2) {
      req.session.currentDifficulty[studentID] = Math.max(req.session.currentDifficulty[studentID] - 1, 1);
      streaks[studentID][streakKey].incorrect = 0;
    }
  }
  return req.session.currentDifficulty[studentID];
}

// Retrieve a question based on current difficulty and question index
function retrieveQuestion(req, studentID, difficulty) {
  const questions = loadedQuestions[studentID][difficulty];
  const currentIndex = req.session.questionIndexes[studentID][difficulty];

  if (!questions || questions.length === 0) throw new Error('Questions are not loaded. Please load questions first.');
  if (currentIndex >= questions.length) throw new Error('No more questions available for the current difficulty');

  const selectedQuestion = questions[currentIndex];
  req.session.questionIndexes[studentID][difficulty] += 1;
  return selectedQuestion;
}

// Route to load questions and start quiz session
router.post('/load-questions', passport.authenticate('jwt', { session: false }), wrapAsync(async (req, res) => {
  const { module,number_of_que } = req.body;
  const studentID = req.user._id;
  if (!module) return res.status(400).send('Invalid module specified');
  req.session.module = { [studentID]: module }; 
  req.session.number_of_que = { [studentID]: number_of_que }; 
  const student = await Student.findById(studentID);
  if (!student) throw new Error('Student not found');

  initializeQuestionLoading(req, studentID, module);
  const questionsByDifficulty = await loadUnattemptedQuestions(req, student, module);
  
  const firstQuestion = retrieveQuestion(req, studentID, req.session.currentDifficulty[studentID]);
  return res.json({
    message: 'Quiz started. Here is the first question.',
    question: firstQuestion,
    score: req.session.score[studentID]
  });
}));

// Route to handle answer correctness and retrieve the next question
router.post('/answer-question', passport.authenticate('jwt', { session: false }), wrapAsync(async (req, res) => {
  const { correct } = req.body;
  const studentID = req.user._id;

  const student = await Student.findById(studentID);
  if (!student) throw new Error('Student not found');

  let currentDifficulty = req.session.currentDifficulty[studentID] || 1;
  if (correct !== undefined) {
    currentDifficulty = updateStreakAndDifficulty(req, student, req.session.module[studentID], correct);
  }
  req.session.currentDifficulty[studentID] = currentDifficulty;
  const score = req.session.score[studentID];

  if (req.session.questionNumber[studentID] === req.session.number_of_que[studentID]) {
    const quizAttempt = {
      totalResult: score,
      attemptedQuestions: attemptedQuestions[studentID]
    };
    student.attemptedQuiz[req.session.module] = quizAttempt;

    await student.save();
    req.session.questionNumber[studentID] += 1; 
    delete req.session.currentDifficulty[studentID];
    delete req.session.questionIndexes[studentID];
    delete req.session.score[studentID];
    delete loadedQuestions[studentID];
    delete attemptedQuestions[studentID];

    return res.json({
      message: `Question Ended`,
      // question: selectedQuestion,
      score
    });
  }else if(req.session.questionNumber[studentID] > req.session.number_of_que[studentID]){
    return res.json({
      message: `Question Ended`,
    });
  }
  const selectedQuestion = retrieveQuestion(req, studentID, currentDifficulty);
  req.session.questionNumber[studentID] += 1; // Increment question number

  if (!attemptedQuestions[studentID].includes(selectedQuestion._id)) {
    attemptedQuestions[studentID].push(selectedQuestion._id);
  }
  return res.json({
    message: `Question retrieved successfully`,
    question: selectedQuestion,
    score
  });
}));

export default router;
