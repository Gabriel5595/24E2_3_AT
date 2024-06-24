/*
PRIMEIRA MODIFICAÇÃO 1FN
Separação das informações da coluno no_of_sim em diversas outras colunas.
*/
ALTER TABLE mobile_phone_price
ADD COLUMN sim_type VARCHAR(50) NOT NULL,
ADD COLUMN band_3G BOOL,
ADD COLUMN band_4G BOOL,
ADD COLUMN band_5G BOOL,
ADD COLUMN band_VoLTE BOOL,
ADD COLUMN band_Vo5G BOOL;

UPDATE mobile_phone_price
SET
	sim_type = TRIM(SUBSTRING_INDEX(no_of_sim, ',', 1)),
    band_3G = CASE
				WHEN no_of_sim LIKE "%3G%" THEN 1
				ELSE 0
				END,
	band_4G = CASE
				WHEN no_of_sim LIKE "%4G%" THEN 1
				ELSE 0
				END,
	band_5G = CASE
				WHEN no_of_sim LIKE "%5G%" THEN 1
				ELSE 0
				END,
	band_VoLTE = CASE
				WHEN no_of_sim LIKE "%VoLTE%" THEN 1
				ELSE 0
				END,
	band_Vo5G = CASE
				WHEN no_of_sim LIKE "%Vo5G%" THEN 1
				ELSE 0
				END;

/*
SEGUNDA MODIFICAÇÃO 1FN
Separação das informações da coluna screen_resolution em várias outras
*/
ALTER TABLE mobile_phone_price
ADD COLUMN screen_width VARCHAR(50),
ADD COLUMN screen_height VARCHAR(50),
ADD COLUMN screen_feature VARCHAR(50);

UPDATE mobile_phone_price
SET
  screen_width = CASE
					WHEN LOCATE('Full HD', screen_resolution) > 0 THEN 'Full HD'
					WHEN LOCATE('HD+', screen_resolution) > 0 THEN 'HD+'
					ELSE SUBSTRING_INDEX(screen_resolution, ' x ', 1)
				  END,
  screen_height = CASE
					 WHEN LOCATE('Full HD', screen_resolution) > 0 THEN 'Full HD'
					 WHEN LOCATE('HD+', screen_resolution) > 0 THEN 'HD+'
					 WHEN LOCATE('with', screen_resolution) > 0 THEN
					   SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(screen_resolution, ' x ', -1), ' px', 1), ' ', 1)
					 ELSE
					   SUBSTRING_INDEX(SUBSTRING_INDEX(screen_resolution, ' x ', -1), ' px', 1)
				   END,
  screen_feature = CASE
					  WHEN LOCATE('with', screen_resolution) > 0 THEN
						TRIM(SUBSTRING(screen_resolution, LOCATE('with', screen_resolution) + 5))
					  WHEN LOCATE('Full HD', screen_resolution) > 0 THEN
						TRIM(SUBSTRING(screen_resolution, LOCATE('Display with', screen_resolution) + 12))
					  WHEN LOCATE('HD+', screen_resolution) > 0 THEN
						TRIM(SUBSTRING(screen_resolution, LOCATE('Display with', screen_resolution) + 12))
					  ELSE
						NULL
					END;

/*
TERCEIRA MODIFICAÇÃO 1FN
Separação das informações da coluna camera em várias outras
*/
ALTER TABLE mobile_phone_price
ADD COLUMN rear_camera_type VARCHAR(20),
ADD COLUMN rear_camera_1 VARCHAR(255),
ADD COLUMN rear_camera_2 VARCHAR(100),
ADD COLUMN rear_camera_3 VARCHAR(100),
ADD COLUMN front_camera VARCHAR(100);

UPDATE mobile_phone_price
SET
  rear_camera_type = CASE
						WHEN Camera LIKE '%Penta Rear%' THEN 'Penta Rear'
                        WHEN Camera LIKE '%Quad Rear%' THEN 'Quad Rear'
						WHEN Camera LIKE '%Triple Rear%' THEN 'Triple Rear'
						WHEN Camera LIKE '%Dual Rear%' THEN 'Dual Rear'
						WHEN Camera LIKE '%Rear%' THEN 'Single Rear'
						ELSE NULL
                    END,
  rear_camera_1 = CASE
						WHEN Camera LIKE '%Quad Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', 1), ' MP', 1)
						WHEN Camera LIKE '%Triple Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', 1), ' MP', 1)
                        WHEN Camera LIKE '%Dual Rear%' AND Camera LIKE '%Dual Front%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', 1), ' MP', 1)
                        WHEN Camera LIKE '%Dual Rear%' AND Camera LIKE '%Depth Sensor%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', 1), ' MP', 1)
                        WHEN Camera LIKE '%Dual Rear%' AND Camera LIKE '%Macro%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', 1), ' MP', 1)
						WHEN Camera LIKE '%Dual Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', -1), ' MP', 1)
						WHEN Camera LIKE '%Rear%' THEN SUBSTRING_INDEX(camera, ' MP', 1)
						ELSE NULL
					END,
  rear_camera_2 = CASE
						WHEN Camera LIKE '%Penta Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' &amp; ', -1), ' MP', 1)
						WHEN Camera LIKE '%Triple Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', 2), ' MP', 1)
                        WHEN Camera LIKE '%Dual Rear%' AND  Camera LIKE '%Dual Front%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', 2), ' MP', 1)
                        WHEN Camera LIKE '%Dual Rear%' AND  Camera LIKE '%Depth Sensor%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', -1), ' Dual Rear', 1)
                        WHEN Camera LIKE '%Dual Rear%' AND Camera LIKE '%Macro%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', -1), ' Dual Rear', 1)
						WHEN Camera LIKE '%Dual Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', -1), ' MP', 1)
						ELSE NULL
					END,
  rear_camera_3 = CASE
						WHEN Camera LIKE '%Triple Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', -2), ' MP', 1)
						ELSE NULL
					END,
  front_camera = CASE
						WHEN Camera LIKE '%Dual Front%' AND Camera LIKE '%Quad Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(Camera, ' &amp; ', -1), ' MP Dual Front', 1)
						WHEN Camera LIKE '%Dual Front%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, ' + ', -1), ' MP Dual Front', 1)
						WHEN Camera LIKE '%Front Camera%' THEN 
							CASE
								WHEN Camera LIKE '% MP Front Camera%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(camera, '&amp;', -1), ' MP', 1)
								ELSE NULL
							END
						ELSE NULL
					END
WHERE
	(Camera NOT LIKE '%Dual Display%'
	OR Camera NOT LIKE '%Foldable Display%'
	OR Camera NOT LIKE '%Foldable Display, Dual Display%')
	AND (Camera LIKE '%Triple Rear%'
		OR Camera LIKE '%Dual Rear%'
		OR Camera LIKE '%Rear%');

UPDATE mobile_phone_price
SET
  rear_camera_type = CASE
						WHEN External_Memory LIKE '%Penta Rear%' THEN 'Penta Rear'
                        WHEN External_Memory LIKE '%Quad Rear%' THEN 'Quad Rear'
						WHEN External_Memory LIKE '%Triple Rear%' THEN 'Triple Rear'
						WHEN External_Memory LIKE '%Dual Rear%' THEN 'Dual Rear'
						WHEN External_Memory LIKE '%Rear%' THEN 'Single Rear'
						ELSE NULL
                    END,
  rear_camera_1 = CASE
						WHEN External_Memory LIKE '%Quad Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', 1), ' MP', 1)
						WHEN External_Memory LIKE '%Triple Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', 1), ' MP', 1)
                        WHEN External_Memory LIKE '%Dual Rear%' AND External_Memory LIKE '%Dual Front%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', 1), ' MP', 1)
                        WHEN External_Memory LIKE '%Dual Rear%' AND External_Memory LIKE '%Depth Sensor%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', 1), ' MP', 1)
                        WHEN External_Memory LIKE '%Dual Rear%' AND External_Memory LIKE '%Macro%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', 1), ' MP', 1)
						WHEN External_Memory LIKE '%Dual Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', -1), ' MP', 1)
						WHEN External_Memory LIKE '%Rear%' THEN SUBSTRING_INDEX(camera, ' MP', 1)
						ELSE NULL
					END,
  rear_camera_2 = CASE
						WHEN External_Memory LIKE '%Penta Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' &amp; ', -1), ' MP', 1)
						WHEN External_Memory LIKE '%Triple Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', 2), ' MP', 1)
                        WHEN External_Memory LIKE '%Dual Rear%' AND External_Memory LIKE '%Dual Front%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', 2), ' MP', 1)
                        WHEN External_Memory LIKE '%Dual Rear%' AND External_Memory LIKE '%Depth Sensor%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', -1), ' Dual Rear', 1)
                        WHEN External_Memory LIKE '%Dual Rear%' AND External_Memory LIKE '%Macro%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', -1), ' Dual Rear', 1)
						WHEN External_Memory LIKE '%Dual Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', -1), ' MP', 1)
						ELSE NULL
					END,
  rear_camera_3 = CASE
						WHEN External_Memory LIKE '%Triple Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', -2), ' MP', 1)
						ELSE NULL
					END,
  front_camera = CASE
						WHEN External_Memory LIKE '%Dual Front%' AND External_Memory LIKE '%Quad Rear%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' &amp; ', -1), ' MP Dual Front', 1)
						WHEN External_Memory LIKE '%Dual Front%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, ' + ', -1), ' MP Dual Front', 1)
						WHEN External_Memory LIKE '%Front Camera%' THEN 
							CASE
								WHEN External_Memory LIKE '% MP Front Camera%' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(External_Memory, '&amp;', -1), ' MP', 1)
								ELSE NULL
							END
						ELSE NULL
					END
WHERE
	(External_Memory NOT LIKE '%Dual Display%'
    OR External_Memory NOT LIKE '%Foldable Display%'
    OR External_Memory NOT LIKE '%Foldable Display, Dual Display%')
    AND (External_Memory LIKE '%Triple Rear%'
       OR External_Memory LIKE '%Dual Rear%'
       OR External_Memory LIKE '%Rear%');

UPDATE mobile_phone_price
SET
  rear_camera_type = NULL,
  rear_camera_1 = NULL,
  rear_camera_2 = NULL,
  rear_camera_3 = NULL,
  front_camera = NULL
WHERE
  External_Memory LIKE '%Dual Display%'
  OR External_Memory LIKE '%Foldable Display%';

/*
QUARTA MODIFICAÇÃO 1FN
Separação das informações da coluna memory_card em várias outras
*/
ALTER TABLE mobile_phone_price
ADD COLUMN memory_card VARCHAR(50),
ADD COLUMN memory_card_size VARCHAR(20);

UPDATE mobile_phone_price
SET
	memory_card = CASE
					WHEN external_memory LIKE "%Memory Card Supported%" THEN "Memory Card Supported"
                    WHEN external_memory LIKE "%Memory Card (Hybrid)%" THEN "Memory Card (Hybrid)"
                    ELSE NULL
				END,
	memory_card_size = CASE
					WHEN external_memory LIKE "%, %" THEN SUBSTRING_INDEX(external_memory, ", ", -1)
                    ELSE NULL
				END;

/*
QUINTA MODIFICAÇÃO 1FN
Separação das informações da coluna display em várias outras
*/
ALTER TABLE mobile_phone_price
ADD COLUMN display_type VARCHAR(100),
ADD COLUMN display_size VARCHAR(20);

UPDATE mobile_phone_price
SET
	display_type = CASE
						WHEN Camera LIKE "%Foldable Display%" AND Camera LIKE "%Dual Display%" THEN "Foldable and Dual"
						WHEN Camera LIKE "%Foldable Display%" THEN "Foldable"
						WHEN Camera LIKE "%Dual Display%" THEN "Dual"
						ELSE "Regular"
					END,
	display_size = CASE
						WHEN display LIKE "%inches%" THEN display
                        ELSE NULL
					END;

/*ELIMINAÇÃO DE COLUNAS CORRIGIDAS*/
ALTER TABLE mobile_phone_price DROP COLUMN screen_resolution;
ALTER TABLE mobile_phone_price DROP COLUMN camera;
ALTER TABLE mobile_phone_price DROP COLUMN external_memory;
ALTER TABLE mobile_phone_price DROP COLUMN display;
ALTER TABLE mobile_phone_price DROP COLUMN no_of_sim;

/*CORREÇÃO DE DADOS DE COLINAS ORIGINAIS REMANESCENTES*/
UPDATE mobile_phone_price
SET ram = CASE
    WHEN INSTR(ram, 'RAM') = 0 THEN NULL
    ELSE ram
END;

UPDATE mobile_phone_price
SET Battery = CASE
    WHEN INSTR(Battery, 'Battery') = 0 THEN NULL
    ELSE Battery
END;

UPDATE mobile_phone_price
SET Inbuilt_memory = CASE
    WHEN INSTR(Inbuilt_memory, 'inbuilt') = 0 THEN NULL
    ELSE Inbuilt_memory
END;

UPDATE mobile_phone_price
SET fast_charging = CASE
    WHEN INSTR(fast_charging, 'Charging') = 0 THEN NULL
    ELSE fast_charging
END;

SELECT * FROM mobile_phone_price;

/*RECONSTRUÇÃO DO BACKUP*/
DROP TABLE mobile_phone_price;
CREATE TABLE mobile_phone_price LIKE mobile_phone_price_BACKUP;
INSERT INTO mobile_phone_price SELECT * FROM mobile_phone_price_BACKUP;
SELECT * FROM mobile_phone_price;

SELECT * FROM mobile_phone_price;
SELECT * FROM mobile_phone_price_backup;
