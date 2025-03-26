CREATE DATABASE company_repository;

CREATE SCHEMA company_storage;

DROP SCHEMA company_storage;

CREATE TABLE company_storage.company
(
    id   INT PRIMARY KEY,
    name VARCHAR(128) UNIQUE NOT NULL,
    date DATE                NOT NULL CHECK (date > '1990-01-01' AND date < '2025-01-01'),

    UNIQUE (id, name)

--SQL constraints:

--PRIMARY KEY (UNIQUE and NOT NULL)- МОЖЕТ БЫТЬ ТОЛЬКО ОЛИН НА ВСЮ ТАБЛИЦУ
--NOT NULL
--UNIQUE (a,b)-важен порядок. конкатенация
--CHECK
--FOREIGN KEY

);


-- ДЕФОЛТНОЕ ФОРМАТИРОВАНИЕ CTRL + ALT + L

INSERT INTO company_storage.company(id, name, date)
VALUES
        --(1, 'Google', '2001-01-01'),
       (2, 'Apple', '2002-10-29');
      -- (3, 'Facedook', '1998-12-12'),
       --(4, 'Amazon', '2005-06-17');


CREATE TABLE employee
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(123) NOT NULL,
    last_name  VARCHAR(128) NOT NULL,
    company_id INT REFERENCES company_storage.company (id) ON DELETE CASCADE, -- ВНЕШНИЙ КЛЮЧ
    salary     INT,
    UNIQUE (first_name, last_name)
--    FOREIGN KEY (company_id) REFERENCES company
);

DROP TABLE company_storage.company;

insert into employee (first_name, last_name, salary, company_id)
values ('Ivan', 'Sidorov', 40000, 1),
       ('Ivan', 'Ivanov', 1000, 2),
       ('Timur', 'Timurov', 2000, 2),
       ('Arni', 'Perett', NULL, 3),
       ('Anna', 'Annonyan', 3000, NULL);

DROP TABLE employee;


--урок 8
--=================================

--установка АЛЬЯНСОВ- именование полей по-другому
--DISTINCT - только уникальные (аналогия Set)
--UNION - объединяет результаты запросов, удаляя дублирующиеся строки

insert into employee (first_name, last_name)
values ('Natan', 'Cron');

SELECT lower(first_name),
       --    concat(first_name,' ',last_name) fio
       first_name || ' ' || last_name fio,
       now()
FROM employee empl;

SELECT now(), 1 + 2 * 3;

SELECT first_name
FROM employee
WHERE company_id IS NOT NULL
UNION
SELECT first_name
FROM employee
WHERE salary IS NULL;

--WHERE salary IN (1000, 3000)
--   OR (first_name ILIKE 'iv%' AND last_name ILIKE '%ov%')
--ORDER BY first_name, salary DESC;


----------------------------
-- DISTINCT выводит только уникальные значения у указанного
-- LIMIT 2- ограничение на вывод
-- OFFSET 2- пропусти с начала

-- SELECT FROM - порядок не гарантирован !!
-- DESC -ПО УБЫВАНИЮ
-- ASC -ПО ВОЗРАСТАНИЮ

--Ключевые слова:
--BETWEEN - МЕЖДУ КАКИМИ-ТО ЗНАЧЕНИЯМИ
--IN - ЧЁТКОЕ соответствие (STRICTE)
--LIKE
--ILIKE - Case-Insensitive LIKE. Оператор ILIKE игнорирует регистр символов.
--        Запрос WHERE column ILIKE 'Test' найдет строки, где значение совпадает с Test, test, TEST

-- УРОК 9, ФИЛЬТРАЦИЯ ДАННЫХ
--=================================
--WHERE A > < <= >= = != (OR <>) ---ДЛЯ ЧТСЕЛ И ДАТ
-- WHERE first_name ILIKE 'iv%'
-- WHERE -ЧУВСТВИТЕЛЬНА К РЕгистру
-- В P.SQL ЕСТЬ ILIKE- FIRST IN UPPER CASE
-- МЕЖДУ КАКИМИ-ТО ЗНАЧЕНИЯМИ == WHERE A BETWEEN B ABD C
-- КОНКРЕТНОЕ СОВПАДЕНИЕ == WHERE A IN (B,C,D)
-- NB! НЕ ЗАБЫВАЙ ПРО СКОБОЧКИ

-- УРОК 10 АГРЕГИРУЮЩИЕ И ВСТРОЕННЫЕ ФУНКЦИИ
--=================================
--АГРЕГИРКЮЩИЕ ФУНКЦИИ (sum, avg, max, min, count)

-- УРОК 11 ВНЕШНИЙ КЛЮЧ
--=================================

--  company_id INT REFERENCES company_storage.company (id) ON DELETE CASCADE,

-- принято именовать поле так: название-таблицы_полне-на-которое-ссылается
--company (id) в скобочках поле на которое ссылаемся. можно не указывать, тогда будем ссылаться на первичный ключ таблицы.

-- всё. это и есть объявление.

-- есть другой способ. По аналогии с Unique --> FOREIGN KEY (company_id) REFERENCES company(id)

-- NB! Более предпочтителен вариант с REFERENCES.
-- NB! ИНДЕКСЫ, NOT NULL И UNIQUE НЕ СОЗДАЮТСЯ АВТОМАТИЧЕСКИ.

-- УРОК 12 ОБЪЕДИНЕНИЕ ЗАПРОСОВ (UNION)
--=================================
-- ХОТИМ ЧТОБ ОТ ОДНОГО ЗАПРОСА ВОЗВРАЩАЛИСЬ ДАННЫЕ ИЗ РАЗНЫХ ТАБЛИЦ
-- ИЛИ КОГДА ДВА ОЧЕНЬ СЛОЖНЫХ ЗАПРОСА К ОДНОЙ ТАБЛИЦЕ И МЫ ХОТИМ
-- ИХ РАЗБИТЬ НА ДВА ЗАПРОСА, А РЕЗУЛЬТИРУЮЩИЙ НАБОР ОБЪЕДЕНИТЬ

-- ПОСТАВИТЬ УСЛОВИЕ ЕСТЬ NULL ИСП IS, А НЕ =, И ТАКЖЕ NOT,
-- КОТОРОЕ ИСП СО ВСЕМИ КЛЮЧЕВЫМИ СЛОВАМИ (СТР. 81)

-- ИСП UNION ALL

-- -- ПРИ ОБЪЕДИНЕНИИ ДВУХ ВЫБОРОК КОЛИЧЕСТВО КОЛОНОК И ИХ ТИПЫ ДАННЫХ ДОЛЖНЫ СОВПАДАТЬ !!!

-- UNION ALL БЕРЁТ ВСЕХ,
-- UNION - УБИРАЕТ ДУБЛИКАТЫ

-- УРОК 13 ПОДЗАПРОСЫ
--=================================

-- ВО FROM ПИXАЕМ ЛЮБОЕ МНОЖЕСТВО, ПРЕДСТАВЛЯЮЩЕЕ ИЗ СЕБЯ ТАБЛИЦУ

SELECT avg(empl.salary)
FROM (SELECT *
      FROM employee
      ORDER BY salary DESC
      LIMIT 2) empl;

SELECT *
FROM employee
ORDER BY salary
LIMIT 2;

SELECT *,
       (SELECT max(salary) FROM employee) - salary diff
FROM employee;

SELECT *
FROM employee
WHERE company_id IN (SELECT company.id
                     FROM company
                     WHERE DATE > '01-01-2000');

-- УРОК 14 УДАЛЕНИЕ СТРОК
--=================================

-- DELETE (СТРОКУ)

DELETE
FROM employee
WHERE salary IS NULL;

DELETE
FROM employee
WHERE salary = (SELECT max(salary)
                FROM employee);

DELETE
FROM company
WHERE id = 2;

SELECT *
FROM employee;

-- ПРИ  УДАЛЕНИИ ВНЕШНЕГО КЛЮЧА МОЖЕМ ПОСТАВИТЬ ON DELETE И СКАЗАТЬ ПОВЕДЕНИЕ ПРИ УДАЛЕНИИ ВНЕШНЕГО КЛЮЧА:
-- CASCADE
-- NO ACTION
-- RESTRICT
-- SET DEFAULT
-- SET NULL

-- УРОК 15 ОБНОВЛЕНИЕ СТРОК
--=================================

--UPDATE (СТРОКУ/запись В ТАБЛИЦЕ) table-name

UPDATE employee
SET company_id=1,
    salary=1700
WHERE id = 7
   OR id = 10
RETURNING id, first_name || ' ' || employee.last_name fio;


-- ПРАКТИЧЕСКОЕ ЗАНЯТИЕ

CREATE DATABASE book_repository;

SHOW hba_file;

-- ALTER USER postgres PASSWORD 'postgres';

SHOW client_encoding;

SET client_encoding TO 'UTF8';
---------------------------------------------------------------------------------------------

CREATE TABLE company_storage.contact
(
    id     SERIAL PRIMARY KEY,
    number varchar(128),
    type   varchar(128)
);
DROP table contact;

INSERT INTO contact (number, type)
VALUES ('234 - 56 - 78', 'домашний'),
       ('111 - 11 - 11', 'рабочий'),
       ('211 - 36 - 90', 'мобильный'),
       ('101 - 04 - 38', NULL),
       ('386 - 87 - 56', NULL);

DELETE
FROM contact;

DROP TABLE contact;

CREATE TABLE company_storage.employee_contact
(
    employee_id BIGINT REFERENCES employee (id),
    contact_id  BIGINT REFERENCES contact (id),
    PRIMARY KEY (employee_id, contact_id)
);

DROP TABLE employee_contact;

INSERT INTO employee_contact (employee_id, contact_id)
VALUES (6, 1),
       (6, 2),
       (7, 2),
       (7, 3),
       (8, 4),
       (9, 5);

--УРОК 20
------------------------------
--СОЕДИНЕНИ ТАБЛИЦ. JOIN
------------------------------

UPDATE employee
SET company_id=NULL
WHERE id = 5;

SELECT company.name,
       employee.first_name || employee.last_name fio
FROM employee,
     company
WHERE company_id = company.id;

-- КОГДА ВО FROM ПЕРЕЧИСЛЯЕМ ЧЕРЕЗ ЗАПЯТУЮ ПОЛУЧАЕТСЯ ДЕКАРТОВО ПРОИЗВЕДЕНИЕ
-- ТО ЕСТЬ КОЛ-ВО ЗАПИСЕЙ ИЗ ОДНОЙ УМНОЖАЕТСЯ НА КОЛ-ВО ЗАПИСЕЙ ИЗ ДРУГОЙ.

-- | ВОТ ТАК УЖЕ НИКТО НЕ ДЕЛАЕТ ! ! !

-- JOIN: ВСЕГО ИХ 5:
-- INNER JOIN             (ПИШУТ ПРОСТО JOIN)
-- LEFT OUTER JOIN   (ПИШУТ ПРОСТО LEFT JOIN)
-- RIGHT OUTER JOIN (ПИШУТ ПРОСТО RIGHT JOIN)
-- FULL JOIN         (ПИШУТ ПРОСТО FULL JOIN)
-- CROSS JOIN - аналогия декартового произведения

-- INNER ОТСЕКАЕТ ВСЕ, БЕЗ ВНЕШНЕГО КЛЮЧА

SELECT c.name,
       employee.first_name || ' ' || employee.last_name fio,
       ec.contact_id,
       c2.number
FROM employee
         INNER JOIN company c
                    ON employee.company_id = c.id
         JOIN employee_contact ec
              ON employee.id = ec.employee_id
         JOIN contact c2
              ON ec.contact_id = c2.id;

SELECT *
FROM employee
         CROSS JOIN company_storage.company;

--УРОК 21
------------------------------
--СОЕДИНЕНИ ТАБЛИЦ. JOIN
------------------------------

-- OUTER JOIN - ПОЛУЧИТЬ ЗАПИСИ, НА КОРОТЫЕ НИКТО НЕ ССЫЛАЕТСЯ

-- LEFT - ЗНАЧИТ ОТОБРАЗИ ВСЕ ЗАПИСИ СЛЕВА (т.е. от той что слева в коде бери все) Т.Е. И NULL (company LEFT...)

SELECT c.name, e.first_name
FROM company c
         LEFT OUTER JOIN employee e ON c.id = e.company_id;

SELECT c.name, e.first_name
FROM employee e
         LEFT OUTER JOIN company c ON c.id = e.company_id;

SELECT c.name, e.first_name
FROM employee e
         RIGHT OUTER JOIN company c
                          ON c.id = e.company_id
                              AND c.date > '2001-01-01';

SELECT c.name, e.first_name
FROM employee e
         FULL OUTER JOIN company c ON c.id = e.company_id;

--УРОК 22
------------------------------
--ГРУППИРОВКИ ЗАПРОСОВ. GROUPED BY & HAVING
------------------------------

SELECT company.name,
       count(e.id)
from company
         left join employee e
                   ON company.id = e.company_id
group by company.id
HAVING count(e.id) > 0;

--УРОК 23
------------------------------
--ОКОННЫЕ ФУНКЦИИ. WINDOW FUNCTIONS.
------------------------------

insert into employee (first_name, last_name, salary, company_id)
values ('Sam', 'Arj', 3000, 1),
       ('Tim', 'Sdr', 5000, 2),
       ('Barth', 'Terran', 3400, 2),
       ('Su', 'Calin', 4870, 3);

SELECT company.name,
SELECT company.name,
       e.first_name,
       e.salary,
       --count(*) OVER (),
       max(e.salary) OVER (PARTITION BY company.name),
       min(e.salary) OVER (PARTITION BY company.name),
       avg(e.salary) OVER (PARTITION BY company.name),
       --row_number() over ()
       --dense_rank() OVER(PARTITION BY company.name order by e.salary NULLS FIRST)
       lag(e.salary) OVER ()
FROM company
         LEFT JOIN employee e on company.id = e.company_id
ORDER BY company.name;

--УРОК 24
------------------------------
--ПРЕДСТАВЛЕНИЕ. VIEW
------------------------------

CREATE VIEW emploee_view AS
SELECT company.name,
       e.first_name,
       e.salary,
       --count(*) OVER (),
       max(e.salary) OVER (PARTITION BY company.name),
       min(e.salary) OVER (PARTITION BY company.name),
       avg(e.salary) OVER (PARTITION BY company.name),
       --row_number() over ()
       --dense_rank() OVER(PARTITION BY company.name order by e.salary NULLS FIRST)
       lag(e.salary) OVER ()
FROM company
         LEFT JOIN employee e on company.id = e.company_id
ORDER BY company.name;

DROP VIEW emploee_view;

SELECT *
FROM emploee_view
WHERE name = 'Facedook';

CREATE MATERIALIZED VIEW m_emploee_view AS
SELECT company.name,
       e.first_name,
       e.salary,
       --count(*) OVER (),
       max(e.salary) OVER (PARTITION BY company.name),
       min(e.salary) OVER (PARTITION BY company.name),
       avg(e.salary) OVER (PARTITION BY company.name),
       --row_number() over ()
       --dense_rank() OVER(PARTITION BY company.name order by e.salary NULLS FIRST)
       lag(e.salary) OVER ()
FROM company
         LEFT JOIN employee e on company.id = e.company_id
ORDER BY company.name;

SELECT *
FROM m_emploee_view;

SELECT *
FROM emploee_view;

REFRESH MATERIALIZED VIEW m_emploee_view;

--УРОК 25
------------------------------
--ИЗМЕНИНИЕ ТАБЛИЦ. ALTER
------------------------------

ALTER TABLE IF EXISTS employee
    ADD COLUMN sex INT;

ALTER TABLE employee
    ALTER COLUMN sex SET NOT NULL;

ALTER TABLE employee
    DROP COLUMN sex;

UPDATE employee
SET sex =1
WHERE id <= 5;

UPDATE company
SET name='Facebook'
WHERE name = 'Facedook'