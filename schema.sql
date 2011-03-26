DROP TABLE IF EXISTS medium CASCADE;
CREATE TABLE medium (
    id SERIAL primary key,
    asin            CHAR(10) UNIQUE,
    ISBN            VARCHAR(13),
    title           VARCHAR(255) NOT NULL,
    made_by         VARCHAR(255),
    publisher       VARCHAR(255),
    amazon_url      VARCHAR(255),
    small_image     VARCHAR(255),
    medium_image    VARCHAR(255),
    large_image     VARCHAR(255),
    language        CHAR(2),
    publish_year    SMALLINT,
    root_id         INTEGER REFERENCES medium (id) ON DELETE CASCADE,
    same_as         INTEGER REFERENCES medium (id) ON DELETE CASCADE,
    l               INTEGER NOT NULL DEFAULT(1),
    r               INTEGER NOT NULL DEFAULT(2),
    level           INTEGER NOT NULL DEFAULT(1)
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

DROP TABLE IF EXISTS user_info CASCADE;
CREATE TABLE user_info (
    id          SERIAL      PRIMARY KEY,
    login_id    INTEGER     NOT NULL REFERENCES user_login (id),
    real_name   VARCHAR(64),
    email       VARCHAR(255)
);

DROP TABLE IF EXISTS attribution CASCADE;
CREATE TABLE attribution (
    id          SERIAL          PRIMARY KEY,
    medium_id   INTEGER         NOT NULL REFERENCES medium (id),
    name        VARCHAR(64)     NOT NULL,
    url         VARCHAR(255)
);
