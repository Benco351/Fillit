import { Request, Response, NextFunction } from 'express';
import * as userService from '../services/userService';
import { CreateUserDTO } from '../types/userSchema';
import { apiResponse } from '../utils/apiResponse';
import { logger } from '../config/logger';

export const getUsers = async (_req: Request, res: Response, next: NextFunction) => {
  try {
    const users = await userService.getAllUsers();
    logger.info('Fetched all users');
    res.json(apiResponse(users));
  } catch (err) {
    logger.error(`getUsers error: ${err}`);
    next(err);
  }
};

export const getUser = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await userService.getUserById(Number(req.params.id));
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(apiResponse(user));
  } catch (err) {
    next(err);
  }
};

export const createUser = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const user = await userService.createUser(req.body as CreateUserDTO);
    logger.info(`Created user ${user.id}`);
    res.status(201).json(apiResponse(user, 'User created'));
  } catch (err) {
    logger.error(`createUser error: ${err}`);
    next(err);
  }
};

export const deleteUser = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const success = await userService.deleteUser(Number(req.params.id));
    if (!success) return res.status(404).json({ error: 'User not found' });
    res.json(apiResponse(null, 'User deleted'));
  } catch (err) {
    next(err);
  }
};