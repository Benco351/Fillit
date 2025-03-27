"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteUser = exports.getUserById = exports.createUser = exports.getAllUsers = void 0;
let users = [];
const getAllUsers = () => __awaiter(void 0, void 0, void 0, function* () { return users; });
exports.getAllUsers = getAllUsers;
const createUser = (data) => __awaiter(void 0, void 0, void 0, function* () {
    const newUser = Object.assign({ id: Date.now() }, data);
    users.push(newUser);
    return newUser;
});
exports.createUser = createUser;
const getUserById = (id) => __awaiter(void 0, void 0, void 0, function* () {
    return users.find(user => user.id === id) || null;
});
exports.getUserById = getUserById;
const deleteUser = (id) => __awaiter(void 0, void 0, void 0, function* () {
    const initialLength = users.length;
    users = users.filter(user => user.id !== id);
    return users.length < initialLength;
});
exports.deleteUser = deleteUser;
