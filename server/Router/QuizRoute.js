import express from 'express';
import passport from 'passport';
import wrapAsync from '../Utils/wrapAsync.js';
import { startQuizSession, answerQuestion } from '../Ctrl/quizCtrl.js';

const router = express.Router();

router.post('/load-questions', passport.authenticate('jwt', { session: false }), wrapAsync(startQuizSession));
router.post('/answer-question', passport.authenticate('jwt', { session: false }), wrapAsync(answerQuestion));

export default router;
