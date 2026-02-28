create database if not exists my_vocabulary_book;
use my_vocabulary_book;

-- table
create table users (
  user_id int auto_increment,
  user_name varchar(50) unique not null,
  password varchar(70) not null,
  create_at timestamp default current_timestamp,
  primary key(user_id)
);

create table books (
  book_id int auto_increment,
  user_id int,
  book_name varchar(20) not null,
  first_review varchar(10),
  create_at timestamp default current_timestamp,
  primary key(book_id),
  foreign key(user_id)
    references users(user_id) on delete cascade
);

create table words (
  word_id int auto_increment,
  book_id int not null,
  word varchar(50),
  translated_word varchar(50),
  create_at timestamp default current_timestamp,
  primary key(word_id),
  foreign key(book_id)
    references books(book_id) on delete cascade
);
