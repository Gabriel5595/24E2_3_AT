USE MODELAGEM_AT;

/*
PRIMEIRA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela SIM_INFO e transferência das colunas sim, band_3G, band_4G, band_5G, band_VoLTE e band_Vo5G.
Conexão entre as tabelas.
*/
CREATE TABLE SIM_INFO (
    sim_id INT AUTO_INCREMENT PRIMARY KEY,
    sim_type VARCHAR(255) NOT NULL,
    band_3g BOOL,
    band_4g BOOL,
    band_5g BOOL,
    band_VoLTE BOOL,
    band_Vo5G BOOL
);

INSERT INTO SIM_INFO (sim_type, band_3g, band_4g, band_5g, band_VoLTE, band_Vo5G)
SELECT DISTINCT sim_type, band_3g, band_4g, band_5g, band_VoLTE, band_Vo5G
FROM mobile_phone_price;

SELECT * FROM sim_info;

/*
Segunda MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela CAMPANIES e transferência da coluna company.
*/
CREATE TABLE COMPANIES (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL
);

INSERT INTO COMPANIES (company_name)
SELECT DISTINCT company
FROM mobile_phone_price;

SELECT * FROM COMPANIES;

/*
TERCEIRA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela RAMS e transferência da coluna ram.
*/
CREATE TABLE RAMS (
    ram_id INT AUTO_INCREMENT PRIMARY KEY,
    ram VARCHAR(50) NOT NULL
);

INSERT INTO RAMS (ram)
SELECT DISTINCT ram
FROM mobile_phone_price
WHERE ram LIKE '%RAM%';

SELECT * FROM RAMS;

/*
QUARTA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela BATTERIES e transferência das colunas battery e fast_charging.
*/
CREATE TABLE BATTERIES (
    battery_id INT AUTO_INCREMENT PRIMARY KEY,
    battery VARCHAR(50),
    fast_charging VARCHAR(50)
);

INSERT INTO BATTERIES (battery, fast_charging)
SELECT DISTINCT battery, fast_charging
FROM mobile_phone_price
WHERE battery LIKE '%Battery%' OR NULL 
AND fast_charging LIKE "%Charging%" OR NULL;

SELECT * FROM BATTERIES;

/*
QUINTA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela DISPLAYS e transferência das colunas display, screen_width, screen_height, screen_feature.
*/
CREATE TABLE DISPLAYS (
    display_id INT AUTO_INCREMENT PRIMARY KEY,
    display_type VARCHAR(100),
    display_size VARCHAR(50),
    screen_width VARCHAR(50),
    screen_height VARCHAR(50),
    screen_feature VARCHAR(50)
);

INSERT INTO DISPLAYS (display_type, display_size, screen_width, screen_height, screen_feature)
SELECT DISTINCT display_type, display_size, screen_width, screen_height, screen_feature
FROM mobile_phone_price;

SELECT * FROM DISPLAYS;

/*
SEXTA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela CAMERAS e transferência das colunas rear_camera_type, rear_camera_1, rear_camera_2, rear_camera_3, front_camera.
*/
CREATE TABLE CAMERAS (
    camera_id INT AUTO_INCREMENT PRIMARY KEY,
    rear_camera_type VARCHAR(100),
    rear_camera_1 VARCHAR(100),
    rear_camera_2 VARCHAR(100),
    rear_camera_3 VARCHAR(100),
    front_camera VARCHAR(100)
);

INSERT INTO CAMERAS (rear_camera_type, rear_camera_1, rear_camera_2, rear_camera_3, front_camera)
SELECT DISTINCT rear_camera_type, rear_camera_1, rear_camera_2, rear_camera_3, front_camera
FROM mobile_phone_price;

SELECT * FROM CAMERAS;

/*
SÉTIMA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela MEMORIES e transferência das colunas memory_card, memory_card_size, inbuilt_memory.
*/
CREATE TABLE MEMORIES (
    memory_id INT AUTO_INCREMENT PRIMARY KEY,
    memory_card VARCHAR(50),
    memory_card_size VARCHAR(50),
    inbuilt_memory VARCHAR(50)
);

INSERT INTO MEMORIES (memory_card, memory_card_size, inbuilt_memory)
SELECT DISTINCT memory_card, memory_card_size, inbuilt_memory
FROM mobile_phone_price
WHERE inbuilt_memory LIKE "%inbuilt%" OR NULL;

SELECT * FROM MEMORIES;

/*
OITAVA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela PROCESSORS e transferência das colunas processor e processor_name.
*/
CREATE TABLE PROCESSORS (
    processor_id INT AUTO_INCREMENT PRIMARY KEY,
    processor VARCHAR(50),
    processor_name VARCHAR(50)
);

INSERT INTO PROCESSORS (processor, processor_name)
SELECT DISTINCT processor, processor_name
FROM mobile_phone_price;

SELECT * FROM PROCESSORS;

/*
NONA MODIFICAÇÃO 2FN
Cópia das informações da tabela principal para as tabelas auxiliares

Criação de tabela SPECS e transferência das colunas spec_score e android_version.
*/
CREATE TABLE SPECS (
    spec_id INT PRIMARY KEY AUTO_INCREMENT,
    spec_score DECIMAL(5,2),
    android_version VARCHAR(20),
    sim_id INT,
    ram_id INT,
    battery_id INT,
    display_id INT,
    camera_id INT,
    memory_id INT,
    processor_id INT,
    FOREIGN KEY (sim_id) REFERENCES SIM_INFO(sim_id),
    FOREIGN KEY (ram_id) REFERENCES RAMS(ram_id),
    FOREIGN KEY (battery_id) REFERENCES BATTERIES(battery_id),
    FOREIGN KEY (display_id) REFERENCES DISPLAYS(display_id),
    FOREIGN KEY (camera_id) REFERENCES CAMERAS(camera_id),
    FOREIGN KEY (memory_id) REFERENCES MEMORIES(memory_id),
    FOREIGN KEY (processor_id) REFERENCES PROCESSORS(processor_id)
);

/*Alteração da tabela MOBILE_PHONE_PRICE para contar as conexões com as tabelas SPECS e COMPANIES*/
ALTER TABLE MOBILE_PHONE_PRICE
ADD COLUMN spec_id INT,
ADD COLUMN company_id INT,
ADD CONSTRAINT fk_spec_id
    FOREIGN KEY (spec_id) REFERENCES SPECS(spec_id),
ADD CONSTRAINT fk_company_id
    FOREIGN KEY (company_id) REFERENCES COMPANIES(company_id);

/*Inserção dos dados das outras tabelas na tabela SPECS*/
INSERT INTO SPECS (spec_score, android_version, sim_id, ram_id, battery_id, display_id, camera_id, memory_id, processor_id)
SELECT DISTINCT
    MOBILE_PHONE_PRICE.spec_score,
    MOBILE_PHONE_PRICE.android_version,
    SIM_INFO.sim_id,
    RAMS.ram_id,
    BATTERIES.battery_id,
    DISPLAYS.display_id,
    CAMERAS.camera_id,
    MEMORIES.memory_id,
    PROCESSORS.processor_id
FROM MOBILE_PHONE_PRICE
JOIN SIM_INFO ON MOBILE_PHONE_PRICE.sim_type = SIM_INFO.sim_type
JOIN RAMS ON MOBILE_PHONE_PRICE.ram = RAMS.ram
JOIN BATTERIES ON MOBILE_PHONE_PRICE.battery = BATTERIES.battery AND MOBILE_PHONE_PRICE.fast_charging = BATTERIES.fast_charging
JOIN DISPLAYS ON MOBILE_PHONE_PRICE.display_type = DISPLAYS.display_type AND MOBILE_PHONE_PRICE.display_size = DISPLAYS.display_size
JOIN CAMERAS ON MOBILE_PHONE_PRICE.rear_camera_type = CAMERAS.rear_camera_type AND MOBILE_PHONE_PRICE.rear_camera_1 = CAMERAS.rear_camera_1 AND MOBILE_PHONE_PRICE.rear_camera_2 = CAMERAS.rear_camera_2 AND MOBILE_PHONE_PRICE.rear_camera_3 = CAMERAS.rear_camera_3 AND MOBILE_PHONE_PRICE.front_camera = CAMERAS.front_camera
JOIN MEMORIES ON MOBILE_PHONE_PRICE.memory_card = MEMORIES.memory_card AND MOBILE_PHONE_PRICE.memory_card_size = MEMORIES.memory_card_size AND MOBILE_PHONE_PRICE.inbuilt_memory = MEMORIES.inbuilt_memory
JOIN PROCESSORS ON MOBILE_PHONE_PRICE.processor_name = PROCESSORS.processor_name;

/*Atualização dos valores do campo spec_id na tabela MOBILE_PHONE_PRICE de acordo com os valores das colunas ainda presentes na tabela original*/
UPDATE MOBILE_PHONE_PRICE
JOIN SIM_INFO ON MOBILE_PHONE_PRICE.sim_type = SIM_INFO.sim_type
JOIN RAMS ON MOBILE_PHONE_PRICE.ram = RAMS.ram
JOIN BATTERIES ON MOBILE_PHONE_PRICE.battery = BATTERIES.battery AND MOBILE_PHONE_PRICE.fast_charging = BATTERIES.fast_charging
JOIN DISPLAYS ON MOBILE_PHONE_PRICE.display_type = DISPLAYS.display_type AND MOBILE_PHONE_PRICE.display_size = DISPLAYS.display_size
JOIN CAMERAS ON MOBILE_PHONE_PRICE.rear_camera_type = CAMERAS.rear_camera_type AND MOBILE_PHONE_PRICE.rear_camera_1 = CAMERAS.rear_camera_1 AND MOBILE_PHONE_PRICE.rear_camera_2 = CAMERAS.rear_camera_2 AND MOBILE_PHONE_PRICE.rear_camera_3 = CAMERAS.rear_camera_3 AND MOBILE_PHONE_PRICE.front_camera = CAMERAS.front_camera
JOIN MEMORIES ON MOBILE_PHONE_PRICE.memory_card = MEMORIES.memory_card AND MOBILE_PHONE_PRICE.memory_card_size = MEMORIES.memory_card_size AND MOBILE_PHONE_PRICE.inbuilt_memory = MEMORIES.inbuilt_memory
JOIN PROCESSORS ON MOBILE_PHONE_PRICE.processor_name = PROCESSORS.processor_name
JOIN SPECS ON MOBILE_PHONE_PRICE.spec_score = SPECS.spec_score
    AND MOBILE_PHONE_PRICE.android_version = SPECS.android_version
    AND SIM_INFO.sim_id = SPECS.sim_id
    AND RAMS.ram_id = SPECS.ram_id
    AND BATTERIES.battery_id = SPECS.battery_id
    AND DISPLAYS.display_id = SPECS.display_id
    AND CAMERAS.camera_id = SPECS.camera_id
    AND MEMORIES.memory_id = SPECS.memory_id
    AND PROCESSORS.processor_id = SPECS.processor_id
JOIN COMPANIES ON MOBILE_PHONE_PRICE.company = COMPANIES.company_name
SET MOBILE_PHONE_PRICE.spec_id = SPECS.spec_id,
    MOBILE_PHONE_PRICE.company_id = COMPANIES.company_id;

/*Foi necessário aumentar o tempo de timeout para concluir a operação acima*/
SET GLOBAL innodb_lock_wait_timeout = 64000;
SHOW VARIABLES LIKE 'innodb_lock_wait_timeout';

/*ELIMINAÇÃO DE TABELAS DE MOBILE_PHONE_PRICE*/
ALTER TABLE mobile_phone_price DROP COLUMN spec_score;
ALTER TABLE mobile_phone_price DROP COLUMN ram;
ALTER TABLE mobile_phone_price DROP COLUMN battery;
ALTER TABLE mobile_phone_price DROP COLUMN android_version;
ALTER TABLE mobile_phone_price DROP COLUMN company;
ALTER TABLE mobile_phone_price DROP COLUMN Inbuilt_memory;
ALTER TABLE mobile_phone_price DROP COLUMN fast_charging;
ALTER TABLE mobile_phone_price DROP COLUMN Processor;
ALTER TABLE mobile_phone_price DROP COLUMN Processor_name;
ALTER TABLE mobile_phone_price DROP COLUMN sim_type;
ALTER TABLE mobile_phone_price DROP COLUMN band_3G;
ALTER TABLE mobile_phone_price DROP COLUMN band_4G;
ALTER TABLE mobile_phone_price DROP COLUMN band_5G;
ALTER TABLE mobile_phone_price DROP COLUMN band_VoLTE;
ALTER TABLE mobile_phone_price DROP COLUMN band_Vo5G;
ALTER TABLE mobile_phone_price DROP COLUMN screen_width;
ALTER TABLE mobile_phone_price DROP COLUMN screen_height;
ALTER TABLE mobile_phone_price DROP COLUMN screen_feature;
ALTER TABLE mobile_phone_price DROP COLUMN rear_camera_type;
ALTER TABLE mobile_phone_price DROP COLUMN rear_camera_1;
ALTER TABLE mobile_phone_price DROP COLUMN rear_camera_2;
ALTER TABLE mobile_phone_price DROP COLUMN rear_camera_3;
ALTER TABLE mobile_phone_price DROP COLUMN front_camera;
ALTER TABLE mobile_phone_price DROP COLUMN memory_card;
ALTER TABLE mobile_phone_price DROP COLUMN memory_card_size;
ALTER TABLE mobile_phone_price DROP COLUMN display_type;
ALTER TABLE mobile_phone_price DROP COLUMN display_size;

/*RECONSTRUÇÃO DO BACKUP E ELIMINAÇÃO DE TABELAS*/
DROP TABLE CAMERAS;
DROP TABLE COMPANIES;
DROP TABLE BATTERIES;
DROP TABLE MEMORIES;
DROP TABLE DISPLAYS;
DROP TABLE PROCESSORS;
DROP TABLE RAMS;
DROP TABLE SIM_INFO;
DROP TABLE SPECS;

DROP TABLE mobile_phone_price;
CREATE TABLE mobile_phone_price LIKE mobile_phone_price_BACKUP;
INSERT INTO mobile_phone_price SELECT * FROM mobile_phone_price_BACKUP;
SELECT * FROM mobile_phone_price;