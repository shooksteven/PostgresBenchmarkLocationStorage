
-- == JSONB String Test == --
-- INSERT INTO appdata.json_string (locations) VALUES ('[]'::jsonb);
-- UPDATE appdata.json_string SET locations = locations || '["{\"stream_token\":\"$tre4mt0k3n\",\"location_data\":{\"coordinate\":{\"latitude\":35.46067,\"longitude\":-89.642334},\"altitude\":3004.8,\"floor\":null,\"horizontal_accuracy\":5,\"vertical_accuracy\":5,\"speed_accuracy\":5,\"course_accuracy\":5,\"timestamp\":1622569606}}"]'::jsonb WHERE ID = 1;
-- SELECT * FROM appdata.json_string;

-- SELECT locations#>>'{0}' FROM appdata.json_string;

do $$
begin
   for counter in 1..1000 loop
  	TRUNCATE appdata.json_string_results;
	INSERT INTO appdata.json_string_results (total_cost, runtime)
	SELECT total_cost, runtime FROM profile($inner$UPDATE appdata.json_string SET locations = locations || '["{\"stream_token\":\"$tre4mt0k3n\",\"location_data\":{\"coordinate\":{\"latitude\":35.46067,\"longitude\":-89.642334},\"altitude\":3004.8,\"floor\":null,\"horizontal_accuracy\":5,\"vertical_accuracy\":5,\"speed_accuracy\":5,\"course_accuracy\":5,\"timestamp\":1622569606}}"]'::jsonb WHERE ID = 1$inner$);
   end loop;
end;
$$;

INSERT INTO appdata.results (test_name, avg_total_cost, avg_runtime, median_total_cost, median_runtime)
SELECT
	'JSONB Strings test',
	AVG(total_cost) AS avg_total_cost,
	AVG(runtime) AS avg_runtime,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY total_cost) AS median_total_cost,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY runtime) AS median_runtime
FROM appdata.json_string_results;


-- == JSONB Object Test == --
-- INSERT INTO appdata.json_object (locations) VALUES ('[]'::jsonb);
-- UPDATE appdata.json_object SET locations = locations || '[{"stream_token":"$tre4mt0k3n","location_data":{"coordinate":{"latitude":35.46067,"longitude":-89.642334},"altitude":3004.8,"floor":null,"horizontal_accuracy":5,"vertical_accuracy":5,"speed_accuracy":5,"course_accuracy":5,"timestamp":1622569606}}]'::jsonb WHERE ID = 1;
-- SELECT * FROM appdata.json_object;

do $$
begin
   for counter in 1..1000 loop
  	TRUNCATE appdata.json_object_results;
	INSERT INTO appdata.json_object_results (total_cost, runtime)
	SELECT total_cost, runtime FROM profile($inner$UPDATE appdata.json_object SET locations = locations || '[{"stream_token":"$tre4mt0k3n","location_data":{"coordinate":{"latitude":35.46067,"longitude":-89.642334},"altitude":3004.8,"floor":null,"horizontal_accuracy":5,"vertical_accuracy":5,"speed_accuracy":5,"course_accuracy":5,"timestamp":1622569606}}]'::jsonb WHERE ID = 1$inner$);
   end loop;
end;
$$;

INSERT INTO appdata.results (test_name, avg_total_cost, avg_runtime, median_total_cost, median_runtime)
SELECT
	'JSONB Objects test',
	AVG(total_cost) AS avg_total_cost,
	AVG(runtime) AS avg_runtime,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY total_cost) AS median_total_cost,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY runtime) AS median_runtime
FROM appdata.json_object_results;


-- == Column Test == --
-- INSERT INTO appdata.columns (latitude, longitude, altitutde, floor, horizontalaccuracy, verticalaccuracy, speedaccuracy, courseaccuracy, timestamp)
-- VALUES (35.46067, -89.642334, 3004.8, NULL, 5, 5, 5, 5, 1622569606);
-- SELECT total_cost, runtime FROM profile($inner$INSERT INTO appdata.columns (latitude, longitude, altitutde, floor, horizontalaccuracy, verticalaccuracy, speedaccuracy, courseaccuracy, timestamp)
-- VALUES (35.46067, -89.642334, 3004.8, NULL, 5, 5, 5, 5, 1622569606)$inner$);

do $$
begin
   for counter in 1..1000 loop
  	TRUNCATE appdata.columns_results;
	INSERT INTO appdata.columns_results (total_cost, runtime)
	SELECT total_cost, runtime FROM profile($inner$INSERT INTO appdata.columns (latitude, longitude, altitutde, floor, horizontalaccuracy, verticalaccuracy, speedaccuracy, courseaccuracy, timestamp)
VALUES (35.46067, -89.642334, 3004.8, NULL, 5, 5, 5, 5, 1622569606)$inner$);
   end loop;
end;
$$;

-- Populate the results
INSERT INTO appdata.results (test_name, avg_total_cost, avg_runtime, median_total_cost, median_runtime)
SELECT
	'Column test',
	AVG(total_cost) AS avg_total_cost,
	AVG(runtime) AS avg_runtime,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY total_cost) AS median_total_cost,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY runtime) AS median_runtime
FROM appdata.columns_results;


-- == String array == --
INSERT INTO appdata.arrays (locations)
VALUES (ARRAY ['']);

-- UPDATE appdata.arrays SET locations = array_append(locations, '{"stream_token":"$tre4mt0k3n","location_data":{"coordinate":{"latitude":35.46067,"longitude":-89.642334},"altitude":3004.8,"floor":null,"horizontal_accuracy":5,"vertical_accuracy":5,"speed_accuracy":5,"course_accuracy":5,"timestamp":1622569606}}')
-- WHERE id=2;

do $$
begin
   for counter in 1..1000 loop
  	TRUNCATE appdata.arrays_results;
	INSERT INTO appdata.arrays_results (total_cost, runtime)
	SELECT total_cost, runtime FROM profile($inner$UPDATE appdata.arrays SET locations = array_append(locations, '{"stream_token":"$tre4mt0k3n","location_data":{"coordinate":{"latitude":35.46067,"longitude":-89.642334},"altitude":3004.8,"floor":null,"horizontal_accuracy":5,"vertical_accuracy":5,"speed_accuracy":5,"course_accuracy":5,"timestamp":1622569606}}')
WHERE id=1$inner$);
   end loop;
end;
$$;

-- Populate the results
INSERT INTO appdata.results (test_name, avg_total_cost, avg_runtime, median_total_cost, median_runtime)
SELECT
	'Arrays test',
	AVG(total_cost) AS avg_total_cost,
	AVG(runtime) AS avg_runtime,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY total_cost) AS median_total_cost,
	percentile_disc(0.5) WITHIN GROUP (ORDER BY runtime) AS median_runtime
FROM appdata.arrays_results;

SELECT * FROM appdata.results;


