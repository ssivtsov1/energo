--  -- "�������" ������� ���������
CREATE OR REPLACE FUNCTION w_upper(text) RETURNS text IMMUTABLE AS '
DECLARE BEGIN
RETURN TRANSLATE($1, ''abcdefghijklmnopqrstuvwxyz���������������������������������_��'',
                     ''ABCDEFGHIJKLMNOPQRSTUVWXYZ���������������������������������_��'');
END; ' LANGUAGE 'plpgsql';

--  -- "������" ������� ���������
CREATE OR REPLACE FUNCTION w_lower(text) RETURNS text IMMUTABLE AS '
DECLARE BEGIN
RETURN TRANSLATE($1, ''ABCDEFGHIJKLMNOPQRSTUVWXYZ���������������������������������_��'',
                     ''abcdefghijklmnopqrstuvwxyz���������������������������������_��'');
END; ' LANGUAGE 'plpgsql';

--  -- ������ ������� �� ���������� �������� �������� �� ��� ���������
CREATE OR REPLACE FUNCTION lat2ukr(text) RETURNS text IMMUTABLE AS '
DECLARE BEGIN
RETURN TRANSLATE($1, ''aceikopyABCEHIKMOPTY'',
                     ''���_���������_������'');
END; ' LANGUAGE 'plpgsql';


