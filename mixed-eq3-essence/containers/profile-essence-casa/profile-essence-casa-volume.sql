CREATE OR REPLACE VIEW PR_ESSENCE_CASA_VOLUME ("TABLE_NAME", "RECORD_COUNT") AS
SELECT 'O_CASA', COUNT(1) FROM O_CASA;
