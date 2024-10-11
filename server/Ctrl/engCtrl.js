import wrapAsync from '../Utils/wrapAsync.js';
import EngAlphabet from '../Schema/EngAlphabet.js';

const alphabetsEng = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');

// Utility function to generate quiz
async function generateQuiz(currentAlphabet, alphabetSet) {
  const currentIndex = alphabetSet.indexOf(currentAlphabet);

  if (currentIndex < 3) {
    throw new Error('Not enough smaller alphabets to generate a quiz');
  }

  const smallerAlphabets = alphabetSet.slice(0, currentIndex);

  const getRandomAlphabets = (num) => {
    const selectedAlphabets = [];
    while (selectedAlphabets.length < num) {
      const randomIndex = Math.floor(Math.random() * smallerAlphabets.length);
      const randomAlphabet = smallerAlphabets[randomIndex];
      if (!selectedAlphabets.includes(randomAlphabet)) {
        selectedAlphabets.push(randomAlphabet);
      }
    }
    return selectedAlphabets;
  };

  const quizOptions = getRandomAlphabets(3);

  const options = await EngAlphabet.find({ alphabet: { $in: quizOptions } }).select('signImage alphabet');

  const quiz = {
    "flag": 'quiz',
    "question": options[0].alphabet,
    "options": [
      {
        "1": options[0].signImage,
        "2": options[1].signImage,
        "3": options[2].signImage
      }
    ],
    "answer": options[0].signImage
  };
  return quiz;
}

// English alphabet route: Start Learning
export const alphabetEng = wrapAsync(async (req, res) => {
  // Initialize session state if not already initialized

  req.session.currentAlphabetIndexEng = 0;
  req.session.flagEng = false;


  const currentAlphabet = alphabetsEng[req.session.currentAlphabetIndexEng];
  const data = await EngAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn";

  req.session.currentAlphabetIndexEng = (req.session.currentAlphabetIndexEng + 1) % alphabetsEng.length; // Update session


  return res.json(data);
});

// Next alphabet route
export const alphabetEngNext = wrapAsync(async (req, res) => {
  // Initialize session state if not already initialized
  if (!req.session.currentAlphabetIndexEng) {
    req.session.currentAlphabetIndexEng = 0;
    req.session.flagEng = false;
  }

  const currentAlphabet = alphabetsEng[req.session.currentAlphabetIndexEng];
  const data = await EngAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn";

  if (req.session.flagEng) {
    req.session.currentAlphabetIndexEng = (req.session.currentAlphabetIndexEng + 1) % alphabetsEng.length;
    req.session.flagEng = false;
    return res.json(data);
  } else if (req.session.currentAlphabetIndexEng !== 0 && req.session.currentAlphabetIndexEng % 5 === 0) {
    const quiz = await generateQuiz(currentAlphabet, alphabetsEng);
    req.session.flagEng = true;
    return res.json(quiz);
  } else {
    req.session.currentAlphabetIndexEng = (req.session.currentAlphabetIndexEng + 1) % alphabetsEng.length;
    return res.json(data);
  }
});

// Previous alphabet route
export const alphabetEngPrev = wrapAsync(async (req, res) => {
  // Initialize session state if not already initialized
  if (!req.session.currentAlphabetIndexEng) {
    req.session.currentAlphabetIndexEng = 0;
    req.session.flagEng = false;
  }

  if (req.session.currentAlphabetIndexEng - 2 < 0) {
    const error = new Error("Start Learning");
    error.status = 400;
    throw error;
  }

  const currentAlphabet = alphabetsEng[req.session.currentAlphabetIndexEng - 2];
  const data = await EngAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn";

  if (req.session.flagEng) {
    req.session.currentAlphabetIndexEng = (req.session.currentAlphabetIndexEng - 1) % alphabetsEng.length;
    req.session.flagEng = false;
    return res.json(data);
  } else if (req.session.currentAlphabetIndexEng !== 0 && req.session.currentAlphabetIndexEng % 5 === 0) {
    const quiz = await generateQuiz(currentAlphabet, alphabetsEng);
    req.session.flagEng = true;
    return res.json(quiz);
  } else {
    req.session.currentAlphabetIndexEng = (req.session.currentAlphabetIndexEng - 1) % alphabetsEng.length;
    return res.json(data);
  }
});
