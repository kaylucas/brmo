/*
Views for visualizing the bag data.
*/
-- DROP VIEWS
-- DROP VIEW V_ADRES_TOTAAL;
-- DROP VIEW V_ADRES_STANDPLAATS;
-- DROP VIEW V_ADRES_LIGPLAATS;
-- DROP VIEW V_ADRES;
-- DROP VIEW V_LIGPLAATS;
-- DROP VIEW V_STANDPLAATS;
-- DROP VIEW V_LIGPLAATS_ALLES;
-- DROP VIEW V_STANDPLAATS_ALLES;
-- DROP VIEW V_PAND_GEBRUIK_NIET_INGEMETEN;
-- DROP VIEW V_PAND_IN_GEBRUIK;
-- DROP VIEW V_VERBLIJFSOBJECT;
-- DROP VIEW V_VERBLIJFSOBJECT_GEVORMD;
-- DROP VIEW V_VERBLIJFSOBJECT_ALLES;

-------------------------------------------------
-- V_VERBLIJFSOBJECT_ALLES
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_VERBLIJFSOBJECT_ALLES
    (
        OBJECTID,
        FID,
        PAND_ID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        STATUS,
        OPPERVLAKTE,
        THE_GEOM
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER)     AS OBJECTID,
    VBO.SC_IDENTIF              AS FID,
    FKPAND.FK_NN_RH_PND_IDENTIF AS PAND_ID,
    GEM.NAAM                    AS GEMEENTE,
    CASE
         WHEN ADDROBJ.FK_6WPL_IDENTIF IS NOT NULL
         -- opzoeken want in andere woonplaats
         THEN  (SELECT NAAM FROM WNPLTS WHERE IDENTIF = FK_6WPL_IDENTIF)
         ELSE WP.NAAM           
    END                         AS WOONPLAATS,
    GEOR.NAAM_OPENB_RMTE        AS STRAATNAAM,
    ADDROBJ.HUINUMMER           AS HUISNUMMER,
    ADDROBJ.HUISLETTER,
    ADDROBJ.HUINUMMERTOEVOEGING AS HUISNUMMER_TOEV,
    ADDROBJ.POSTCODE,
    VBO.STATUS,
    GOBJ.OPPERVLAKTE_OBJ AS OPPERVLAKTE,
    GOBJ.PUNTGEOM        AS THE_GEOM
FROM
    ((((((((VERBLIJFSOBJ VBO
JOIN
    VERBLIJFSOBJ_PAND FKPAND
ON
    ((FKPAND.FK_NN_LH_VBO_SC_IDENTIF = VBO.SC_IDENTIF)))
JOIN
    GEBOUWD_OBJ GOBJ
ON
    ((GOBJ.SC_IDENTIF = VBO.SC_IDENTIF)))
JOIN
    NUMMERAAND NA
ON
    ((NA.SC_IDENTIF = VBO.FK_11NRA_SC_IDENTIF)))
JOIN
    ADDRESSEERB_OBJ_AAND ADDROBJ
ON
    ((ADDROBJ.IDENTIF = NA.SC_IDENTIF)))
JOIN
    GEM_OPENB_RMTE GEOR
ON
    ((GEOR.IDENTIFCODE = ADDROBJ.FK_7OPR_IDENTIFCODE)))
LEFT JOIN
    OPENB_RMTE_WNPLTS ORWP
ON
    ((GEOR.IDENTIFCODE = ORWP.FK_NN_LH_OPR_IDENTIFCODE)))
LEFT JOIN
    WNPLTS WP
ON
    ((ORWP.FK_NN_RH_WPL_IDENTIF = WP.IDENTIF)))
LEFT JOIN
    GEMEENTE GEM
ON
    ((
            WP.FK_7GEM_CODE = GEM.CODE)))
WHERE
    ((((
                    ADDROBJ.DAT_EIND_GELDH IS NULL)
            AND (
                    GEOR.DATUM_EINDE_GELDH IS NULL))
        AND (
                GEM.DATUM_EINDE_GELDH IS NULL))
    AND (
            GOBJ.DATUM_EINDE_GELDH IS NULL));
-------------------------------------------------
-- V_VERBLIJFSOBJECT_GEVORMD
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_VERBLIJFSOBJECT_GEVORMD
    (
        OBJECTID,
        FID,
        PAND_ID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        --GEBRUIKSDOEL,
        STATUS,
        OPPERVLAKTE,
        THE_GEOM
    ) AS
SELECT
    OBJECTID,
    FID,
    PAND_ID,
    GEMEENTE,
    WOONPLAATS,
    STRAATNAAM,
    HUISNUMMER,
    HUISLETTER,
    HUISNUMMER_TOEV,
    POSTCODE,
    --GEBRUIKSDOEL,
    STATUS,
    OPPERVLAKTE,
    THE_GEOM
FROM
    V_VERBLIJFSOBJECT_ALLES
WHERE
    STATUS = 'Verblijfsobject gevormd';
-------------------------------------------------
-- V_VERBLIJFSOBJECT
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_VERBLIJFSOBJECT
    (
        OBJECTID,
        FID,
        PAND_ID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        --GEBRUIKSDOEL,
        STATUS,
        OPPERVLAKTE,
        THE_GEOM
    ) AS
SELECT
    OBJECTID,
    FID,
    PAND_ID,
    GEMEENTE,
    WOONPLAATS,
    STRAATNAAM,
    HUISNUMMER,
    HUISLETTER,
    HUISNUMMER_TOEV,
    POSTCODE,
    --GEBRUIKSDOEL,
    STATUS,
    OPPERVLAKTE,
    THE_GEOM
FROM
    V_VERBLIJFSOBJECT_ALLES
WHERE
    STATUS = 'Verblijfsobject in gebruik (niet ingemeten)'
OR  STATUS = 'Verblijfsobject in gebruik';
-------------------------------------------------
-- V_PAND_IN_GEBRUIK
-------------------------------------------------
CREATE  OR REPLACE VIEW
    V_PAND_IN_GEBRUIK
    (
        OBJECTID,
        FID,
        EIND_DATUM_GELDIG,
        BEGIN_DATUM_GELDIG,
        STATUS,
        BOUWJAAR,
        THE_GEOM
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    P.IDENTIF               AS FID,
    P.DATUM_EINDE_GELDH     AS EIND_DATUM_GELDIG,
    P.DAT_BEG_GELDH         AS BEGIN_DATUM_GELDIG,
    P.STATUS,
    P.OORSPRONKELIJK_BOUWJAAR AS BOUWJAAR,
    P.GEOM_BOVENAANZICHT      AS THE_GEOM
FROM
    PAND P
WHERE
    STATUS IN ('Sloopvergunning verleend',
               'Pand in gebruik (niet ingemeten)',
               'Pand in gebruik',
               'Bouw gestart')
AND DATUM_EINDE_GELDH IS NULL;
-------------------------------------------------
-- V_PAND_GEBRUIK_NIET_INGEMETEN
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_PAND_GEBRUIK_NIET_INGEMETEN
    (
        OBJECTID,
        FID,
        BEGIN_DATUM_GELDIG,
        STATUS,
        BOUWJAAR,
        THE_GEOM
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    P.IDENTIF               AS FID,
    P.DAT_BEG_GELDH         AS BEGIN_DATUM_GELDIG,
    P.STATUS,
    P.OORSPRONKELIJK_BOUWJAAR AS BOUWJAAR,
    P.GEOM_BOVENAANZICHT      AS THE_GEOM
FROM
    PAND P
WHERE
    STATUS = 'Pand in gebruik (niet ingemeten)'
AND DATUM_EINDE_GELDH IS NULL;
-------------------------------------------------
-- V_STANDPLAATS
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_STANDPLAATS
    (
        OBJECTID,
        SC_IDENTIF,
        STATUS,
        FK_4NRA_SC_IDENTIF,
        DATUM_BEGIN_GELDH,
        GEOMETRIE
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    SP.SC_IDENTIF,
    SP.STATUS,
    SP.FK_4NRA_SC_IDENTIF,
    BT.DAT_BEG_GELDH,
    BT.GEOM AS GEOMETRIE
FROM
    STANDPLAATS SP
LEFT JOIN
    BENOEMD_TERREIN BT
ON
    (
        SP.SC_IDENTIF = BT.SC_IDENTIF);
-------------------------------------------------
-- V_LIGPLAATS
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_LIGPLAATS
    (
        OBJECTID,
        SC_IDENTIF,
        STATUS,
        FK_4NRA_SC_IDENTIF,
        DAT_BEG_GELDH,
        GEOMETRIE
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    LP.SC_IDENTIF,
    LP.STATUS,
    LP.FK_4NRA_SC_IDENTIF,
    BT.DAT_BEG_GELDH,
    BT.GEOM AS GEOMETRIE
FROM
    LIGPLAATS LP
LEFT JOIN
    BENOEMD_TERREIN BT
ON
    (
        LP.SC_IDENTIF = BT.SC_IDENTIF) ;
-------------------------------------------------
-- V_LIGPLAATS_ALLES
-------------------------------------------------
/*
LIGPLAATS MET HOOFDADRES
*/		
CREATE OR REPLACE VIEW
    V_LIGPLAATS_ALLES
    (
        OBJECTID,
        FID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        STATUS,
        THE_GEOM
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    LP.SC_IDENTIF           AS FID,
    GEM.NAAM                AS GEMEENTE,
    CASE
         WHEN ADDROBJ.FK_6WPL_IDENTIF IS NOT NULL
         -- opzoeken want in andere woonplaats
         THEN  (SELECT NAAM FROM WNPLTS WHERE IDENTIF = FK_6WPL_IDENTIF)
         ELSE WP.NAAM           
    END                     AS WOONPLAATS,
    GEOR.NAAM_OPENB_RMTE    AS STRAATNAAM,
    ADDROBJ.HUINUMMER       AS HUISNUMMER,
    ADDROBJ.HUISLETTER,
    ADDROBJ.HUINUMMERTOEVOEGING AS HUISNUMMER_TOEV,
    ADDROBJ.POSTCODE,
    LP.STATUS,
    BT.GEOM AS THE_GEOM
FROM
    (((((((LIGPLAATS LP
JOIN
    BENOEMD_TERREIN BT
ON
    ((LP.SC_IDENTIF = BT.SC_IDENTIF)))
JOIN
    NUMMERAAND NA
ON
    ((NA.SC_IDENTIF = LP.FK_4NRA_SC_IDENTIF)))
JOIN
    ADDRESSEERB_OBJ_AAND ADDROBJ
ON
    ((ADDROBJ.IDENTIF = NA.SC_IDENTIF)))
JOIN
    GEM_OPENB_RMTE GEOR
ON
    ((GEOR.IDENTIFCODE = ADDROBJ.FK_7OPR_IDENTIFCODE)))
LEFT JOIN
    OPENB_RMTE_WNPLTS ORWP
ON
    ((GEOR.IDENTIFCODE = ORWP.FK_NN_LH_OPR_IDENTIFCODE)))
LEFT JOIN
    WNPLTS WP
ON
    ((ORWP.FK_NN_RH_WPL_IDENTIF = WP.IDENTIF)))
LEFT JOIN
    GEMEENTE GEM
ON
    ((
            WP.FK_7GEM_CODE = GEM.CODE)))
WHERE
    ((((
                    ADDROBJ.DAT_EIND_GELDH IS NULL)
            AND (
                    GEOR.DATUM_EINDE_GELDH IS NULL))
        AND (
                GEM.DATUM_EINDE_GELDH IS NULL))
    AND (
            BT.DATUM_EINDE_GELDH IS NULL));	
-------------------------------------------------
-- V_STANDPLAATS_ALLES
-------------------------------------------------
/*
STANDPLAATS MET HOOFDADRES
*/		
CREATE OR REPLACE VIEW
    V_STANDPLAATS_ALLES
    (
        OBJECTID,
        FID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        STATUS,
        THE_GEOM
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    SP.SC_IDENTIF           AS FID,
    GEM.NAAM                AS GEMEENTE,
    CASE
         WHEN ADDROBJ.FK_6WPL_IDENTIF IS NOT NULL
         -- opzoeken want in andere woonplaats
         THEN  (SELECT NAAM FROM WNPLTS WHERE IDENTIF = FK_6WPL_IDENTIF)
         ELSE WP.NAAM           
    END                     AS WOONPLAATS,
    GEOR.NAAM_OPENB_RMTE    AS STRAATNAAM,
    ADDROBJ.HUINUMMER       AS HUISNUMMER,
    ADDROBJ.HUISLETTER,
    ADDROBJ.HUINUMMERTOEVOEGING AS HUISNUMMER_TOEV,
    ADDROBJ.POSTCODE,
    SP.STATUS,
    BT.GEOM AS THE_GEOM
FROM
    (((((((STANDPLAATS SP
JOIN
    BENOEMD_TERREIN BT
ON
    ((SP.SC_IDENTIF = BT.SC_IDENTIF)))
JOIN
    NUMMERAAND NA
ON
    ((NA.SC_IDENTIF = SP.FK_4NRA_SC_IDENTIF)))
JOIN
    ADDRESSEERB_OBJ_AAND ADDROBJ
ON
    ((ADDROBJ.IDENTIF = NA.SC_IDENTIF)))
JOIN
    GEM_OPENB_RMTE GEOR
ON
    ((GEOR.IDENTIFCODE = ADDROBJ.FK_7OPR_IDENTIFCODE)))
LEFT JOIN
    OPENB_RMTE_WNPLTS ORWP
ON
    ((GEOR.IDENTIFCODE = ORWP.FK_NN_LH_OPR_IDENTIFCODE)))
LEFT JOIN
    WNPLTS WP
ON
    ((ORWP.FK_NN_RH_WPL_IDENTIF = WP.IDENTIF)))
LEFT JOIN
    GEMEENTE GEM
ON
    ((
            WP.FK_7GEM_CODE = GEM.CODE)))
WHERE
    ((((
                    ADDROBJ.DAT_EIND_GELDH IS NULL)
            AND (
                    GEOR.DATUM_EINDE_GELDH IS NULL))
        AND (
                GEM.DATUM_EINDE_GELDH IS NULL))
    AND (
            BT.DATUM_EINDE_GELDH IS NULL));			
-------------------------------------------------
-- V_ADRES
-------------------------------------------------
/*
VOLLEDIGE ADRESSENLIJST
STANDPLAATS EN LIGPLAATS VIA BENOEMD_TERREIN, 
WAARBIJ CENTROIDE VAN POLYGON WORDT GENOMEN
PLUS VERBLIJFSOBJECT VIA PUNT OBJECT VAN GEBOUWD_OBJ
*/
CREATE OR REPLACE VIEW
    V_ADRES
    (
        OBJECTID,
        FID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        STATUS,
        OPPERVLAKTE,
        THE_GEOM
    ) AS
SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    VBO.SC_IDENTIF          AS FID,
    GEM.NAAM                AS GEMEENTE,
    CASE
         WHEN ADDROBJ.FK_6WPL_IDENTIF IS NOT NULL
         -- opzoeken want in andere woonplaats
         THEN  (SELECT NAAM FROM WNPLTS WHERE IDENTIF = FK_6WPL_IDENTIF)
         ELSE WP.NAAM           
    END                     AS WOONPLAATS,
    GEOR.NAAM_OPENB_RMTE    AS STRAATNAAM,
    ADDROBJ.HUINUMMER       AS HUISNUMMER,
    ADDROBJ.HUISLETTER,
    ADDROBJ.HUINUMMERTOEVOEGING AS HUISNUMMER_TOEV,
    ADDROBJ.POSTCODE,
    VBO.STATUS,
    GOBJ.OPPERVLAKTE_OBJ || ' m2' AS OPPERVLAKTE,
    GOBJ.PUNTGEOM                 AS THE_GEOM
FROM
    VERBLIJFSOBJ VBO
JOIN
    GEBOUWD_OBJ GOBJ
ON
    (
        GOBJ.SC_IDENTIF = VBO.SC_IDENTIF )
LEFT JOIN
    VERBLIJFSOBJ_NUMMERAAND VNA
ON
    (
        VNA.FK_NN_LH_VBO_SC_IDENTIF = VBO.SC_IDENTIF )
LEFT JOIN
    NUMMERAAND NA
ON
    (
        NA.SC_IDENTIF = VBO.FK_11NRA_SC_IDENTIF)
LEFT JOIN
    ADDRESSEERB_OBJ_AAND ADDROBJ
ON
    (
        ADDROBJ.IDENTIF = NA.SC_IDENTIF )
JOIN
    GEM_OPENB_RMTE GEOR
ON
    (
        GEOR.IDENTIFCODE = ADDROBJ.FK_7OPR_IDENTIFCODE )
LEFT JOIN
    OPENB_RMTE_WNPLTS ORWP
ON
    (
        GEOR.IDENTIFCODE = ORWP.FK_NN_LH_OPR_IDENTIFCODE)
LEFT JOIN
    WNPLTS WP
ON
    (
        ORWP.FK_NN_RH_WPL_IDENTIF = WP.IDENTIF)
LEFT JOIN
    GEMEENTE GEM
ON
    (
        WP.FK_7GEM_CODE = GEM.CODE )
WHERE
    NA.STATUS = 'Naamgeving uitgegeven'
AND (
        VBO.STATUS = 'Verblijfsobject in gebruik (niet ingemeten)'
    OR  VBO.STATUS = 'Verblijfsobject in gebruik');
-------------------------------------------------
-- V_ADRES_LIGPLAATS
-------------------------------------------------
CREATE  OR REPLACE VIEW
    V_ADRES_LIGPLAATS
    (
        FID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        STATUS,
        THE_GEOM,
        CENTROIDE
    ) AS
SELECT
    LPA.SC_IDENTIF       AS FID,
    GEM.NAAM             AS GEMEENTE,
    CASE
         WHEN ADDROBJ.FK_6WPL_IDENTIF IS NOT NULL
         -- opzoeken want in andere woonplaats
         THEN  (SELECT NAAM FROM WNPLTS WHERE IDENTIF = FK_6WPL_IDENTIF)
         ELSE WP.NAAM           
    END                  AS WOONPLAATS,
    GEOR.NAAM_OPENB_RMTE AS STRAATNAAM,
    ADDROBJ.HUINUMMER    AS HUISNUMMER,
    ADDROBJ.HUISLETTER,
    ADDROBJ.HUINUMMERTOEVOEGING AS HUISNUMMER_TOEV,
    ADDROBJ.POSTCODE,
    LPA.STATUS,
    BENTER.GEOM AS THE_GEOM,
    SDO_GEOM.SDO_CENTROID(BENTER.GEOM,2)
FROM
    LIGPLAATS LPA
JOIN
    BENOEMD_TERREIN BENTER
ON
    (
        BENTER.SC_IDENTIF = LPA.SC_IDENTIF )
LEFT JOIN
    LIGPLAATS_NUMMERAAND LNA
ON
    (
        LNA.FK_NN_LH_LPL_SC_IDENTIF = LPA.SC_IDENTIF )
LEFT JOIN
    NUMMERAAND NA
ON
    (
        NA.SC_IDENTIF = LPA.FK_4NRA_SC_IDENTIF )
LEFT JOIN
    ADDRESSEERB_OBJ_AAND ADDROBJ
ON
    (
        ADDROBJ.IDENTIF = NA.SC_IDENTIF )
JOIN
    GEM_OPENB_RMTE GEOR
ON
    (
        GEOR.IDENTIFCODE = ADDROBJ.FK_7OPR_IDENTIFCODE )
LEFT JOIN
    OPENB_RMTE_WNPLTS ORWP
ON
    (
        GEOR.IDENTIFCODE = ORWP.FK_NN_LH_OPR_IDENTIFCODE)
LEFT JOIN
    WNPLTS WP
ON
    (
        ORWP.FK_NN_RH_WPL_IDENTIF = WP.IDENTIF)
LEFT JOIN
    GEMEENTE GEM
ON
    (
        WP.FK_7GEM_CODE = GEM.CODE )
WHERE
    NA.STATUS = 'Naamgeving uitgegeven'
AND LPA.STATUS = 'Plaats aangewezen';
-------------------------------------------------
-- V_ADRES_STANDPLAATS
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_ADRES_STANDPLAATS
    (
        FID,
        GEMEENTE,
        WOONPLAATS,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        STATUS,
        THE_GEOM,
        CENTROIDE
    ) AS
SELECT
    SPL.SC_IDENTIF       AS FID,
    GEM.NAAM             AS GEMEENTE,
    CASE
         WHEN ADDROBJ.FK_6WPL_IDENTIF IS NOT NULL
         -- opzoeken want in andere woonplaats
         THEN  (SELECT NAAM FROM WNPLTS WHERE IDENTIF = FK_6WPL_IDENTIF)
         ELSE WP.NAAM           
    END                  AS WOONPLAATS,
    GEOR.NAAM_OPENB_RMTE AS STRAATNAAM,
    ADDROBJ.HUINUMMER    AS HUISNUMMER,
    ADDROBJ.HUISLETTER,
    ADDROBJ.HUINUMMERTOEVOEGING AS HUISNUMMER_TOEV,
    ADDROBJ.POSTCODE,
    SPL.STATUS,
    BENTER.GEOM AS THE_GEOM,
    SDO_GEOM.SDO_CENTROID(BENTER.GEOM,2)
FROM
    STANDPLAATS SPL
JOIN
    BENOEMD_TERREIN BENTER
ON
    (
        BENTER.SC_IDENTIF = SPL.SC_IDENTIF )
LEFT JOIN
    STANDPLAATS_NUMMERAAND SNA
ON
    (
        SNA.FK_NN_LH_SPL_SC_IDENTIF = SPL.SC_IDENTIF )
LEFT JOIN
    NUMMERAAND NA
ON
    (
        NA.SC_IDENTIF = SPL.FK_4NRA_SC_IDENTIF)
LEFT JOIN
    ADDRESSEERB_OBJ_AAND ADDROBJ
ON
    (
        ADDROBJ.IDENTIF = NA.SC_IDENTIF )
JOIN
    GEM_OPENB_RMTE GEOR
ON
    (
        GEOR.IDENTIFCODE = ADDROBJ.FK_7OPR_IDENTIFCODE )
LEFT JOIN
    OPENB_RMTE_WNPLTS ORWP
ON
    (
        GEOR.IDENTIFCODE = ORWP.FK_NN_LH_OPR_IDENTIFCODE)
LEFT JOIN
    WNPLTS WP
ON
    (
        ORWP.FK_NN_RH_WPL_IDENTIF = WP.IDENTIF)
LEFT JOIN
    GEMEENTE GEM
ON
    (
        WP.FK_7GEM_CODE = GEM.CODE )
WHERE
    NA.STATUS = 'Naamgeving uitgegeven'
AND SPL.STATUS = 'Plaats aangewezen';
-------------------------------------------------
-- V_ADRES_TOTAAL
-------------------------------------------------
CREATE OR REPLACE VIEW
    V_ADRES_TOTAAL
    (
        OBJECTID,
        FID,
        STRAATNAAM,
        HUISNUMMER,
        HUISLETTER,
        HUISNUMMER_TOEV,
        POSTCODE,
        GEMEENTE,
        WOONPLAATS,
        THE_GEOM
    ) AS
  SELECT
    CAST(ROWNUM AS INTEGER) AS OBJECTID,
    QRY.*
    FROM (
        SELECT
            FID ,
            STRAATNAAM,
            HUISNUMMER,
            HUISLETTER,
            HUISNUMMER_TOEV,
            POSTCODE,
            GEMEENTE,
        		WOONPLAATS,
            THE_GEOM
        FROM
            V_ADRES
        UNION ALL
        SELECT
            FID ,
            STRAATNAAM,
            HUISNUMMER,
            HUISLETTER,
            HUISNUMMER_TOEV,
            POSTCODE,
            GEMEENTE,
        		WOONPLAATS,
            CENTROIDE AS THE_GEOM
        FROM
            V_ADRES_LIGPLAATS
        UNION ALL
        SELECT
            FID ,
            STRAATNAAM,
            HUISNUMMER,
            HUISLETTER,
            HUISNUMMER_TOEV,
            POSTCODE,
            GEMEENTE,
        		WOONPLAATS,
            CENTROIDE AS THE_GEOM
        FROM
            V_ADRES_STANDPLAATS
    ) QRY;
