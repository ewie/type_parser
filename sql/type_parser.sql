CREATE EXTENSION type_parser;

-- test builtin types
WITH t (type_str) AS (
  VALUES
    ('bit varying (42)'),
    ('bool'),
    ('boolean'),
    ('bpchar (7)'),
    ('char (42)'),
    ('character (37)'),
    ('character varying (37)'),
    ('date'),
    ('decimal (6,3)'),
    ('decimal'),
    ('double precision'),
    ('float'),
    ('float4'),
    ('int'),
    ('int4'),
    ('integer'),
    ('interval day to hour'),
    ('interval day to minute'),
    ('interval day to second (3)'),
    ('interval day to second'),
    ('interval day'),
    ('interval hour to minute'),
    ('interval hour to second (3)'),
    ('interval hour to second'),
    ('interval hour'),
    ('interval minute to second (3)'),
    ('interval minute to second'),
    ('interval month'),
    ('interval second (3)'),
    ('interval second'),
    ('interval year to month'),
    ('interval year'),
    ('interval year'),
    ('interval'),
    ('numeric (8,2)'),
    ('numeric'),
    ('real'),
    ('text'),
    ('text[][]'),
    ('time (3) with time zone'),
    ('time with time zone'),
    ('time without time zone'),
    ('time'),
    ('timestamp (3) with time zone'),
    ('timestamp (3) without time zone'),
    ('timestamp'),
    ('timestamptz (3)'),
    ('timetz (3)'),
    ('timetz'),
    ('varbit (23)'),
    ('varchar (42)')
)
SELECT
  t.type_str,
  format_type(p.typid, p.typmod)
FROM t
  CROSS JOIN parse_type_string(type_str) p
ORDER BY 1, 2;

-- test NULL as type string
\pset null '<NULL>'
SELECT parse_type_string(NULL);

-- test nonexistent type
SELECT parse_type_string('no_such_type');

-- test custom type
CREATE TYPE mytype AS (a int);
SELECT format_type(typid, typmod)
FROM parse_type_string('mytype');

-- test shell type
CREATE TYPE myshell;
SELECT parse_type_string('myshell');
