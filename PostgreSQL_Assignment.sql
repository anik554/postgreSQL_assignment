CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    region VARCHAR(50)
);
SELECT * FROM rangers;

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(50),
    discovery_date DATE,
    conservation_status VARCHAR(50)
);
SELECT * FROM species;

CREATE TABLE sightings(
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id) NOT NULL,
    species_id INT REFERENCES species(species_id) NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    "location" VARCHAR(100) NOT NULL,
    notes VARCHAR(50)
);

SELECT * FROM sightings;

INSERT INTO rangers(name,region) VALUES
    ('Alice Green','Northern Hills'),
    ('Bob White','River Delta'),
    ('Carol King','Mountain Range');

INSERT INTO species(common_name,scientific_name,discovery_date,conservation_status) VALUES
    ('Snow Leopard','Panthera uncia','1775-01-01','Endangered'),
    ('Bengal Tiger','Panthera tigris tigris','1758-01-01','Endangered'),
    ('Red Panda','Ailurus fulgens','1825-01-01','Vulnerable'),
    ('Asiatic Elephant','Elephas maximus indicus','1758-01-01','Endangered');

INSERT INTO sightings(ranger_id,species_id,sighting_time,"location",notes) VALUES
    (1,1,'2024-05-10 07:45:00','Peak Ridge','Camera trap image captured'),
    (2,2,'2024-05-12 16:20:00','Bankwood Area','Juvenile seen'),
    (3,3,'2024-05-15 09:10:00','Bamboo Grove East','Feeding observed'),
    (1,2,'2024-05-18 18:30:00','Snowfall Pass',Null);


--> Problem 1
INSERT INTO rangers(name,region) VALUES
    ('Derek Fox','Coastal Plains');

--> Problem 2
SELECT  COUNT(DISTINCT common_name) as unique_species_count FROM species;

--> Problem 3
SELECT * FROM sightings
    WHERE "location" LIKE '%Pass%';

--> Problem 4
SELECT "name",COUNT(*)::INT as total_sightings FROM rangers
    JOIN sightings USING(ranger_id)
    GROUP BY "name";

--> Problem 5
SELECT common_name FROM species
    FULL JOIN sightings USING(species_id)
    WHERE  sighting_id IS NULL;

--> Problem 6
SELECT common_name,sighting_time,"name" FROM species
    JOIN sightings USING(species_id)
    JOIN rangers USING(ranger_id)
    ORDER BY sighting_time DESC
    LIMIT 2;

--> Problem 7
CREATE OR REPLACE FUNCTION update_status(p_year INT)
RETURNS void
LANGUAGE SQL
AS
$$
    UPDATE species SET conservation_status = 'Historic'
        WHERE EXTRACT(year FROM discovery_date) < p_year;
$$;

SELECT update_status(1800);

--> Problem 8
SELECT sighting_id, 
    CASE 
        WHEN CAST(sighting_time as TIME) < '11:59:59' THEN 'Morning'
        WHEN CAST(sighting_time as TIME) >= '12:00:00' AND  CAST(sighting_time as TIME) <= '16:59:59' THEN 'Afternoon'
        WHEN CAST(sighting_time as TIME) > '17:00:00' THEN 'Evening'
    ELSE
        'Normal'
    END as time_of_day FROM sightings;

--> Problem 9
DELETE FROM rangers
    WHERE NOT EXISTS(
        SELECT 1
        FROM sightings
        WHERE sightings.ranger_id = rangers.ranger_id
    );


-- Q: What is PostgreSQL?
-- A: PostgreSQL is powerful object-relational database..which is used in best stucture way to mmanage big data store.

-- Q: What is the purpose of a database schema in PostgreSQL?
-- A: Database schema is a organizing databse objects and making the database more manageable.

-- Q: Explain the Primary Key and Foreign Key concepts in PostgreSQL.
-- A: Primary key means in the table find a row wise data easily. Primary key always be a unique number or mulitiple char,number,symble etc..

-- Q: What is the difference between the VARCHAR and CHAR data types?
-- A: CHAR and VARCHAR is a data type in database. CHAR store in database fix length data where as VARCHAR store depends on variable size.

-- Q: Explain the purpose of the WHERE clause in a SELECT statement.
-- A: Normaly SELECT used when detarmind the need of data on sigle or multiple table whare as WHERE used conditional specific table column of data.

-- Q: What are the LIMIT and OFFSET clauses used for?
-- A: Basically when filtered data on table then how many data show on result that time used LIMIT and OFFSET is number of next occurance data 
      -- according to LIMIT number.

