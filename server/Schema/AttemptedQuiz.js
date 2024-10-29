import mongoose from 'mongoose';

const attemptedQuizSchema = new mongoose.Schema({
  totalResult: { type: Number, default: 0 }, // Total score or result for the AttemptedQuiz
  attemptedQuestions: { type: [String], default: [] }, // Array of question IDs that were attempted
});

const AttemptedQuiz = mongoose.model('AttemptedQuiz', attemptedQuizSchema);
export default AttemptedQuiz;
