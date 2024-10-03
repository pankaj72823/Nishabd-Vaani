import wrapAsync from '../Utils/wrapAsync.js'
import EngAlphabet from '../Schema/EngAlphabet.js';

let currentAlphabetIndexEng = 0;
const alphabetsEng = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
const number = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
// const alphabetsGujarati = ['અ', 'આ', 'ઇ', 'ઈ', 'ઉ', 'ઊ', 'ઋ', 'એ', 'ઐ', 'ઓ', 'ઔ', 'ક', 'ખ', 'ગ', 'ઘ', 'ચ', 'છ', 'જ', 'ઝ', 'ટ', 'ઠ', 'ડ', 'ઢ', 'ત', 'થ', 'દ', 'ધ', 'ન', 'પ', 'ફ', 'બ', 'ભ', 'મ', 'ય', 'ર', 'લ', 'વ', 'શ', 'ષ', 'સ', 'હ']; // Add more as needed

let flagEng = false;


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
  }
  return quiz;
}

// English alphabet route
export const alphabetEng = wrapAsync(async (req, res) => {
  currentAlphabetIndexEng = 0;
  const currentAlphabet = alphabetsEng[0];
  const data = await EngAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn"
  currentAlphabetIndexEng = (currentAlphabetIndexEng + 1) % alphabetsEng.length;
  return res.json(data);
});

export const alphabetEngNext = wrapAsync(async (req, res) => {
  const currentAlphabet = alphabetsEng[currentAlphabetIndexEng];
  const data = await EngAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn"

  if (flagEng) {
    currentAlphabetIndexEng = (currentAlphabetIndexEng + 1) % alphabetsEng.length;
    flagEng = false;
    return res.json(data);
  } else if (currentAlphabetIndexEng !== 0 && currentAlphabetIndexEng % 5 === 0) {
    const quiz = await generateQuiz(currentAlphabet, alphabetsEng);
    flagEng = true;
    return res.json(quiz);
  } else {
    currentAlphabetIndexEng = (currentAlphabetIndexEng + 1) % alphabetsEng.length;
    return res.json(data);
  }
});

export const alphabetEngPrev = wrapAsync(async (req, res) => {
  if(currentAlphabetIndexEng-2<0){
    const error = new Error("Start Learning");
    error.status = 400; // Set a custom status code
    throw error;
  }
  const currentAlphabet = alphabetsEng[currentAlphabetIndexEng-2];

  const data = await EngAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn"
 
  if(flagEng){
    currentAlphabetIndexEng = (currentAlphabetIndexEng - 1) % alphabetsEng.length;
    flagEng=false
    return res.json(data);
  }else if(currentAlphabetIndexEng!=0 && currentAlphabetIndexEng%5==0){
    const quiz = await generateQuiz(currentAlphabet,alphabetsEng);
    flagEng=true
    return res.json(quiz)
  }else{
    currentAlphabetIndexEng = (currentAlphabetIndexEng - 1) % alphabetsEng.length;
    return res.json(data);
  }
});
