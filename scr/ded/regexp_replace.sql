CREATE OR REPLACE FUNCTION version_major()
  RETURNS "numeric" AS
'select substring(version() from ''PostgreSQL ([0-9]+.[0-9]+)'')::numeric(6, 1)'
  LANGUAGE 'sql' IMMUTABLE STRICT;

---------------------------------------

CREATE OR REPLACE FUNCTION regexp_replace(text, text, text, int4)
  RETURNS text AS
'DECLARE
  sSource      alias for $1;
  sPattern     alias for $2;
  sReplacement alias for $3;
  iFlags       alias for $4;
  
  --substring(...) finds the *1st* match in the string so we need
  --to loop through all of them to properly replace everything
  sFlagPattern    text;
  bMultipass      boolean;    --whether to loop running the replacement until there are none more to do
  sNewstring      text;       --the current body that is having replacements found and done
  sFound          text;       --the string found in the body that needs replacing
  sBackRefReplace text;       --the replacement with back refs to put in each time

begin

  sNewstring   := sSource;
  sFlagPattern := sPattern;
  if version_major() > 7.3 then                                               --7.4 onwards supports flags in patterns
    if iFlags & 1 then sFlagPattern := \'(?i)\' || sFlagPattern; end if;        --flags 1 indicates case insensitive
  end if;
  --if the pattern matches the replacement then we should not loop because it will constantly find the replacement
  --if the pattern does not match then null is returned, pattern can correctly return a match of an empty string eg(.*)eg
  bMultipass        := (substring(sReplacement from sFlagPattern) is null) or (substring(sReplacement from sFlagPattern) = \'\');        
  loop
    sFound          := substring(sNewstring from sFlagPattern);               --get the \\\\0 (or \\\\1 if there are brackets) found
    exit when sFound is null or sFound = \'\';                                  --we have to exit on null or \'\' because of infinite looping (we cannot replace \'\')
    sBackRefReplace := replace(sReplacement, \'\\\\1\', sFound);                  --this allows \\\\1 back references
    sNewstring      := replace(sNewstring, sFound, sBackRefReplace);          --replace the \\\\1 substitution
    exit when not bMultipass;
  end loop;

  return sNewstring;
end;
'
  LANGUAGE 'plpgsql' STABLE STRICT;

-----------------------------------
CREATE OR REPLACE FUNCTION regexp_replace(text, text, text)
  RETURNS text AS
'select regexp_replace($1, $2, $3, 1) --default to case insensitive'
  LANGUAGE 'sql' IMMUTABLE STRICT;
--------------------------------

CREATE OR REPLACE FUNCTION regexp_replace(text, text)
  RETURNS text AS
'select regexp_replace($1, $2, \'\');'
  LANGUAGE 'sql' IMMUTABLE STRICT;