--
-- Cleaned PostgreSQL schema & data for sizing_calculator
-- Drops existing tables so you can re-run at any time
--

-- 1) Encoding & defaults
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- 2) Drop any old tables
DROP TABLE IF EXISTS public.onaccess_ipcctv         CASCADE;
DROP TABLE IF EXISTS public.onwatch                 CASCADE;
DROP TABLE IF EXISTS public.onwatch_honeywell_s70   CASCADE;
DROP TABLE IF EXISTS public.onwatch_s70_nogpu       CASCADE;
DROP TABLE IF EXISTS public.onwatch_small_jetsons   CASCADE;

-- 3) Create tables
CREATE TABLE public.onaccess_ipcctv (
    max_streams integer NOT NULL,
    gpu text,
    cpu text,
    memory text,
    os_ssd text,
    sw_ssd text,
    hdd_storage text,
    network text
);

CREATE TABLE public.onwatch (
    max_streams integer NOT NULL,
    gpu text,
    cpu text,
    memory text,
    os_ssd text,
    sw_ssd text,
    hdd_storage text,
    network text
);

CREATE TABLE public.onwatch_honeywell_s70 (
    max_streams integer NOT NULL,
    cpu text,
    memory text,
    os_ssd text,
    sw_ssd text,
    hdd_storage text,
    network text
);

CREATE TABLE public.onwatch_s70_nogpu (
    max_streams integer NOT NULL,
    cpu text,
    memory text,
    ssd text,
    hdd_storage text,
    network text
);

CREATE TABLE public.onwatch_small_jetsons (
    max_streams integer NOT NULL,
    cpu text,
    memory text,
    ssd text,
    hdd_storage text,
    network text,
    jetsons_count integer
);

-- 4) Load data
COPY public.onaccess_ipcctv (max_streams, gpu, cpu, memory, os_ssd, sw_ssd, hdd_storage, network) FROM stdin;
20	1 x NVIDIA A10	2 x Intel Xeon Silver 4214R	96 GB	2 x 512 GB (RAID1)	2 x 1 TB (RAID1)	~8 TB usable 7200 RPM SATA (after RAID)	10G
40	2 x NVIDIA A10	2 x Intel Xeon Silver 4214R	96 GB	2 x 512 GB (RAID1)	2 x 1 TB (RAID1)	~8 TB usable 7200 RPM SATA (after RAID)	10G
60	3 x NVIDIA A10	2 x Intel Xeon Silver 4214R	128 GB	2 x 512 GB (RAID1)	2 x 2 TB (RAID1)	~8 TB usable 7200 RPM SATA (after RAID)	10G
80	4 x NVIDIA A10	2 x Intel Xeon Silver 4214R	128 GB	2 x 512 GB (RAID1)	2 x 2 TB (RAID1)	~8 TB usable 7200 RPM SATA (after RAID)	10G
\.

COPY public.onwatch (max_streams, gpu, cpu, memory, os_ssd, sw_ssd, hdd_storage, network) FROM stdin;
14	1 x NVIDIA A10	2 x Intel Xeon Silver 4214R	96 GB	2 x 512 GB (RAID1)	2 x 1 TB (RAID1)	~8 TB usable 7200 RPM SATA (after RAID)	10G
28	2 x NVIDIA A10	2 x Intel Xeon Silver 4214R	128 GB	2 x 512 GB (RAID1)	2 x 1 TB (RAID1)	~15 TB usable 7200 RPM SATA (after RAID)	10G
42	3 x NVIDIA A10	2 x Intel Xeon Silver 4214R	128 GB	2 x 512 GB (RAID1)	2 x 1 TB (RAID1)	~22 TB usable 7200 RPM SATA (after RAID)	10G
56	4 x NVIDIA A10	2 x Intel Xeon Gold 6230R	128 GB	2 x 512 GB (RAID1)	2 x 2 TB (RAID1)	~29 TB usable 7200 RPM SATA (after RAID)	10G
\.

COPY public.onwatch_honeywell_s70 (max_streams, cpu, memory, os_ssd, sw_ssd, hdd_storage, network) FROM stdin;
15	2 x Intel Xeon Silver 4214R	96 GB	2 x 512 GB (RAID1)	2 x 1 TB (RAID1)	~4 TB usable 7200 RPM SATA (after RAID)	10G
25	2 x Intel Xeon Silver 4214R	96 GB	2 x 512 GB (RAID1)	2 x 1 TB (RAID1)	~4 TB usable 7200 RPM SATA (after RAID)	10G
30	2 x Intel Xeon Silver 4214R	128 GB	2 x 512 GB (RAID1)	2 x 2 TB (RAID1)	~4 TB usable 7200 RPM SATA (after RAID)	10G
100	2 x Intel Xeon Silver 4214R	128 GB	2 x 512 GB (RAID1)	2 x 3 TB (RAID1)	~4 TB usable 7200 RPM SATA (after RAID)	10G
\.

COPY public.onwatch_s70_nogpu (max_streams, cpu, memory, ssd, hdd_storage, network) FROM stdin;
25	Intel Core i7-12700K	64 GB DDR4	2 TB	~4 TB usable 7200 RPM SATA	1G/10G
\.

COPY public.onwatch_small_jetsons (max_streams, cpu, memory, ssd, hdd_storage, network, jetsons_count) FROM stdin;
15	Intel Core i7-12700K	64 GB DDR4	2 TB	~9 TB usable 7200 RPM SATA	1G/10G	3
25	Intel Core i7-12700K	64 GB DDR4	2 TB	~14 TB usable 7200 RPM SATA	1G/10G	5
30	Intel Core i7-12700K	64 GB DDR4	2 TB	~16 TB usable 7200 RPM SATA	1G/10G	6
\.

-- 5) Add primary keys
ALTER TABLE ONLY public.onaccess_ipcctv       ADD CONSTRAINT onaccess_ipcctv_pkey       PRIMARY KEY (max_streams);
ALTER TABLE ONLY public.onwatch               ADD CONSTRAINT onwatch_pkey               PRIMARY KEY (max_streams);
ALTER TABLE ONLY public.onwatch_honeywell_s70 ADD CONSTRAINT onwatch_honeywell_s70_pkey PRIMARY KEY (max_streams);
ALTER TABLE ONLY public.onwatch_s70_nogpu     ADD CONSTRAINT onwatch_s70_nogpu_pkey     PRIMARY KEY (max_streams);
ALTER TABLE ONLY public.onwatch_small_jetsons ADD CONSTRAINT onwatch_small_jetsons_pkey PRIMARY KEY (max_streams);
