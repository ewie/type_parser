#include "postgres.h"
#include "fmgr.h"
#include "funcapi.h"            /* for returning composite type */
#include "utils/builtins.h"     /* text_to_cstring() */
#include "parser/parse_type.h"  /* parseTypeString() */

PG_MODULE_MAGIC;

Datum parse_type_string(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(parse_type_string);

Datum
parse_type_string(PG_FUNCTION_ARGS)
{
#define PARSE_TYPE_STRING_COLS 2
  const char *type;    /* the type string we want to resolve */
  Oid         typid;   /* the resolved type oid */
  int32       typmod;  /* the resolved type modifier */
  TupleDesc   tupdesc;
  HeapTuple   rettuple;
  Datum       values[PARSE_TYPE_STRING_COLS] = {0};
  bool        nulls[PARSE_TYPE_STRING_COLS] = {0};

  type = text_to_cstring(PG_GETARG_TEXT_PP(0));

  /* Build a tuple descriptor for our result type */
  if (get_call_result_type(fcinfo, NULL, &tupdesc) != TYPEFUNC_COMPOSITE) {
    ereport(ERROR,
            (errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
             errmsg("function returning record called in context that cannot accept type record")));
  }

  BlessTupleDesc(tupdesc);

  /* Resolve type oid and modifier. */
  parseTypeString(type, &typid, &typmod, fcinfo->context);

  /* Create return tuple. */
  values[0] = typid;
  values[1] = typmod;
  rettuple = heap_form_tuple(tupdesc, values, nulls);

  return HeapTupleGetDatum(rettuple);
#undef PARSE_TYPE_STRING_COLS
}
