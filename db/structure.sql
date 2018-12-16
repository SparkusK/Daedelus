SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: credit_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.credit_notes (
    id bigint NOT NULL,
    creditor_order_id bigint,
    payment_type character varying NOT NULL,
    amount_paid numeric(15,2) DEFAULT 0.0 NOT NULL,
    note character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    invoice_code character varying NOT NULL,
    CONSTRAINT amount_paid_positive CHECK ((amount_paid >= 0.0))
);


--
-- Name: credit_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.credit_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: credit_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.credit_notes_id_seq OWNED BY public.credit_notes.id;


--
-- Name: creditor_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creditor_orders (
    id bigint NOT NULL,
    supplier_id bigint,
    job_id bigint,
    delivery_note character varying,
    date_issued timestamp without time zone NOT NULL,
    value_excluding_tax numeric(15,2) DEFAULT 0.0 NOT NULL,
    tax_amount numeric(15,2) DEFAULT 0.0 NOT NULL,
    value_including_tax numeric(15,2) DEFAULT 0.0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    reference_number character varying NOT NULL,
    CONSTRAINT tax_amount_lt_value_incl CHECK ((tax_amount < value_including_tax)),
    CONSTRAINT tax_amount_positive CHECK ((tax_amount >= 0.0)),
    CONSTRAINT value_excl_lt_value_incl CHECK ((value_excluding_tax < value_including_tax)),
    CONSTRAINT value_excluding_tax_positive CHECK ((value_excluding_tax >= 0.0)),
    CONSTRAINT value_including_tax_positive CHECK ((value_including_tax >= 0.0))
);


--
-- Name: creditor_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.creditor_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: creditor_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.creditor_orders_id_seq OWNED BY public.creditor_orders.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    email character varying,
    phone character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: debtor_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.debtor_orders (
    id bigint NOT NULL,
    customer_id bigint,
    job_id bigint,
    order_number character varying NOT NULL,
    value_including_tax numeric(15,2) DEFAULT 0.0 NOT NULL,
    tax_amount numeric(15,2) DEFAULT 0.0 NOT NULL,
    value_excluding_tax numeric(15,2) DEFAULT 0.0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT tax_amount_lt_value_incl CHECK ((tax_amount < value_including_tax)),
    CONSTRAINT tax_amount_positive CHECK ((tax_amount >= 0.0)),
    CONSTRAINT value_excl_lt_value_incl CHECK ((value_excluding_tax < value_including_tax)),
    CONSTRAINT value_excluding_tax_positive CHECK ((value_excluding_tax >= 0.0)),
    CONSTRAINT value_including_tax_positive CHECK ((value_including_tax >= 0.0))
);


--
-- Name: debtor_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.debtor_orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: debtor_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.debtor_orders_id_seq OWNED BY public.debtor_orders.id;


--
-- Name: debtor_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.debtor_payments (
    id bigint NOT NULL,
    debtor_order_id bigint,
    payment_amount numeric(15,2) DEFAULT 0.0 NOT NULL,
    payment_type character varying NOT NULL,
    note character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    payment_date timestamp without time zone NOT NULL,
    invoice_code character varying NOT NULL,
    CONSTRAINT payment_amount_positive CHECK ((payment_amount >= 0.0))
);


--
-- Name: debtor_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.debtor_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: debtor_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.debtor_payments_id_seq OWNED BY public.debtor_payments.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.employees (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    occupation character varying NOT NULL,
    section_id bigint,
    company_number character varying NOT NULL,
    net_rate numeric(15,2) DEFAULT 0.0 NOT NULL,
    inclusive_rate numeric(15,2) DEFAULT 0.0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    eoc boolean DEFAULT false NOT NULL,
    CONSTRAINT inclusive_rate_positive CHECK ((inclusive_rate >= 0.0)),
    CONSTRAINT net_rate_less_than_inclusive_rate CHECK ((net_rate < inclusive_rate)),
    CONSTRAINT net_rate_positive CHECK ((net_rate >= 0.0))
);


--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.employees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    receive_date date NOT NULL,
    section_id bigint,
    contact_person character varying NOT NULL,
    responsible_person character varying NOT NULL,
    total numeric(15,2) DEFAULT 0.0 NOT NULL,
    work_description character varying NOT NULL,
    jce_number character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    quotation_reference character varying NOT NULL,
    targeted_amount numeric(15,2) DEFAULT 0.0 NOT NULL,
    target_date date NOT NULL,
    is_finished boolean DEFAULT false,
    CONSTRAINT targeted_amount_lte_total CHECK ((targeted_amount <= total)),
    CONSTRAINT targeted_amount_positive CHECK ((targeted_amount >= 0.0)),
    CONSTRAINT total_positive CHECK ((total > 0.0))
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: labor_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.labor_records (
    id bigint NOT NULL,
    employee_id bigint,
    labor_date date NOT NULL,
    hours numeric(6,4) DEFAULT 0.0 NOT NULL,
    normal_time_amount_before_tax numeric(15,2) DEFAULT 0.0 NOT NULL,
    normal_time_amount_after_tax numeric(15,2) DEFAULT 0.0 NOT NULL,
    job_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    section_id bigint,
    overtime_amount_before_tax numeric(15,2) DEFAULT 0 NOT NULL,
    overtime_amount_after_tax numeric(15,2) DEFAULT 0 NOT NULL,
    sunday_time_amount_before_tax numeric(15,2) DEFAULT 0 NOT NULL,
    sunday_time_amount_after_tax numeric(15,2) DEFAULT 0 NOT NULL,
    CONSTRAINT hours_between_0_and_24 CHECK (((hours >= 0.0) AND (hours <= 24.0))),
    CONSTRAINT normal_time_amount_after_tax_positive CHECK ((normal_time_amount_after_tax >= 0.0)),
    CONSTRAINT normal_time_amount_before_tax_positive CHECK ((normal_time_amount_before_tax >= 0.0)),
    CONSTRAINT overtime_amount_after_tax_positive CHECK ((overtime_amount_after_tax >= 0.0)),
    CONSTRAINT overtime_amount_before_tax_positive CHECK ((overtime_amount_before_tax >= 0.0)),
    CONSTRAINT sunday_time_amount_after_tax_positive CHECK ((sunday_time_amount_after_tax >= 0.0)),
    CONSTRAINT sunday_time_amount_before_tax_positive CHECK ((sunday_time_amount_before_tax >= 0.0))
);


--
-- Name: labor_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.labor_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: labor_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.labor_records_id_seq OWNED BY public.labor_records.id;


--
-- Name: managers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.managers (
    id bigint NOT NULL,
    employee_id bigint,
    section_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: managers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.managers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: managers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.managers_id_seq OWNED BY public.managers.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sections (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    overheads numeric(12,2) DEFAULT 0.0 NOT NULL,
    CONSTRAINT overheads_positive CHECK ((overheads >= 0.0))
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.suppliers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    email character varying,
    phone character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: credit_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_notes ALTER COLUMN id SET DEFAULT nextval('public.credit_notes_id_seq'::regclass);


--
-- Name: creditor_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creditor_orders ALTER COLUMN id SET DEFAULT nextval('public.creditor_orders_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: debtor_orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debtor_orders ALTER COLUMN id SET DEFAULT nextval('public.debtor_orders_id_seq'::regclass);


--
-- Name: debtor_payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debtor_payments ALTER COLUMN id SET DEFAULT nextval('public.debtor_payments_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: labor_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labor_records ALTER COLUMN id SET DEFAULT nextval('public.labor_records_id_seq'::regclass);


--
-- Name: managers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managers ALTER COLUMN id SET DEFAULT nextval('public.managers_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: credit_notes credit_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_notes
    ADD CONSTRAINT credit_notes_pkey PRIMARY KEY (id);


--
-- Name: creditor_orders creditor_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creditor_orders
    ADD CONSTRAINT creditor_orders_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: debtor_orders debtor_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debtor_orders
    ADD CONSTRAINT debtor_orders_pkey PRIMARY KEY (id);


--
-- Name: debtor_payments debtor_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debtor_payments
    ADD CONSTRAINT debtor_payments_pkey PRIMARY KEY (id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: labor_records labor_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labor_records
    ADD CONSTRAINT labor_records_pkey PRIMARY KEY (id);


--
-- Name: managers managers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT managers_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_credit_notes_on_creditor_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_credit_notes_on_creditor_order_id ON public.credit_notes USING btree (creditor_order_id);


--
-- Name: index_creditor_orders_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_creditor_orders_on_job_id ON public.creditor_orders USING btree (job_id);


--
-- Name: index_creditor_orders_on_supplier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_creditor_orders_on_supplier_id ON public.creditor_orders USING btree (supplier_id);


--
-- Name: index_debtor_orders_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_debtor_orders_on_customer_id ON public.debtor_orders USING btree (customer_id);


--
-- Name: index_debtor_orders_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_debtor_orders_on_job_id ON public.debtor_orders USING btree (job_id);


--
-- Name: index_debtor_payments_on_debtor_order_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_debtor_payments_on_debtor_order_id ON public.debtor_payments USING btree (debtor_order_id);


--
-- Name: index_employees_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_employees_on_section_id ON public.employees USING btree (section_id);


--
-- Name: index_jobs_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jobs_on_section_id ON public.jobs USING btree (section_id);


--
-- Name: index_labor_records_on_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labor_records_on_employee_id ON public.labor_records USING btree (employee_id);


--
-- Name: index_labor_records_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labor_records_on_job_id ON public.labor_records USING btree (job_id);


--
-- Name: index_labor_records_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_labor_records_on_section_id ON public.labor_records USING btree (section_id);


--
-- Name: index_managers_on_employee_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managers_on_employee_id ON public.managers USING btree (employee_id);


--
-- Name: index_managers_on_section_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_managers_on_section_id ON public.managers USING btree (section_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: debtor_payments fk_rails_060c4f2f47; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debtor_payments
    ADD CONSTRAINT fk_rails_060c4f2f47 FOREIGN KEY (debtor_order_id) REFERENCES public.debtor_orders(id) ON DELETE CASCADE;


--
-- Name: managers fk_rails_11c969110a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT fk_rails_11c969110a FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: jobs fk_rails_14b1e351b2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT fk_rails_14b1e351b2 FOREIGN KEY (section_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: creditor_orders fk_rails_1b63abbc0e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creditor_orders
    ADD CONSTRAINT fk_rails_1b63abbc0e FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE CASCADE;


--
-- Name: employees fk_rails_238d677ff2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT fk_rails_238d677ff2 FOREIGN KEY (section_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: managers fk_rails_374abe6c6d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.managers
    ADD CONSTRAINT fk_rails_374abe6c6d FOREIGN KEY (section_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: creditor_orders fk_rails_6cf49229ad; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creditor_orders
    ADD CONSTRAINT fk_rails_6cf49229ad FOREIGN KEY (supplier_id) REFERENCES public.suppliers(id) ON DELETE CASCADE;


--
-- Name: debtor_orders fk_rails_a553e29ce2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debtor_orders
    ADD CONSTRAINT fk_rails_a553e29ce2 FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE CASCADE;


--
-- Name: labor_records fk_rails_c515429342; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labor_records
    ADD CONSTRAINT fk_rails_c515429342 FOREIGN KEY (job_id) REFERENCES public.jobs(id) ON DELETE CASCADE;


--
-- Name: labor_records fk_rails_c576d4291e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labor_records
    ADD CONSTRAINT fk_rails_c576d4291e FOREIGN KEY (section_id) REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: credit_notes fk_rails_e9e779706e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.credit_notes
    ADD CONSTRAINT fk_rails_e9e779706e FOREIGN KEY (creditor_order_id) REFERENCES public.creditor_orders(id) ON DELETE CASCADE;


--
-- Name: debtor_orders fk_rails_f269618a0f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.debtor_orders
    ADD CONSTRAINT fk_rails_f269618a0f FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON DELETE CASCADE;


--
-- Name: labor_records fk_rails_fba787195c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.labor_records
    ADD CONSTRAINT fk_rails_fba787195c FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180406105542'),
('20180410150747'),
('20180410151053'),
('20180413184024'),
('20180413184041'),
('20180413185612'),
('20180413210414'),
('20180414115224'),
('20180414115243'),
('20180414120127'),
('20180414130120'),
('20180414133015'),
('20180414142719'),
('20180414143300'),
('20180414171811'),
('20180414172832'),
('20180414172918'),
('20180414173122'),
('20180414173201'),
('20180517050323'),
('20180517060020'),
('20180517075004'),
('20180517075006'),
('20180517075012'),
('20180703142656'),
('20180703142718'),
('20180726030823'),
('20180726031320'),
('20180726032832'),
('20180726033945'),
('20180726170139'),
('20180727213641'),
('20180727232426'),
('20180728003252'),
('20180728004532'),
('20180728024646'),
('20180729003418'),
('20180730050405'),
('20180802101159'),
('20180802102359'),
('20180914124539'),
('20180914124547'),
('20180918120354'),
('20180918170652'),
('20180923143507'),
('20180924140134'),
('20180924140142'),
('20180924140732'),
('20180924140930'),
('20180924155133'),
('20180926202514'),
('20180926202525'),
('20180927120242'),
('20180928141926'),
('20180928142246'),
('20180928154931'),
('20180928163946'),
('20181002154640'),
('20181002180310'),
('20181004134654'),
('20181101124400'),
('20181102142539'),
('20181102145106'),
('20181102152923'),
('20181102154157'),
('20181102154206'),
('20181116054556'),
('20181212072435'),
('20181214074645'),
('20181214090630'),
('20181215111652'),
('20181216114822');


