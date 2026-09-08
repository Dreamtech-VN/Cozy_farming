-- Email cho tài khoản (doc 22).
--
-- Cho phép NULL: các tài khoản tạo trước bản này không có email, và bắt buộc
-- email sẽ khoá luôn đường đăng ký nhanh chỉ bằng username. Ràng buộc UNIQUE
-- trong SQLite bỏ qua NULL nên nhiều tài khoản không email vẫn cùng tồn tại.
ALTER TABLE users ADD COLUMN email TEXT;
CREATE UNIQUE INDEX idx_users_email ON users (email) WHERE email IS NOT NULL;
