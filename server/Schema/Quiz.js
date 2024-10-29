import mongoose from 'mongoose';

const quizSchema = new mongoose.Schema({
  question: { type: String, required: true },
  options: { type: [String], required: false }, // For multiple choice questions
  correctAnswer: { type: String, required: true },
  difficulty: { type: Number, required: true, min: 1, max: 5 },
  module: { type: String, required: true, enum: ['science', 'maths', 'alpha', 'word'] },
});

const Quiz = mongoose.model('Quiz', quizSchema);
export default Quiz;
