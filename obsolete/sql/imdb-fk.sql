
-- Name: aka_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY aka
    ADD CONSTRAINT aka_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: color_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY color
    ADD CONSTRAINT color_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: countries_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: directors_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY directors
    ADD CONSTRAINT directors_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: directors_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY directors
    ADD CONSTRAINT directors_pid_fkey FOREIGN KEY (pid) REFERENCES persons(pid) ON DELETE CASCADE;


--
-- Name: episodes_episodeof_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_episodeof_fkey FOREIGN KEY (episodeof) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: episodes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY episodes
    ADD CONSTRAINT episodes_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: genres_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY genres
    ADD CONSTRAINT genres_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: languages_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY languages
    ADD CONSTRAINT languages_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: links_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: links_idlinkedto_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_idlinkedto_fkey FOREIGN KEY (idlinkedto) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: locations_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


--
-- Name: ratings_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dmg
--

ALTER TABLE ONLY ratings
    ADD CONSTRAINT ratings_id_fkey FOREIGN KEY (id) REFERENCES productions(id) ON DELETE CASCADE;


