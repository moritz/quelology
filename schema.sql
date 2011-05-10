-- all DROP TABLEs need to go first, so that newly created tables
-- don't add dependencies to to-be-deleted tables
DROP TABLE IF EXISTS title CASCADE;
DROP TABLE IF EXISTS publication CASCADE;
DROP TABLE IF EXISTS raw_publication CASCADE;
DROP TABLE IF EXISTS raw_publication_attribution;
DROP TABLE IF EXISTS user_login CASCADE;
DROP TABLE IF EXISTS user_info;
DROP TABLE IF EXISTS title_attribution;
DROP TABLE IF EXISTS publication_attribution;
DROP TABLE IF EXISTS author CASCADE;
DROP TABLE IF EXISTS author_title_map;
DROP VIEW  IF EXISTS author_wiki_link_count;
DROP TABLE IF EXISTS author_link;
DROP TABLE IF EXISTS author_attribution;
DROP TABLE IF EXISTS publisher CASCADE;
DROP TABLE IF EXISTS publisher_link;

-- trigger function from
-- http://www.revsys.com/blog/2006/aug/04/automatically-updating-a-timestamp-column-in-postgresql/
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

DROP TYPE bookbinding;
CREATE TYPE bookbinding AS ENUM('paperback', 'hardcover', 'pamphlet', 'digest',
        'ebook', 'audio', 'video');

CREATE TABLE title (
    id SERIAL primary key,
    title           VARCHAR(512) NOT NULL,
    lang            CHAR(2),

    isfdb_id        INTEGER         UNIQUE,
    -- NestedSet columns:
    root_id         INTEGER REFERENCES title (id) ON DELETE CASCADE,
    same_as         INTEGER REFERENCES title (id) ON DELETE CASCADE,
    l               INTEGER NOT NULL DEFAULT(1),
    r               INTEGER NOT NULL DEFAULT(2),
    level           INTEGER NOT NULL DEFAULT(1),
    created         TIMESTAMP NOT NULL DEFAULT NOW(),
    modified        TIMESTAMP NOT NULL DEFAULT NOW()
--    CHECK(r > l)
--    CHECK((r - l) % 2 = 1)
);
CREATE TRIGGER update_title_modtime BEFORE UPDATE ON title FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE INDEX title_root_id_idx on title (root_id);

CREATE TABLE publisher (
    id              SERIAL          PRIMARY KEY,
    isfdb_id        INTEGER         UNIQUE,
    name            VARCHAR(255)    NOT NULL UNIQUE
);

CREATE TABLE publisher_link (
    id              SERIAL          PRIMARY KEY,
    publisher_id    INTEGER NOT NULL REFERENCES publisher (id) ON DELETE CASCADE,
    type            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255)    NOT NULL
);
CREATE INDEX publisher_link_publisher_id_idx ON publisher_link (publisher_id);

CREATE TABLE publication (
    id                  SERIAL primary key,
    asin                CHAR(10) UNIQUE,
    isbn                VARCHAR(13),
    title               VARCHAR(512) NOT NULL,
    -- TODO: maybe make "NOT NULL"?
    publisher_id        INTEGER REFERENCES publisher (id),
    lang                CHAR(2),
    -- cannot make NOT NULL because of how import from isfdb
    -- works. TODO: fixup later
    title_id            INTEGER REFERENCES title (id),

    amazon_url          VARCHAR(255),
    publication_date    DATE,
    binding             bookbinding,
    pages               INTEGER,

    small_image         VARCHAR(255),
    small_image_width   INTEGER,
    small_image_height  INTEGER,

    medium_image        VARCHAR(255),
    medium_image_width  INTEGER,
    medium_image_height INTEGER,

    large_image         VARCHAR(255),
    large_image_width   INTEGER,
    large_image_height  INTEGER,

    created             TIMESTAMP NOT NULL DEFAULT NOW(),
    modified            TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TRIGGER update_publication_modtime BEFORE UPDATE ON publication FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE INDEX publication_title_id_idx on publication (title_id);
CREATE INDEX publication_publisher_id_idx on publication (publisher_id);


CREATE TABLE raw_publication (
    id                  SERIAL primary key,
    asin                CHAR(10) UNIQUE,
    isbn                VARCHAR(13) UNIQUE,
    title               VARCHAR(512) NOT NULL,
    authors             VARCHAR(512),
    publisher           VARCHAR(255),
    lang                CHAR(2),

    maybe_title_id      INTEGER REFERENCES title (id) ON DELETE CASCADE,

    amazon_url          VARCHAR(255),
    publication_date    DATE,
    binding             bookbinding,
    pages               INTEGER,

    small_image         VARCHAR(255),
    small_image_width   INTEGER,
    small_image_height  INTEGER,

    medium_image        VARCHAR(255),
    medium_image_width  INTEGER,
    medium_image_height INTEGER,

    large_image         VARCHAR(255),
    large_image_width   INTEGER,
    large_image_height  INTEGER,

    created             TIMESTAMP NOT NULL DEFAULT NOW(),
    modified            TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TRIGGER update_raw_publication_modtime BEFORE UPDATE ON raw_publication FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE TABLE raw_publication_attribution (
    id              SERIAL          PRIMARY KEY,
    raw_publication_id  INTEGER         NOT NULL REFERENCES raw_publication (id) ON DELETE CASCADE,
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
CREATE INDEX raw_publication_attribution_raw_publication_id on raw_publication_attribution (raw_publication_id);

CREATE TABLE user_login (
    id      SERIAL      PRIMARY KEY,
    name    VARCHAR(64) UNIQUE,
    salt    BYTEA       NOT NULL,
    cost    INTEGER     NOT NULL,
    pw_hash BYTEA       NOT NULL,
    created             TIMESTAMP NOT NULL DEFAULT NOW(),
    modified            TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TRIGGER update_user_login_modtime BEFORE UPDATE ON user_login FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE TABLE user_info (
    id              SERIAL      PRIMARY KEY,
    login_id        INTEGER     NOT NULL REFERENCES user_login (id) ON DELETE CASCADE,
    real_name       VARCHAR(64),
    email           VARCHAR(255)
);
CREATE INDEX user_info_login_id_idx on user_info (login_id);

CREATE TABLE title_attribution (
    id              SERIAL          PRIMARY KEY,
    title_id        INTEGER         NOT NULL REFERENCES title (id) ON DELETE CASCADE,
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
CREATE INDEX title_attributioin_title_id on title_attribution (title_id);

CREATE TABLE publication_attribution (
    id              SERIAL          PRIMARY KEY,
    publication_id  INTEGER         NOT NULL REFERENCES publication (id) ON DELETE CASCADE,
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
CREATE INDEX publication_attribution_publication_id on publication_attribution (publication_id);

CREATE TABLE author (
    id              SERIAL          PRIMARY KEY,
    -- for import from isfdb.org
    isfdb_id        INTEGER         UNIQUE,
    -- TODO: figure out if that should really be UNIQUE 
    name            VARCHAR(255)    NOT NULL UNIQUE,
    legal_name      VARCHAR(255),
    birthplace      VARCHAR(64),
    birthplace_lat  FLOAT,
    birthplace_lon  FLOAT,
    birthdate       DATE,
    deathdate       DATE,
    created         TIMESTAMP NOT NULL DEFAULT NOW(),
    modified        TIMESTAMP NOT NULL DEFAULT NOW()
);
CREATE TRIGGER update_author_modtime BEFORE UPDATE ON author FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE TABLE author_title_map (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER NOT NULL REFERENCES author (id) ON DELETE CASCADE,
    title_id        INTEGER NOT NULL REFERENCES title  (id) ON DELETE CASCADE,
                    UNIQUE(author_id, title_id)
);

CREATE TABLE author_link (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER NOT NULL REFERENCES author (id) ON DELETE CASCADE,
    type            VARCHAR(64)     NOT NULL,
    url             VARCHAR(512)    NOT NULL,
    lang            CHAR(2),
    UNIQUE(author_id, url)
);
CREATE INDEX author_link_author_id_idx ON author_link (author_id);

-- just a gimmick for useless statistics
CREATE OR REPLACE VIEW author_wiki_link_count ( author_id, link_count )
AS  SELECT   author_id, count(author_id)
    FROM     author_link
    WHERE    type = 'wikipedia'
    GROUP BY author_id
    ;

CREATE TABLE author_attribution (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER         NOT NULL REFERENCES author (id) ON DELETE CASCADE,
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
CREATE INDEX author_attribution_author_id on author_attribution (author_id);

