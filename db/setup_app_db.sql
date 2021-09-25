CREATE DATABASE memoapp;

\c memoapp

CREATE TABLE memos(
                      id uuid,
                      title text,
                      content text,
                      created_at timestamp,
                      updated_at timestamp
);
