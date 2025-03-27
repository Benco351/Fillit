import { z } from 'zod';

export const CreateUserSchema = z.object({
  name: z.string().min(1),
  email: z.string().email()
});

export type CreateUserDTO = z.infer<typeof CreateUserSchema>; 