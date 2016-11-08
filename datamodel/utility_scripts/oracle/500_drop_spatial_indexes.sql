--
-- Drop alle ruimtelijke indexen.
-- tbv. update/migratie BRMO 1.2.10 naar 1.2.11
--
-- (her-)genereer dit script eventueel met (als schema owner):
-- SELECT 'DROP INDEX '|| INDEX_NAME || ';' FROM USER_SDO_INDEX_INFO;
--
DROP INDEX KAD_PERCEEL_PLAATSCOORDIN2_IDX;
DROP INDEX KAD_PERCEEL_BEGRENZING_PE1_IDX;
DROP INDEX INRICHTINGSELEMENT_GEOM1_IDX;
DROP INDEX GEMEENTE_GEOM1_IDX;
DROP INDEX GEBOUWINSTALLATIE_GEOM1_IDX;
DROP INDEX GEBOUWD_OBJ_PUNTGEOM2_IDX;
DROP INDEX GEBOUWD_OBJ_VLAKGEOM1_IDX;
DROP INDEX FUNCTIONEEL_GEBIED_GEOM1_IDX;
DROP INDEX BUURT_GEOM1_IDX;
DROP INDEX BENOEMD_TERREIN_GEOM1_IDX;
DROP INDEX BEGR_TERR_DL_KRUINLIJNGEO2_IDX;
DROP INDEX BEGR_TERR_DL_GEOM1_IDX;
DROP INDEX WOZ_OBJ_ARCHIEF_GEOM1_IDX;
DROP INDEX WNPLTS_ARCHIEF_GEOM1_IDX;
DROP INDEX WIJK_ARCHIEF_GEOM1_IDX;
DROP INDEX WEGDEEL_ARCHIEF_GEOM1_IDX;
DROP INDEX WATERSCHAP_ARCHIEF_GEOM1_IDX;
DROP INDEX WATERDEEL_ARCHIEF_GEOM1_IDX;
DROP INDEX VRIJSTAAND_VEGETATIE_O_AR1_IDX;
DROP INDEX STADSDEEL_ARCHIEF_GEOM1_IDX;
DROP INDEX SPOOR_ARCHIEF_GEOM1_IDX;
DROP INDEX SCHEIDING_ARCHIEF_GEOM1_IDX;
DROP INDEX VRIJSTAAND_VEGETATIE_OBJ_1_IDX;
DROP INDEX STADSDEEL_GEOM1_IDX;
DROP INDEX SPOOR_GEOM1_IDX;
DROP INDEX SCHEIDING_GEOM1_IDX;
DROP INDEX PAND_GEOM_MAAIVELD2_IDX;
DROP INDEX PAND_GEOM_BOVENAANZICHT1_IDX;
DROP INDEX OVRG_SCHEIDING_GEOM1_IDX;
DROP INDEX OVERIG_BOUWWERK_GEOM1_IDX;
DROP INDEX ONDERSTEUNEND_WEGDEEL_GEO1_IDX;
DROP INDEX ONBEGR_TERR_DL_KRUINLIJNG2_IDX;
DROP INDEX ONBEGR_TERR_DL_GEOM1_IDX;
DROP INDEX KUNSTWERKDEEL_GEOM1_IDX;
DROP INDEX PAND_ARCHIEF_GEOM_MAAIVEL2_IDX;
DROP INDEX PAND_ARCHIEF_GEOM_BOVENAA1_IDX;
DROP INDEX OVRG_SCHEIDING_ARCHIEF_GE1_IDX;
DROP INDEX OVERIG_BOUWWERK_ARCHIEF_G1_IDX;
DROP INDEX ONDERSTEUNEND_WEGDEEL_ARC1_IDX;
DROP INDEX ONBEGR_TERR_DL_ARCHIEF_KR2_IDX;
DROP INDEX ONBEGR_TERR_DL_ARCHIEF_GE1_IDX;
DROP INDEX KUNSTWERKDEEL_ARCHIEF_GEO1_IDX;
DROP INDEX KAD_PERCEEL_ARCHIEF_PLAAT2_IDX;
DROP INDEX KAD_PERCEEL_ARCHIEF_BEGRE1_IDX;
DROP INDEX INRICHTINGSELEMENT_ARCHIE1_IDX;
DROP INDEX GEMEENTE_ARCHIEF_GEOM1_IDX;
DROP INDEX GEBOUWINSTALLATIE_ARCHIEF1_IDX;
DROP INDEX GEBOUWD_OBJ_ARCHIEF_PUNTG2_IDX;
DROP INDEX GEBOUWD_OBJ_ARCHIEF_VLAKG1_IDX;
DROP INDEX FUNCTIONEEL_GEBIED_ARCHIE1_IDX;
DROP INDEX BUURT_ARCHIEF_GEOM1_IDX;
DROP INDEX BENOEMD_TERREIN_ARCHIEF_G1_IDX;
DROP INDEX BEGR_TERR_DL_ARCHIEF_KRUI2_IDX;
DROP INDEX BEGR_TERR_DL_ARCHIEF_GEOM1_IDX;
DROP INDEX WOZ_OBJ_GEOM1_IDX;
DROP INDEX WNPLTS_GEOM1_IDX;
DROP INDEX WIJK_GEOM1_IDX;
DROP INDEX WEGDEEL_GEOM1_IDX;
DROP INDEX WATERSCHAP_GEOM1_IDX;
DROP INDEX WATERDEEL_GEOM1_IDX;