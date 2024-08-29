import { Schema, model } from 'mongoose';

const signImageSchema = new Schema({
    number: { type: Number, required: true },
    signImage: { type: String, required: true } // URL for the image
  });
  
const NumberImage = model('NumberImage', signImageSchema);

export default NumberImage