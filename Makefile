MODULES = type_parser
EXTENSION = type_parser
DATA = type_parser--0.1.sql

REGRESS_OPTS = --dbname=$(PL_TESTDB)
REGRESS = type_parser

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
