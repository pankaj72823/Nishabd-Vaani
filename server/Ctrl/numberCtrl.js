import wrapAsync from '../Utils/wrapAsync.js'
import NumberImage from '../Model/Number.js';


let currentNumberIndex = 0;
const number = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]


export const numberSign = wrapAsync(async(req,res)=>{
  currentNumberIndex = 0;
  const currentNumber = number[0];
  const data = await NumberImage.findOne({ number: currentNumber }).select('-_id -__v').lean();
  data.Basket = 'https://res.cloudinary.com/dihixxcnt/image/upload/v1724945980/Pngtree_vector_free_buckle_cartoon_basketball_4581831_1_dvexdu.png'
  currentNumberIndex = (currentNumberIndex + 1) % number.length;

  return res.json(data);
})
export const NumberNext = wrapAsync(async(req,res)=>{
  const currentNumber = number[currentNumberIndex];
  const data = await NumberImage.findOne({ number: currentNumber }).select('-_id -__v').lean();
  data.Basket = 'https://res.cloudinary.com/dihixxcnt/image/upload/v1724945980/Pngtree_vector_free_buckle_cartoon_basketball_4581831_1_dvexdu.png'
  currentNumberIndex = (currentNumberIndex + 1) % number.length;

  return res.json(data);
})

export const NumberPrev = wrapAsync(async(req,res)=>{
  if(currentNumberIndex-2<=0){
    const error = new Error("Start Learning");
    error.status = 400; // Set a custom status code
    throw error;
  }
  const currentNumber = number[currentNumberIndex-2];
  const data = await NumberImage.findOne({ number: currentNumber }).select('-_id -__v').lean();
  currentNumberIndex = (currentNumberIndex - 1) % number.length;
  return res.json(data);
})