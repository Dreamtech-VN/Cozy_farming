/**
 * Error envelope chuẩn (doc 15).
 * Response lỗi luôn có dạng: { "error": { "code", "message", "details" } }
 */
export class ApiError extends Error {
  constructor(status, code, message, details = undefined) {
    super(message);
    this.status = status;
    this.code = code;
    this.details = details;
  }
  toJSON() {
    return { error: { code: this.code, message: this.message, ...(this.details ? { details: this.details } : {}) } };
  }
}

export const badRequest = (message, details) => new ApiError(400, 'bad_request', message, details);
export const unauthorized = (message = 'Cần đăng nhập') => new ApiError(401, 'unauthorized', message);
export const forbidden = (message = 'Không có quyền') => new ApiError(403, 'forbidden', message);
export const notFound = (message = 'Không tìm thấy') => new ApiError(404, 'not_found', message);
export const conflict = (message, details) => new ApiError(409, 'conflict', message, details);
export const tooManyRequests = (message = 'Thao tác quá nhanh') => new ApiError(429, 'rate_limited', message);
export const serverError = (message = 'Lỗi hệ thống') => new ApiError(500, 'internal_error', message);
