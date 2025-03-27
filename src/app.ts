import express, { Application } from 'express';
 import userRoutes from './routes/userRoutes';

const app: Application = express();

// Middleware for parsing JSON bodies
app.use(express.json());

// Register routes
app.use('/api/users', userRoutes);

export default app;