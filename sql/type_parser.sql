CREATE EXTENSION type_parser;

WITH t (type_str) AS (
  VALUES
    ('bit varying (42)'),
    ('double precision'),
    ('float'),
    ('float4'),
    ('int'),
    ('int4'),
    ('integer'),
    ('interval second (3)'),
    ('interval year'),
    ('real'),
    ('timestamp (3) with time zone'),
    ('timestamptz (3)'),
    ('varbit(23)')
)
SELECT
  t.type_str,
  format_type(p.typid, p.typmod)
FROM t
  CROSS JOIN parse_type_string(type_str) p
ORDER BY 1, 2;
