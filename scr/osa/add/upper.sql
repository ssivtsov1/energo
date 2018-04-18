--  -- "ВЕРХНИЙ" регистр киррилицы
CREATE OR REPLACE FUNCTION w_upper(text) RETURNS text IMMUTABLE AS '
DECLARE BEGIN
RETURN TRANSLATE($1, ''abcdefghijklmnopqrstuvwxyzёабвгдежзийклмнопрстуфхцчшщъыьэюя_╓╜'',
                     ''ABCDEFGHIJKLMNOPQRSTUVWXYZЁАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ_╢╫'');
END; ' LANGUAGE 'plpgsql';

--  -- "нижний" регистр киррилицы
CREATE OR REPLACE FUNCTION w_lower(text) RETURNS text IMMUTABLE AS '
DECLARE BEGIN
RETURN TRANSLATE($1, ''ABCDEFGHIJKLMNOPQRSTUVWXYZЁАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ_╢╫'',
                     ''abcdefghijklmnopqrstuvwxyzёабвгдежзийклмнопрстуфхцчшщъыьэюя_╓╜'');
END; ' LANGUAGE 'plpgsql';

--  -- замена похожих по начертанию символов латиницы на укр киррилицу
CREATE OR REPLACE FUNCTION lat2ukr(text) RETURNS text IMMUTABLE AS '
DECLARE BEGIN
RETURN TRANSLATE($1, ''aceikopyABCEHIKMOPTY'',
                     ''асе_коруАВСЕН_КМОРТУ'');
END; ' LANGUAGE 'plpgsql';


