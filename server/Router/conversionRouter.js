import express from 'express'
import Gif from '../Model/GIf.js'
import wrapAsync from '../Utils/wrapAsync.js'

const router = express.Router()

router.post('/', wrapAsync(async(req,res)=>{
    const word = req.body.word;
    const gif = await Gif.findOne({sign_name : word}).select('-_id -__v');
    if(!gif){
        const error = new Error("Gif Not Found");
        error.status = 400; // Set a custom status code
        throw error;
    }
    return res.json(gif)
}))

export default router