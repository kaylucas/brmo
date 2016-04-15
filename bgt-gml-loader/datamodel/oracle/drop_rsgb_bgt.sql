DELETE FROM USER_SDO_GEOM_METADATA;

 BEGIN
    FOR c IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE ('DROP TABLE ' || c.table_name || ' CASCADE CONSTRAINTS');
    END LOOP;
END;

