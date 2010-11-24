DROP TABLE IF EXISTS medium CASCADE;
CREATE TABLE medium (
    id SERIAL primary key,
    asin CHAR(10) UNIQUE,
    ISBN VARCHAR(13),
    title VARCHAR(255) NOT NULL,
    made_by VARCHAR(255),
    publisher VARCHAR(255),
    amazon_url VARCHAR(255),
    small_image VARCHAR(255),
    medium_image VARCHAR(255),
    large_image VARCHAR(255),
    publish_year SMALLINT,
    root_id INTEGER REFERENCES medium (id) ON DELETE CASCADE,
    l INTEGER,
    r INTEGER,
    level INTEGER
);
