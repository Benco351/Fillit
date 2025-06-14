import { Request, Response, NextFunction } from 'express';
import { AnyZodObject, ZodError } from 'zod';

export const validate = (schema: AnyZodObject) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      schema.parse(req.body);
      next();
    } catch (err) {
      if (err instanceof ZodError) {
        res.status(400).json({
          status: 'fail',
          errors: err.errors
        });
      } else {
        next(err);
      }
    }
  };
};


export const validateQuery = (schema: AnyZodObject) => {
  return (req: Request, res: Response, next: NextFunction): void => {
    try {
      schema.parse(req.query);
      next();
    } catch (err) {
      if (err instanceof ZodError) {
        res.status(400).json({
          status: 'fail',
          errors: err.errors
        });
      } else {
        next(err);
      }
    }
  };
};

export const validateId = (id: string): number | null => {
  const empId = Number(id);
  return isNaN(empId) ? null : empId;
};

