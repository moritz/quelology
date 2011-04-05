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
ALTER TABLE ONLY public.title_attribution DROP CONSTRAINT title_attribution_title_id_fkey;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_title_id_fkey;
ALTER TABLE ONLY public.publication_attribution DROP CONSTRAINT publication_attribution_publication_id_fkey;
ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_same_as_fkey;
ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_root_id_fkey;
ALTER TABLE ONLY public.attribution DROP CONSTRAINT attribution_medium_id_fkey;
DROP INDEX public.title_root_id_idx;
DROP INDEX public.medium_root_id_idx;
ALTER TABLE ONLY public.user_login DROP CONSTRAINT user_login_pkey;
ALTER TABLE ONLY public.user_login DROP CONSTRAINT user_login_name_key;
ALTER TABLE ONLY public.user_info DROP CONSTRAINT user_info_pkey;
ALTER TABLE ONLY public.title DROP CONSTRAINT title_pkey;
ALTER TABLE ONLY public.title_attribution DROP CONSTRAINT title_attribution_pkey;
ALTER TABLE ONLY public.title DROP CONSTRAINT title_asin_key;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_pkey;
ALTER TABLE ONLY public.publication_attribution DROP CONSTRAINT publication_attribution_pkey;
ALTER TABLE ONLY public.publication DROP CONSTRAINT publication_asin_key;
ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_pkey;
ALTER TABLE ONLY public.medium DROP CONSTRAINT medium_asin_key;
ALTER TABLE ONLY public.attribution DROP CONSTRAINT attribution_pkey;
ALTER TABLE public.user_login ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.user_info ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.title_attribution ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.title ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.publication_attribution ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.publication ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.medium ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.attribution ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE public.user_login_id_seq;
DROP TABLE public.user_login;
DROP SEQUENCE public.user_info_id_seq;
DROP TABLE public.user_info;
DROP SEQUENCE public.title_id_seq;
DROP SEQUENCE public.title_attribution_id_seq;
DROP TABLE public.title_attribution;
DROP TABLE public.title;
DROP SEQUENCE public.publication_id_seq;
DROP SEQUENCE public.publication_attribution_id_seq;
DROP TABLE public.publication_attribution;
DROP TABLE public.publication;
DROP SEQUENCE public.medium_id_seq;
DROP TABLE public.medium;
DROP SEQUENCE public.attribution_id_seq;
DROP TABLE public.attribution;
DROP SCHEMA public;
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
-- Name: attribution; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE attribution (
    id integer NOT NULL,
    medium_id integer NOT NULL,
    name character varying(64) NOT NULL,
    url character varying(255),
    retrieved date DEFAULT ('now'::text)::date
);


--
-- Name: attribution_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE attribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: attribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE attribution_id_seq OWNED BY attribution.id;


--
-- Name: attribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('attribution_id_seq', 39, true);


--
-- Name: medium; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE medium (
    id integer NOT NULL,
    asin character(10),
    isbn character varying(13),
    title character varying(255) NOT NULL,
    author character varying(255),
    publisher character varying(255),
    amazon_url character varying(255),
    small_image character varying(255),
    medium_image character varying(255),
    large_image character varying(255),
    lang character(2),
    publish_year smallint,
    root_id integer,
    same_as integer,
    l integer DEFAULT 1 NOT NULL,
    r integer DEFAULT 2 NOT NULL,
    level integer DEFAULT 1 NOT NULL
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

SELECT pg_catalog.setval('medium_id_seq', 48, true);


--
-- Name: publication; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publication (
    id integer NOT NULL,
    asin character(10),
    isbn character varying(13),
    title character varying(255) NOT NULL,
    author character varying(255),
    publisher character varying(255),
    lang character(2),
    title_id integer,
    amazon_url character varying(255),
    publication_date date,
    small_image character varying(255),
    small_image_width integer,
    small_image_height integer,
    medium_image character varying(255),
    medium_image_width integer,
    medium_image_height integer,
    large_image character varying(255),
    large_image_width integer,
    large_image_height integer
);


--
-- Name: publication_attribution; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publication_attribution (
    id integer NOT NULL,
    publication_id integer NOT NULL,
    name character varying(64) NOT NULL,
    url character varying(255),
    retrieved date DEFAULT ('now'::text)::date
);


--
-- Name: publication_attribution_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publication_attribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: publication_attribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publication_attribution_id_seq OWNED BY publication_attribution.id;


--
-- Name: publication_attribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('publication_attribution_id_seq', 39, true);


--
-- Name: publication_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publication_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: publication_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publication_id_seq OWNED BY publication.id;


--
-- Name: publication_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('publication_id_seq', 39, true);


--
-- Name: title; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE title (
    id integer NOT NULL,
    asin character(10),
    title character varying(255) NOT NULL,
    author character varying(255),
    publisher character varying(255),
    lang character(2),
    root_id integer,
    same_as integer,
    l integer DEFAULT 1 NOT NULL,
    r integer DEFAULT 2 NOT NULL,
    level integer DEFAULT 1 NOT NULL
);


--
-- Name: title_attribution; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE title_attribution (
    id integer NOT NULL,
    title_id integer NOT NULL,
    name character varying(64) NOT NULL,
    url character varying(255),
    retrieved date DEFAULT ('now'::text)::date
);


--
-- Name: title_attribution_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE title_attribution_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: title_attribution_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE title_attribution_id_seq OWNED BY title_attribution.id;


--
-- Name: title_attribution_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('title_attribution_id_seq', 1, false);


--
-- Name: title_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE title_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: title_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE title_id_seq OWNED BY title.id;


--
-- Name: title_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('title_id_seq', 48, true);


--
-- Name: user_info; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_info (
    id integer NOT NULL,
    login_id integer NOT NULL,
    real_name character varying(64),
    email character varying(255)
);


--
-- Name: user_info_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: user_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_info_id_seq OWNED BY user_info.id;


--
-- Name: user_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('user_info_id_seq', 4, true);


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

SELECT pg_catalog.setval('user_login_id_seq', 4, true);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE attribution ALTER COLUMN id SET DEFAULT nextval('attribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE medium ALTER COLUMN id SET DEFAULT nextval('medium_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE publication ALTER COLUMN id SET DEFAULT nextval('publication_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE publication_attribution ALTER COLUMN id SET DEFAULT nextval('publication_attribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE title ALTER COLUMN id SET DEFAULT nextval('title_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE title_attribution ALTER COLUMN id SET DEFAULT nextval('title_attribution_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_info ALTER COLUMN id SET DEFAULT nextval('user_info_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE user_login ALTER COLUMN id SET DEFAULT nextval('user_login_id_seq'::regclass);


--
-- Data for Name: attribution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY attribution (id, medium_id, name, url, retrieved) FROM stdin;
1	1	amazon	http://www.amazon.com/Lord-Rings-Fellowship-J-Tolkien/dp/0007269706%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269706	2011-04-04
2	2	amazon	http://www.amazon.com/Two-Towers-Lord-Rings-Part/dp/0618129081%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618129081	2011-04-04
3	3	amazon	http://www.amazon.com/Lord-Rings-J-R-Tolkien/dp/0007269722%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269722	2011-04-04
4	4	amazon	http://www.amazon.com/Warded-Man-Peter-V-Brett/dp/0345518705%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345518705	2011-04-04
5	5	amazon	http://www.amazon.com/Desert-Spear-Peter-V-Brett/dp/0345503813%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345503813	2011-04-04
6	6	amazon	http://www.amazon.com/Magicians-Guild-Black-Magician-Trilogy/dp/006057528X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D006057528X	2011-04-04
7	7	amazon	http://www.amazon.com/Novice-Black-Magician-Trilogy-Book/dp/0060575298%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575298	2011-04-04
8	8	amazon	http://www.amazon.com/High-Lord-Black-Magician-Trilogy/dp/0060575301%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575301	2011-04-04
9	9	amazon	http://www.amazon.com/Ambassadors-Mission-Traitor-Spy-Trilogy/dp/0316037834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037834	2011-04-04
10	10	amazon	http://www.amazon.com/Rogue-Traitor-Spy-Trilogy/dp/0316037869%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037869	2011-04-04
11	11	amazon	http://www.amazon.com/Hobbit-J-R-R-Tolkien/dp/0345296044%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345296044	2011-04-04
12	12	amazon	http://www.amazon.com/Silmarillion-Second-J-R-R-Tolkien/dp/B0017PICLQ%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB0017PICLQ	2011-04-04
13	13	amazon	http://www.amazon.com/Unfinished-Numenor-Middle-earth-Christopher-Tolkien/dp/0618154043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618154043	2011-04-04
14	14	amazon	http://www.amazon.com/Kushiels-Dart-Jacqueline-Carey/dp/0765342987%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765342987	2011-04-04
15	15	amazon	http://www.amazon.com/Kushiels-Chosen-Jacqueline-Carey/dp/0765345048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765345048	2011-04-04
16	16	amazon	http://www.amazon.com/Kushiels-Avatar-Legacy-Trilogy/dp/0765347539%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765347539	2011-04-04
17	17	amazon	http://www.amazon.com/Kushiels-Scion-Legacy-Jacqueline-Carey/dp/044661002X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661002X	2011-04-04
18	18	amazon	http://www.amazon.com/Kushiels-Justice-Legacy-Jacqueline-Carey/dp/0446610143%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446610143	2011-04-04
19	19	amazon	http://www.amazon.com/Kushiels-Mercy-Jacqueline-Carey/dp/044661016X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661016X	2011-04-04
20	20	amazon	http://www.amazon.com/Naamahs-Kushiel-Legacy-Jacqueline-Carey/dp/0446198048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198048	2011-04-04
21	21	amazon	http://www.amazon.com/Naamahs-Curse-Jacqueline-Carey/dp/0446198056%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198056	2011-04-04
22	22	amazon	http://www.amazon.com/Naamahs-Blessing-Kushiels-Legacy-Jacqueline/dp/0446198072%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198072	2011-04-04
23	23	amazon	http://www.amazon.com/Amulet-Samarkand-Bartimaeus-Trilogy-Book/dp/0786852550%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0786852550	2011-04-04
24	24	amazon	http://www.amazon.com/Bartimaeus-Ring-Solomon-Jonathan-Stroud/dp/1423123727%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D1423123727	2011-04-04
25	25	amazon	http://www.amazon.com/Ptolemys-Gate-Bartimaeus-Trilogy-Book/dp/078683868X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D078683868X	2011-04-04
26	26	amazon	http://www.amazon.com/Bartimaeus-Trilogy-Boxed-Set/dp/142310420X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D142310420X	2011-04-04
27	27	amazon	http://www.amazon.com/Golems-Bartimaeus-Trilogy-Jonathan-Stroud/dp/038560615X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D038560615X	2011-04-04
28	28	amazon	http://www.amazon.com/Kushiel-01-Zeichen-Jacqueline-Carey/dp/3802581202%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581202	2011-04-04
29	29	amazon	http://www.amazon.com/Kushiel-02-Verrat-Jacqueline-Carey/dp/3802581210%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581210	2011-04-04
30	30	amazon	http://www.amazon.com/Kushiel-03-Erl%C3%B6sung-Jacqueline-Carey/dp/3802581229%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581229	2011-04-04
31	31	amazon	http://www.amazon.com/Computer-Programming-Volumes-1-4A-Boxed/dp/0321751043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0321751043	2011-04-04
32	32	amazon	http://www.amazon.com/Art-Computer-Programming-Fundamental-Algorithms/dp/0201896834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896834	2011-04-04
33	33	amazon	http://www.amazon.com/Art-Computer-Programming-Seminumerical-Algorithms/dp/0201896842%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896842	2011-04-04
34	34	amazon	http://www.amazon.com/Art-Computer-Programming-Sorting-Searching/dp/0201896850%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896850	2011-04-04
35	35	amazon	http://www.amazon.com/Art-Computer-Programming-Combinatorial-Algorithms/dp/0201038048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201038048	2011-04-04
36	36	amazon	http://www.amazon.com/Lord-Rings-J-R-R-Tolkien/dp/0618260587%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618260587	2011-04-04
37	46	amazon	http://www.amazon.com/Name-Wind-Kingkiller-Chronicles-Day/dp/0756405890%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0756405890	2011-04-04
38	47	amazon	http://www.amazon.com/Name-Windes-Patrick-Rothfuss/dp/360893815X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D360893815X	2011-04-04
39	48	amazon	http://www.amazon.com/Nombre-Viento-Name-Wind-Spanish/dp/8499082475%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D8499082475	2011-04-04
\.


--
-- Data for Name: medium; Type: TABLE DATA; Schema: public; Owner: -
--

COPY medium (id, asin, isbn, title, author, publisher, amazon_url, small_image, medium_image, large_image, lang, publish_year, root_id, same_as, l, r, level) FROM stdin;
9	0316037834	9780316037839	The Ambassador's Mission	Trudi Canavan	Orbit	http://www.amazon.com/Ambassadors-Mission-Traitor-Spy-Trilogy/dp/0316037834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037834	http://ecx.images-amazon.com/images/I/51rcW1kFeGL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51rcW1kFeGL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51rcW1kFeGL.jpg	en	2010	38	\N	2	3	1
10	0316037869	0316037869	The Rogue	Trudi Canavan	Orbit	http://www.amazon.com/Rogue-Traitor-Spy-Trilogy/dp/0316037869%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037869	http://ecx.images-amazon.com/images/I/51UYVonc3lL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51UYVonc3lL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51UYVonc3lL.jpg	en	2011	38	\N	4	5	1
6	006057528X	006057528X	The Magicians' Guild	Trudi Canavan	Harper Voyager	http://www.amazon.com/Magicians-Guild-Black-Magician-Trilogy/dp/006057528X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D006057528X	http://ecx.images-amazon.com/images/I/51tN5SeF1wL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51tN5SeF1wL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51tN5SeF1wL.jpg	en	2004	39	\N	2	3	1
7	0060575298	9780060575298	The Novice	Trudi Canavan	Harper Voyager	http://www.amazon.com/Novice-Black-Magician-Trilogy-Book/dp/0060575298%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575298	http://ecx.images-amazon.com/images/I/415Td1q9EmL._SL75_.jpg	http://ecx.images-amazon.com/images/I/415Td1q9EmL._SL160_.jpg	http://ecx.images-amazon.com/images/I/415Td1q9EmL.jpg	en	2004	39	\N	4	5	1
8	0060575301	9780060575304	The High Lord	Trudi Canavan	Harper Voyager	http://www.amazon.com/High-Lord-Black-Magician-Trilogy/dp/0060575301%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575301	http://ecx.images-amazon.com/images/I/51Q-3cRiwiL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51Q-3cRiwiL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51Q-3cRiwiL.jpg	en	2004	39	\N	6	7	1
4	0345518705	9780345518705	The Warded Man	Peter V. Brett	Del Rey	http://www.amazon.com/Warded-Man-Peter-V-Brett/dp/0345518705%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345518705	http://ecx.images-amazon.com/images/I/51u6lj2ouJL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51u6lj2ouJL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51u6lj2ouJL.jpg	en	2010	42	\N	2	3	1
5	0345503813	9780345503817	The Desert Spear	Peter V. Brett	Del Rey	http://www.amazon.com/Desert-Spear-Peter-V-Brett/dp/0345503813%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345503813	http://ecx.images-amazon.com/images/I/41fvCXHZoHL._SL75_.jpg	http://ecx.images-amazon.com/images/I/41fvCXHZoHL._SL160_.jpg	http://ecx.images-amazon.com/images/I/41fvCXHZoHL.jpg	en	2010	42	\N	4	5	1
12	B0017PICLQ	\N	The Silmarillion, Second Edition	J.R.R. Tolkien, Christopher Tolkien	\N	http://www.amazon.com/Silmarillion-Second-J-R-R-Tolkien/dp/B0017PICLQ%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB0017PICLQ	http://ecx.images-amazon.com/images/I/41%2BsuVXiorL._SL75_.jpg	http://ecx.images-amazon.com/images/I/41%2BsuVXiorL._SL160_.jpg	http://ecx.images-amazon.com/images/I/41%2BsuVXiorL.jpg	\N	\N	44	\N	2	3	1
11	0345296044	0345296044	The Hobbit	J.R.R. Tolkien	Ballantine Books	http://www.amazon.com/Hobbit-J-R-R-Tolkien/dp/0345296044%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345296044	http://ecx.images-amazon.com/images/I/61BtpQ95N7L._SL75_.jpg	http://ecx.images-amazon.com/images/I/61BtpQ95N7L._SL160_.jpg	http://ecx.images-amazon.com/images/I/61BtpQ95N7L.jpg	en	1981	44	\N	4	5	1
3	0007269722	9780007269723	Lord of the Rings, The: The Return of the King	J. R. R. Tolkien	HarperCollins	http://www.amazon.com/Lord-Rings-J-R-Tolkien/dp/0007269722%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269722	http://ecx.images-amazon.com/images/I/51W9T9VpTjL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51W9T9VpTjL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51W9T9VpTjL.jpg	en	2008	44	\N	11	12	2
13	0618154043	0618154043	Unfinished Tales of Numenor and Middle-earth	Christopher Tolkien, J.R.R. Tolkien	Houghton Mifflin Harcourt	http://www.amazon.com/Unfinished-Numenor-Middle-earth-Christopher-Tolkien/dp/0618154043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618154043	http://ecx.images-amazon.com/images/I/51c7zKC8DSL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51c7zKC8DSL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51c7zKC8DSL.jpg	en	\N	44	\N	14	15	1
14	0765342987	9780765342980	Kushiel's Dart	Jacqueline Carey	Tor Fantasy	http://www.amazon.com/Kushiels-Dart-Jacqueline-Carey/dp/0765342987%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765342987	http://ecx.images-amazon.com/images/I/51wgsbYdF9L._SL75_.jpg	http://ecx.images-amazon.com/images/I/51wgsbYdF9L._SL160_.jpg	http://ecx.images-amazon.com/images/I/51wgsbYdF9L.jpg	en	2002	45	\N	3	4	2
23	0786852550	0786852550	The Amulet of Samarkand	Jonathan Stroud	Disney-Hyperion	http://www.amazon.com/Amulet-Samarkand-Bartimaeus-Trilogy-Book/dp/0786852550%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0786852550	http://ecx.images-amazon.com/images/I/51DGa4T2v2L._SL75_.jpg	http://ecx.images-amazon.com/images/I/51DGa4T2v2L._SL160_.jpg	http://ecx.images-amazon.com/images/I/51DGa4T2v2L.jpg	en	2004	23	\N	1	2	0
24	1423123727	9781423123729	Bartimaeus: The Ring of Solomon	Jonathan Stroud	Hyperion Book CH	http://www.amazon.com/Bartimaeus-Ring-Solomon-Jonathan-Stroud/dp/1423123727%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D1423123727	http://ecx.images-amazon.com/images/I/41LYVL93LgL._SL75_.jpg	http://ecx.images-amazon.com/images/I/41LYVL93LgL._SL160_.jpg	http://ecx.images-amazon.com/images/I/41LYVL93LgL.jpg	\N	2010	24	\N	1	2	0
25	078683868X	078683868X	Ptolemy's Gate	Jonathan Stroud	Hyperion Book CH	http://www.amazon.com/Ptolemys-Gate-Bartimaeus-Trilogy-Book/dp/078683868X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D078683868X	http://ecx.images-amazon.com/images/I/21GDQ710ADL._SL75_.jpg	http://ecx.images-amazon.com/images/I/21GDQ710ADL._SL160_.jpg	http://ecx.images-amazon.com/images/I/21GDQ710ADL.jpg	en	2007	25	\N	1	2	0
26	142310420X	142310420X	The Bartimaeus Trilogy Boxed Set	Jonathan Stroud	Disney-Hyperion	http://www.amazon.com/Bartimaeus-Trilogy-Boxed-Set/dp/142310420X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D142310420X	http://ecx.images-amazon.com/images/I/21E0CGCDZEL._SL75_.jpg	http://ecx.images-amazon.com/images/I/21E0CGCDZEL._SL160_.jpg	http://ecx.images-amazon.com/images/I/21E0CGCDZEL.jpg	\N	\N	26	\N	1	2	0
27	038560615X	038560615X	Golem's Eye	Jonathan Stroud	Doubleday Children's Books	http://www.amazon.com/Golems-Bartimaeus-Trilogy-Jonathan-Stroud/dp/038560615X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D038560615X	http://ecx.images-amazon.com/images/I/41073NG1J3L._SL75_.jpg	http://ecx.images-amazon.com/images/I/41073NG1J3L._SL160_.jpg	http://ecx.images-amazon.com/images/I/41073NG1J3L.jpg	en	2004	27	\N	1	2	0
28	3802581202	3802581202	Kushiel 01. Das Zeichen	Jacqueline Carey	Egmont vgs Verlagsgesell.	http://www.amazon.com/Kushiel-01-Zeichen-Jacqueline-Carey/dp/3802581202%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581202	http://ecx.images-amazon.com/images/I/21wTujaDZpL._SL75_.jpg	http://ecx.images-amazon.com/images/I/21wTujaDZpL._SL160_.jpg	http://ecx.images-amazon.com/images/I/21wTujaDZpL.jpg	de	2007	37	\N	2	3	1
16	0765347539	0765347539	Kushiel's Avatar	Jacqueline Carey	Tor Fantasy	http://www.amazon.com/Kushiels-Avatar-Legacy-Trilogy/dp/0765347539%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765347539	http://ecx.images-amazon.com/images/I/41IroVTFHgL._SL75_.jpg	http://ecx.images-amazon.com/images/I/41IroVTFHgL._SL160_.jpg	http://ecx.images-amazon.com/images/I/41IroVTFHgL.jpg	en	2004	45	\N	7	8	2
15	0765345048	0765345048	Kushiel's Chosen	Jacqueline Carey	Tor Fantasy	http://www.amazon.com/Kushiels-Chosen-Jacqueline-Carey/dp/0765345048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765345048	http://ecx.images-amazon.com/images/I/510zCCQSX2L._SL75_.jpg	http://ecx.images-amazon.com/images/I/510zCCQSX2L._SL160_.jpg	http://ecx.images-amazon.com/images/I/510zCCQSX2L.jpg	en	2003	45	\N	5	6	2
19	044661016X	9780446610162	Kushiel's Mercy	Jacqueline Carey	Grand Central Publishing	http://www.amazon.com/Kushiels-Mercy-Jacqueline-Carey/dp/044661016X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661016X	http://ecx.images-amazon.com/images/I/514ZlQoxZyL._SL75_.jpg	http://ecx.images-amazon.com/images/I/514ZlQoxZyL._SL160_.jpg	http://ecx.images-amazon.com/images/I/514ZlQoxZyL.jpg	en	2009	45	\N	15	16	2
18	0446610143	9780446610148	Kushiel's Justice	Jacqueline Carey	Grand Central Publishing	http://www.amazon.com/Kushiels-Justice-Legacy-Jacqueline-Carey/dp/0446610143%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446610143	http://ecx.images-amazon.com/images/I/51FgNHapbUL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51FgNHapbUL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51FgNHapbUL.jpg	en	2008	45	\N	13	14	2
21	0446198056	9780446198059	Naamah's Curse	Jacqueline Carey	Grand Central Publishing	http://www.amazon.com/Naamahs-Curse-Jacqueline-Carey/dp/0446198056%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198056	http://ecx.images-amazon.com/images/I/517FyWIUZYL._SL75_.jpg	http://ecx.images-amazon.com/images/I/517FyWIUZYL._SL160_.jpg	http://ecx.images-amazon.com/images/I/517FyWIUZYL.jpg	en	2010	45	\N	21	22	2
20	0446198048	0446198048	Naamah's Kiss	Jacqueline Carey	Grand Central Publishing	http://www.amazon.com/Naamahs-Kushiel-Legacy-Jacqueline-Carey/dp/0446198048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198048	http://ecx.images-amazon.com/images/I/51JDVcFFm0L._SL75_.jpg	http://ecx.images-amazon.com/images/I/51JDVcFFm0L._SL160_.jpg	http://ecx.images-amazon.com/images/I/51JDVcFFm0L.jpg	en	2010	45	\N	19	20	2
44	\N	\N	Middle Earth	J.R.R. Tolkien, Christopher Tolkien, Alan Lee	Houghton Mifflin Harcourt, Ballantine Books	\N	\N	\N	\N	en	\N	44	\N	1	16	0
29	3802581210	9783802581212	Kushiel 02. Der Verrat	Jacqueline Carey	Egmont vgs Verlagsgesell.	http://www.amazon.com/Kushiel-02-Verrat-Jacqueline-Carey/dp/3802581210%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581210	http://ecx.images-amazon.com/images/I/51L9D5j7YwL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51L9D5j7YwL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51L9D5j7YwL.jpg	de	2008	37	\N	4	5	1
37	\N	\N	Kushiels Auserwählte	Jacqueline Carey	Egmont vgs Verlagsgesell.	\N	\N	\N	\N	de	\N	37	\N	1	8	0
2	0618129081	0618129081	The Two Towers	J.R.R. Tolkien	Mariner Books	http://www.amazon.com/Two-Towers-Lord-Rings-Part/dp/0618129081%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618129081	http://ecx.images-amazon.com/images/I/411RC3MC6WL._SL75_.jpg	http://ecx.images-amazon.com/images/I/411RC3MC6WL._SL160_.jpg	http://ecx.images-amazon.com/images/I/411RC3MC6WL.jpg	en	\N	44	\N	9	10	2
38	\N	\N	The Traitor Spy Trilogy	Trudi Canavan	Orbit	\N	\N	\N	\N	en	\N	38	\N	1	6	0
1	0007269706	9780007269709	Lord of the Rings, The: The Fellowship of the Ring	J. R. R. Tolkien	HarperCollins	http://www.amazon.com/Lord-Rings-Fellowship-J-Tolkien/dp/0007269706%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269706	http://ecx.images-amazon.com/images/I/51HRRyQf0wL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51HRRyQf0wL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51HRRyQf0wL.jpg	en	2008	44	\N	7	8	2
39	\N	\N	The Black Magician Trilogy	Trudi Canavan	Harper Voyager	\N	\N	\N	\N	en	\N	39	\N	1	8	0
30	3802581229	9783802581229	Kushiel 03. Die Erlösung	Jacqueline Carey	Egmont vgs Verlagsgesell.	http://www.amazon.com/Kushiel-03-Erl%C3%B6sung-Jacqueline-Carey/dp/3802581229%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581229	http://ecx.images-amazon.com/images/I/51I4wJF2PoL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51I4wJF2PoL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51I4wJF2PoL.jpg	de	2008	37	16	6	7	1
45	\N	\N	Terre d'Ange	Jacqueline Carey	Grand Central Publishing, Tor Fantasy	\N	\N	\N	\N	en	\N	45	\N	1	26	0
32	0201896834	0201896834	Art of Computer Programming, Volume 1: Fundamental Algorithms	Donald E. Knuth	Addison-Wesley Professional	http://www.amazon.com/Art-Computer-Programming-Fundamental-Algorithms/dp/0201896834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896834	http://ecx.images-amazon.com/images/I/41233D6XS0L._SL75_.jpg	http://ecx.images-amazon.com/images/I/41233D6XS0L._SL160_.jpg	http://ecx.images-amazon.com/images/I/41233D6XS0L.jpg	en	1997	31	\N	2	3	1
36	0618260587	0618260587	The Lord of the Rings	J.R.R. Tolkien, Alan Lee	Houghton Mifflin Harcourt	http://www.amazon.com/Lord-Rings-J-R-R-Tolkien/dp/0618260587%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618260587	http://ecx.images-amazon.com/images/I/31F0RQ5PXAL._SL75_.jpg	http://ecx.images-amazon.com/images/I/31F0RQ5PXAL._SL160_.jpg	http://ecx.images-amazon.com/images/I/31F0RQ5PXAL.jpg	en	\N	44	\N	6	13	1
42	\N	\N	Demon Series	Peter V. Brett	Del Rey	\N	\N	\N	\N	en	\N	42	\N	1	6	0
43	\N	\N	Naamah's Gift (Moirin)	Jacqueline Carey	Grand Central Publishing	\N	\N	\N	\N	en	\N	45	\N	18	25	1
41	\N	\N	Kushiel's Dart (Phedre)	Jacqueline Carey	Tor Fantasy	\N	\N	\N	\N	en	\N	45	\N	2	9	1
40	\N	\N	Kushiel's Scion (Imriel)	Jacqueline Carey	Grand Central Publishing	\N	\N	\N	\N	en	\N	45	\N	10	17	1
31	0321751043	0321751043	Art of Computer Programming, Volumes 1-4A Boxed Set, The (3rd Edition)	Donald E. Knuth	Addison-Wesley Professional	http://www.amazon.com/Computer-Programming-Volumes-1-4A-Boxed/dp/0321751043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0321751043	http://ecx.images-amazon.com/images/I/41gCSRxxVeL._SL75_.jpg	http://ecx.images-amazon.com/images/I/41gCSRxxVeL._SL160_.jpg	http://ecx.images-amazon.com/images/I/41gCSRxxVeL.jpg	en	2011	31	\N	1	10	0
33	0201896842	0201896842	Art of Computer Programming, Volume 2: Seminumerical Algorithms	Donald E. Knuth	Addison-Wesley Professional	http://www.amazon.com/Art-Computer-Programming-Seminumerical-Algorithms/dp/0201896842%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896842	http://ecx.images-amazon.com/images/I/41T1XCAEE1L._SL75_.jpg	http://ecx.images-amazon.com/images/I/41T1XCAEE1L._SL160_.jpg	http://ecx.images-amazon.com/images/I/41T1XCAEE1L.jpg	en	1997	31	\N	4	5	1
34	0201896850	0201896850	Art of Computer Programming, Volume 3: Sorting and Searching	Donald E. Knuth	Addison-Wesley Professional	http://www.amazon.com/Art-Computer-Programming-Sorting-Searching/dp/0201896850%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896850	http://ecx.images-amazon.com/images/I/41N01A6R2KL._SL75_.jpg	http://ecx.images-amazon.com/images/I/41N01A6R2KL._SL160_.jpg	http://ecx.images-amazon.com/images/I/41N01A6R2KL.jpg	en	1998	31	\N	6	7	1
35	0201038048	\N	The Art of Computer Programming, Volume 4A: Combinatorial Algorithms, Part 1	Donald E. Knuth	Addison-Wesley Professional	http://www.amazon.com/Art-Computer-Programming-Combinatorial-Algorithms/dp/0201038048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201038048	http://ecx.images-amazon.com/images/I/41Uv2Tm1D4L._SL75_.jpg	http://ecx.images-amazon.com/images/I/41Uv2Tm1D4L._SL160_.jpg	http://ecx.images-amazon.com/images/I/41Uv2Tm1D4L.jpg	\N	\N	31	\N	8	9	1
17	044661002X	9780446610025	Kushiel's Scion	Jacqueline Carey	Grand Central Publishing	http://www.amazon.com/Kushiels-Scion-Legacy-Jacqueline-Carey/dp/044661002X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661002X	http://ecx.images-amazon.com/images/I/51C8YGxxWuL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51C8YGxxWuL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51C8YGxxWuL.jpg	en	2007	45	\N	11	12	2
22	0446198072	0446198072	Naamah's Blessing	Jacqueline Carey	Grand Central Publishing	http://www.amazon.com/Naamahs-Blessing-Kushiels-Legacy-Jacqueline/dp/0446198072%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198072	http://ecx.images-amazon.com/images/I/51kn%2B%2BlaLJL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51kn%2B%2BlaLJL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51kn%2B%2BlaLJL.jpg	en	2011	45	\N	23	24	2
46	0756405890	0756405890	The Name of the Wind	Patrick Rothfuss	DAW Trade	http://www.amazon.com/Name-Wind-Kingkiller-Chronicles-Day/dp/0756405890%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0756405890	http://ecx.images-amazon.com/images/I/51qxhokQlWL._SL75_.jpg	http://ecx.images-amazon.com/images/I/51qxhokQlWL._SL160_.jpg	http://ecx.images-amazon.com/images/I/51qxhokQlWL.jpg	en	2009	46	\N	1	2	0
47	360893815X	9783608938159	Der Name des Windes	Patrick Rothfuss	Klett Cotta Verlag	http://www.amazon.com/Name-Windes-Patrick-Rothfuss/dp/360893815X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D360893815X	http://ecx.images-amazon.com/images/I/413fiTHKV5L._SL75_.jpg	http://ecx.images-amazon.com/images/I/413fiTHKV5L._SL160_.jpg	http://ecx.images-amazon.com/images/I/413fiTHKV5L.jpg	de	2008	47	\N	1	2	0
48	8499082475	8499082475	El Nombre Del Viento / The Name Of The Wind	Patrick Rothfuss	\N	http://www.amazon.com/Nombre-Viento-Name-Wind-Spanish/dp/8499082475%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D8499082475	\N	\N	\N	es	2011	48	\N	1	2	0
\.


--
-- Data for Name: publication; Type: TABLE DATA; Schema: public; Owner: -
--

COPY publication (id, asin, isbn, title, author, publisher, lang, title_id, amazon_url, publication_date, small_image, small_image_width, small_image_height, medium_image, medium_image_width, medium_image_height, large_image, large_image_width, large_image_height) FROM stdin;
1	0007269706	9780007269709	Lord of the Rings, The: The Fellowship of the Ring	J. R. R. Tolkien	HarperCollins	en	1	http://www.amazon.com/Lord-Rings-Fellowship-J-Tolkien/dp/0007269706%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269706	2008-04-01	http://ecx.images-amazon.com/images/I/51HRRyQf0wL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51HRRyQf0wL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51HRRyQf0wL.jpg	\N	\N
2	0618129081	0618129081	The Two Towers	J.R.R. Tolkien	Mariner Books	en	2	http://www.amazon.com/Two-Towers-Lord-Rings-Part/dp/0618129081%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618129081	\N	http://ecx.images-amazon.com/images/I/411RC3MC6WL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/411RC3MC6WL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/411RC3MC6WL.jpg	\N	\N
3	0007269722	9780007269723	Lord of the Rings, The: The Return of the King	J. R. R. Tolkien	HarperCollins	en	3	http://www.amazon.com/Lord-Rings-J-R-Tolkien/dp/0007269722%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269722	2008-04-01	http://ecx.images-amazon.com/images/I/51W9T9VpTjL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51W9T9VpTjL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51W9T9VpTjL.jpg	\N	\N
4	0345518705	9780345518705	The Warded Man	Peter V. Brett	Del Rey	en	4	http://www.amazon.com/Warded-Man-Peter-V-Brett/dp/0345518705%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345518705	2010-03-23	http://ecx.images-amazon.com/images/I/51u6lj2ouJL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51u6lj2ouJL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51u6lj2ouJL.jpg	\N	\N
5	0345503813	9780345503817	The Desert Spear	Peter V. Brett	Del Rey	en	5	http://www.amazon.com/Desert-Spear-Peter-V-Brett/dp/0345503813%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345503813	2010-04-13	http://ecx.images-amazon.com/images/I/41fvCXHZoHL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41fvCXHZoHL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41fvCXHZoHL.jpg	\N	\N
6	006057528X	006057528X	The Magicians' Guild	Trudi Canavan	Harper Voyager	en	6	http://www.amazon.com/Magicians-Guild-Black-Magician-Trilogy/dp/006057528X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D006057528X	2004-02-01	http://ecx.images-amazon.com/images/I/51tN5SeF1wL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51tN5SeF1wL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51tN5SeF1wL.jpg	\N	\N
7	0060575298	9780060575298	The Novice	Trudi Canavan	Harper Voyager	en	7	http://www.amazon.com/Novice-Black-Magician-Trilogy-Book/dp/0060575298%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575298	2004-05-01	http://ecx.images-amazon.com/images/I/415Td1q9EmL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/415Td1q9EmL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/415Td1q9EmL.jpg	\N	\N
8	0060575301	9780060575304	The High Lord	Trudi Canavan	Harper Voyager	en	8	http://www.amazon.com/High-Lord-Black-Magician-Trilogy/dp/0060575301%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575301	2004-09-01	http://ecx.images-amazon.com/images/I/51Q-3cRiwiL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51Q-3cRiwiL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51Q-3cRiwiL.jpg	\N	\N
9	0316037834	9780316037839	The Ambassador's Mission	Trudi Canavan	Orbit	en	9	http://www.amazon.com/Ambassadors-Mission-Traitor-Spy-Trilogy/dp/0316037834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037834	2010-05-18	http://ecx.images-amazon.com/images/I/51rcW1kFeGL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51rcW1kFeGL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51rcW1kFeGL.jpg	\N	\N
10	0316037869	0316037869	The Rogue	Trudi Canavan	Orbit	en	10	http://www.amazon.com/Rogue-Traitor-Spy-Trilogy/dp/0316037869%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037869	2011-05-11	http://ecx.images-amazon.com/images/I/51UYVonc3lL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51UYVonc3lL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51UYVonc3lL.jpg	\N	\N
11	0345296044	0345296044	The Hobbit	J.R.R. Tolkien	Ballantine Books	en	11	http://www.amazon.com/Hobbit-J-R-R-Tolkien/dp/0345296044%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345296044	1981-03-12	http://ecx.images-amazon.com/images/I/61BtpQ95N7L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/61BtpQ95N7L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/61BtpQ95N7L.jpg	\N	\N
12	B0017PICLQ	\N	The Silmarillion, Second Edition	J.R.R. Tolkien, Christopher Tolkien	\N	\N	12	http://www.amazon.com/Silmarillion-Second-J-R-R-Tolkien/dp/B0017PICLQ%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB0017PICLQ	\N	http://ecx.images-amazon.com/images/I/41%2BsuVXiorL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41%2BsuVXiorL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41%2BsuVXiorL.jpg	\N	\N
13	0618154043	0618154043	Unfinished Tales of Numenor and Middle-earth	Christopher Tolkien, J.R.R. Tolkien	Houghton Mifflin Harcourt	en	13	http://www.amazon.com/Unfinished-Numenor-Middle-earth-Christopher-Tolkien/dp/0618154043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618154043	\N	http://ecx.images-amazon.com/images/I/51c7zKC8DSL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51c7zKC8DSL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51c7zKC8DSL.jpg	\N	\N
14	0765342987	9780765342980	Kushiel's Dart	Jacqueline Carey	Tor Fantasy	en	14	http://www.amazon.com/Kushiels-Dart-Jacqueline-Carey/dp/0765342987%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765342987	2002-03-01	http://ecx.images-amazon.com/images/I/51wgsbYdF9L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51wgsbYdF9L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51wgsbYdF9L.jpg	\N	\N
15	0765345048	0765345048	Kushiel's Chosen	Jacqueline Carey	Tor Fantasy	en	15	http://www.amazon.com/Kushiels-Chosen-Jacqueline-Carey/dp/0765345048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765345048	2003-03-31	http://ecx.images-amazon.com/images/I/510zCCQSX2L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/510zCCQSX2L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/510zCCQSX2L.jpg	\N	\N
16	0765347539	0765347539	Kushiel's Avatar	Jacqueline Carey	Tor Fantasy	en	16	http://www.amazon.com/Kushiels-Avatar-Legacy-Trilogy/dp/0765347539%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765347539	2004-03-01	http://ecx.images-amazon.com/images/I/41IroVTFHgL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41IroVTFHgL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41IroVTFHgL.jpg	\N	\N
17	044661002X	9780446610025	Kushiel's Scion	Jacqueline Carey	Grand Central Publishing	en	17	http://www.amazon.com/Kushiels-Scion-Legacy-Jacqueline-Carey/dp/044661002X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661002X	2007-05-01	http://ecx.images-amazon.com/images/I/51C8YGxxWuL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51C8YGxxWuL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51C8YGxxWuL.jpg	\N	\N
18	0446610143	9780446610148	Kushiel's Justice	Jacqueline Carey	Grand Central Publishing	en	18	http://www.amazon.com/Kushiels-Justice-Legacy-Jacqueline-Carey/dp/0446610143%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446610143	2008-05-01	http://ecx.images-amazon.com/images/I/51FgNHapbUL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51FgNHapbUL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51FgNHapbUL.jpg	\N	\N
19	044661016X	9780446610162	Kushiel's Mercy	Jacqueline Carey	Grand Central Publishing	en	19	http://www.amazon.com/Kushiels-Mercy-Jacqueline-Carey/dp/044661016X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661016X	2009-06-01	http://ecx.images-amazon.com/images/I/514ZlQoxZyL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/514ZlQoxZyL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/514ZlQoxZyL.jpg	\N	\N
20	0446198048	0446198048	Naamah's Kiss	Jacqueline Carey	Grand Central Publishing	en	20	http://www.amazon.com/Naamahs-Kushiel-Legacy-Jacqueline-Carey/dp/0446198048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198048	2010-06-01	http://ecx.images-amazon.com/images/I/51JDVcFFm0L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51JDVcFFm0L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51JDVcFFm0L.jpg	\N	\N
21	0446198056	9780446198059	Naamah's Curse	Jacqueline Carey	Grand Central Publishing	en	21	http://www.amazon.com/Naamahs-Curse-Jacqueline-Carey/dp/0446198056%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198056	2010-06-14	http://ecx.images-amazon.com/images/I/517FyWIUZYL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/517FyWIUZYL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/517FyWIUZYL.jpg	\N	\N
22	0446198072	0446198072	Naamah's Blessing	Jacqueline Carey	Grand Central Publishing	en	22	http://www.amazon.com/Naamahs-Blessing-Kushiels-Legacy-Jacqueline/dp/0446198072%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198072	2011-06-29	http://ecx.images-amazon.com/images/I/51kn%2B%2BlaLJL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51kn%2B%2BlaLJL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51kn%2B%2BlaLJL.jpg	\N	\N
23	0786852550	0786852550	The Amulet of Samarkand	Jonathan Stroud	Disney-Hyperion	en	23	http://www.amazon.com/Amulet-Samarkand-Bartimaeus-Trilogy-Book/dp/0786852550%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0786852550	2004-05-12	http://ecx.images-amazon.com/images/I/51DGa4T2v2L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51DGa4T2v2L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51DGa4T2v2L.jpg	\N	\N
24	1423123727	9781423123729	Bartimaeus: The Ring of Solomon	Jonathan Stroud	Hyperion Book CH	\N	24	http://www.amazon.com/Bartimaeus-Ring-Solomon-Jonathan-Stroud/dp/1423123727%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D1423123727	2010-11-02	http://ecx.images-amazon.com/images/I/41LYVL93LgL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41LYVL93LgL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41LYVL93LgL.jpg	\N	\N
25	078683868X	078683868X	Ptolemy's Gate	Jonathan Stroud	Hyperion Book CH	en	25	http://www.amazon.com/Ptolemys-Gate-Bartimaeus-Trilogy-Book/dp/078683868X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D078683868X	2007-01-01	http://ecx.images-amazon.com/images/I/21GDQ710ADL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/21GDQ710ADL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/21GDQ710ADL.jpg	\N	\N
26	142310420X	142310420X	The Bartimaeus Trilogy Boxed Set	Jonathan Stroud	Disney-Hyperion	\N	26	http://www.amazon.com/Bartimaeus-Trilogy-Boxed-Set/dp/142310420X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D142310420X	\N	http://ecx.images-amazon.com/images/I/21E0CGCDZEL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/21E0CGCDZEL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/21E0CGCDZEL.jpg	\N	\N
27	038560615X	038560615X	Golem's Eye	Jonathan Stroud	Doubleday Children's Books	en	27	http://www.amazon.com/Golems-Bartimaeus-Trilogy-Jonathan-Stroud/dp/038560615X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D038560615X	2004-10-07	http://ecx.images-amazon.com/images/I/41073NG1J3L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41073NG1J3L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41073NG1J3L.jpg	\N	\N
28	3802581202	3802581202	Kushiel 01. Das Zeichen	Jacqueline Carey	Egmont vgs Verlagsgesell.	de	28	http://www.amazon.com/Kushiel-01-Zeichen-Jacqueline-Carey/dp/3802581202%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581202	2007-09-15	http://ecx.images-amazon.com/images/I/21wTujaDZpL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/21wTujaDZpL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/21wTujaDZpL.jpg	\N	\N
29	3802581210	9783802581212	Kushiel 02. Der Verrat	Jacqueline Carey	Egmont vgs Verlagsgesell.	de	29	http://www.amazon.com/Kushiel-02-Verrat-Jacqueline-Carey/dp/3802581210%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581210	2008-03-15	http://ecx.images-amazon.com/images/I/51L9D5j7YwL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51L9D5j7YwL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51L9D5j7YwL.jpg	\N	\N
30	3802581229	9783802581229	Kushiel 03. Die Erlösung	Jacqueline Carey	Egmont vgs Verlagsgesell.	de	30	http://www.amazon.com/Kushiel-03-Erl%C3%B6sung-Jacqueline-Carey/dp/3802581229%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581229	2008-09-15	http://ecx.images-amazon.com/images/I/51I4wJF2PoL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51I4wJF2PoL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51I4wJF2PoL.jpg	\N	\N
31	0321751043	0321751043	Art of Computer Programming, Volumes 1-4A Boxed Set, The (3rd Edition)	Donald E. Knuth	Addison-Wesley Professional	en	31	http://www.amazon.com/Computer-Programming-Volumes-1-4A-Boxed/dp/0321751043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0321751043	2011-04-15	http://ecx.images-amazon.com/images/I/41gCSRxxVeL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41gCSRxxVeL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41gCSRxxVeL.jpg	\N	\N
32	0201896834	0201896834	Art of Computer Programming, Volume 1: Fundamental Algorithms	Donald E. Knuth	Addison-Wesley Professional	en	32	http://www.amazon.com/Art-Computer-Programming-Fundamental-Algorithms/dp/0201896834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896834	1997-07-07	http://ecx.images-amazon.com/images/I/41233D6XS0L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41233D6XS0L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41233D6XS0L.jpg	\N	\N
33	0201896842	0201896842	Art of Computer Programming, Volume 2: Seminumerical Algorithms	Donald E. Knuth	Addison-Wesley Professional	en	33	http://www.amazon.com/Art-Computer-Programming-Seminumerical-Algorithms/dp/0201896842%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896842	1997-11-04	http://ecx.images-amazon.com/images/I/41T1XCAEE1L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41T1XCAEE1L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41T1XCAEE1L.jpg	\N	\N
34	0201896850	0201896850	Art of Computer Programming, Volume 3: Sorting and Searching	Donald E. Knuth	Addison-Wesley Professional	en	34	http://www.amazon.com/Art-Computer-Programming-Sorting-Searching/dp/0201896850%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896850	1998-06-23	http://ecx.images-amazon.com/images/I/41N01A6R2KL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41N01A6R2KL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41N01A6R2KL.jpg	\N	\N
35	0201038048	\N	The Art of Computer Programming, Volume 4A: Combinatorial Algorithms, Part 1	Donald E. Knuth	Addison-Wesley Professional	\N	35	http://www.amazon.com/Art-Computer-Programming-Combinatorial-Algorithms/dp/0201038048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201038048	\N	http://ecx.images-amazon.com/images/I/41Uv2Tm1D4L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41Uv2Tm1D4L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/41Uv2Tm1D4L.jpg	\N	\N
36	0618260587	0618260587	The Lord of the Rings	J.R.R. Tolkien, Alan Lee	Houghton Mifflin Harcourt	en	36	http://www.amazon.com/Lord-Rings-J-R-R-Tolkien/dp/0618260587%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618260587	\N	http://ecx.images-amazon.com/images/I/31F0RQ5PXAL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/31F0RQ5PXAL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/31F0RQ5PXAL.jpg	\N	\N
37	0756405890	0756405890	The Name of the Wind	Patrick Rothfuss	DAW Trade	en	46	http://www.amazon.com/Name-Wind-Kingkiller-Chronicles-Day/dp/0756405890%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0756405890	2009-04-07	http://ecx.images-amazon.com/images/I/51qxhokQlWL._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51qxhokQlWL._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/51qxhokQlWL.jpg	\N	\N
38	360893815X	9783608938159	Der Name des Windes	Patrick Rothfuss	Klett Cotta Verlag	de	47	http://www.amazon.com/Name-Windes-Patrick-Rothfuss/dp/360893815X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D360893815X	2008-09-01	http://ecx.images-amazon.com/images/I/413fiTHKV5L._SL75_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/413fiTHKV5L._SL160_.jpg	\N	\N	http://ecx.images-amazon.com/images/I/413fiTHKV5L.jpg	\N	\N
39	8499082475	8499082475	El Nombre Del Viento / The Name Of The Wind	Patrick Rothfuss	\N	es	48	http://www.amazon.com/Nombre-Viento-Name-Wind-Spanish/dp/8499082475%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D8499082475	2011-01-01	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: publication_attribution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY publication_attribution (id, publication_id, name, url, retrieved) FROM stdin;
1	1	amazon	http://www.amazon.com/Lord-Rings-Fellowship-J-Tolkien/dp/0007269706%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269706	2011-04-05
2	2	amazon	http://www.amazon.com/Two-Towers-Lord-Rings-Part/dp/0618129081%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618129081	2011-04-05
3	3	amazon	http://www.amazon.com/Lord-Rings-J-R-Tolkien/dp/0007269722%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0007269722	2011-04-05
4	4	amazon	http://www.amazon.com/Warded-Man-Peter-V-Brett/dp/0345518705%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345518705	2011-04-05
5	5	amazon	http://www.amazon.com/Desert-Spear-Peter-V-Brett/dp/0345503813%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345503813	2011-04-05
6	6	amazon	http://www.amazon.com/Magicians-Guild-Black-Magician-Trilogy/dp/006057528X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D006057528X	2011-04-05
7	7	amazon	http://www.amazon.com/Novice-Black-Magician-Trilogy-Book/dp/0060575298%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575298	2011-04-05
8	8	amazon	http://www.amazon.com/High-Lord-Black-Magician-Trilogy/dp/0060575301%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0060575301	2011-04-05
9	9	amazon	http://www.amazon.com/Ambassadors-Mission-Traitor-Spy-Trilogy/dp/0316037834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037834	2011-04-05
10	10	amazon	http://www.amazon.com/Rogue-Traitor-Spy-Trilogy/dp/0316037869%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0316037869	2011-04-05
11	11	amazon	http://www.amazon.com/Hobbit-J-R-R-Tolkien/dp/0345296044%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0345296044	2011-04-05
12	12	amazon	http://www.amazon.com/Silmarillion-Second-J-R-R-Tolkien/dp/B0017PICLQ%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB0017PICLQ	2011-04-05
13	13	amazon	http://www.amazon.com/Unfinished-Numenor-Middle-earth-Christopher-Tolkien/dp/0618154043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618154043	2011-04-05
14	14	amazon	http://www.amazon.com/Kushiels-Dart-Jacqueline-Carey/dp/0765342987%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765342987	2011-04-05
15	15	amazon	http://www.amazon.com/Kushiels-Chosen-Jacqueline-Carey/dp/0765345048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765345048	2011-04-05
16	16	amazon	http://www.amazon.com/Kushiels-Avatar-Legacy-Trilogy/dp/0765347539%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0765347539	2011-04-05
17	17	amazon	http://www.amazon.com/Kushiels-Scion-Legacy-Jacqueline-Carey/dp/044661002X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661002X	2011-04-05
18	18	amazon	http://www.amazon.com/Kushiels-Justice-Legacy-Jacqueline-Carey/dp/0446610143%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446610143	2011-04-05
19	19	amazon	http://www.amazon.com/Kushiels-Mercy-Jacqueline-Carey/dp/044661016X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D044661016X	2011-04-05
20	20	amazon	http://www.amazon.com/Naamahs-Kushiel-Legacy-Jacqueline-Carey/dp/0446198048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198048	2011-04-05
21	21	amazon	http://www.amazon.com/Naamahs-Curse-Jacqueline-Carey/dp/0446198056%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198056	2011-04-05
22	22	amazon	http://www.amazon.com/Naamahs-Blessing-Kushiels-Legacy-Jacqueline/dp/0446198072%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0446198072	2011-04-05
23	23	amazon	http://www.amazon.com/Amulet-Samarkand-Bartimaeus-Trilogy-Book/dp/0786852550%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0786852550	2011-04-05
24	24	amazon	http://www.amazon.com/Bartimaeus-Ring-Solomon-Jonathan-Stroud/dp/1423123727%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D1423123727	2011-04-05
25	25	amazon	http://www.amazon.com/Ptolemys-Gate-Bartimaeus-Trilogy-Book/dp/078683868X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D078683868X	2011-04-05
26	26	amazon	http://www.amazon.com/Bartimaeus-Trilogy-Boxed-Set/dp/142310420X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D142310420X	2011-04-05
27	27	amazon	http://www.amazon.com/Golems-Bartimaeus-Trilogy-Jonathan-Stroud/dp/038560615X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D038560615X	2011-04-05
28	28	amazon	http://www.amazon.com/Kushiel-01-Zeichen-Jacqueline-Carey/dp/3802581202%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581202	2011-04-05
29	29	amazon	http://www.amazon.com/Kushiel-02-Verrat-Jacqueline-Carey/dp/3802581210%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581210	2011-04-05
30	30	amazon	http://www.amazon.com/Kushiel-03-Erl%C3%B6sung-Jacqueline-Carey/dp/3802581229%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D3802581229	2011-04-05
31	31	amazon	http://www.amazon.com/Computer-Programming-Volumes-1-4A-Boxed/dp/0321751043%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0321751043	2011-04-05
32	32	amazon	http://www.amazon.com/Art-Computer-Programming-Fundamental-Algorithms/dp/0201896834%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896834	2011-04-05
33	33	amazon	http://www.amazon.com/Art-Computer-Programming-Seminumerical-Algorithms/dp/0201896842%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896842	2011-04-05
34	34	amazon	http://www.amazon.com/Art-Computer-Programming-Sorting-Searching/dp/0201896850%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201896850	2011-04-05
35	35	amazon	http://www.amazon.com/Art-Computer-Programming-Combinatorial-Algorithms/dp/0201038048%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0201038048	2011-04-05
36	36	amazon	http://www.amazon.com/Lord-Rings-J-R-R-Tolkien/dp/0618260587%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0618260587	2011-04-05
37	37	amazon	http://www.amazon.com/Name-Wind-Kingkiller-Chronicles-Day/dp/0756405890%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D0756405890	2011-04-05
38	38	amazon	http://www.amazon.com/Name-Windes-Patrick-Rothfuss/dp/360893815X%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D360893815X	2011-04-05
39	39	amazon	http://www.amazon.com/Nombre-Viento-Name-Wind-Spanish/dp/8499082475%3FSubscriptionId%3DAKIAJQH5L3AY6MOXEEVQ%26tag%3Dquelology-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3D8499082475	2011-04-05
\.


--
-- Data for Name: title; Type: TABLE DATA; Schema: public; Owner: -
--

COPY title (id, asin, title, author, publisher, lang, root_id, same_as, l, r, level) FROM stdin;
23	\N	The Amulet of Samarkand	Jonathan Stroud	Disney-Hyperion	en	23	\N	1	2	0
24	\N	Bartimaeus: The Ring of Solomon	Jonathan Stroud	Hyperion Book CH	\N	24	\N	1	2	0
25	\N	Ptolemy's Gate	Jonathan Stroud	Hyperion Book CH	en	25	\N	1	2	0
26	\N	The Bartimaeus Trilogy Boxed Set	Jonathan Stroud	Disney-Hyperion	\N	26	\N	1	2	0
27	\N	Golem's Eye	Jonathan Stroud	Doubleday Children's Books	en	27	\N	1	2	0
22	\N	Naamah's Blessing	Jacqueline Carey	Grand Central Publishing	en	45	\N	23	24	2
21	\N	Naamah's Curse	Jacqueline Carey	Grand Central Publishing	en	45	\N	21	22	2
28	\N	Kushiel 01. Das Zeichen	Jacqueline Carey	Egmont vgs Verlagsgesell.	de	37	\N	2	3	1
29	\N	Kushiel 02. Der Verrat	Jacqueline Carey	Egmont vgs Verlagsgesell.	de	37	\N	4	5	1
37	\N	Kushiels Auserwählte	Jacqueline Carey	Egmont vgs Verlagsgesell.	de	37	\N	1	8	0
9	\N	The Ambassador's Mission	Trudi Canavan	Orbit	en	38	\N	2	3	1
38	\N	The Traitor Spy Trilogy	Trudi Canavan	Orbit	en	38	\N	1	6	0
10	\N	The Rogue	Trudi Canavan	Orbit	en	38	\N	4	5	1
6	\N	The Magicians' Guild	Trudi Canavan	Harper Voyager	en	39	\N	2	3	1
7	\N	The Novice	Trudi Canavan	Harper Voyager	en	39	\N	4	5	1
39	\N	The Black Magician Trilogy	Trudi Canavan	Harper Voyager	en	39	\N	1	8	0
8	\N	The High Lord	Trudi Canavan	Harper Voyager	en	39	\N	6	7	1
16	\N	Kushiel's Avatar	Jacqueline Carey	Tor Fantasy	en	45	\N	7	8	2
3	\N	Lord of the Rings, The: The Return of the King	J. R. R. Tolkien	HarperCollins	en	44	\N	11	12	2
20	\N	Naamah's Kiss	Jacqueline Carey	Grand Central Publishing	en	45	\N	19	20	2
4	\N	The Warded Man	Peter V. Brett	Del Rey	en	42	\N	2	3	1
42	\N	Demon Series	Peter V. Brett	Del Rey	en	42	\N	1	6	0
5	\N	The Desert Spear	Peter V. Brett	Del Rey	en	42	\N	4	5	1
46	\N	The Name of the Wind	Patrick Rothfuss	DAW Trade	en	46	\N	1	2	0
15	\N	Kushiel's Chosen	Jacqueline Carey	Tor Fantasy	en	45	\N	5	6	2
12	\N	The Silmarillion, Second Edition	J.R.R. Tolkien, Christopher Tolkien	\N	\N	44	\N	2	3	1
14	\N	Kushiel's Dart	Jacqueline Carey	Tor Fantasy	en	45	\N	3	4	2
11	\N	The Hobbit	J.R.R. Tolkien	Ballantine Books	en	44	\N	4	5	1
2	\N	The Two Towers	J.R.R. Tolkien	Mariner Books	en	44	\N	9	10	2
1	\N	Lord of the Rings, The: The Fellowship of the Ring	J. R. R. Tolkien	HarperCollins	en	44	\N	7	8	2
36	\N	The Lord of the Rings	J.R.R. Tolkien, Alan Lee	Houghton Mifflin Harcourt	en	44	\N	6	13	1
44	\N	Middle Earth	J.R.R. Tolkien, Christopher Tolkien, Alan Lee	Houghton Mifflin Harcourt, Ballantine Books	en	44	\N	1	16	0
13	\N	Unfinished Tales of Numenor and Middle-earth	Christopher Tolkien, J.R.R. Tolkien	Houghton Mifflin Harcourt	en	44	\N	14	15	1
41	\N	Kushiel's Dart (Phedre)	Jacqueline Carey	Tor Fantasy	en	45	\N	2	9	1
34	\N	Art of Computer Programming, Volume 3: Sorting and Searching	Donald E. Knuth	Addison-Wesley Professional	en	31	\N	6	7	1
19	\N	Kushiel's Mercy	Jacqueline Carey	Grand Central Publishing	en	45	\N	15	16	2
18	\N	Kushiel's Justice	Jacqueline Carey	Grand Central Publishing	en	45	\N	13	14	2
17	\N	Kushiel's Scion	Jacqueline Carey	Grand Central Publishing	en	45	\N	11	12	2
40	\N	Kushiel's Scion (Imriel)	Jacqueline Carey	Grand Central Publishing	en	45	\N	10	17	1
45	\N	Terre d'Ange	Jacqueline Carey	Grand Central Publishing, Tor Fantasy	en	45	\N	1	26	0
43	\N	Naamah's Gift (Moirin)	Jacqueline Carey	Grand Central Publishing	en	45	\N	18	25	1
32	\N	Art of Computer Programming, Volume 1: Fundamental Algorithms	Donald E. Knuth	Addison-Wesley Professional	en	31	\N	2	3	1
47	\N	Der Name des Windes	Patrick Rothfuss	Klett Cotta Verlag	de	47	\N	1	2	0
33	\N	Art of Computer Programming, Volume 2: Seminumerical Algorithms	Donald E. Knuth	Addison-Wesley Professional	en	31	\N	4	5	1
31	\N	Art of Computer Programming, Volumes 1-4A Boxed Set, The (3rd Edition)	Donald E. Knuth	Addison-Wesley Professional	en	31	\N	1	10	0
35	\N	The Art of Computer Programming, Volume 4A: Combinatorial Algorithms, Part 1	Donald E. Knuth	Addison-Wesley Professional	\N	31	\N	8	9	1
30	\N	Kushiel 03. Die Erlösung	Jacqueline Carey	Egmont vgs Verlagsgesell.	de	37	16	6	7	1
48	\N	El Nombre Del Viento / The Name Of The Wind	Patrick Rothfuss	\N	es	48	\N	1	2	0
\.


--
-- Data for Name: title_attribution; Type: TABLE DATA; Schema: public; Owner: -
--

COPY title_attribution (id, title_id, name, url, retrieved) FROM stdin;
\.


--
-- Data for Name: user_info; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_info (id, login_id, real_name, email) FROM stdin;
1	1	Test	test@example.com
2	2	Admin	admin@example.com
3	3	Root	root@example.com
4	4	Moritz	moritz@example.com
\.


--
-- Data for Name: user_login; Type: TABLE DATA; Schema: public; Owner: -
--

COPY user_login (id, name, salt, cost, pw_hash) FROM stdin;
1	test	+\\277\\030\\335\\223\\310\\260^\\336\\275qZ\\272Bd\\306	9	\\374\\240\\015.j\\350\\030v0\\200\\326\\006eL\\307\\256\\360\\313\\\\qI\\035Z
2	admin	\\327\\222\\266\\025t\\034\\213c\\220\\364\\335)FB\\353o	9	\\302\\343b\\371\\332\\344{<\\320\\206\\177\\212\\3511\\245L\\033i\\037\\251\\231\\026U
3	root	\\311 \\024\\357\\006'a'\\206\\337mCO\\304\\033\\304	9	_\\312\\001\\372`\\343\\014\\345;\\017\\236\\367#e\\023\\314\\360\\356s"h%\\343
4	moritz	\\2637\\302h\\245\\355\\200\\257o\\233\\223\\241v\\241#\\364	9	{\\214\\275\\377k\\247\\376G2w\\262:\\212\\022\\303i\\226\\206q{\\370\\264[
\.


--
-- Name: attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY attribution
    ADD CONSTRAINT attribution_pkey PRIMARY KEY (id);


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
-- Name: publication_asin_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_asin_key UNIQUE (asin);


--
-- Name: publication_attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publication_attribution
    ADD CONSTRAINT publication_attribution_pkey PRIMARY KEY (id);


--
-- Name: publication_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_pkey PRIMARY KEY (id);


--
-- Name: title_asin_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_asin_key UNIQUE (asin);


--
-- Name: title_attribution_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY title_attribution
    ADD CONSTRAINT title_attribution_pkey PRIMARY KEY (id);


--
-- Name: title_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_pkey PRIMARY KEY (id);


--
-- Name: user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_info
    ADD CONSTRAINT user_info_pkey PRIMARY KEY (id);


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
-- Name: title_root_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX title_root_id_idx ON title USING btree (root_id);


--
-- Name: attribution_medium_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY attribution
    ADD CONSTRAINT attribution_medium_id_fkey FOREIGN KEY (medium_id) REFERENCES medium(id);


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
-- Name: publication_attribution_publication_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY publication_attribution
    ADD CONSTRAINT publication_attribution_publication_id_fkey FOREIGN KEY (publication_id) REFERENCES publication(id);


--
-- Name: publication_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY publication
    ADD CONSTRAINT publication_title_id_fkey FOREIGN KEY (title_id) REFERENCES title(id);


--
-- Name: title_attribution_title_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY title_attribution
    ADD CONSTRAINT title_attribution_title_id_fkey FOREIGN KEY (title_id) REFERENCES title(id);


--
-- Name: title_root_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_root_id_fkey FOREIGN KEY (root_id) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: title_same_as_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY title
    ADD CONSTRAINT title_same_as_fkey FOREIGN KEY (same_as) REFERENCES title(id) ON DELETE CASCADE;


--
-- Name: user_info_login_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_info
    ADD CONSTRAINT user_info_login_id_fkey FOREIGN KEY (login_id) REFERENCES user_login(id);


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

