--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aka; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE aka (
    id character varying(400) NOT NULL,
    akaid character varying(400) NOT NULL,
    note character varying(800) NOT NULL
);


ALTER TABLE public.aka OWNER TO dmg;

--
-- Name: color; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE color (
    id character varying(400) NOT NULL,
    color character varying NOT NULL,
    note character varying NOT NULL
);


ALTER TABLE public.color OWNER TO dmg;

ALTER TABLE ONLY color
    ADD CONSTRAINT color_pkey PRIMARY KEY (id, color, note);

--
-- Name: countries; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE countries (
    id character varying(400) NOT NULL,
    country character varying(100) NOT NULL
);


ALTER TABLE public.countries OWNER TO dmg;

--
-- Name: directors; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE directors (
    id character varying(400) NOT NULL,
    pid character varying(200) NOT NULL,
    dnote character varying(500) NOT NULL
);


ALTER TABLE public.directors OWNER TO dmg;

--
-- Name: episodes; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE episodes (
    id character varying(400) NOT NULL,
    subtitle character varying(400),
    season integer,
    epnumber integer,
    episodeof character varying(400)
);


ALTER TABLE public.episodes OWNER TO dmg;

--
-- Name: genres; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE genres (
    id character varying(310) NOT NULL,
    genre character varying(20) NOT NULL
);


ALTER TABLE public.genres OWNER TO dmg;

--
-- Name: languages; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE languages (
    id character varying(400) NOT NULL,
    language character varying NOT NULL,
    note character varying NOT NULL
);


ALTER TABLE public.languages OWNER TO dmg;

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id, language, note);

--
-- Name: links; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE links (
    id character varying(400) NOT NULL,
    idlinkedto character varying(400) NOT NULL,
    relationship character varying(30) NOT NULL
);


ALTER TABLE public.links OWNER TO dmg;

--
-- Name: locations; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE locations (
    id character varying(400) NOT NULL,
    country character varying(100) NOT NULL,
    location character varying(1000) NOT NULL,
    note character varying(500) NOT NULL
);


ALTER TABLE public.locations OWNER TO dmg;

--
-- Name: persons; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE persons (
    pid character varying(200) NOT NULL,
    lastname character varying(150),
    firstname character varying(100),
    pindex character varying(10),
    gender character(1)
);


ALTER TABLE public.persons OWNER TO dmg;

--
-- Name: productions; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE productions (
    id character varying(400) NOT NULL,
    title character varying(250),
    year integer,
    index character varying(5),
    notes character varying(500),
    attr character varying(10)
);


ALTER TABLE public.productions OWNER TO dmg;

--
-- Name: ratings; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE ratings (
    id character varying(400) NOT NULL,
    dist character(10),
    votes integer,
    rank double precision
);


ALTER TABLE public.ratings OWNER TO dmg;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: dmg; Tablespace: 
--

CREATE TABLE roles (
    id character varying(400) NOT NULL,
    pid character varying(200) NOT NULL,
    "character" character varying(1000) NOT NULL,
    billing integer,
    snote character varying(200)
);


ALTER TABLE public.roles OWNER TO dmg;

--
-- Name: aka_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY aka
    ADD CONSTRAINT aka_pkey PRIMARY KEY (id, akaid, note);


--
-- Name: color_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY color
    ADD CONSTRAINT color_pkey PRIMARY KEY (id, color, note);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id, country);


--
-- Name: directors_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY directors
    ADD CONSTRAINT directors_pkey PRIMARY KEY (id, pid, dnote);


--
-- Name: episodes_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_pkey PRIMARY KEY (id);


--
-- Name: genres_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_pkey PRIMARY KEY (id, genre);


--
-- Name: languages_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id, language, note);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id, idlinkedto, relationship);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id, country, location, note);


--
-- Name: personskey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY persons
    ADD CONSTRAINT personskey PRIMARY KEY (pid);


--
-- Name: productionskey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY productions
    ADD CONSTRAINT productionskey PRIMARY KEY (id);

ALTER TABLE productions CLUSTER ON productionskey;


--
-- Name: ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: dmg; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id, pid, "character");


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: aka; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE aka FROM PUBLIC;
REVOKE ALL ON TABLE aka FROM dmg;
GRANT ALL ON TABLE aka TO dmg;
GRANT SELECT ON TABLE aka TO PUBLIC;


--
-- Name: color; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE color FROM PUBLIC;
REVOKE ALL ON TABLE color FROM dmg;
GRANT ALL ON TABLE color TO dmg;
GRANT SELECT ON TABLE color TO PUBLIC;


--
-- Name: countries; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE countries FROM PUBLIC;
REVOKE ALL ON TABLE countries FROM dmg;
GRANT ALL ON TABLE countries TO dmg;
GRANT SELECT ON TABLE countries TO PUBLIC;


--
-- Name: directors; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE directors FROM PUBLIC;
REVOKE ALL ON TABLE directors FROM dmg;
GRANT ALL ON TABLE directors TO dmg;
GRANT SELECT ON TABLE directors TO PUBLIC;


--
-- Name: episodes; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE episodes FROM PUBLIC;
REVOKE ALL ON TABLE episodes FROM dmg;
GRANT ALL ON TABLE episodes TO dmg;
GRANT SELECT ON TABLE episodes TO PUBLIC;


--
-- Name: genres; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE genres FROM PUBLIC;
REVOKE ALL ON TABLE genres FROM dmg;
GRANT ALL ON TABLE genres TO dmg;
GRANT SELECT ON TABLE genres TO PUBLIC;


--
-- Name: languages; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE languages FROM PUBLIC;
REVOKE ALL ON TABLE languages FROM dmg;
GRANT ALL ON TABLE languages TO dmg;
GRANT SELECT ON TABLE languages TO PUBLIC;


--
-- Name: links; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE links FROM PUBLIC;
REVOKE ALL ON TABLE links FROM dmg;
GRANT ALL ON TABLE links TO dmg;
GRANT SELECT ON TABLE links TO PUBLIC;


--
-- Name: locations; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE locations FROM PUBLIC;
REVOKE ALL ON TABLE locations FROM dmg;
GRANT ALL ON TABLE locations TO dmg;
GRANT SELECT ON TABLE locations TO PUBLIC;


--
-- Name: persons; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE persons FROM PUBLIC;
REVOKE ALL ON TABLE persons FROM dmg;
GRANT ALL ON TABLE persons TO dmg;
GRANT SELECT ON TABLE persons TO PUBLIC;


--
-- Name: productions; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE productions FROM PUBLIC;
REVOKE ALL ON TABLE productions FROM dmg;
GRANT ALL ON TABLE productions TO dmg;
GRANT SELECT ON TABLE productions TO PUBLIC;


--
-- Name: ratings; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE ratings FROM PUBLIC;
REVOKE ALL ON TABLE ratings FROM dmg;
GRANT ALL ON TABLE ratings TO dmg;
GRANT SELECT ON TABLE ratings TO PUBLIC;


--
-- Name: roles; Type: ACL; Schema: public; Owner: dmg
--

REVOKE ALL ON TABLE roles FROM PUBLIC;
REVOKE ALL ON TABLE roles FROM dmg;
GRANT ALL ON TABLE roles TO dmg;
GRANT SELECT ON TABLE roles TO PUBLIC;


--
-- PostgreSQL database dump complete
--

