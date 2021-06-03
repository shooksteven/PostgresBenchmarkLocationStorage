CREATE DATABASE benchmarkdb
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8';

\connect benchmarkdb

CREATE SCHEMA appdata
    AUTHORIZATION postgres;

COMMENT ON SCHEMA appdata
    IS 'contains actual application data';


-- Automatically updates the last_updated timestamp whenever a row is updated.
CREATE FUNCTION appdata.update_last_updated() RETURNS trigger
   LANGUAGE plpgsql AS
$$BEGIN
   NEW.last_updated := current_timestamp;
   RETURN NEW;
END;$$;

-- JSONB String Test--
CREATE TABLE appdata.json_string (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    locations JSONB,
    created_time timestamptz NOT NULL DEFAULT current_timestamp,
	last_updated timestamptz NULL DEFAULT NULL,
    PRIMARY KEY(id)
);

CREATE TRIGGER json_string_last_updated_trigger
   BEFORE UPDATE ON appdata.json_string
   FOR EACH ROW
   EXECUTE PROCEDURE appdata.update_last_updated();

-- JSONB Object Test--
CREATE TABLE appdata.json_object (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    locations JSONB,
    created_time timestamptz NOT NULL DEFAULT current_timestamp,
	last_updated timestamptz NULL DEFAULT NULL,
    PRIMARY KEY(id)
);

CREATE TRIGGER json_object_last_updated_trigger
   BEFORE UPDATE ON appdata.json_object
   FOR EACH ROW
   EXECUTE PROCEDURE appdata.update_last_updated();

-- Columns Test --
CREATE TABLE appdata.columns (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    latitude numeric,
    longitude numeric,
    altitutde numeric,
	floor numeric,
	horizontalaccuracy numeric,
	verticalaccuracy numeric,
	speedaccuracy numeric,
	courseaccuracy numeric,
	timestamp numeric,
    created_time timestamptz NOT NULL DEFAULT current_timestamp,
	last_updated timestamptz NULL DEFAULT NULL,
    PRIMARY KEY(id)
);

CREATE TRIGGER columns_last_updated_trigger
   BEFORE UPDATE ON appdata.columns
   FOR EACH ROW
   EXECUTE PROCEDURE appdata.update_last_updated();

-- Arrays test --
CREATE TABLE appdata.arrays (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    locations TEXT[],
    created_time timestamptz NOT NULL DEFAULT current_timestamp,
	last_updated timestamptz NULL DEFAULT NULL,
    PRIMARY KEY(id)
);

CREATE TRIGGER arrays_last_updated_trigger
   BEFORE UPDATE ON appdata.arrays
   FOR EACH ROW
   EXECUTE PROCEDURE appdata.update_last_updated();


CREATE OR REPLACE FUNCTION profile(
      IN query text,
      OUT total_cost double precision,
      OUT runtime double precision
   ) RETURNS record
  LANGUAGE plpgsql STRICT AS
$$DECLARE
   j json;
BEGIN
   EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) ' || query INTO j;
   total_cost := (j->0->'Plan'->>'Total Cost')::double precision;
   runtime := (j->0->'Plan'->>'Actual Total Time')::double precision;
   RETURN;
END;$$;


CREATE TABLE appdata.json_string_results (id BIGINT GENERATED ALWAYS AS IDENTITY, total_cost double precision, runtime double precision);
CREATE TABLE appdata.json_object_results (id BIGINT GENERATED ALWAYS AS IDENTITY, total_cost double precision, runtime double precision);
CREATE TABLE appdata.columns_results (id BIGINT GENERATED ALWAYS AS IDENTITY, total_cost double precision, runtime double precision);
CREATE TABLE appdata.arrays_results (id BIGINT GENERATED ALWAYS AS IDENTITY, total_cost double precision, runtime double precision);
CREATE TABLE appdata.results (id BIGINT GENERATED ALWAYS AS IDENTITY, test_name TEXT, avg_total_cost double precision, avg_runtime double precision, median_total_cost double precision, median_runtime double precision);
