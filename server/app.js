import dotenv from 'dotenv';
dotenv.config();

import express from 'express';
import { createServer } from 'http';
import session from 'express-session';
import cookieParser from 'cookie-parser';
import path from 'path';
import passport from 'passport';
import cors from './config/corsConfig.js';
import './config/multer.js';
import './config/mongodb.js';
import passportConfig from './config/passport.js';
import websocketRoutes from './Router/websocketRoutes.js';
import learningRoute from './Router/learningRouter.js';
import ConversRoute from './Router/conversionRouter.js';
import BoardRoute from './Router/BoardRouter.js';
import EngBoardRoute from './Router/engBoardRouter.js';
import studentRoutes from './Router/student.js';
import fakerRoute from './Router/Faker.js';
import client from 'prom-client';

// Initialize Express and HTTP server
const app = express();
const server = createServer(app);

app.set('server', server); // Make the server instance accessible in other modules

const PORT = process.env.PORT || 5000;
const register = new client.Registry();

// Default metrics collection (memory, CPU, etc.)
client.collectDefaultMetrics({ register });

// Example of a custom metric (Counter)
const httpRequestCounter = new client.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code'],
});

// Middleware to parse incoming requests
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(cookieParser());
// Middleware to increase the counter on every request
app.use((req, res, next) => {
  res.on('finish', () => {
    httpRequestCounter.labels(req.method, req.route ? req.route.path : req.url, res.statusCode).inc();
  });
  next();
});

// CORS setup
app.use(cors);

// Initialize session middleware
app.use(session({
  secret: 'mysecretkey',  // Replace with your secret key
  resave: false,          // Avoid resaving unchanged sessions
  saveUninitialized: true, // Save new (but unmodified) sessions
  cookie: { maxAge: 24 * 60 * 60 * 1000 } // Session cookie valid for 1 day
}));


//Passport.js Authentication setUp
app.use(passport.initialize());
passportConfig(passport); // Passport config

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
app.use('/students', studentRoutes);
app.use('/learning', learningRoute);
app.use('/conversion', ConversRoute);
app.use('/gujBoard', BoardRoute);
app.use('/EngBoard', EngBoardRoute);
app.use('/fake-user', fakerRoute)
app.use('/', websocketRoutes); // This will handle the WebSocket initialization route

// Root route
app.get('/', (req, res) => {
  res.send("Server is live.... ");
});
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
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

app.use((req, res, next) => {
  res.status(404).json({ title: '404', message: 'Page Not Found' });
});

// Start the server
server.listen(PORT, () => {
  console.log(`Click to Connect: http://localhost:${PORT}/`);
});
