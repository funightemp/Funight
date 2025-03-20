CREATE DATABASE postgres
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt-PT'
    LC_CTYPE = 'pt-PT'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

CREATE TABLE IF NOT EXISTS public.discotecas
(
    id integer NOT NULL DEFAULT nextval('discotecas_id_seq'::regclass),
    nome character varying(100) COLLATE pg_catalog."default" NOT NULL,
    endereco text COLLATE pg_catalog."default" NOT NULL,
    telefone character varying(20) COLLATE pg_catalog."default",
    capacidade integer,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT discotecas_pkey PRIMARY KEY (id)
)

CREATE TABLE IF NOT EXISTS public.eventos
(
    id integer NOT NULL DEFAULT nextval('eventos_id_seq'::regclass),
    titulo character varying(150) COLLATE pg_catalog."default" NOT NULL,
    descricao text COLLATE pg_catalog."default",
    data_inicio timestamp without time zone NOT NULL,
    data_fim timestamp without time zone,
    discoteca_id integer,
    url_imagem text COLLATE pg_catalog."default",
    url_ingressos text COLLATE pg_catalog."default",
    fonte fonte_enum,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT eventos_pkey PRIMARY KEY (id),
    CONSTRAINT eventos_discoteca_id_fkey FOREIGN KEY (discoteca_id)
        REFERENCES public.discotecas (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

CREATE TABLE IF NOT EXISTS public.pagamentos
(
    id integer NOT NULL DEFAULT nextval('pagamentos_id_seq'::regclass),
    usuario_id integer,
    reserva_id integer,
    metodo metodo_enum NOT NULL,
    status status_pagamento_enum DEFAULT 'pendente'::status_pagamento_enum,
    valor numeric(10,2) NOT NULL,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pagamentos_pkey PRIMARY KEY (id),
    CONSTRAINT pagamentos_reserva_id_fkey FOREIGN KEY (reserva_id)
        REFERENCES public.reservas (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT pagamentos_usuario_id_fkey FOREIGN KEY (usuario_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

CREATE TABLE IF NOT EXISTS public.reservas
(
    id integer NOT NULL DEFAULT nextval('reservas_id_seq'::regclass),
    usuario_id integer,
    evento_id integer,
    status status_reserva_enum DEFAULT 'pendente'::status_reserva_enum,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reservas_pkey PRIMARY KEY (id),
    CONSTRAINT reservas_evento_id_fkey FOREIGN KEY (evento_id)
        REFERENCES public.eventos (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT reservas_usuario_id_fkey FOREIGN KEY (usuario_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

CREATE TABLE IF NOT EXISTS public.users
(
    id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    nome character varying(100) COLLATE pg_catalog."default" NOT NULL,
    email character varying(100) COLLATE pg_catalog."default" NOT NULL,
    senha_hash text COLLATE pg_catalog."default" NOT NULL,
    tipo_user tipo_user_enum NOT NULL,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT user_pkey PRIMARY KEY (id),
    CONSTRAINT user_email_key UNIQUE (email)
)
