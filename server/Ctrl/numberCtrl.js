import wrapAsync from '../Utils/wrapAsync.js';
import NumberImage from '../Schema/Number.js';

// Number sequence
const number = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

// Start learning number sign
export const numberSign = wrapAsync(async (req, res) => {
  
  req.session.currentNumberIndex = 0;
 
  const currentNumber = number[req.session.currentNumberIndex];
  const data = await NumberImage.findOne({ number: currentNumber }).select('-_id -__v').lean();
  data.Basket = 'https://res.cloudinary.com/dihixxcnt/image/upload/v1724945980/Pngtree_vector_free_buckle_cartoon_basketball_4581831_1_dvexdu.png';

  // Move to the next number
  req.session.currentNumberIndex = (req.session.currentNumberIndex + 1) % number.length;

  return res.json(data);
});

// Get next number sign
export const NumberNext = wrapAsync(async (req, res) => {
  // Ensure session-based index is initialized
  if (!req.session.currentNumberIndex) {
    req.session.currentNumberIndex = 0;
  }

  const currentNumber = number[req.session.currentNumberIndex];
  const data = await NumberImage.findOne({ number: currentNumber }).select('-_id -__v').lean();
  data.Basket = 'https://res.cloudinary.com/dihixxcnt/image/upload/v1724945980/Pngtree_vector_free_buckle_cartoon_basketball_4581831_1_dvexdu.png';

  // Move to the next number
  req.session.currentNumberIndex = (req.session.currentNumberIndex + 1) % number.length;
  return res.json(data);
});

// Get previous number sign
export const NumberPrev = wrapAsync(async (req, res) => {
  if (!req.session.currentNumberIndex || req.session.currentNumberIndex - 2 < 0) {
    const error = new Error("Start Learning");
    error.status = 400; // Set a custom status code
    throw error;
  }

  // Move two steps back for "previous" functionality
  const currentNumber = number[req.session.currentNumberIndex - 2];
  const data = await NumberImage.findOne({ number: currentNumber }).select('-_id -__v').lean();
  data.Basket = 'https://res.cloudinary.com/dihixxcnt/image/upload/v1724945980/Pngtree_vector_free_buckle_cartoon_basketball_4581831_1_dvexdu.png';

  // Update the session to move back in sequence
  req.session.currentNumberIndex = (req.session.currentNumberIndex - 1) % number.length;

  return res.json(data);
});
