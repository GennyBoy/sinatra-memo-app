CREATE DATABASE memoapp;

\c memoapp

CREATE TABLE memos(
   id uuid,
   title text,
   content text,
   created_at timestamp,
   updated_at timestamp
);

CREATE DATABASE test_memoapp;

\c test_memoapp

CREATE TABLE memos(
    id uuid,
    title text,
    content text,
    created_at timestamp,
    updated_at timestamp
);

INSERT INTO memos (id, title, content, created_at, updated_at) VALUES
    ('c58668db-74aa-4025-b7ba-1a5d72f6b203', 'テストのタイトル', 'テストの本文', '2021-09-13 09:00:00', '2021-09-13 09:00:00'),
    ('c58668db-74aa-4025-b7ba-1a5d72f6b204', '更新テストのタイトル', '更新テストの本文', '2021-09-13 09:00:00', '2021-09-13 09:00:00');
