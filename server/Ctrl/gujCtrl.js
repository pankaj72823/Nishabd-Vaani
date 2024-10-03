import wrapAsync from '../Utils/wrapAsync.js'
import GujAlphabet from '../Schema/GujAlphabet.js';


let currentAlphabetIndexGujarati = 0;
// const alphabetsGujarati = ['અ', 'આ', 'ઇ', 'ઈ', 'ઉ', 'ઊ', 'ઋ', 'એ', 'ઐ', 'ઓ', 'ઔ', 'ક', 'ખ', 'ગ', 'ઘ', 'ચ', 'છ', 'જ', 'ઝ', 'ટ', 'ઠ', 'ડ', 'ઢ', 'ત', 'થ', 'દ', 'ધ', 'ન', 'પ', 'ફ', 'બ', 'ભ', 'મ', 'ય', 'ર', 'લ', 'વ', 'શ', 'ષ', 'સ', 'હ']; // Add more as needed
const alphabetsGujarati = ['ક', 'ખ', 'ગ', 'ઘ', 'ચ', 'છ', 'જ', 'ઝ', 'ટ', 'ઠ', 'ડ', 'ઢ','ણ', 'ત', 'થ', 'દ', 'ધ', 'ન', 'પ', 'ફ', 'બ', 'ભ', 'મ', 'ય', 'ર', 'લ', 'વ', 'શ', 'ષ', 'સ', 'હ','ળ','ક્ષ']; // Add more as needed
let flagGujarati = false;

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
  }
  return quiz;
}



// Gujarati alphabet route

export const alphabetGujarati = wrapAsync(async (req, res) => {
    currentAlphabetIndexGujarati = 0;
    const currentAlphabet = alphabetsGujarati[0];
    const data = await GujAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
    data.flag = "Learn"
    currentAlphabetIndexGujarati = (currentAlphabetIndexGujarati + 1) % alphabetsGujarati.length;
    return res.json(data);
  });


export const alphabetGujaratiNext = wrapAsync(async (req, res) => {
  
  const currentAlphabet = alphabetsGujarati[currentAlphabetIndexGujarati];
  const data = await GujAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn"

  if (flagGujarati) {
    currentAlphabetIndexGujarati = (currentAlphabetIndexGujarati + 1) % alphabetsGujarati.length;
    flagGujarati = false;
    return res.json(data);
  } else if (currentAlphabetIndexGujarati !== 0 && currentAlphabetIndexGujarati % 5 === 0) {
    const quiz = await generateQuiz(currentAlphabet, alphabetsGujarati);
    flagGujarati = true;
    return res.json(quiz);
  } else {
    currentAlphabetIndexGujarati = (currentAlphabetIndexGujarati + 1) % alphabetsGujarati.length;
    return res.json(data);
  }
});

export const alphabetGujaratiPrev = wrapAsync(async (req, res) => {
  if(currentAlphabetIndexGujarati-2<0){
    const error = new Error("Start Learning");
    error.status = 400; // Set a custom status code
    throw error;
  }
  const currentAlphabet = alphabetsGujarati[currentAlphabetIndexGujarati-2];

  const data = await GujAlphabet.findOne({ alphabet: currentAlphabet }).select('-_id -__v').lean();
  data.flag = "Learn"
 
  if(flagGujarati){
    currentAlphabetIndexGujarati = (currentAlphabetIndexGujarati - 1) % alphabetsGujarati.length;
    flagGujarati=false
    return res.json(data);
  }else if(currentAlphabetIndexGujarati!=0 && currentAlphabetIndexGujarati%5==0){
    const quiz = await generateQuiz(currentAlphabet,alphabetsGujarati);
    flagGujarati=true
    return res.json(quiz)
  }else{
    currentAlphabetIndexGujarati = (currentAlphabetIndexGujarati - 1) % alphabetsGujarati.length;
    return res.json(data);
  }
});

