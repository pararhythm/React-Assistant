-- Kích hoạt extension hỗ trợ sinh UUID ngẫu nhiên
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Tạo các kiểu dữ liệu Enum
CREATE TYPE sign_in_method_enum AS ENUM ('Google', 'Github', 'Email');
CREATE TYPE locale_enum AS ENUM ('vi', 'en');
CREATE TYPE sender_enum AS ENUM ('chatbot', 'user');
CREATE TYPE model_type_enum AS ENUM ('default', 'thinking');

-- Hàm tự động cập nhật cột updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 1. Bảng Users
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(500) NULL,
    sign_in_method sign_in_method_enum NOT NULL,
    locales locale_enum NOT NULL DEFAULT 'en',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    
    -- Constraint: Nếu đăng nhập bằng Email thì password_hash KHÔNG ĐƯỢC để NULL
    CONSTRAINT chk_password_for_email_auth 
        CHECK (
            (sign_in_method = 'Email' AND password_hash IS NOT NULL) OR 
            (sign_in_method <> 'Email')
        )
);

-- 2. Bảng chat_sessions
CREATE TABLE chat_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chat_title VARCHAR(100) NOT NULL,
    user_id UUID NOT NULL,
    is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    
    -- Khóa ngoại trỏ đến bảng users
    CONSTRAINT fk_chat_sessions_users 
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 3. Bảng chat_messages
CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    messages TEXT NOT NULL,
    sender sender_enum NOT NULL,
    model_type model_type_enum NOT NULL DEFAULT 'default',
    thinking TEXT NULL,
    chat_session_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    
    -- Khóa ngoại trỏ đến bảng chat_sessions
    CONSTRAINT fk_chat_messages_sessions 
        FOREIGN KEY (chat_session_id) REFERENCES chat_sessions(id) ON DELETE CASCADE
);

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chat_sessions_updated_at
    BEFORE UPDATE ON chat_sessions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_chat_messages_updated_at
    BEFORE UPDATE ON chat_messages
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Indexes cho bảng Users
-- Unique index cho email để đăng nhập nhanh & tránh trùng lặp
CREATE UNIQUE INDEX idx_users_email ON users(email);
-- Index tìm kiếm người dùng theo username
CREATE INDEX idx_users_username ON users(username);

-- Indexes cho bảng chat_sessions
-- Index hỗ trợ query danh sách chat theo User, lọc tin ghim và sắp xếp từ mới nhất đến cũ nhất
CREATE INDEX idx_chat_sessions_user_pinned_updated 
ON chat_sessions(user_id, is_pinned DESC, updated_at DESC);

-- Indexes cho bảng chat_messages
-- Composite Index hỗ trợ lấy danh sách tin nhắn của 1 đoạn chat theo đúng thứ tự thời gian
CREATE INDEX idx_chat_messages_session_created 
ON chat_messages(chat_session_id, created_at ASC);
