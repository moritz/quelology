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
    same_as INTEGER REFERENCES medium (id) ON DELETE CASCADE,
    l INTEGER NOT NULL DEFAULT(1),
    r INTEGER NOT NULL DEFAULT(2),
    level INTEGER NOT NULL DEFAULT(0)
);

CREATE INDEX medium_root_id_idx on medium (root_id);

DROP TABLE IF EXISTS user_login CASCADE;
CREATE TABLE user_login (
    id      SERIAL      PRIMARY KEY,
    name    VARCHAR(64) UNIQUE,
    salt    BYTEA       NOT NULL,
    cost    INTEGER     NOT NULL,
    pw_hash BYTEA       NOT NULL
);
