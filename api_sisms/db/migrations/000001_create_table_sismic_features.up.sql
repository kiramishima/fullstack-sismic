CREATE TABLE IF NOT EXISTS features (
    id BIGSERIAL NOT NULL PRIMARY KEY ,
    external_id VARCHAR(20) NOT NULL UNIQUE,
    mag FLOAT NOT NULL CHECK(mag BETWEEN -1.0 AND 10.0),
    place VARCHAR(150) NOT NULL,
    time VARCHAR(20),
    url VARCHAR(200) NOT NULL,
    tsunami SMALLINT NOT NULL,
    mag_type VARCHAR(10) NOT NULL,
    title VARCHAR(100) NOT NULL,
    latitude FLOAT NOT NULL CHECK(latitude BETWEEN -90.0 AND 90.0),
    longitude FLOAT NOT NULL CHECK(longitude BETWEEN -180.0 AND 180.0)
);