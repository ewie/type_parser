# type\_parser

Postgres extension for parsing type strings to get the type OID and modifier.

This is a proof of concept for fixing a [regression in pgTAP][pgtap-315].
Tested on Postgres 15.

[pgtap-315]: https://github.com/theory/pgtap/issues/315


## Installation

Build and install with [PGXS][pgxs]:

[pgxs]: https://www.postgresql.org/docs/current/extend-pgxs.html

    make
    make install
    make installcheck

Create the extension:

    CREATE EXTENSION type_parser;


## Usage

Call function `parse_type_string(text)` with the type string as you would
write it in a `CREATE TABLE` command or `CAST` expression.  Then call
`format_type(oid, integer)` with the resulting `typid` and `typmod` columns.

    WITH t (typstr) AS (
      VALUES ('int'), ('int4'), ('integer'),
             ('float'), ('double precision'),
             ('real'), ('float4'),
             ('varbit(23)'), ('bit varying (42)'),
             ('timestamptz (3)'), ('timestamp (3) with time zone'),
             ('interval second (3)')
    )
    SELECT
      t.typstr,
      format_type(p.typid, p.typmod)
    FROM t
      CROSS JOIN parse_type_string(t.typstr) p
    ORDER BY 1, 2;

                typstr            |         format_type
    ------------------------------+-----------------------------
     bit varying (42)             | bit varying(42)
     double precision             | double precision
     float                        | double precision
     float4                       | real
     int                          | integer
     int4                         | integer
     integer                      | integer
     interval second (3)          | interval second(3)
     real                         | real
     timestamp (3) with time zone | timestamp(3) with time zone
     timestamptz (3)              | timestamp(3) with time zone
     varbit(23)                   | bit varying(23)
    (12 rows)

Also works with types from other extensions, e.g. PostGIS:

    CREATE EXTENSION postgis;

    SELECT format_type(typid, typmod)
    FROM parse_type_string('geometry(point, 4326)');

         format_type
    ----------------------
     geometry(Point,4326)
    (1 row)
