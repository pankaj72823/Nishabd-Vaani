import dotenv from 'dotenv';
dotenv.config();

import express from 'express'
import './config/multer.js'
// import './config/passport.js'
import './config/mongodb.js'

import learningRoute from './Router/learningRouter.js'
import ConversRoute from './Router/conversionRouter.js'

const app = express();
app.use(express.urlencoded({ extended: true }))
app.use(express.json())
const PORT = process.env.PORT || 5000;

app.use((req, res, next) => {
  const Logtime = new Date(Date.now());
  if(req.path != "/appIcon.ico"){
  console.log(
    `Method : ${req.method} \n Path : ${req.path} \n Time : ${Logtime} \n`
  )}
  next();
});
  
app.use('/learning',learningRoute)
app.use('/conversion',ConversRoute)
app.get('/',(req,res)=>{
    res.send("Server is live.... ") 
})




app.use((err, req, res, next) => {
  console.error(err.message); // Log the error to the console
  const statusCode = err.status || 500; // Use the error status if available, otherwise use 500
  res.status(statusCode).json({
      error: {
          message: err.message || 'Internal Server Error',
          status: statusCode
      }
  });
});
app.listen(PORT, () => {
    console.log(`Click to Connect : http://localhost:${PORT}/`);
});