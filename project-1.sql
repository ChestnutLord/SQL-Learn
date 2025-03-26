CREATE TABLE author
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(128) NOT NULL,
    last_name  VARCHAR(128) NOT NULL
);

CREATE TABLE book
(
    id        BIGSERIAL PRIMARY KEY,
    name      VARCHAR(128) NOT NULL,
    year      SMALLINT     NOT NULL,
    pages     SMALLINT     NOT NULL,
    author_id INT REFERENCES author (id) ON DELETE CASCADE
);

INSERT INTO author(first_name, last_name)
VALUES ('Кей', 'Хорстманн'),
       ('Стивен', 'Кови'),
       ('Тони', 'Роббинс'),
       ('Наполеон', 'Хилл'),
       ('Роберт', 'Кийосаки'),
       ('Дейл', 'Карнеги');

UPDATE author
SET last_name='Хорстманн'
WHERE first_name = 'Кей';

SELECT *
FROM author;

insert into book (name, year, pages, author_id)
values ('Книга 1', 1900, 100, (SELECT id FROM author WHERE last_name = 'Хорстманн')),
       ('Книга 2', 1901, 1000, (SELECT id FROM author WHERE last_name = 'Хорстманн')),
       ('Книга 3', 1902, 300, (SELECT id FROM author WHERE last_name = 'Карнеги')),
       ('Книга 4', 1903, 10, (SELECT id FROM author WHERE last_name = 'Хорстманн')),
       ('Книга 5', 1945, 2345, (SELECT id FROM author WHERE last_name = 'Карнеги')),
       ('Книга 6', 1970, 3400, (SELECT id FROM author WHERE last_name = 'Роббинс')),
       ('Книга 7', 2020, 100, (SELECT id FROM author WHERE last_name = 'Кийосаки')),
       ('Книга 8', 1842, 200, (SELECT id FROM author WHERE last_name = 'Кови')),
       ('Книга 9', 1791, 156, (SELECT id FROM author WHERE last_name = 'Кови')),
       ('Книга 10', 2024, 123, (SELECT id FROM author WHERE last_name = 'Хилл'));

DROP TABLE book;

SELECT *
FROM book;

DELETE
FROM book;

-- ЗАПРОС, ВЫДАЮЩИЙ НАЗВАНИЕ, ГОД И ИМЯ АВТОРА, ORDERED BY ГОДУ
SELECT name,
       year,
       (SELECT first_name FROM author WHERE author.id = book.author_id)
FROM book
ORDER BY year DESC;

-- ЗАПРОС, ВЫДАЮЩИЙ КОЛИЧЕСТВО КНИГ У ЗАДАННОГО АВТОРА

SELECT count(*)
FROM book
where author_id = (SELECT author.id FROM author where first_name = 'Кей')

-- написать запрос, выбирающий книги,
-- у которых количество страниц больше среднего еоличества страниц по всем книгам

SELECT name,
       pages
FROM book
WHERE pages > (SELECT avg(pages) from book);

--запрос, выбирающий 5 самых старых книг

SELECT sum(pages)
FROM (SELECT *
      FROM BOOK
      ORDER BY year
      LIMIT 5) oldest;

SELECT *
FROM BOOK
ORDER BY year
LIMIT 5;

-- запрос, изменяющий количество страниц у книги

UPDATE book
SET pages=pages + 1
WHERE year = 1900
returning *;

-- написать запрос, удаляющий автора, который написал самую большую книгу

DELETE
FROM book
WHERE author_id = (SELECT
                author_id
            FROM book

            WHERE pages =
                  (SELECT max(pages) FROM book));


DELETE
FROM author
WHERE id = 3
returning *;
