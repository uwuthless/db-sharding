--
--
--


-- Удаляем базу данных если она есть
DROP DATABASE IF EXISTS payments;

-- И создаём её заново
CREATE DATABASE payments;

-- Установка базы данных по умолчанию
\c payments;

CREATE SEQUENCE hibernate_sequence START 1;

CREATE TABLE PAYMENT
(
    ID       bigint,
    SENDER   bigint   NOT NULL,
    RECEIVER bigint   NOT NULL,
    PRICE    bigint   NOT NULL,
    PRIMARY KEY (ID)
);

