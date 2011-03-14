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

ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_same_as_fkey;
ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_root_id_fkey;
DROP INDEX public.medium_root_id_idx;
ALTER TABLE ONLY public.user_login DROP CONSTRAINT user_login_pkey;
ALTER TABLE ONLY public.user_login DROP CONSTRAINT user_login_name_key;
ALTER TABLE ONLY public.user_auth DROP CONSTRAINT user_auth_pkey;
ALTER TABLE ONLY public.user_auth DROP CONSTRAINT user_auth_name_key;
ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_pkey;
ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_asin_key;
ALTER TABLE ONLY public.login DROP CONSTRAINT login_pkey;
ALTER TABLE ONLY public.login DROP CONSTRAINT login_name_key;
ALTER TABLE public.user_login ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_auth ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medium ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.login ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.user_login_id_seq;
DROP TABLE public.user_login;
DROP SEQUENCE public.user_auth_id_seq;
DROP TABLE public.user_auth;
DROP SEQUENCE public.medium_id_seq;
DROP TABLE public.medium;
DROP SEQUENCE public.login_id_seq;
DROP TABLE public.login;
DROP SCHEMA public;
--
-- Name: xfacts-dev; Type: COMMENT; Schema: -; Owner: -
--



--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--



SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: login; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE login (
    id integer NOT NULL,
    name character varying(64),
    salt bytea NOT NULL,
    cost integer NOT NULL,
    pw_hash bytea NOT NULL
);


--
-- Name: login_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE login_id_seq OWNED BY login.id;


--
-- Name: login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('login_id_seq', 1, false);


--
-- Name: medium; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medium (
    id integer NOT NULL,
    asin character(10),
    isbn character varying(13),
    title character varying(255) NOT NULL,
    made_by character varying(255),
    publisher character varying(255),
    amazon_url character varying(255),
    small_image character varying(255),
    medium_image character varying(255),
    large_image character varying(255),
    publish_year smallint,
    root_id integer,
    same_as integer,
    l integer DEFAULT 1 NOT NULL,
    r integer DEFAULT 2 NOT NULL,
    level integer DEFAULT 0 NOT NULL
);


--
-- Name: medium_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medium_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: medium_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medium_id_seq OWNED BY medium.id;


--
-- Name: medium_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('medium_id_seq', 1, false);


--
-- Name: user_auth; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_auth (
    id integer NOT NULL,
    name character varying(64),
    salt bytea NOT NULL,
    cost integer NOT NULL,
    pw_hash bytea NOT NULL
);


--
-- Name: user_auth_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_auth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_auth_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_auth_id_seq OWNED BY user_auth.id;


--
-- Name: user_auth_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_auth_id_seq', 1, false);


--
-- Name: user_login; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_login (
    id integer NOT NULL,
    name character varying(64),
    salt bytea NOT NULL,
    cost integer NOT NULL,
    pw_hash bytea NOT NULL
);


--
-- Name: user_login_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_login_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_login_id_seq OWNED BY user_login.id;


--
-- Name: user_login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_login_id_seq', 1, false);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE login ALTER COLUMN id SET DEFAULT nextval('login_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE medium ALTER COLUMN id SET DEFAULT nextval('medium_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_auth ALTER COLUMN id SET DEFAULT nextval('user_auth_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_login ALTER COLUMN id SET DEFAULT nextval('user_login_id_seq'::regclass);


--
-- Data for Name: login; Type: TABLE DATA; Schema: public; Owner: -
--

COPY login (id, name, salt, cost, pw_hash) FROM stdin;
\.


--
-- Data for Name: medium; Type: TABLE DATA; Schema: public; Owner: -
--

COPY medium (id, asin, isbn, title, made_by, publisher, amazon_url, small_image, medium_image, large_image, publish_year, root_id, same_as, l, r, level) FROM stdin;
\.


--
-- Data for Name: user_auth; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_auth (id, name, salt, cost, pw_hash) FROM stdin;
\.


--
-- Data for Name: user_login; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_login (id, name, salt, cost, pw_hash) FROM stdin;
\.


--
-- Name: login_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY login
    ADD CONSTRAINT login_name_key UNIQUE (name);


--
-- Name: login_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY login
    ADD CONSTRAINT login_pkey PRIMARY KEY (id);


--
-- Name: medium_asin_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_asin_key UNIQUE (asin);


--
-- Name: medium_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_pkey PRIMARY KEY (id);


--
-- Name: user_auth_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_auth
    ADD CONSTRAINT user_auth_name_key UNIQUE (name);


--
-- Name: user_auth_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_auth
    ADD CONSTRAINT user_auth_pkey PRIMARY KEY (id);


--
-- Name: user_login_name_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_login
    ADD CONSTRAINT user_login_name_key UNIQUE (name);


--
-- Name: user_login_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_login
    ADD CONSTRAINT user_login_pkey PRIMARY KEY (id);


--
-- Name: medium_root_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX medium_root_id_idx ON medium USING btree (root_id);


--
-- Name: medium_root_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_root_id_fkey FOREIGN KEY (root_id) REFERENCES medium(id) ON DELETE CASCADE;


--
-- Name: medium_same_as_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_same_as_fkey FOREIGN KEY (same_as) REFERENCES medium(id) ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

