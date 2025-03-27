"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.apiResponse = void 0;
const apiResponse = (data, message = 'Success') => ({
    status: 'ok',
    message,
    data
});
exports.apiResponse = apiResponse;
