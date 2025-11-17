-- 1. Создаем основные таблицы.
CREATE TABLE IF NOT EXISTS singers (
    singers_id INTEGER PRIMARY KEY,
    nickname VARCHAR(30) NOT NULL UNIQUE,
    biography VARCHAR(2000) NOT NULL
);

CREATE TABLE IF NOT EXISTS genries (
    genries_id INTEGER PRIMARY KEY,
    name VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS albums (
    albums_id INTEGER PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    year INTEGER NOT NULL CHECK (year >= 2000 AND year <= 2025)
);

CREATE TABLE IF NOT EXISTS collection (
    collection_id INTEGER PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    year INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS songs (
    songs_id INTEGER PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    duration INTEGER NOT NULL CHECK (duration >= 150 AND duration <= 600),
    albums_id INTEGER NOT NULL REFERENCES albums(albums_id)
);

-- 2. Создаем таблицы M-T-M.
CREATE TABLE IF NOT EXISTS singer_genries (
    singer_genries_id INTEGER PRIMARY KEY,
    singers_id INTEGER NOT NULL REFERENCES singers(singers_id),
    genries_id INTEGER NOT NULL REFERENCES genries(genries_id)
);

CREATE TABLE IF NOT EXISTS album_singers (
    album_singers_id INTEGER PRIMARY KEY,
    singers_id INTEGER NOT NULL REFERENCES singers(singers_id),
    albums_id INTEGER NOT NULL REFERENCES albums(albums_id)
);

CREATE TABLE IF NOT EXISTS collection_songs (
    collection_songs_id INTEGER PRIMARY KEY,
    collection_id INTEGER NOT NULL REFERENCES collection(collection_id),
    songs_id INTEGER NOT NULL REFERENCES songs(songs_id)
);


-- Задание № 1. Заполняем данными.
-- 1.1. Заполняем данные об исполнителях.
INSERT INTO singers (singers_id, nickname, biography) VALUES
    (1, 'Михаил Горшенев', 'Солист группы "Король и Шут".'),
    (2, 'Billie Eilish', 'Американская певица.'),
    (3, 'Ram', 'Российский репер.'),
    (4, 'Тейлор Свифт', 'Американская певица.');

-- 1.2. Заполняем данные о жанрах.
INSERT INTO genries (genries_id, name) VALUES
    (1, 'Rock'),
    (2, 'Punk'),
    (3, 'Pop'),
    (4, 'Hip-Hop');

-- 1.3. Заполняем данные об альбомах.
INSERT INTO albums (albums_id, name, year) VALUES
    (1, 'Король и Шут - Акустический', 2010),
    (2, 'When We All Fall Asleep', 2019),
    (3, 'Независимый', 2020),
    (4, '1989', 2014);

-- 1.4. Заполняем данные о треках.
INSERT INTO songs (songs_id, name, duration, albums_id) VALUES
    (1, 'Валет и дама', 210, 1),
    (2, 'Прыгну со скалы', 198, 1),
    (3, 'Bad Guy', 194, 2),
    (4, 'Bury a Friend', 183, 2),
    (5, 'Мой путь', 240, 3),
    (6, 'Город', 215, 3),
    (7, 'Shake It Off', 200, 4),
    (8, 'Blank Space', 231, 4);

-- 1.5. Заполняем данные о сборниках.
INSERT INTO collection (collection_id, name, year) VALUES
    (1, 'Русский рок', 2018),
    (2, 'Pop Mix 2019', 2019),
    (3, 'Hip-Hop 2020', 2020),
    (4, 'Top Hits 2021', 2021);

-- 1.6. Формируем связи (исполнители - жанры).
INSERT INTO singer_genries (singer_genries_id, singers_id, genries_id) VALUES
    (1, 1, 1), (2, 1, 2),  -- Михаил Горшенев: Rock, Punk
    (3, 2, 3),             -- Billie Eilish: Pop
    (4, 3, 4),             -- Ram: Hip-Hop
    (5, 4, 3);             -- Тейлор Свифт: Pop

-- 1.7. Формируем связи (исполнители - альбомы).
INSERT INTO album_singers (album_singers_id, singers_id, albums_id) VALUES
    (1, 1, 1),  -- Михаил Горшенев: Акустический
    (2, 2, 2),  -- Billie Eilish: When We All Fall Asleep
    (3, 3, 3),  -- Ram: Независимый
    (4, 4, 4);  -- Тейлор Свифт: 1989

-- 1.8. Формируем связи (жанр - песни).
INSERT INTO collection_songs (collection_songs_id, collection_id, songs_id) VALUES
    (1, 1, 1), (2, 1, 2),  -- Русский рок: Валет и дама, Прыгну со скалы
    (3, 2, 3), (4, 2, 4), (5, 2, 7),  -- Pop Mix 2019: Bad Guy, Bury a Friend, Shake It Off
    (6, 3, 5), (7, 3, 6),  -- Hip-Hop 2020: Мой путь, Город
    (8, 4, 1), (9, 4, 3), (10, 4, 5), (11, 4, 7);  -- Top Hits 2021: Валет и дама, Bad Guy, Мой путь, Shake It Off
    
    
-- 2. Блок SELECT-запросов.
-- 2.1. Вывести навание и продолжительность самого длительного трека.
SELECT name, duration 
FROM songs 
ORDER BY duration DESC 
LIMIT 1;

--2.2. Вывести название треков, продолжительность которых составляет не менее 3,5 минут.
SELECT name 
FROM songs 
WHERE duration >= 210;

-- 2.3. Вывести названия сборников, вышедших в период с 2018 по 2020 год включительно.
SELECT name 
FROM collection 
WHERE year BETWEEN 2018 AND 2020;

-- 2.4. Вывести исполнителей, чьи никнеймы состоят из одного слова.
SELECT nickname 
FROM singers 
WHERE nickname NOT LIKE '% %';

--2.5. Вывести названия треков, которые содержат слово «мой» или «my».
SELECT DISTINCT name 
FROM songs 
WHERE name LIKE '%мой%' OR name LIKE '%Мой%' OR name LIKE '%My%' OR name LIKE '%my%';

-- 3. Блок дополнительных SELECT-запросов.
-- 3.1. Вывести количество исполнителей в каждом жанре.
SELECT g.name, COUNT(sg.singers_id) 
FROM genries g 
LEFT JOIN singer_genries sg ON g.genries_id = sg.genries_id 
GROUP BY g.name;

-- 3.2. Вывести количество треков, вошедших в альбомы 2019–2020 годов.
SELECT COUNT(s.songs_id) 
FROM songs s 
JOIN albums a ON s.albums_id = a.albums_id 
WHERE a.year BETWEEN 2019 AND 2020;

-- 3.3.Вывести средняю продолжительность треков по каждому альбому.
SELECT a.name, ROUND(AVG(s.duration), 2) 
FROM albums a 
JOIN songs s ON a.albums_id = s.albums_id 
GROUP BY a.name;

-- 3.4. Вывести всех исполнителей, которые не выпустили альбомы в 2020 году.
SELECT DISTINCT si.nickname 
FROM singers si 
WHERE si.singers_id NOT IN (
    SELECT asg.singers_id 
    FROM album_singers asg 
    JOIN albums al ON asg.albums_id = al.albums_id 
    WHERE al.year = 2020
);

-- 3.5. Вывести названия сборников, в которых присутствует конкретный исполнитель:
SELECT DISTINCT c.name 
FROM collection c 
JOIN collection_songs cs ON c.collection_id = cs.collection_id 
JOIN songs s ON cs.songs_id = s.songs_id 
JOIN albums a ON s.albums_id = a.albums_id 
JOIN album_singers als ON a.albums_id = als.albums_id 
JOIN singers si ON als.singers_id = si.singers_id 
WHERE si.nickname = 'Ram';