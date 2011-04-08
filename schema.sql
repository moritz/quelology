DROP TABLE IF EXISTS title CASCADE;
CREATE TABLE title (
    id SERIAL primary key,
    asin            CHAR(10) UNIQUE,
    title           VARCHAR(255) NOT NULL,
    author          VARCHAR(255),
    publisher       VARCHAR(255),
    lang            CHAR(2),

    -- NestedSet columns:
    root_id         INTEGER REFERENCES title (id) ON DELETE CASCADE,
    same_as         INTEGER REFERENCES title (id) ON DELETE CASCADE,
    l               INTEGER NOT NULL DEFAULT(1),
    r               INTEGER NOT NULL DEFAULT(2),
    level           INTEGER NOT NULL DEFAULT(1)
);

CREATE INDEX title_root_id_idx on title (root_id);

DROP TABLE IF EXISTS publication CASCADE;
CREATE TABLE publication (
    id                  SERIAL primary key,
    asin                CHAR(10) UNIQUE,
    isbn                VARCHAR(13),
    title               VARCHAR(255) NOT NULL,
    author              VARCHAR(255),
    publisher           VARCHAR(255),
    lang                CHAR(2),
    title_id            INTEGER REFERENCES title (id),

    amazon_url          VARCHAR(255),
    publication_date    DATE,

    small_image         VARCHAR(255),
    small_image_width   INTEGER,
    small_image_height  INTEGER,

    medium_image        VARCHAR(255),
    medium_image_width  INTEGER,
    medium_image_height INTEGER,

    large_image         VARCHAR(255),
    large_image_width   INTEGER,
    large_image_height  INTEGER

);

DROP TABLE IF EXISTS user_login CASCADE;
CREATE TABLE user_login (
    id      SERIAL      PRIMARY KEY,
    name    VARCHAR(64) UNIQUE,
    salt    BYTEA       NOT NULL,
    cost    INTEGER     NOT NULL,
    pw_hash BYTEA       NOT NULL
);

DROP TABLE IF EXISTS user_info;
CREATE TABLE user_info (
    id              SERIAL      PRIMARY KEY,
    login_id        INTEGER     NOT NULL REFERENCES user_login (id),
    real_name       VARCHAR(64),
    email           VARCHAR(255)
);

DROP TABLE IF EXISTS title_attribution;
CREATE TABLE title_attribution (
    id              SERIAL          PRIMARY KEY,
    title_id        INTEGER         NOT NULL REFERENCES title (id),
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS publication_attribution;
CREATE TABLE publication_attribution (
    id              SERIAL          PRIMARY KEY,
    publication_id  INTEGER         NOT NULL REFERENCES publication (id),
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS author CASCADE;
CREATE TABLE author (
    id              SERIAL          PRIMARY KEY,
    -- TODO: figure out if that should really be UNIQUE 
    name            VARCHAR(255)    NOT NULL UNIQUE,
    legal_name      VARCHAR(255),
    birthplace      VARCHAR(64),
    birthplace_lat  FLOAT,
    birthplace_lon  FLOAT,
    birthdate       DATE,
    deathdate       DATE
);

DROP TABLE IF EXISTS author_title_map;
CREATE TABLE author_title_map (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER NOT NULL REFERENCES author (id),
    title_id        INTEGER NOT NULL REFERENCES title  (id),
                    UNIQUE(author_id, title_id)
);

DROP TABLE IF EXISTS author_link;
CREATE TABLE author_link (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER NOT NULL REFERENCES author (id),
    type            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255)    NOT NULL
);

DROP TABLE IF EXISTS author_attribution;
CREATE TABLE author_attribution (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER         NOT NULL REFERENCES author (id),
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
