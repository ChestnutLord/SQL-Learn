CREATE DATABASE flight_repository;

CREATE TABLE airport
(
    code    CHAR(3) PRIMARY KEY,
    country VARCHAR(256) NOT NULL,
    CITY    VARCHAR(128) NOT NULL
);

CREATE TABLE aircraft
(
    id    SERIAL PRIMARY KEY,
    model VARCHAR NOT NULL
);

CREATE TABLE seat
(
    aircraft_id INT REFERENCES aircraft (id),
    seat_no     VARCHAR(4) NOT NULL,
    PRIMARY KEY (aircraft_id, seat_no)
);

CREATE TABLE flight
(
    id                     BIGSERIAL PRIMARY KEY,
    flight_no              VARCHAR(16)                       NOT NULL,
    departure_date         timestamp                         NOT NULL,
    departure_airport_code CHAR(3) REFERENCES airport (code) NOT NULL,
    arrival_date           timestamp                         NOT NULL,
    arrival_airport_code   CHAR(3) REFERENCES airport (code) NOT NULL,
    aircraft_id            INT REFERENCES aircraft (id)      NOT NULL,
    status                 VARCHAR(32)                       NOT NULL
);

CREATE TABLE ticket
(
    id             BIGSERIAL PRIMARY KEY,
    passenger_no   VARCHAR(32)                   NOT NULL,
    passenger_name VARCHAR(128)                  NOT NULL,
    flight_id      BIGINT REFERENCES flight (id) NOT NULL,
    seat_no        VARCHAR(4)                    NOT NULL,
    cost           NUMERIC(8, 2)                 NOT NULL
);


insert into airport (code, country, city)
values ('MNK', 'Беларусь', 'Минск'),
       ('LDN', 'Англия', 'Лондон'),
       ('MЅК', 'Россия', 'Москва'),
       ('BSL', 'Испания', 'Барселона');

UPDATE airport
SET code='MSK'
where code = 'MЅК';

insert into aircraft (model)
values ('Боинг 777-300'),
       ('Боинг 737-300'),
       ('Аэробус А320-200'),
       ('Суперджет-100');


insert into seat (aircraft_id, seat_no)
select id, s.column1
from aircraft
         cross join (values ('A1'), ('A2'), ('B1'), ('B2'), ('C1'), ('C2'), ('D1'), ('D2') order by 1) s;


insert into flight (flight_no, departure_date, departure_airport_code, arrival_date, arrival_airport_code,
                    aircraft_id, status)
values ('MN3082', '2028-06-14T14:30', 'MNK', '2020-06-14T18:07', 'LDN', 1, 'ARRIVED')
     , ('MN3882', '2028-06-16T09:15', 'LDN', '2020-06-16T13:00', 'MNK', 1, 'ARRIVED')
     , ('BC2801', '2020-07-28T23:25', 'MNK', '2020-07-29T02:43', 'LDN', 2, 'ARRIVED')
     , ('BC2881', '2828-08-01T11:00', 'LDN', '2020-08-01T14:15', 'MNK', 2, 'DEPARTED')
     , ('TR3103', '2020-05-03T13:10', 'MSK', '2020-05-03T18:38', 'BSL', 3, 'ARRIVED')
     , ('TR3103', '2020-05-10T07:15', 'BSL', '2020-05-10T012:44', 'MSK', 3, 'CANCELLED')
     , ('CV9827', '2020-09-09T18:00', 'MNK', '2020-09-09T19:15', 'MSK', 4, 'SCHEDULED')
     , ('CV9827', '2828-09-19T08:55', 'MSK', '2020-09-19T18:05', 'MNK', 4, 'SCHEDULED')
     , ('QS8712', '2828-12-18T03:35', 'MNK', '2828-12-18T06:46', 'LDN', 2, 'ARRIVED');

DROP table flight;
drop table ticket;


insert into ticket (passenger_no, passenger_name, flight_id, seat_no, cost)
values ('112233', 'Иван Иванов', 1, 'A1', 200),
       ('23234А', 'Петр Петров', 1, 'B1', 180),
       ('ЅЅ9880', 'Светлана Светикова', 1, 'B2', 175),
       ('QYASDE', 'Aндрей Андреев', 1, 'C2', 175),
       ('Р00234', 'Иван Кожемякин', 1, 'D1', 160),
       ('898123', 'Олег Рубцов', 1, 'A2', 198),
       ('555321', 'Екатерина Петренко', 2, 'A1', 250),
       ('002300', 'Иван Розмаринов', 2, 'B2', 225),
       ('988310', 'Иван Кожемякин', 2, 'C1', 217),
       ('123U12', 'Aндрей буйнов', 2, 'C2', 227),
       ('ЅЅ988D', 'Светлана Светикова', 2, 'D2', 277),
       ('ЕЕ2344', 'Дмитрий Трусцов', 3, 'A1', 300),
       ('AS23PP', 'Максим Комсомольцев', 3, 'A2', 285),
       ('322349', 'Эдуард Щеглов', 3, 'B1', 99),
       ('DL123S', 'Игорь Беркутов', 3, 'B2', 199),
       ('МVМ111', 'Алексей Щербин', 3, 'C1', 299),
       ('zzz111', 'Денис Колобков', 3, 'C2', 230),
       ('234444', 'Иван Старовойтов', 3, 'D1', 180),
       ('LLLL12', 'Людмила Старовойтова', 3, 'D2', 224),
       ('RT34TR', 'Cтепан Дор', 4, 'A1', 129),
       ('999666', 'Анастасия Шепелева', 4, 'A2', 152),
       ('234444', 'Иван Старовойтов', 4, 'B1', 140),
       ('12', 'Людмила Старовойтова', 4, 'B2', 140),
       (' 12', 'Роман Дронов', 4, 'D2', 109),
       ('112233', 'Иван Иванов', 5, 'C2', 170),
       ('NMNB 2', 'Лариса Тельникова', 5, 'C1', 185),
       ('DЅА586', 'Лариса Привольная', 5, 'A1', 204),
       ('DSA583', 'Артур Мирный', 5, 'B1', 189),
       ('DЅА581', 'Евгений Кудрявцев', 6, 'A1', 204),
       ('ЕЕ2344', 'Дмитрий Трусцов', 6, 'A2', 214),
       ('AS23PP', 'Максим Комсомольцев', 6, 'B2', 176),
       ('112233', 'Иван Иванов', 6, 'B1', 135),
       ('309623', 'Татьяна Крот', 6, 'С1', 155),
       ('319623', 'Юрий Дувинков', 6, 'D1', 125),
       ('322349 ', 'Здуард Щеглов', 7, 'A1', 69),
       ('DIOPSL', 'Евгений Безфамильная', 7, 'A2', 58),
       ('DIOPS2', 'Юлия Швец', 7, 'D2', 65),
       ('110PS2', 'Ник Говриленко', 7, 'C2', 73),
       ('999666', ' Анастасия Шепелева', 7, 'B1', 66),
       ('23234А', 'Петр Петров', 7, 'C1', 80),
       ('OYASDE', 'Андрей Андреев ', 8, ' A1 ', 100),
       ('10202', 'Лариса Потемнкина', 8, 'A2', 89),
       ('500702', 'Карл Хмелев', 8, 'B2', 79),
       ('2QAZD2', 'Жанна Хмелева', 8, 'C2', 77),
       ('BMXND1', 'Светлана Хмурая', 8, 'B2', 94),
       ('ВМХ 2', 'Кирилл Сарычев', 8, 'D1', 81),
       ('SS988D', 'Светлана Светикова', 9, 'A2', 222),
       ('SS978D', 'Андрей Желудь', 9, 'A1', 198),
       ('SS968D', 'Дмитрий Воснецов', 9, 'B1', 243),
       ('ЅЅ9580', 'Максим Гребцов', 9, 'C1', 251),
       ('112233', 'Иван Иванов', 9, 'C2', 135),
       ('NMNBV2', 'Лариса Тельникова', 9, 'B2', 217),
       ('23234A', 'Петр Петров', 9, 'D1', 189),
       ('123951', 'Полина Зверева', 9, 'D2', 234);
--------------------------------------------------------------

SELECT *
FROM flight
WHERE flight_no = 'MN3082';

SELECT *
FROM flight f
         JOIN ticket t ON f.id = t.flight_id
    AND departure_airport_code = 'MNK'
    AND arrival_airport_code = 'LDN'
    AND t.seat_no = 'B1'
    AND departure_date::date > (now() - interval '1 years')::date;


-- сколько мест осталось свободными на рейсе MN3082

SELECT s.count - f.count free
from (SELECT aircraft_id, count(*)
      FROM ticket t
               JOIN flight f on t.flight_id = f.id
      WHERE f.flight_no = 'MN3082'
        AND f.departure_date::date = '2020-06-14'
      GROUP BY aircraft_id) f
         JOIN
     (SELECT aircraft_id, count(*)
      FROM seat
      GROUP BY aircraft_id) s
     ON f.aircraft_id = s.aircraft_id

-- каакие 2 перелёта были самые длительные за всё время

SELECT id,
       departure_date,
       arrival_date,
       arrival_date - flight.departure_date result
FROM flight
order by (arrival_date - flight.departure_date) DESC

SELECT departure_airport_code || '-' || arrival_airport_code fin,
       count(*),
       max(arrival_date - flight.departure_date),
       min(arrival_date - flight.departure_date)
FROM flight
WHERE departure_airport_code = 'MNK'
  AND arrival_airport_code = 'LDN'
GROUP BY departure_airport_code || '-' || arrival_airport_code;

SELECT t.passenger_name,
       count(*),
       100 * count(*) / (select count(*) from ticket)
FROM ticket t
GROUP BY t.passenger_name
ORDER BY 2 DESC;

-- ВЫВЕСТИ ИЕНА ПАССАЖИРОВ, СКОЛЬКО КАЖДЫЙ ИЗ НИХ КУПИЛ БИЛЕТОВ, РАЗНИЦА С MAX КУПИВШИМ

SELECT passenger_name,
       count(*)                           tiskets,
       (max(count(*)) OVER ()) - count(*) result
FROM ticket
GROUP BY passenger_name
ORDER BY count(*) DESC;

SELECT f.id,
       sum(t.cost),
       COALESCE(lead(sum(t.cost)) over (order by sum(t.cost) ), sum(t.cost)) - sum(t.cost)
FROM ticket t
         JOIN flight f on t.flight_id = f.id
GROUP BY f.id
ORDER BY 2;

CREATE TABLE test1
(
    id      SERIAL PRIMARY KEY,
    number1 INT         NOT NULL,
    number2 INT         NOT NULL,
    value   VARCHAR(32) NOT NULL
);

DROP TABLE test1;

CREATE INDEX test_1_number_1_idx ON test1 (number1);
CREATE INDEX test_1_number_2_idx ON test1 (number2);

INSERT INTO test1 (number1, number2, value)
SELECT random() * generate_series,
       random() * generate_series,
       generate_series
FROM generate_series(1, 100000);

SELECT relname,
       reltuples,
       relkind,
       relpages
FROM pg_class
WHERE relname like 'test_1%';

EXPLAIN ANALYZE
SELECT *
from test1
WHERE number1 < 1000;

CREATE TABLE test2
(
    id        SERIAL PRIMARY KEY,
    test_1_id INT REFERENCES test1,
    number1   INT         NOT NULL,
    number2   INT         NOT NULL,
    value     VARCHAR(32) NOT NULL
);

INSERT INTO test2 (test_1_id, number1, number2, value)
SELECT id,
       random() * number1,
       random() * number2,
       value
FROM test1;


CREATE INDEX test_2_number_1_idx ON test2 (number1);
CREATE INDEX test_2_number_2_idx ON test2 (number2);
CREATE INDEX test_2_test1_id_idx ON test2 (test_1_id);


EXPLAIN ANALYZE
SELECT *
FROM test1
         join (SELECT * FROM test2 ORDER BY test_1_id) t2
             on test1.id = t2.test_1_id;

ANALYZE test2;

CREATE TABLE audit
(
    id INT,
    name TEXT,
    date TIMESTAMP
);

CREATE FUNCTION audit_function() returns trigger
language plpgsql
AS
    $$
    begin
    INSERT INTO audit (id, name, date)
    values (new.id,tg_table_name, now());
    return null;
    end
    $$;

CREATE TRIGGER audit_aircraft_trigger
    AFTER UPDATE OR DELETE OR INSERT
    on aircraft
    FOR EACH ROW
    EXECUTE FUNCTION audit_function();

INSERT INTO aircraft (model)
values ('новая модель');

