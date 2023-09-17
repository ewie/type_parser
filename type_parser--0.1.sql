-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION type_parser" to load this file. \quit

CREATE FUNCTION parse_type_string(type text, OUT typid oid, OUT typmod int4)
  RETURNS RECORD
  AS 'MODULE_PATHNAME', 'parse_type_string'
  LANGUAGE C
  STABLE
  STRICT;
