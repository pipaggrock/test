#creamos el esquema
bq --location=us-west2 mk derco

#cargamos la tabla a bigquery
bq load \
--source_format=CSV \
--replace \
--field_delimiter ',' \
--skip_leading_rows 1 \
derco.input \
gs://derco/input/bbdd_prueba_corp_enriched.csv \
PATENTE:STRING,\
MARCA:STRING,\
MODELO:STRING,\
AGNO:NUMERIC,\
ID_CLIENTE:STRING,\
COMUNA:STRING,\
SEXO:STRING,\
ACTIVIDAD:STRING,\
TASACION:STRING,\
COLOR2:STRING,\
EDAD:STRING,\
SM_FEC_TRANSFERENCIA:STRING,\
VIGENCIA_BIN:NUMERIC,\
SM_REGION:STRING,\
ZONA:STRING,\
ZONA_NORTE:NUMERIC,\
ZONA_CENTRO:NUMERIC,\
ZONA_SUR:NUMERIC,\
RM:NUMERIC

