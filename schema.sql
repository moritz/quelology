DROP TABLE IF EXISTS medium CASCADE;
CREATE TABLE medium (
    id SERIAL primary key,
    asin CHAR(10) unique,
    ISBN VARCHAR(13),
    title VARCHAR(255),
    made_by VARCHAR(255),
    publisher VARCHAR(255),
    amazon_url VARCHAR(255),
    small_image VARCHAR(255),
    medium_image VARCHAR(255),
    large_image VARCHAR(255),
    publish_year SMALLINT
);

DROP TABLE IF EXISTS medium_link;
CREATE TABLE medium_link (
    id BIGSERIAL primary key,
    first  INTEGER NOT NULL REFERENCES medium (id) ON DELETE CASCADE,
    second INTEGER NOT NULL REFERENCES medium (id) ON DELETE CASCADE,
    link_type VARCHAR(20),
    UNIQUE(first, second)
);

