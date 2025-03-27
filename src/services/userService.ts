import { CreateUserDTO } from '../types/userSchema';

interface User extends CreateUserDTO {
  id: number;
}

let users: User[] = [];

export const getAllUsers = async (): Promise<User[]> => users;

export const createUser = async (data: CreateUserDTO): Promise<User> => {
  const newUser = { id: Date.now(), ...data };
  users.push(newUser);
  return newUser;
};

export const getUserById = async (id: number): Promise<User | null> => {
  return users.find(user => user.id === id) || null;
};

export const deleteUser = async (id: number): Promise<boolean> => {
  const initialLength = users.length;
  users = users.filter(user => user.id !== id);
  return users.length < initialLength;
};