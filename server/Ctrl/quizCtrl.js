// quizController.js
import Student from '../Schema/Student.js';
import Quiz from '../Schema/Quiz.js';
import GujAlphabet from '../Schema/GujAlphabet.js';
import EngAlphabet from '../Schema/EngAlphabet.js';
import Gif from '../Schema/GIf.js'

const loadedQuestions = {};
const attemptedQuestions = {};
const streaks = {};

// Utility to get random items
function getRandomItems(arr, count) {
    const shuffled = arr.sort(() => 0.5 - Math.random());
    return shuffled.slice(0, count);
}
function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1)); // Random index from 0 to i
      [array[i], array[j]] = [array[j], array[i]]; // Swap elements
    }
    return array;
  }

// Initialize data for a student's quiz session
export function initializeQuestionLoading(req, studentID, module) {
    loadedQuestions[studentID] = {};
    attemptedQuestions[studentID] = [];
    streaks[studentID] = {};

    req.session.currentDifficulty = { [studentID]: 1 };
    req.session.questionIndexes = { [studentID]: { 1: 0, 2: 0, 3: 0 } };
    req.session.score = { [studentID]: 0 };
    req.session.questionNumber = { [studentID]: 1 };
}

// Load unattempted questions by difficulty and store in `loadedQuestions`
export async function loadUnattemptedQuestions(req, student, module) {
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

//Load Aplhabet questions by difficulty and store in `loadedQuestions`
export async function generateAlphaQuiz(req, student, module) {
        const gujaratiData = await GujAlphabet.find();
        const englishData = await EngAlphabet.find();
        const data = {
            gujarati: [...gujaratiData],
            english: [...englishData] 
        };
        const levelOneQuestions = Array.from({ length: parseInt(req.session.number_of_que[student._id]) }).map(() => {
            const isGujarati = Math.random() < 0.5; 
            const correctItem = data[isGujarati ? 'gujarati' : 'english'][Math.floor(Math.random() * data[isGujarati ? 'gujarati' : 'english'].length)];
            const options = getRandomItems(data[isGujarati ? 'gujarati' : 'english'], 4).map(item => item.alphabet);
            if (!options.includes(correctItem.alphabet || correctItem.signImage)) {
                options[Math.floor(Math.random() * options.length)] = correctItem.alphabet || correctItem.signImage;
            }
            return {
                question: correctItem.signImage,
                options,
                correctAnswer: correctItem.alphabet,
                difficulty: 1,
                module
            };
        });
        const levelTwoQuestions = Array.from({ length: parseInt(req.session.number_of_que[student._id]) }).map(() => {
            const isGujarati = Math.random() < 0.5;
            const correctItem = data[isGujarati ? 'gujarati' : 'english'][Math.floor(Math.random() * data[isGujarati ? 'gujarati' : 'english'].length)];
            const options = getRandomItems(data[isGujarati ? 'gujarati' : 'english'], 4).map(item => item.signImage);
            if (!options.includes(correctItem.signImage || correctItem.alphabet)) {
                options[Math.floor(Math.random() * options.length)] = correctItem.signImage || correctItem.alphabet;
            }
            return {
                question: correctItem.alphabet,
                options,
                correctAnswer: correctItem.signImage,
                difficulty: 2,
                module
            };
        });
        const levelThreeQuestions = Array.from({ length: parseInt(req.session.number_of_que[student._id]) }).map(() => {
            const isGujarati = Math.random() < 0.5; 
            const selectedData = data[isGujarati ? 'gujarati' : 'english'];

            const selectedItems = getRandomItems(selectedData, 3);
            
            return {
                question: 'Match each letter to the correct sign image.',
                options: {
                    columnA: shuffleArray(selectedItems.map(item => item.alphabet)), // Shuffle letters
                    columnB: shuffleArray(selectedItems.map(item => item.signImage)), // Shuffle images
                },
                correctAnswer: selectedItems.map(item => ({ alphabet: item.alphabet, signImage: item.signImage })),
                difficulty: 3,
                module
            };
        });
        const questionsByDifficulty = {
            '1': levelOneQuestions,
            '2': levelTwoQuestions,
            '3': levelThreeQuestions
        };
        loadedQuestions[student._id] = questionsByDifficulty
        return questionsByDifficulty;
    } 

//Load Word questions by difficulty and store in `loadedQuestions`
export async function generateWordQuiz(req, student, module) {
        const data = [
            ...(await Gif.find())
        ];
   
        const levelOneQuestions = Array.from({ length: parseInt(req.session.number_of_que[student._id]) }).map(() => {
            const correctItem = data[Math.floor(Math.random() * data.length)];
            const options = getRandomItems(data, 4).map(item => item.sign_name);
            if (!options.includes(correctItem.sign_name || correctItem.cloud_location)) {
                options[Math.floor(Math.random() * options.length)] = correctItem.sign_name || correctItem.cloud_location;
            }
            return {
                question: correctItem.cloud_location,
                options,
                correctAnswer: correctItem.sign_name,
                difficulty: 1,
                module
            };
        });
        const levelTwoQuestions = Array.from({ length: parseInt(req.session.number_of_que[student._id]) }).map(() => {
            const correctItem = data[Math.floor(Math.random() * data.length)];
            const options = getRandomItems(data, 4).map(item => item.cloud_location);
            if (!options.includes(correctItem.cloud_location || correctItem.sign_name)) {
                options[Math.floor(Math.random() * options.length)] = correctItem.cloud_location || correctItem.sign_name;
            }
            return {
                question: correctItem.sign_name,
                options,
                correctAnswer: correctItem.cloud_location,
                difficulty: 2,
                module
            };
        });
        const levelThreeQuestions = Array.from({ length: parseInt(req.session.number_of_que[student._id]) }).map(() => {
            const selectedData = data;

            const selectedItems = getRandomItems(selectedData, 3);
            
            return {
                question: 'Match each letter to the correct sign image.',
                options: {
                    columnA: selectedItems.map(item => item.sign_name),
                    columnB: selectedItems.map(item => item.cloud_location),
                },
                correctAnswer: selectedItems.map(item => ({ sign_name: item.sign_name, cloud_location: item.cloud_location })),
                difficulty: 3,
                module
            };
        });
        const questionsByDifficulty = {
            '1': levelOneQuestions,
            '2': levelTwoQuestions,
            '3': levelThreeQuestions
        };
        loadedQuestions[student._id] = questionsByDifficulty
        return questionsByDifficulty;
    } 


// Update streak and difficulty based on correct/incorrect answers
export function updateStreakAndDifficulty(req, student, module, correct) {
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
export function retrieveQuestion(req, studentID, difficulty) {
    const questions = loadedQuestions[studentID][difficulty];
    const currentIndex = req.session.questionIndexes[studentID][difficulty];

    if (!questions || questions.length === 0) throw new Error('Questions are not loaded. Please load questions first.');
    if (currentIndex >= questions.length) throw new Error('No more questions available for the current difficulty');

    const selectedQuestion = questions[currentIndex];
    req.session.questionIndexes[studentID][difficulty] += 1;
    return selectedQuestion;
}

// Start quiz session and load questions
export async function startQuizSession(req, res) {
    const { module, number_of_que } = req.body;
    const studentID = req.user._id;
    if (!module) return res.status(400).send('Invalid module specified');
    req.session.module = { [studentID]: module };
    req.session.number_of_que = { [studentID]: number_of_que };
    const student = await Student.findById(studentID);
    if (!student) throw new Error('Student not found');

    initializeQuestionLoading(req, studentID, module);

    if(module === 'alpha'){
    const questionsByDifficulty = await generateAlphaQuiz(req, student, module);
    }else if(module === 'word'){
        const questionsByDifficulty = await generateWordQuiz(req, student, module);
    }else{
    const questionsByDifficulty = await loadUnattemptedQuestions(req, student, module);
    }
    const firstQuestion = retrieveQuestion(req, studentID, req.session.currentDifficulty[studentID]);
    return res.json({
        message: 'Quiz started. Here is the first question.',
        question: firstQuestion,
        score: req.session.score[studentID]
    });
}

// Handle answer correctness and retrieve next question
export async function answerQuestion(req, res) {
    let { correct } = req.body;
    if(typeof(correct)== "string"){
        correct = Boolean(correct);
    }
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
            score
        });
    } else if (req.session.questionNumber[studentID] > req.session.number_of_que[studentID]) {
        return res.json({
            message: `Question Ended`,
        });
    }
    const selectedQuestion = retrieveQuestion(req, studentID, currentDifficulty);
    req.session.questionNumber[studentID] += 1;

    if (!attemptedQuestions[studentID].includes(selectedQuestion._id)) {
        attemptedQuestions[studentID].push(selectedQuestion._id);
    }
    return res.json({
        message: `Question retrieved successfully`,
        question: selectedQuestion,
        score
    });
}
