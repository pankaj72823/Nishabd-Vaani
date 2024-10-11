import wrapAsync from '../Utils/wrapAsync.js';
import GujAlphabet from '../Schema/GujAlphabet.js';

// Gujarati alphabet set
const alphabetsGujarati = ['ક', 'ખ', 'ગ', 'ઘ', 'ચ', 'છ', 'જ', 'ઝ', 'ટ', 'ઠ', 'ડ', 'ઢ', 'ણ', 'ત', 'થ', 'દ', 'ધ', 'ન', 'પ', 'ફ', 'બ', 'ભ', 'મ', 'ય', 'ર', 'લ', 'વ', 'શ', 'ષ', 'સ', 'હ', 'ળ', 'ક્ષ']; // Add more as needed

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

  const options = await GujAlphabet.find({ alphabet: { $in: quizOptions } }).select('signImage alphabet');

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

// Gujarati alphabet route (starting alphabet)
export const alphabetGujarati = wrapAsync(async (req, res) => {

    req.session.currentAlphabetIndexGujarati = 0;
    req.session.flagGujarati = false;
  

    const currentAlphabet = alphabetsGujarati[req.session.currentAlphabetIndexGujarati];
    const data = await GujAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
    data.flag = "Learn";

    // Move to the next alphabet
    req.session.currentAlphabetIndexGujarati = (req.session.currentAlphabetIndexGujarati + 1) % alphabetsGujarati.length;

    return res.json(data);
});

// Route for next alphabet
export const alphabetGujaratiNext = wrapAsync(async (req, res) => {
    // Ensure session is initialized
    if (!req.session.currentAlphabetIndexGujarati) {
        req.session.currentAlphabetIndexGujarati = 0;
        req.session.flagGujarati = false;
    }

    const currentAlphabet = alphabetsGujarati[req.session.currentAlphabetIndexGujarati];
    const data = await GujAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
    data.flag = "Learn";

    if (req.session.flagGujarati) {
        // Move to the next alphabet after the quiz
        req.session.currentAlphabetIndexGujarati = (req.session.currentAlphabetIndexGujarati + 1) % alphabetsGujarati.length;
        req.session.flagGujarati = false;
        return res.json(data);
    } else if (req.session.currentAlphabetIndexGujarati !== 0 && req.session.currentAlphabetIndexGujarati % 5 === 0) {
        // Every 5th alphabet triggers a quiz
        const quiz = await generateQuiz(currentAlphabet, alphabetsGujarati);
        req.session.flagGujarati = true;
        return res.json(quiz);
    } else {
        // Proceed to the next alphabet
        req.session.currentAlphabetIndexGujarati = (req.session.currentAlphabetIndexGujarati + 1) % alphabetsGujarati.length;
        return res.json(data);
    }
});

// Route for previous alphabet
export const alphabetGujaratiPrev = wrapAsync(async (req, res) => {
    if (!req.session.currentAlphabetIndexGujarati || req.session.currentAlphabetIndexGujarati - 2 < 0) {
        const error = new Error("Start Learning");
        error.status = 400; // Set a custom status code
        throw error;
    }

    const currentAlphabet = alphabetsGujarati[req.session.currentAlphabetIndexGujarati - 2];
    const data = await GujAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
    data.flag = "Learn";

    if (req.session.flagGujarati) {
        // Move back in the sequence after a quiz
        req.session.currentAlphabetIndexGujarati = (req.session.currentAlphabetIndexGujarati - 1) % alphabetsGujarati.length;
        req.session.flagGujarati = false;
        return res.json(data);
    } else if (req.session.currentAlphabetIndexGujarati !== 0 && req.session.currentAlphabetIndexGujarati % 5 === 0) {
        // Generate a quiz for every 5th alphabet
        const quiz = await generateQuiz(currentAlphabet, alphabetsGujarati);
        req.session.flagGujarati = true;
        return res.json(quiz);
    } else {
        // Move back in the sequence
        req.session.currentAlphabetIndexGujarati = (req.session.currentAlphabetIndexGujarati - 1) % alphabetsGujarati.length;
        return res.json(data);
    }
});
