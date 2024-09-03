import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import { createServer } from 'http';
import path from 'path';
import cors from './config/corsConfig.js';
import './config/multer.js';
// import './config/passport.js';
import './config/mongodb.js';
import websocketRoutes from './Router/websocketRoutes.js';
import learningRoute from './Router/learningRouter.js';
import ConversRoute from './Router/conversionRouter.js';
import BoardRoute from './Router/BoardRouter.js';
import EngBoardRoute from './Router/engBoardRouter.js'

// Initialize Express and HTTP server
const app = express();
const server = createServer(app);

app.set('server', server); // Make the server instance accessible in other modules

const PORT = process.env.PORT || 5000;

// Middleware to parse incoming requests
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// CORS setup
app.use(cors);

// Request logging middleware
app.use((req, res, next) => {
  const Logtime = new Date(Date.now());
  if (req.path !== "/appIcon.ico") {
    console.log(
      `Method : ${req.method} \n Path : ${req.path} \n Time : ${Logtime} \n`
    );
  }
  next();
});

// API routes
app.use('/learning', learningRoute);
app.use('/conversion', ConversRoute);
app.use('/gujBoard', BoardRoute)
app.use('/EngBoard', EngBoardRoute)
app.use('/', websocketRoutes); // This will handle the WebSocket initialization route

// Root route
app.get('/', (req, res) => {
  res.send("Server is live.... ");
});

// Global error handling middleware
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

// Start the server
server.listen(PORT, () => {
  console.log(`Click to Connect: http://localhost:${PORT}/`);
});
