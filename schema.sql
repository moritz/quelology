-- trigger function from
-- http://www.revsys.com/blog/2006/aug/04/automatically-updating-a-timestamp-column-in-postgresql/
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$ language 'plpgsql';


DROP TABLE IF EXISTS title CASCADE;
CREATE TABLE title (
    id SERIAL primary key,
    title           VARCHAR(255) NOT NULL,
    lang            CHAR(2),

    isfdb_id        INTEGER         UNIQUE,
    -- NestedSet columns:
    root_id         INTEGER REFERENCES title (id) ON DELETE CASCADE,
    same_as         INTEGER REFERENCES title (id) ON DELETE CASCADE,
    l               INTEGER NOT NULL DEFAULT(1),
    r               INTEGER NOT NULL DEFAULT(2),
    level           INTEGER NOT NULL DEFAULT(1),
    created         TIMESTAMP NOT NULL DEFAULT NOW(),
    modified        TIMESTAMP NOT NULL DEFAULT NOW(),
    CHECK(r > l),
    CHECK((r - l) % 2 = 1)
);
CREATE TRIGGER update_title_modtime BEFORE UPDATE ON title FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE INDEX title_root_id_idx on title (root_id);

DROP TABLE IF EXISTS publication CASCADE;
CREATE TABLE publication (
    id                  SERIAL primary key,
    asin                CHAR(10) UNIQUE,
    isbn                VARCHAR(13),
    title               VARCHAR(255) NOT NULL,
    -- TODO: maybe make "NOT NULL"?
    publisher_id        INTEGER REFERENCES publisher (id),
    lang                CHAR(2),
    title_id            INTEGER NOT NULL REFERENCES title (id),

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
    large_image_height  INTEGER,

    created             TIMESTAMP NOT NULL DEFAULT NOW(),
    modified            TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TRIGGER update_publication_modtime BEFORE UPDATE ON publication FOR EACH ROW EXECUTE PROCEDURE update_modified_column();

CREATE INDEX publication_title_id_idx on publication (title_id);
CREATE INDEX publication_publisher_id_idx on publication (publisher_id);

DROP TABLE IF EXISTS user_login CASCADE;
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

DROP TABLE IF EXISTS user_info;
CREATE TABLE user_info (
    id              SERIAL      PRIMARY KEY,
    login_id        INTEGER     NOT NULL REFERENCES user_login (id) ON DELETE CASCADE,
    real_name       VARCHAR(64),
    email           VARCHAR(255)
);
CREATE INDEX user_info_login_id_idx on user_info (login_id);

DROP TABLE IF EXISTS title_attribution;
CREATE TABLE title_attribution (
    id              SERIAL          PRIMARY KEY,
    title_id        INTEGER         NOT NULL REFERENCES title (id) ON DELETE CASCADE,
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
CREATE INDEX title_attributioin_title_id on title_attribution (title_id);

DROP TABLE IF EXISTS publication_attribution;
CREATE TABLE publication_attribution (
    id              SERIAL          PRIMARY KEY,
    publication_id  INTEGER         NOT NULL REFERENCES publication (id) ON DELETE CASCADE,
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
CREATE INDEX publication_attribution_publication_id on publication_attribution (publication_id);

DROP TABLE IF EXISTS author CASCADE;
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

DROP TABLE IF EXISTS author_title_map;
CREATE TABLE author_title_map (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER NOT NULL REFERENCES author (id) ON DELETE CASCADE,
    title_id        INTEGER NOT NULL REFERENCES title  (id) ON DELETE CASCADE,
                    UNIQUE(author_id, title_id)
);

DROP TABLE IF EXISTS author_link;
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

DROP TABLE IF EXISTS author_attribution;
CREATE TABLE author_attribution (
    id              SERIAL          PRIMARY KEY,
    author_id       INTEGER         NOT NULL REFERENCES author (id) ON DELETE CASCADE,
    name            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255),
    retrieved       DATE            DEFAULT CURRENT_DATE
);
CREATE INDEX author_attribution_author_id on author_attribution (author_id);

DROP TABLE IF EXISTS publisher CASCADE;
CREATE TABLE publisher (
    id              SERIAL          PRIMARY KEY,
    isfdb_id        INTEGER         UNIQUE,
    name            VARCHAR(255)    NOT NULL UNIQUE
);

DROP TABLE IF EXISTS publisher_link;
CREATE TABLE publisher_link (
    id              SERIAL          PRIMARY KEY,
    publisher_id    INTEGER NOT NULL REFERENCES publisher (id) ON DELETE CASCADE,
    type            VARCHAR(64)     NOT NULL,
    url             VARCHAR(255)    NOT NULL
);
CREATE INDEX publisher_link_publisher_id_idx ON publisher_link (publisher_id);
