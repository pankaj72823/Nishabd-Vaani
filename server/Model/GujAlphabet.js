import { Schema,model } from "mongoose";
const alphabetSchema = new Schema({
  alphabet: {
    type: String,
    required: true,
    unique: true,
    maxlength: 1,
  },
  signImage: {
    type: String, 
    required: true,
  },
  objectImage: {
    type: String,  
    required: true,
  },
});

const GujAlphabet = model('GujAlphabet', alphabetSchema);

export default GujAlphabet