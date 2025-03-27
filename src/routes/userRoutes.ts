import { Router } from 'express';
import * as userController from '../controllers/userController';
import { validate } from '../middlewares/validateMiddleware';
import { CreateUserSchema } from '../types/userSchema';

const router = Router();

router.get('/', userController.getUsers);
// router.get('/:id', userController.getUser);
router.post('/', validate(CreateUserSchema), userController.createUser);
// router.delete('/:id', userController.deleteUser); // No validation schema needed for delete

export default router;