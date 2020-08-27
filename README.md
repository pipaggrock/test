# derco prueba técnica
responderemos el fenómeno de preferencia y recambio de automóviles en Chile.
se realizará en dos pasos:
* ETL
* Análisis

# ETL
El proceso de transformación y enriquecimiento de la data se realizará
a través de un notebook por medio de python 2, utilizando principalmente
la manipulación de la data a través de dataframes.

*  1_ETL.ipynb

En esta etapa se analiza el porcentaje de datos poblados y válidos, se reparan posibles variables y se realizan distintas agregaciones para facilitar el posterior análisis, para finalmente obtener una nueva fuente de datos limpia y filtrada (el detalle y paso a paso se encuentra en el archivo 1_ETL.ipynb)

# Análisis
Para el análisis llevaremos la data enriquecida previamente a una suite
de google cloud platform el cuál a través de sentencias estilo sql 
responderemos el fenómeno en cuestión.

* 2_load_to_bigquery.sh
* 3_querys.sql

En primera instancia requerimos cargar la data en google cloud storage, de manera de almacenarla y generar la instancia de levantarla como un dataset (ver 2_load_to_bigquery.sh)

Finalmente para ayudar a entender el fenómeno en cuestión, realizaremos un conjunto de agregaciones sobre el dataset el cual nos ayudará a extender nuestra fuente de datos para la toma de decisiones y explicacr la tendencias (ver 3_querys.sql)

# Explicación
Para explicar el fenómeno de preferencia y recambio de automóviles en Chile veremos la variación en ventas por año y en base a estos cambios, veremos como ha sido la participación de las ventas por año por marca y se mostrarán las marcas que han ido en tendencia incremental durante los años y por otro lado las marcas que han ido en caída.

# Paso a paso
  1. obtener el porcentaje de aumento o caída en ventas en referencia al año anterior.

|AÑO    |ventas| diff_perc
|2010	  |108250|	     0
|2011	  |136796|   20.87
|2012	  |133456|	  -2.5
|2013	  |144099|    7.39
|2014	  |133435|   -7.99
|2015	  |103970|  -28.34
|2016	  |94836 |   -9.63
|2017	  |110632|   14.28
|2018	  |41495 | -166.62

# Complementar
