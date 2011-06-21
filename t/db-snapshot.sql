--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

ALTER TABLE ONLY public.user_info DROP CONSTRAINT user_info_login_id_fkey;
ALTER TABLE ONLY public.title DROP CONSTRAINT title_same_as_fkey;
ALTER TABLE ONLY public.title DROP CONSTRAINT title_root_id_fkey;
ALTER TABLE ONLY public.title_link DROP CONSTRAINT title_link_title_id_fkey;
ALTER TABLE ONLY public.title_attribution DROP CONSTRAINT title_attribution_title_id_fkey;
ALTER TABLE ONLY public.raw_publication DROP CONSTRAINT raw_publication_maybe_title_id_fkey;
ALTER TABLE ONLY public.raw_publication_attribution DROP CONSTRAINT raw_publication_attribution_raw_publication_id_fkey;
ALTER TABLE ONLY public.publisher_link DROP CONSTRAINT publisher_link_publisher_id_fkey;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_title_id_fkey;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_publisher_id_fkey;
ALTER TABLE ONLY public.publication_attribution DROP CONSTRAINT publication_attribution_publication_id_fkey;
ALTER TABLE ONLY public.author_title_map DROP CONSTRAINT author_title_map_title_id_fkey;
ALTER TABLE ONLY public.author_title_map DROP CONSTRAINT author_title_map_author_id_fkey;
ALTER TABLE ONLY public.author_link DROP CONSTRAINT author_link_author_id_fkey;
ALTER TABLE ONLY public.author_attribution DROP CONSTRAINT author_attribution_author_id_fkey;
DROP TRIGGER update_user_login_modtime ON public.user_login;
DROP TRIGGER update_title_modtime ON public.title;
DROP TRIGGER update_raw_publication_modtime ON public.raw_publication;
DROP TRIGGER update_publication_modtime ON public.publication;
DROP TRIGGER update_author_modtime ON public.author;
DROP INDEX public.user_info_login_id_idx;
DROP INDEX public.title_root_id_idx;
DROP INDEX public.title_link_title_id_idx;
DROP INDEX public.title_attributioin_title_id;
DROP INDEX public.raw_publication_attribution_raw_publication_id;
DROP INDEX public.publisher_link_publisher_id_idx;
DROP INDEX public.publication_title_id_idx;
DROP INDEX public.publication_publisher_id_idx;
DROP INDEX public.publication_attribution_publication_id;
DROP INDEX public.author_link_author_id_idx;
DROP INDEX public.author_attribution_author_id;
ALTER TABLE ONLY public.user_login DROP CONSTRAINT user_login_pkey;
ALTER TABLE ONLY public.user_login DROP CONSTRAINT user_login_name_key;
ALTER TABLE ONLY public.user_info DROP CONSTRAINT user_info_pkey;
ALTER TABLE ONLY public.user_auth DROP CONSTRAINT user_auth_pkey;
ALTER TABLE ONLY public.user_auth DROP CONSTRAINT user_auth_name_key;
ALTER TABLE ONLY public.title DROP CONSTRAINT title_same_as_key;
ALTER TABLE ONLY public.title DROP CONSTRAINT title_pkey;
ALTER TABLE ONLY public.title_link DROP CONSTRAINT title_link_title_id_key;
ALTER TABLE ONLY public.title_link DROP CONSTRAINT title_link_pkey;
ALTER TABLE ONLY public.title DROP CONSTRAINT title_isfdb_id_key;
ALTER TABLE ONLY public.title_attribution DROP CONSTRAINT title_attribution_pkey;
ALTER TABLE ONLY public.raw_publication DROP CONSTRAINT raw_publication_pkey;
ALTER TABLE ONLY public.raw_publication DROP CONSTRAINT raw_publication_libris_id_key;
ALTER TABLE ONLY public.raw_publication DROP CONSTRAINT raw_publication_isbn_key;
ALTER TABLE ONLY public.raw_publication_attribution DROP CONSTRAINT raw_publication_attribution_pkey;
ALTER TABLE ONLY public.raw_publication DROP CONSTRAINT raw_publication_asin_key;
ALTER TABLE ONLY public.publisher DROP CONSTRAINT publisher_pkey;
ALTER TABLE ONLY public.publisher DROP CONSTRAINT publisher_name_key;
ALTER TABLE ONLY public.publisher_link DROP CONSTRAINT publisher_link_pkey;
ALTER TABLE ONLY public.publisher DROP CONSTRAINT publisher_isfdb_id_key;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_pkey;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_libris_id_key;
ALTER TABLE ONLY public.publication_attribution DROP CONSTRAINT publication_attribution_pkey;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_asin_key;
ALTER TABLE ONLY public.login DROP CONSTRAINT login_pkey;
ALTER TABLE ONLY public.login DROP CONSTRAINT login_name_key;
ALTER TABLE ONLY public.author_title_map DROP CONSTRAINT author_title_map_pkey;
ALTER TABLE ONLY public.author_title_map DROP CONSTRAINT author_title_map_author_id_key;
ALTER TABLE ONLY public.author DROP CONSTRAINT author_pkey;
ALTER TABLE ONLY public.author DROP CONSTRAINT author_name_key;
ALTER TABLE ONLY public.author_link DROP CONSTRAINT author_link_pkey;
ALTER TABLE ONLY public.author_link DROP CONSTRAINT author_link_author_id_key;
ALTER TABLE ONLY public.author DROP CONSTRAINT author_libris_id_key;
ALTER TABLE ONLY public.author DROP CONSTRAINT author_isfdb_id_key;
ALTER TABLE ONLY public.author_attribution DROP CONSTRAINT author_attribution_pkey;
ALTER TABLE public.user_login ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_info ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_auth ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.title_link ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.title_attribution ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.title ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.raw_publication_attribution ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.raw_publication ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.publisher_link ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.publisher ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.publication_attribution ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.publication ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.login ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.author_title_map ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.author_link ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.author_attribution ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.author ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.user_login_id_seq;
DROP TABLE public.user_login;
DROP SEQUENCE public.user_info_id_seq;
DROP TABLE public.user_info;
DROP SEQUENCE public.user_auth_id_seq;
DROP TABLE public.user_auth;
DROP SEQUENCE public.title_link_id_seq;
DROP TABLE public.title_link;
DROP SEQUENCE public.title_id_seq;
DROP SEQUENCE public.title_attribution_id_seq;
DROP TABLE public.title_attribution;
DROP TABLE public.title;
DROP SEQUENCE public.raw_publication_id_seq;
DROP SEQUENCE public.raw_publication_attribution_id_seq;
DROP TABLE public.raw_publication_attribution;
DROP TABLE public.raw_publication;
DROP SEQUENCE public.publisher_link_id_seq;
DROP TABLE public.publisher_link;
DROP SEQUENCE public.publisher_id_seq;
DROP TABLE public.publisher;
DROP SEQUENCE public.publication_id_seq;
DROP SEQUENCE public.publication_attribution_id_seq;
DROP TABLE public.publication_attribution;
DROP TABLE public.publication;
DROP SEQUENCE public.login_id_seq;
DROP TABLE public.login;
DROP VIEW public.author_wiki_link_count;
DROP SEQUENCE public.author_title_map_id_seq;
DROP TABLE public.author_title_map;
DROP SEQUENCE public.author_link_id_seq;
DROP TABLE public.author_link;
DROP SEQUENCE public.author_id_seq;
DROP SEQUENCE public.author_attribution_id_seq;
DROP TABLE public.author_attribution;
DROP TABLE public.author;
DROP FUNCTION public.update_modified_column();
DROP TYPE public.bookbinding;
DROP PROCEDURAL LANGUAGE plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: bookbinding; Type: TYPE; Schema: public; Owner: quelology-dev
--

CREATE TYPE bookbinding AS ENUM (
    'paperback',
    'hardcover',
    'pamphlet',
    'digest',
    'ebook',
    'audio',
    'video'
);


ALTER TYPE public.bookbinding OWNER TO "quelology-dev";

--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: quelology-dev
--

CREATE FUNCTION update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.modified = now();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO "quelology-dev";

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: author; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE author (
    id integer NOT NULL,
    isfdb_id integer,
    libris_id character varying(24),
    name character varying(255) NOT NULL,
    legal_name character varying(255),
    birthplace character varying(64),
    birthplace_lat double precision,
    birthplace_lon double precision,
    birthdate date,
    deathdate date,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.author OWNER TO "quelology-dev";

--
-- Name: author_attribution; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE author_attribution (
    id integer NOT NULL,
    author_id integer NOT NULL,
    name character varying(64) NOT NULL,
    url character varying(255),
    retrieved date DEFAULT ('now'::text)::date
);


ALTER TABLE public.author_attribution OWNER TO "quelology-dev";

--
-- Name: author_attribution_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE author_attribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.author_attribution_id_seq OWNER TO "quelology-dev";

--
-- Name: author_attribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE author_attribution_id_seq OWNED BY author_attribution.id;


--
-- Name: author_attribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('author_attribution_id_seq', 1, false);


--
-- Name: author_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE author_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.author_id_seq OWNER TO "quelology-dev";

--
-- Name: author_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE author_id_seq OWNED BY author.id;


--
-- Name: author_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('author_id_seq', 1, false);


--
-- Name: author_link; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE author_link (
    id integer NOT NULL,
    author_id integer NOT NULL,
    type character varying(64) NOT NULL,
    url character varying(512) NOT NULL,
    lang character(2)
);


ALTER TABLE public.author_link OWNER TO "quelology-dev";

--
-- Name: author_link_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE author_link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.author_link_id_seq OWNER TO "quelology-dev";

--
-- Name: author_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE author_link_id_seq OWNED BY author_link.id;


--
-- Name: author_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('author_link_id_seq', 1, false);


--
-- Name: author_title_map; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE author_title_map (
    id integer NOT NULL,
    author_id integer NOT NULL,
    title_id integer NOT NULL
);


ALTER TABLE public.author_title_map OWNER TO "quelology-dev";

--
-- Name: author_title_map_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE author_title_map_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.author_title_map_id_seq OWNER TO "quelology-dev";

--
-- Name: author_title_map_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE author_title_map_id_seq OWNED BY author_title_map.id;


--
-- Name: author_title_map_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('author_title_map_id_seq', 1, false);


--
-- Name: author_wiki_link_count; Type: VIEW; Schema: public; Owner: quelology-dev
--

CREATE VIEW author_wiki_link_count AS
    SELECT author_link.author_id, count(author_link.author_id) AS link_count FROM author_link WHERE ((author_link.type)::text = 'wikipedia'::text) GROUP BY author_link.author_id;


ALTER TABLE public.author_wiki_link_count OWNER TO "quelology-dev";

--
-- Name: login; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE login (
    id integer NOT NULL,
    name character varying(64),
    salt bytea NOT NULL,
    cost integer NOT NULL,
    pw_hash bytea NOT NULL
);


ALTER TABLE public.login OWNER TO "quelology-dev";

--
-- Name: login_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.login_id_seq OWNER TO "quelology-dev";

--
-- Name: login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE login_id_seq OWNED BY login.id;


--
-- Name: login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('login_id_seq', 1, false);


--
-- Name: publication; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE publication (
    id integer NOT NULL,
    asin character(10),
    isbn character varying(13),
    libris_id character varying(24),
    title character varying(512) NOT NULL,
    publisher_id integer,
    lang character(2),
    title_id integer,
    amazon_url character varying(255),
    publication_date date,
    binding bookbinding,
    pages integer,
    small_image character varying(255),
    small_image_width integer,
    small_image_height integer,
    medium_image character varying(255),
    medium_image_width integer,
    medium_image_height integer,
    large_image character varying(255),
    large_image_width integer,
    large_image_height integer,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.publication OWNER TO "quelology-dev";

--
-- Name: publication_attribution; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE publication_attribution (
    id integer NOT NULL,
    publication_id integer NOT NULL,
    name character varying(64) NOT NULL,
    url character varying(255),
    retrieved date DEFAULT ('now'::text)::date
);


ALTER TABLE public.publication_attribution OWNER TO "quelology-dev";

--
-- Name: publication_attribution_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE publication_attribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.publication_attribution_id_seq OWNER TO "quelology-dev";

--
-- Name: publication_attribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE publication_attribution_id_seq OWNED BY publication_attribution.id;


--
-- Name: publication_attribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('publication_attribution_id_seq', 1, false);


--
-- Name: publication_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE publication_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.publication_id_seq OWNER TO "quelology-dev";

--
-- Name: publication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE publication_id_seq OWNED BY publication.id;


--
-- Name: publication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('publication_id_seq', 1, false);


--
-- Name: publisher; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE publisher (
    id integer NOT NULL,
    isfdb_id integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.publisher OWNER TO "quelology-dev";

--
-- Name: publisher_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE publisher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.publisher_id_seq OWNER TO "quelology-dev";

--
-- Name: publisher_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE publisher_id_seq OWNED BY publisher.id;


--
-- Name: publisher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('publisher_id_seq', 1, false);


--
-- Name: publisher_link; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE publisher_link (
    id integer NOT NULL,
    publisher_id integer NOT NULL,
    type character varying(64) NOT NULL,
    url character varying(255) NOT NULL
);


ALTER TABLE public.publisher_link OWNER TO "quelology-dev";

--
-- Name: publisher_link_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE publisher_link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.publisher_link_id_seq OWNER TO "quelology-dev";

--
-- Name: publisher_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE publisher_link_id_seq OWNED BY publisher_link.id;


--
-- Name: publisher_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('publisher_link_id_seq', 1, false);


--
-- Name: raw_publication; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE raw_publication (
    id integer NOT NULL,
    asin character(10),
    libris_id character varying(24),
    isbn character varying(13),
    title character varying(512) NOT NULL,
    authors character varying(512),
    publisher character varying(255),
    lang character(2),
    maybe_title_id integer,
    amazon_url character varying(255),
    publication_date date,
    binding bookbinding,
    pages integer,
    small_image character varying(255),
    small_image_width integer,
    small_image_height integer,
    medium_image character varying(255),
    medium_image_width integer,
    medium_image_height integer,
    large_image character varying(255),
    large_image_width integer,
    large_image_height integer,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.raw_publication OWNER TO "quelology-dev";

--
-- Name: raw_publication_attribution; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE raw_publication_attribution (
    id integer NOT NULL,
    raw_publication_id integer NOT NULL,
    name character varying(64) NOT NULL,
    url character varying(255),
    retrieved date DEFAULT ('now'::text)::date
);


ALTER TABLE public.raw_publication_attribution OWNER TO "quelology-dev";

--
-- Name: raw_publication_attribution_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE raw_publication_attribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.raw_publication_attribution_id_seq OWNER TO "quelology-dev";

--
-- Name: raw_publication_attribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE raw_publication_attribution_id_seq OWNED BY raw_publication_attribution.id;


--
-- Name: raw_publication_attribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('raw_publication_attribution_id_seq', 1, false);


--
-- Name: raw_publication_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE raw_publication_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.raw_publication_id_seq OWNER TO "quelology-dev";

--
-- Name: raw_publication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE raw_publication_id_seq OWNED BY raw_publication.id;


--
-- Name: raw_publication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('raw_publication_id_seq', 1, false);


--
-- Name: title; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE title (
    id integer NOT NULL,
    title character varying(512) NOT NULL,
    lang character(2),
    isfdb_id integer,
    root_id integer,
    l integer DEFAULT 1 NOT NULL,
    r integer DEFAULT 2 NOT NULL,
    level integer DEFAULT 1 NOT NULL,
    same_as integer,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.title OWNER TO "quelology-dev";

--
-- Name: title_attribution; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE title_attribution (
    id integer NOT NULL,
    title_id integer NOT NULL,
    name character varying(64) NOT NULL,
    url character varying(255),
    retrieved date DEFAULT ('now'::text)::date
);


ALTER TABLE public.title_attribution OWNER TO "quelology-dev";

--
-- Name: title_attribution_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE title_attribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.title_attribution_id_seq OWNER TO "quelology-dev";

--
-- Name: title_attribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE title_attribution_id_seq OWNED BY title_attribution.id;


--
-- Name: title_attribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('title_attribution_id_seq', 1, false);


--
-- Name: title_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE title_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.title_id_seq OWNER TO "quelology-dev";

--
-- Name: title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE title_id_seq OWNED BY title.id;


--
-- Name: title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('title_id_seq', 1, false);


--
-- Name: title_link; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE title_link (
    id integer NOT NULL,
    title_id integer NOT NULL,
    url character varying(512) NOT NULL,
    type character varying(255) NOT NULL,
    lang character(2)
);


ALTER TABLE public.title_link OWNER TO "quelology-dev";

--
-- Name: title_link_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE title_link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.title_link_id_seq OWNER TO "quelology-dev";

--
-- Name: title_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE title_link_id_seq OWNED BY title_link.id;


--
-- Name: title_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('title_link_id_seq', 1, false);


--
-- Name: user_auth; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE user_auth (
    id integer NOT NULL,
    name character varying(64),
    salt bytea NOT NULL,
    cost integer NOT NULL,
    pw_hash bytea NOT NULL
);


ALTER TABLE public.user_auth OWNER TO "quelology-dev";

--
-- Name: user_auth_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE user_auth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_auth_id_seq OWNER TO "quelology-dev";

--
-- Name: user_auth_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE user_auth_id_seq OWNED BY user_auth.id;


--
-- Name: user_auth_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('user_auth_id_seq', 1, false);


--
-- Name: user_info; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE user_info (
    id integer NOT NULL,
    login_id integer NOT NULL,
    real_name character varying(64),
    email character varying(255)
);


ALTER TABLE public.user_info OWNER TO "quelology-dev";

--
-- Name: user_info_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE user_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_info_id_seq OWNER TO "quelology-dev";

--
-- Name: user_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE user_info_id_seq OWNED BY user_info.id;


--
-- Name: user_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('user_info_id_seq', 1, false);


--
-- Name: user_login; Type: TABLE; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE TABLE user_login (
    id integer NOT NULL,
    name character varying(64),
    salt bytea NOT NULL,
    cost integer NOT NULL,
    pw_hash bytea NOT NULL,
    created timestamp without time zone DEFAULT now() NOT NULL,
    modified timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.user_login OWNER TO "quelology-dev";

--
-- Name: user_login_id_seq; Type: SEQUENCE; Schema: public; Owner: quelology-dev
--

CREATE SEQUENCE user_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.user_login_id_seq OWNER TO "quelology-dev";

--
-- Name: user_login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: quelology-dev
--

ALTER SEQUENCE user_login_id_seq OWNED BY user_login.id;


--
-- Name: user_login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: quelology-dev
--

SELECT pg_catalog.setval('user_login_id_seq', 1, false);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE author ALTER COLUMN id SET DEFAULT nextval('author_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE author_attribution ALTER COLUMN id SET DEFAULT nextval('author_attribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE author_link ALTER COLUMN id SET DEFAULT nextval('author_link_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE author_title_map ALTER COLUMN id SET DEFAULT nextval('author_title_map_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE login ALTER COLUMN id SET DEFAULT nextval('login_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE publication ALTER COLUMN id SET DEFAULT nextval('publication_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE publication_attribution ALTER COLUMN id SET DEFAULT nextval('publication_attribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE publisher ALTER COLUMN id SET DEFAULT nextval('publisher_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE publisher_link ALTER COLUMN id SET DEFAULT nextval('publisher_link_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE raw_publication ALTER COLUMN id SET DEFAULT nextval('raw_publication_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE raw_publication_attribution ALTER COLUMN id SET DEFAULT nextval('raw_publication_attribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE title ALTER COLUMN id SET DEFAULT nextval('title_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE title_attribution ALTER COLUMN id SET DEFAULT nextval('title_attribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE title_link ALTER COLUMN id SET DEFAULT nextval('title_link_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE user_auth ALTER COLUMN id SET DEFAULT nextval('user_auth_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE user_info ALTER COLUMN id SET DEFAULT nextval('user_info_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: quelology-dev
--

ALTER TABLE user_login ALTER COLUMN id SET DEFAULT nextval('user_login_id_seq'::regclass);


--
-- Data for Name: author; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY author (id, isfdb_id, libris_id, name, legal_name, birthplace, birthplace_lat, birthplace_lon, birthdate, deathdate, created, modified) FROM stdin;
809	159	\N	Jules Verne	Verne, Jules Gabriel	Nantes, Loire-Atlantique, Pays-de-la-Loire, France	47.219167200000001	-1.5529162000000001	1828-02-08	1905-03-24	2011-05-06 13:25:41.370605	2011-06-19 15:41:32.355688
2111	138945	\N	Nicole Pitesa	\N	\N	\N	\N	\N	\N	2011-05-06 13:53:31.262856	2011-06-19 15:41:32.355688
2112	138947	\N	Maria Wilhelm	\N	\N	\N	\N	\N	\N	2011-05-06 13:53:31.262856	2011-06-19 15:41:32.355688
2113	138948	\N	Dirk Mathison	\N	\N	\N	\N	\N	\N	2011-05-06 13:53:31.262856	2011-06-19 15:41:32.355688
1996	6852	\N	Jacqueline Carey	\N	Highland Park, Illinois, USA	42.181691899999997	-87.800343799999993	1964-01-01	\N	2011-05-06 13:51:20.605216	2011-06-19 15:41:32.355688
\.


--
-- Data for Name: author_attribution; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY author_attribution (id, author_id, name, url, retrieved) FROM stdin;
\.


--
-- Data for Name: author_link; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY author_link (id, author_id, type, url, lang) FROM stdin;
\.


--
-- Data for Name: author_title_map; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY author_title_map (id, author_id, title_id) FROM stdin;
69520	809	62011
82482	809	74299
20834	2111	17602
20835	2112	17602
20836	2113	17602
20831	2111	17600
20832	2112	17601
20833	2113	17601
41283	1996	35263
41282	1996	35262
41277	1996	35257
41273	1996	35253
41274	1996	35254
41275	1996	35255
41276	1996	35256
41281	1996	35261
41278	1996	35258
41279	1996	35259
41280	1996	35260
41272	1996	35252
41269	1996	35249
41270	1996	35250
41271	1996	35251
88683	1996	80186
89141	1996	80615
88640	1996	80146
\.


--
-- Data for Name: login; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY login (id, name, salt, cost, pw_hash) FROM stdin;
\.


--
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY publication (id, asin, isbn, libris_id, title, publisher_id, lang, title_id, amazon_url, publication_date, binding, pages, small_image, small_image_width, small_image_height, medium_image, medium_image_width, medium_image_height, large_image, large_image_width, large_image_height, created, modified) FROM stdin;
93908	0819567965	0819567965	\N	The Begum's Millions	587	en	62011	http://www.amazon.com/exec/obidos/ASIN/0819567965/quelology-20	2005-11-01	hardcover	262	http://images.amazon.com/images/P/0819567965.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0819567965.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0819567965.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 16:06:20.614174	2011-05-06 16:06:20.697658
110266	0819567043	0819567043	\N	The Kip Brothers	587	en	74299	http://www.amazon.com/exec/obidos/ASIN/0819567043/quelology-20	2007-05-01	hardcover	475	http://images.amazon.com/images/P/0819567043.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0819567043.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0819567043.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 16:46:52.279956	2011-05-06 16:46:52.360643
30116	0061801267	0061801267	\N	James Cameron's Avatar: The Na'vi Quest	440	en	17600	http://www.amazon.com/exec/obidos/ASIN/0061801267/quelology-20	2009-12-01	paperback	58	http://images.amazon.com/images/P/0061801267.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0061801267.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0061801267.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 13:53:31.262856	2011-05-06 13:53:31.262856
30117	0061896756	0061896756	11766531	Avatar: A Confidential Report on the Biological and Social History of Pandora	1831	en	17601	http://www.amazon.com/exec/obidos/ASIN/0061896756/quelology-20	2009-12-01	paperback	224	http://images.amazon.com/images/P/0061896756.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0061896756.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0061896756.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 13:53:31.262856	2011-06-18 18:47:48.191631
141867	1439170835	1439170835	\N	Songs of love & death : all-original tales of star-crossed love	5113	en	35253	\N	2010-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:32.43048	2011-06-04 09:05:32.43048
19130	1439150141	1439150141	\N	Songs of Love and Death: All-Original Tales of Star-Crossed Love	1266	en	35253	http://www.amazon.com/exec/obidos/ASIN/1439150141/quelology-20	2010-11-16	hardcover	480	http://images.amazon.com/images/P/1439150141.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1439150141.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1439150141.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 13:34:47.986614	2011-05-06 14:35:50.270409
50357	0312872380	0312872380	\N	Kushiel's Dart	2	en	35254	http://www.amazon.com/exec/obidos/ASIN/0312872380/quelology-20	2001-06-01	hardcover	701	http://images.amazon.com/images/P/0312872380.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0312872380.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0312872380.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50358	0765342987	0765342987	\N	Kushiel's Dart	2	en	35254	http://www.amazon.com/exec/obidos/ASIN/0765342987/quelology-20	2002-03-01	paperback	901	http://images.amazon.com/images/P/0765342987.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0765342987.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0765342987.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50359	140500097X	140500097X	\N	Kushiel's Dart	933	en	35254	http://www.amazon.com/exec/obidos/ASIN/140500097X/quelology-20	2002-09-01	paperback	701	http://images.amazon.com/images/P/140500097X.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/140500097X.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/140500097X.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50360	0330493744	0330493744	\N	Kushiel's Dart	933	en	35254	http://www.amazon.com/exec/obidos/ASIN/0330493744/quelology-20	2003-09-01	paperback	1015	http://images.amazon.com/images/P/0330493744.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0330493744.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0330493744.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
141869	1400129494	1400129494	\N	Kushiel's dart	45	en	35254	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:32.894945	2011-06-04 09:05:32.894945
50361	1400109493	1400109493	\N	Kushiel's Dart	45	en	35254	http://www.amazon.com/exec/obidos/ASIN/1400109493/quelology-20	2009-01-01	\N	\N	http://images.amazon.com/images/P/1400109493.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400109493.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400109493.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
134968	\N	\N	\N	Kushiel's dart	45	en	35254	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-27 12:16:20.242538	2011-05-27 12:16:20.242538
134969	1400159490	1400159490	\N	Kushiel's Dart (Kushiel's Legacy)	45	en	35254	http://www.amazon.com/exec/obidos/ASIN/1400159490/quelology-20	2009-02-09	\N	\N	http://ecx.images-amazon.com/images/I/613Ts6xLPaL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/613Ts6xLPaL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/613Ts6xLPaL.jpg	378	500	2011-05-27 12:16:21.504087	2011-05-27 12:16:21.504087
134966	140013949X	140013949X	\N	Kushiel's Dart (Kushiel's Legacy)	45	en	35254	http://www.amazon.com/exec/obidos/ASIN/140013949X/quelology-20	2009-02-09	\N	\N	http://ecx.images-amazon.com/images/I/51IAj8nqw5L._SL75_.jpg	72	75	http://ecx.images-amazon.com/images/I/51IAj8nqw5L._SL160_.jpg	154	160	http://ecx.images-amazon.com/images/I/51IAj8nqw5L.jpg	481	500	2011-05-27 12:16:16.38559	2011-05-27 12:16:16.38559
50362	0312872399	0312872399	\N	Kushiel's Chosen	2	en	35255	http://www.amazon.com/exec/obidos/ASIN/0312872399/quelology-20	2002-04-01	hardcover	704	http://images.amazon.com/images/P/0312872399.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0312872399.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0312872399.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50363	0765345048	0765345048	\N	Kushiel's Chosen	2	en	35255	http://www.amazon.com/exec/obidos/ASIN/0765345048/quelology-20	2003-03-01	paperback	678	http://images.amazon.com/images/P/0765345048.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0765345048.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0765345048.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50364	1405005882	1405005882	\N	Kushiel's Chosen	933	en	35255	http://www.amazon.com/exec/obidos/ASIN/1405005882/quelology-20	2003-09-01	paperback	700	http://images.amazon.com/images/P/1405005882.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1405005882.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1405005882.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50365	0330412779	0330412779	\N	Kushiel's Chosen	933	en	35255	http://www.amazon.com/exec/obidos/ASIN/0330412779/quelology-20	2004-09-01	paperback	893	http://images.amazon.com/images/P/0330412779.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0330412779.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0330412779.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
134970	\N	\N	\N	Kushiel's chosen	45	en	35255	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-27 12:16:21.779652	2011-05-27 12:16:21.779652
141870	1400129508	1400129508	\N	Kushiel's chosen	45	en	35255	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:33.118895	2011-06-04 09:05:33.118895
50366	1400109507	1400109507	\N	Kushiel's Chosen	45	en	35255	http://www.amazon.com/exec/obidos/ASIN/1400109507/quelology-20	2009-02-01	\N	\N	http://images.amazon.com/images/P/1400109507.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400109507.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400109507.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
115488	1400139503	1400139503	\N	Kushiel's Chosen (Kushiel's Legacy)	45	en	35255	http://www.amazon.com/exec/obidos/ASIN/1400139503/quelology-20	2009-03-09	\N	\N	http://ecx.images-amazon.com/images/I/515PtWkDnhL._SL75_.jpg	75	66	http://ecx.images-amazon.com/images/I/515PtWkDnhL._SL160_.jpg	160	140	http://ecx.images-amazon.com/images/I/515PtWkDnhL.jpg	500	437	2011-05-18 22:36:41.195199	2011-05-18 22:36:41.195199
115489	1400159504	1400159504	\N	Kushiel's Chosen (Kushiel's Legacy)	45	en	35255	http://www.amazon.com/exec/obidos/ASIN/1400159504/quelology-20	2009-03-09	\N	\N	http://ecx.images-amazon.com/images/I/51dmBeMcVcL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51dmBeMcVcL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51dmBeMcVcL.jpg	378	500	2011-05-18 22:36:41.899238	2011-05-18 22:36:41.899238
50367	0312872402	0312872402	\N	Kushiel's Avatar	2	en	35256	http://www.amazon.com/exec/obidos/ASIN/0312872402/quelology-20	2003-04-01	hardcover	702	http://images.amazon.com/images/P/0312872402.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0312872402.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0312872402.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50368	0765347539	0765347539	\N	Kushiel's Avatar	2	en	35256	http://www.amazon.com/exec/obidos/ASIN/0765347539/quelology-20	2004-03-01	paperback	750	http://images.amazon.com/images/P/0765347539.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0765347539.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0765347539.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50369	1405034149	1405034149	\N	Kushiel's Avatar	933	en	35256	http://www.amazon.com/exec/obidos/ASIN/1405034149/quelology-20	2004-09-01	paperback	702	http://images.amazon.com/images/P/1405034149.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1405034149.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1405034149.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50370	0330420011	0330420011	\N	Kushiel's Avatar	933	en	35256	http://www.amazon.com/exec/obidos/ASIN/0330420011/quelology-20	2005-09-01	paperback	967	http://images.amazon.com/images/P/0330420011.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0330420011.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0330420011.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
134971	\N	\N	\N	Kushiel's avatar	45	en	35256	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-27 12:16:21.875293	2011-05-27 12:16:21.875293
141871	1400129516	1400129516	\N	Kushiel's avatar	45	en	35256	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:33.254343	2011-06-04 09:05:33.254343
50371	1400109515	1400109515	\N	Kushiel's Avatar	45	en	35256	http://www.amazon.com/exec/obidos/ASIN/1400109515/quelology-20	2009-03-01	\N	\N	http://images.amazon.com/images/P/1400109515.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400109515.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400109515.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
115490	1400159512	1400159512	\N	Kushiel's Avatar (Kushiel's Legacy)	45	en	35256	http://www.amazon.com/exec/obidos/ASIN/1400159512/quelology-20	2009-04-06	\N	\N	http://ecx.images-amazon.com/images/I/510CrhYXIlL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/510CrhYXIlL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/510CrhYXIlL.jpg	378	500	2011-05-18 22:36:43.201825	2011-05-18 22:36:43.201825
115492	1400139511	1400139511	\N	Kushiel's Avatar (Kushiel's Legacy)	45	en	35256	http://www.amazon.com/exec/obidos/ASIN/1400139511/quelology-20	2009-04-06	\N	\N	http://ecx.images-amazon.com/images/I/51HPbOczpuL._SL75_.jpg	75	75	http://ecx.images-amazon.com/images/I/51HPbOczpuL._SL160_.jpg	160	160	http://ecx.images-amazon.com/images/I/51HPbOczpuL.jpg	499	500	2011-05-18 22:36:45.408978	2011-05-18 22:36:45.408978
50372	044650002X	044650002X	\N	Kushiel's Scion	132	en	35258	http://www.amazon.com/exec/obidos/ASIN/044650002X/quelology-20	2006-06-01	hardcover	753	http://images.amazon.com/images/P/044650002X.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044650002X.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044650002X.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50373	044661002X	044661002X	\N	Kushiel's Scion	132	en	35258	http://www.amazon.com/exec/obidos/ASIN/044661002X/quelology-20	2007-04-01	paperback	943	http://images.amazon.com/images/P/044661002X.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044661002X.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044661002X.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
141874	0446541540	0446541540	\N	Kushiel's scion	132	en	35258	\N	2008-01-01	ebook	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:33.878053	2011-06-04 09:05:33.878053
134977	\N	\N	\N	Kushiel's scion	132	en	35258	\N	2008-01-01	ebook	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-27 12:17:44.071619	2011-05-27 12:17:44.071619
50374	1841493619	1841493619	\N	Kushiel's Scion	12	en	35258	http://www.amazon.com/exec/obidos/ASIN/1841493619/quelology-20	2008-08-01	paperback	753	http://images.amazon.com/images/P/1841493619.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1841493619.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1841493619.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50375	1400159520	1400159520	\N	Kushiel's Scion	45	en	35258	http://www.amazon.com/exec/obidos/ASIN/1400159520/quelology-20	2008-11-01	\N	\N	http://images.amazon.com/images/P/1400159520.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400159520.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400159520.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
115579	1400109523	1400109523	\N	Kushiel's Scion (Kushiel's Legacy)	45	en	35258	http://www.amazon.com/exec/obidos/ASIN/1400109523/quelology-20	2008-12-08	\N	\N	http://ecx.images-amazon.com/images/I/51et9SUjOfL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51et9SUjOfL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51et9SUjOfL.jpg	378	500	2011-05-18 22:41:05.579192	2011-05-18 22:41:05.579192
115580	140013952X	140013952X	\N	Kushiel's Scion (Kushiel's Legacy)	45	en	35258	http://www.amazon.com/exec/obidos/ASIN/140013952X/quelology-20	2008-12-08	\N	\N	http://ecx.images-amazon.com/images/I/51et9SUjOfL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51et9SUjOfL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51et9SUjOfL.jpg	378	500	2011-05-18 22:41:06.406153	2011-05-18 22:41:06.406153
134974	\N	\N	\N	Kushiel's justice	132	en	35259	\N	2007-01-01	ebook	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-27 12:17:43.431406	2011-05-27 12:17:43.431406
141876	0446196533	0446196533	\N	Kushiel's justice	132	en	35259	\N	2007-01-01	ebook	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:34.102824	2011-06-04 09:05:34.102824
141875	0446196517	0446196517	\N	Kushiel's justice	132	en	35259	\N	2007-01-01	ebook	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:34.02675	2011-06-04 09:05:34.02675
50376	0446500038	0446500038	\N	Kushiel's Justice	132	en	35259	http://www.amazon.com/exec/obidos/ASIN/0446500038/quelology-20	2007-06-01	hardcover	703	http://images.amazon.com/images/P/0446500038.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446500038.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446500038.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50377	0446610143	0446610143	\N	Kushiel's Justice	2834	en	35259	http://www.amazon.com/exec/obidos/ASIN/0446610143/quelology-20	2008-05-01	paperback	880	http://images.amazon.com/images/P/0446610143.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446610143.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446610143.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50379	1841493627	1841493627	\N	Kushiel's Justice	12	en	35259	http://www.amazon.com/exec/obidos/ASIN/1841493627/quelology-20	2008-09-01	paperback	703	http://images.amazon.com/images/P/1841493627.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1841493627.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1841493627.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
116776	\N	\N	\N	Kushiel's justice	45	en	35259	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-19 20:27:23.693905	2011-05-19 20:27:23.693905
50378	1400159539	1400159539	\N	Kushiel's Justice	45	en	35259	http://www.amazon.com/exec/obidos/ASIN/1400159539/quelology-20	2009-01-01	\N	\N	http://images.amazon.com/images/P/1400159539.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400159539.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1400159539.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
115581	1400139538	1400139538	\N	Kushiel's Justice (Kushiel's Legacy)	45	en	35259	http://www.amazon.com/exec/obidos/ASIN/1400139538/quelology-20	2009-01-19	\N	\N	http://ecx.images-amazon.com/images/I/51M29H8M6jL._SL75_.jpg	75	70	http://ecx.images-amazon.com/images/I/51M29H8M6jL._SL160_.jpg	160	149	http://ecx.images-amazon.com/images/I/51M29H8M6jL.jpg	500	467	2011-05-18 22:41:07.246669	2011-05-18 22:41:07.246669
115583	1400109531	1400109531	\N	Kushiel's Justice (Kushiel's Legacy)	45	en	35259	http://www.amazon.com/exec/obidos/ASIN/1400109531/quelology-20	2009-01-19	\N	\N	http://ecx.images-amazon.com/images/I/51YU6tD-YhL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51YU6tD-YhL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51YU6tD-YhL.jpg	378	500	2011-05-18 22:41:10.028871	2011-05-18 22:41:10.028871
50380	0446500046	0446500046	\N	Kushiel's Mercy	2834	en	35260	http://www.amazon.com/exec/obidos/ASIN/0446500046/quelology-20	2008-06-01	hardcover	654	http://images.amazon.com/images/P/0446500046.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446500046.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446500046.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50381	140010954X	140010954X	\N	Kushiel's Mercy	45	en	35260	http://www.amazon.com/exec/obidos/ASIN/140010954X/quelology-20	2008-09-01	\N	\N	http://images.amazon.com/images/P/140010954X.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/140010954X.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/140010954X.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
115585	1400159547	1400159547	\N	Kushiel's Mercy (Kushiel's Legacy)	45	en	35260	http://www.amazon.com/exec/obidos/ASIN/1400159547/quelology-20	2008-10-06	\N	\N	http://ecx.images-amazon.com/images/I/51o-Tul2trL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51o-Tul2trL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51o-Tul2trL.jpg	378	500	2011-05-18 22:41:12.11979	2011-05-18 22:41:12.11979
50382	044661016X	044661016X	\N	Kushiel's Mercy	1458	en	35260	http://www.amazon.com/exec/obidos/ASIN/044661016X/quelology-20	2009-06-01	paperback	832	http://images.amazon.com/images/P/044661016X.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044661016X.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044661016X.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50383	1841493635	1841493635	\N	Kushiel's Mercy	12	en	35260	http://www.amazon.com/exec/obidos/ASIN/1841493635/quelology-20	2009-11-01	paperback	653	http://images.amazon.com/images/P/1841493635.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1841493635.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/1841493635.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
122144	\N	\N	\N	Naamah's kiss	45	en	35249	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-20 11:23:16.355594	2011-05-20 11:23:16.355594
141878	140019251X	140019251X	\N	Naamah's kiss	45	en	35249	\N	2009-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:34.62619	2011-06-04 09:05:34.62619
50345	044619803X	044619803X	\N	Naamah's Kiss	1458	en	35249	http://www.amazon.com/exec/obidos/ASIN/044619803X/quelology-20	2009-06-01	hardcover	645	http://images.amazon.com/images/P/044619803X.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044619803X.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/044619803X.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
115566	1400142512	1400142512	\N	Naamah's Kiss	45	en	35249	http://www.amazon.com/exec/obidos/ASIN/1400142512/quelology-20	2009-07-09	\N	\N	http://ecx.images-amazon.com/images/I/51TAeKXngDL._SL75_.jpg	75	69	http://ecx.images-amazon.com/images/I/51TAeKXngDL._SL160_.jpg	160	146	http://ecx.images-amazon.com/images/I/51TAeKXngDL.jpg	500	457	2011-05-18 22:40:49.302689	2011-05-18 22:40:49.302689
115567	1400112516	1400112516	\N	Naamah's Kiss	45	en	35249	http://www.amazon.com/exec/obidos/ASIN/1400112516/quelology-20	2009-07-09	\N	\N	http://ecx.images-amazon.com/images/I/51TiY469IxL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51TiY469IxL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51TiY469IxL.jpg	378	500	2011-05-18 22:40:50.201099	2011-05-18 22:40:50.201099
115569	1400162513	1400162513	\N	Naamah's Kiss	45	en	35249	http://www.amazon.com/exec/obidos/ASIN/1400162513/quelology-20	2009-07-09	\N	\N	http://ecx.images-amazon.com/images/I/51TiY469IxL._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51TiY469IxL._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51TiY469IxL.jpg	378	500	2011-05-18 22:40:51.818228	2011-05-18 22:40:51.818228
50347	0575093579	0575093579	\N	Naamah's Kiss	18	en	35249	http://www.amazon.com/exec/obidos/ASIN/0575093579/quelology-20	2010-01-21	paperback	656	http://images.amazon.com/images/P/0575093579.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093579.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093579.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50346	0575093560	0575093560	\N	Naamah's Kiss	18	en	35249	http://www.amazon.com/exec/obidos/ASIN/0575093560/quelology-20	2010-01-21	hardcover	656	http://images.amazon.com/images/P/0575093560.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093560.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093560.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50344	0575093587	0575093587	\N	Naamah's Kiss	18	en	35249	http://www.amazon.com/exec/obidos/ASIN/0575093587/quelology-20	2010-05-13	paperback	672	http://images.amazon.com/images/P/0575093587.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093587.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093587.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50348	0446198048	0446198048	\N	Naamah's Kiss	1458	en	35249	http://www.amazon.com/exec/obidos/ASIN/0446198048/quelology-20	2010-06-01	paperback	800	http://images.amazon.com/images/P/0446198048.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198048.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198048.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
122148	\N	\N	\N	Naamah's curse	18	en	35250	\N	2010-01-01	ebook	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-20 11:23:16.629787	2011-05-20 11:23:16.629787
122146	\N	\N	\N	Naamah's curse	45	en	35250	\N	2010-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-20 11:23:16.518408	2011-05-20 11:23:16.518408
141882	0575093633	0575093633	\N	Naamah's curse	18	en	35250	\N	2010-01-01	ebook	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:34.872684	2011-06-04 09:05:34.872684
141880	1400193753	1400193753	\N	Naamah's curse	45	en	35250	\N	2010-01-01	audio	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:34.778096	2011-06-04 09:05:34.778096
50351	0446198056	0446198056	\N	Naamah's Curse	1459	en	35250	http://www.amazon.com/exec/obidos/ASIN/0446198056/quelology-20	2010-06-14	hardcover	576	http://images.amazon.com/images/P/0446198056.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198056.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198056.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50349	0575093609	0575093609	\N	Naamah's Curse	18	en	35250	http://www.amazon.com/exec/obidos/ASIN/0575093609/quelology-20	2010-06-17	hardcover	576	http://images.amazon.com/images/P/0575093609.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093609.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093609.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50350	0575093617	0575093617	\N	Naamah's Curse	18	en	35250	http://www.amazon.com/exec/obidos/ASIN/0575093617/quelology-20	2010-06-17	paperback	576	http://images.amazon.com/images/P/0575093617.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093617.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093617.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
115573	1400163757	9781400163755	\N	Naamah's Curse	45	en	35250	http://www.amazon.com/exec/obidos/ASIN/1400163757/quelology-20	2010-06-22	\N	\N	http://ecx.images-amazon.com/images/I/51bHnrV22vL._SL75_.jpg	52	75	http://ecx.images-amazon.com/images/I/51bHnrV22vL._SL160_.jpg	111	160	http://ecx.images-amazon.com/images/I/51bHnrV22vL.jpg	347	500	2011-05-18 22:40:58.24349	2011-05-18 22:40:58.24349
115571	1400143756	1400143756	\N	Naamah's Curse	45	en	35250	http://www.amazon.com/exec/obidos/ASIN/1400143756/quelology-20	2010-06-22	\N	\N	http://ecx.images-amazon.com/images/I/51Ezx8npQML._SL75_.jpg	57	75	http://ecx.images-amazon.com/images/I/51Ezx8npQML._SL160_.jpg	121	160	http://ecx.images-amazon.com/images/I/51Ezx8npQML.jpg	378	500	2011-05-18 22:40:56.193849	2011-05-18 22:40:56.193849
115570	140011375X	140011375X	\N	Naamah's Curse	45	en	35250	http://www.amazon.com/exec/obidos/ASIN/140011375X/quelology-20	2010-06-22	\N	\N	http://ecx.images-amazon.com/images/I/61wLzDiiwTL._SL75_.jpg	75	64	http://ecx.images-amazon.com/images/I/61wLzDiiwTL._SL160_.jpg	160	138	http://ecx.images-amazon.com/images/I/61wLzDiiwTL.jpg	500	430	2011-05-18 22:40:54.730892	2011-05-18 22:40:54.730892
50352	0575093625	0575093625	\N	Naamah's Curse	18	en	35250	http://www.amazon.com/exec/obidos/ASIN/0575093625/quelology-20	2011-04-14	paperback	576	http://images.amazon.com/images/P/0575093625.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093625.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093625.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50353	0446198064	0446198064	\N	Naamah's Curse	1459	en	35250	http://www.amazon.com/exec/obidos/ASIN/0446198064/quelology-20	2011-05-01	paperback	704	http://images.amazon.com/images/P/0446198064.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198064.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198064.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50354	0446198072	0446198072	\N	Naamah's Blessing	1459	en	35251	http://www.amazon.com/exec/obidos/ASIN/0446198072/quelology-20	2011-06-29	hardcover	624	http://images.amazon.com/images/P/0446198072.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198072.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0446198072.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50355	0575093641	0575093641	\N	Naamah's Blessing	18	en	35251	http://www.amazon.com/exec/obidos/ASIN/0575093641/quelology-20	2011-06-30	hardcover	624	http://images.amazon.com/images/P/0575093641.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093641.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093641.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
50356	0575093668	0575093668	\N	Naamah's Blessing	18	en	35251	http://www.amazon.com/exec/obidos/ASIN/0575093668/quelology-20	2011-06-30	paperback	624	http://images.amazon.com/images/P/0575093668.01.THUMBZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093668.01.MZZZZZZZ.jpg	\N	\N	http://images.amazon.com/images/P/0575093668.01.LZZZZZZZ.jpg	\N	\N	2011-05-06 14:35:50.270409	2011-05-06 14:35:50.270409
134967	\N	\N	\N	La marque	254	fr	80186	\N	2008-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-27 12:16:17.818036	2011-05-27 12:16:17.818036
141868	2352942373	2352942373	\N	La marque	254	fr	80186	\N	2008-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:32.655769	2011-06-04 09:05:32.655769
127047	\N	\N	\N	Il sangue e el traditore : romanzo	757	it	80146	\N	2010-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-05-21 13:51:06.772347	2011-05-21 13:51:06.772347
141873	8842916536	8842916536	\N	Il sangue e el traditore : romanzo	757	it	80146	\N	2010-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2011-06-04 09:05:33.519853	2011-06-04 09:05:33.519853
\.


--
-- Data for Name: publication_attribution; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY publication_attribution (id, publication_id, name, url, retrieved) FROM stdin;
\.


--
-- Data for Name: publisher; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY publisher (id, isfdb_id, name) FROM stdin;
587	1031	Wesleyan University Press
440	3484	HarperFestival
1831	32322	It Books
5113	18153	Gallery Books
1266	32484	Gallery
2	23	Tor
933	2126	Tor / Pan Macmillan UK
45	3889	Tantor Media
132	30	Warner Books
12	113	Orbit
2834	34938	Grand Central
1458	23109	Grand Central Publishing / Hachette
18	13	Gollancz
1459	31835	Grand Central Publishing
254	5752	Bragelonne
757	29379	Editrice Nord
\.


--
-- Data for Name: publisher_link; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY publisher_link (id, publisher_id, type, url) FROM stdin;
\.


--
-- Data for Name: raw_publication; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY raw_publication (id, asin, libris_id, isbn, title, authors, publisher, lang, maybe_title_id, amazon_url, publication_date, binding, pages, small_image, small_image_width, small_image_height, medium_image, medium_image_width, medium_image_height, large_image, large_image_width, large_image_height, created, modified) FROM stdin;
\.


--
-- Data for Name: raw_publication_attribution; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY raw_publication_attribution (id, raw_publication_id, name, url, retrieved) FROM stdin;
\.


--
-- Data for Name: title; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY title (id, title, lang, isfdb_id, root_id, l, r, level, same_as, created, modified) FROM stdin;
62011	The Begum's Millions	en	179546	62011	1	2	0	\N	2011-05-06 16:06:20.651939	2011-05-06 16:06:20.708519
74299	The Kip Brothers	en	1142817	74299	1	2	0	\N	2011-05-06 16:46:52.314789	2011-05-06 16:46:52.37165
17602	James Cameron's Avatar	en	\N	17602	1	6	0	\N	2011-05-06 13:53:31.262856	2011-05-06 13:53:31.262856
17600	James Cameron's Avatar: The Na'vi Quest	en	1137091	17602	2	3	1	\N	2011-05-06 13:53:31.262856	2011-05-06 13:53:31.262856
17601	Avatar: A Confidential Report on the Biological and Social History of Pandora	en	1137093	17602	4	5	1	\N	2011-05-06 13:53:31.262856	2011-05-06 13:53:31.262856
35263	Kushiel's Legacy Universe	en	\N	35263	1	30	0	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35262	Kushiel's Legacy	en	\N	35263	2	21	1	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35257	Phèdre Trilogy	en	\N	35263	3	12	2	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35253	You, and You Alone	en	1195873	35263	4	5	3	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35254	Kushiel's Dart	en	21713	35263	6	7	3	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35255	Kushiel's Chosen	en	21714	35263	8	9	3	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35256	Kushiel's Avatar	en	21715	35263	10	11	3	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35261	Imriel Trilogy	en	\N	35263	13	20	2	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35258	Kushiel's Scion	en	169100	35263	14	15	3	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35259	Kushiel's Justice	en	223921	35263	16	17	3	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35260	Kushiel's Mercy	en	829257	35263	18	19	3	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35252	Moirin Trilogy	en	\N	35263	22	29	1	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35249	Naamah's Kiss	en	930192	35263	23	24	2	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35250	Naamah's Curse	en	1098586	35263	25	26	2	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
35251	Naamah's Blessing	en	1224834	35263	27	28	2	\N	2011-05-06 14:35:50.270409	2011-05-26 11:20:09.829204
80186	La marque	fr	\N	80186	1	2	0	35254	2011-05-19 20:27:57.322053	2011-05-19 20:27:57.322053
80615	La maschera e le tenebre : romanzo	it	\N	80615	1	2	0	35256	2011-05-20 11:17:19.626323	2011-05-20 11:17:19.626323
80146	Il sangue e el traditore : romanzo	it	\N	80146	1	2	0	35258	2011-05-19 20:27:23.533169	2011-05-19 20:27:23.533169
\.


--
-- Data for Name: title_attribution; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY title_attribution (id, title_id, name, url, retrieved) FROM stdin;
\.


--
-- Data for Name: title_link; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY title_link (id, title_id, url, type, lang) FROM stdin;
\.


--
-- Data for Name: user_auth; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY user_auth (id, name, salt, cost, pw_hash) FROM stdin;
\.


--
-- Data for Name: user_info; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY user_info (id, login_id, real_name, email) FROM stdin;
\.


--
-- Data for Name: user_login; Type: TABLE DATA; Schema: public; Owner: quelology-dev
--

COPY user_login (id, name, salt, cost, pw_hash, created, modified) FROM stdin;
\.


--
-- Name: author_attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author_attribution
    ADD CONSTRAINT author_attribution_pkey PRIMARY KEY (id);


--
-- Name: author_isfdb_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_isfdb_id_key UNIQUE (isfdb_id);


--
-- Name: author_libris_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_libris_id_key UNIQUE (libris_id);


--
-- Name: author_link_author_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author_link
    ADD CONSTRAINT author_link_author_id_key UNIQUE (author_id, url);


--
-- Name: author_link_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author_link
    ADD CONSTRAINT author_link_pkey PRIMARY KEY (id);


--
-- Name: author_name_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_name_key UNIQUE (name);


--
-- Name: author_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_pkey PRIMARY KEY (id);


--
-- Name: author_title_map_author_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author_title_map
    ADD CONSTRAINT author_title_map_author_id_key UNIQUE (author_id, title_id);


--
-- Name: author_title_map_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY author_title_map
    ADD CONSTRAINT author_title_map_pkey PRIMARY KEY (id);


--
-- Name: login_name_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY login
    ADD CONSTRAINT login_name_key UNIQUE (name);


--
-- Name: login_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY login
    ADD CONSTRAINT login_pkey PRIMARY KEY (id);


--
-- Name: publication_asin_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_asin_key UNIQUE (asin);


--
-- Name: publication_attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publication_attribution
    ADD CONSTRAINT publication_attribution_pkey PRIMARY KEY (id);


--
-- Name: publication_libris_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_libris_id_key UNIQUE (libris_id);


--
-- Name: publication_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_pkey PRIMARY KEY (id);


--
-- Name: publisher_isfdb_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publisher
    ADD CONSTRAINT publisher_isfdb_id_key UNIQUE (isfdb_id);


--
-- Name: publisher_link_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publisher_link
    ADD CONSTRAINT publisher_link_pkey PRIMARY KEY (id);


--
-- Name: publisher_name_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publisher
    ADD CONSTRAINT publisher_name_key UNIQUE (name);


--
-- Name: publisher_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY publisher
    ADD CONSTRAINT publisher_pkey PRIMARY KEY (id);


--
-- Name: raw_publication_asin_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY raw_publication
    ADD CONSTRAINT raw_publication_asin_key UNIQUE (asin);


--
-- Name: raw_publication_attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY raw_publication_attribution
    ADD CONSTRAINT raw_publication_attribution_pkey PRIMARY KEY (id);


--
-- Name: raw_publication_isbn_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY raw_publication
    ADD CONSTRAINT raw_publication_isbn_key UNIQUE (isbn);


--
-- Name: raw_publication_libris_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY raw_publication
    ADD CONSTRAINT raw_publication_libris_id_key UNIQUE (libris_id);


--
-- Name: raw_publication_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY raw_publication
    ADD CONSTRAINT raw_publication_pkey PRIMARY KEY (id);


--
-- Name: title_attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY title_attribution
    ADD CONSTRAINT title_attribution_pkey PRIMARY KEY (id);


--
-- Name: title_isfdb_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_isfdb_id_key UNIQUE (isfdb_id);


--
-- Name: title_link_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY title_link
    ADD CONSTRAINT title_link_pkey PRIMARY KEY (id);


--
-- Name: title_link_title_id_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY title_link
    ADD CONSTRAINT title_link_title_id_key UNIQUE (title_id, url, lang);


--
-- Name: title_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_pkey PRIMARY KEY (id);


--
-- Name: title_same_as_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_same_as_key UNIQUE (same_as, lang);


--
-- Name: user_auth_name_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY user_auth
    ADD CONSTRAINT user_auth_name_key UNIQUE (name);


--
-- Name: user_auth_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY user_auth
    ADD CONSTRAINT user_auth_pkey PRIMARY KEY (id);


--
-- Name: user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY user_info
    ADD CONSTRAINT user_info_pkey PRIMARY KEY (id);


--
-- Name: user_login_name_key; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY user_login
    ADD CONSTRAINT user_login_name_key UNIQUE (name);


--
-- Name: user_login_pkey; Type: CONSTRAINT; Schema: public; Owner: quelology-dev; Tablespace: 
--

ALTER TABLE ONLY user_login
    ADD CONSTRAINT user_login_pkey PRIMARY KEY (id);


--
-- Name: author_attribution_author_id; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX author_attribution_author_id ON author_attribution USING btree (author_id);


--
-- Name: author_link_author_id_idx; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX author_link_author_id_idx ON author_link USING btree (author_id);


--
-- Name: publication_attribution_publication_id; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX publication_attribution_publication_id ON publication_attribution USING btree (publication_id);


--
-- Name: publication_publisher_id_idx; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX publication_publisher_id_idx ON publication USING btree (publisher_id);


--
-- Name: publication_title_id_idx; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX publication_title_id_idx ON publication USING btree (title_id);


--
-- Name: publisher_link_publisher_id_idx; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX publisher_link_publisher_id_idx ON publisher_link USING btree (publisher_id);


--
-- Name: raw_publication_attribution_raw_publication_id; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX raw_publication_attribution_raw_publication_id ON raw_publication_attribution USING btree (raw_publication_id);


--
-- Name: title_attributioin_title_id; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX title_attributioin_title_id ON title_attribution USING btree (title_id);


--
-- Name: title_link_title_id_idx; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX title_link_title_id_idx ON title_link USING btree (title_id);


--
-- Name: title_root_id_idx; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX title_root_id_idx ON title USING btree (root_id);


--
-- Name: user_info_login_id_idx; Type: INDEX; Schema: public; Owner: quelology-dev; Tablespace: 
--

CREATE INDEX user_info_login_id_idx ON user_info USING btree (login_id);


--
-- Name: update_author_modtime; Type: TRIGGER; Schema: public; Owner: quelology-dev
--

CREATE TRIGGER update_author_modtime
    BEFORE UPDATE ON author
    FOR EACH ROW
    EXECUTE PROCEDURE update_modified_column();


--
-- Name: update_publication_modtime; Type: TRIGGER; Schema: public; Owner: quelology-dev
--

CREATE TRIGGER update_publication_modtime
    BEFORE UPDATE ON publication
    FOR EACH ROW
    EXECUTE PROCEDURE update_modified_column();


--
-- Name: update_raw_publication_modtime; Type: TRIGGER; Schema: public; Owner: quelology-dev
--

CREATE TRIGGER update_raw_publication_modtime
    BEFORE UPDATE ON raw_publication
    FOR EACH ROW
    EXECUTE PROCEDURE update_modified_column();


--
-- Name: update_title_modtime; Type: TRIGGER; Schema: public; Owner: quelology-dev
--

CREATE TRIGGER update_title_modtime
    BEFORE UPDATE ON title
    FOR EACH ROW
    EXECUTE PROCEDURE update_modified_column();


--
-- Name: update_user_login_modtime; Type: TRIGGER; Schema: public; Owner: quelology-dev
--

CREATE TRIGGER update_user_login_modtime
    BEFORE UPDATE ON user_login
    FOR EACH ROW
    EXECUTE PROCEDURE update_modified_column();


--
-- Name: author_attribution_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY author_attribution
    ADD CONSTRAINT author_attribution_author_id_fkey FOREIGN KEY (author_id) REFERENCES author(id) ON DELETE CASCADE;


--
-- Name: author_link_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY author_link
    ADD CONSTRAINT author_link_author_id_fkey FOREIGN KEY (author_id) REFERENCES author(id) ON DELETE CASCADE;


--
-- Name: author_title_map_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY author_title_map
    ADD CONSTRAINT author_title_map_author_id_fkey FOREIGN KEY (author_id) REFERENCES author(id) ON DELETE CASCADE;


--
-- Name: author_title_map_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY author_title_map
    ADD CONSTRAINT author_title_map_title_id_fkey FOREIGN KEY (title_id) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: publication_attribution_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY publication_attribution
    ADD CONSTRAINT publication_attribution_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES publication(id) ON DELETE CASCADE;


--
-- Name: publication_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES publisher(id);


--
-- Name: publication_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_title_id_fkey FOREIGN KEY (title_id) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: publisher_link_publisher_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY publisher_link
    ADD CONSTRAINT publisher_link_publisher_id_fkey FOREIGN KEY (publisher_id) REFERENCES publisher(id) ON DELETE CASCADE;


--
-- Name: raw_publication_attribution_raw_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY raw_publication_attribution
    ADD CONSTRAINT raw_publication_attribution_raw_publication_id_fkey FOREIGN KEY (raw_publication_id) REFERENCES raw_publication(id) ON DELETE CASCADE;


--
-- Name: raw_publication_maybe_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY raw_publication
    ADD CONSTRAINT raw_publication_maybe_title_id_fkey FOREIGN KEY (maybe_title_id) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: title_attribution_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY title_attribution
    ADD CONSTRAINT title_attribution_title_id_fkey FOREIGN KEY (title_id) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: title_link_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY title_link
    ADD CONSTRAINT title_link_title_id_fkey FOREIGN KEY (title_id) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: title_root_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_root_id_fkey FOREIGN KEY (root_id) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: title_same_as_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_same_as_fkey FOREIGN KEY (same_as) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: user_info_login_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: quelology-dev
--

ALTER TABLE ONLY user_info
    ADD CONSTRAINT user_info_login_id_fkey FOREIGN KEY (login_id) REFERENCES user_login(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

