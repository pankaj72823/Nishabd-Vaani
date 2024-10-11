import express from 'express'
import Gif from '../Schema/GIf.js'
import wrapAsync from '../Utils/wrapAsync.js'

const router = express.Router()
function capitalize(word){
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
};


router.post('/', wrapAsync(async(req,res)=>{
    const word = capitalize(req.body.word);
    const gif = await Gif.findOne({sign_name: { $regex: new RegExp(`^${word}$`, 'i') } }).select('-_id -__v');
    if(!gif){
        const error = new Error("Gif Not Found");
        error.status = 400; // Set a custom status code
        throw error;
    }
    return res.json(gif)
})).get('/',wrapAsync(async(req,res)=>{
    const gifs = await Gif.find().select('sign_name -_id')
    return res.json(gifs)
}))

export default router