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

| AÑO         | Q_VENTAS      |      DIFF_PERC |
|-------------|---------------|---------------:|
|     2010    |     108250    |           0    |
|     2011    |     136796    |       20.87    |
|     2012    |     133456    |        -2.5    |
|     2013    |     144099    |        7.39    |
|     2014    |     133435    |       -7.99    |
|     2015    |     103970    |      -28.34    |
|     2016    |      94836    |       -9.63    |
|     2017    |     110632    |       14.28    |
|     2018    |      41495    |     -166.62    |

entonces para el ejemplo el año 2011 aumentaron las ventas en un 20,87% con respecto al año anterior. 

Este ejercicio se repetirá, pero lo haremos por cada marca

| AGNO | MARCA   | total | diff_perc |
|------|---------|-------|-----------|
| 2010 | HYUNDAI | 17722 |           |
| 2011 | HYUNDAI | 18709 |    5.28   |
| 2012 | HYUNDAI | 17962 |   -4.16   |
| 2013 | HYUNDAI | 15473 |  -16.09   |
| 2014 | HYUNDAI | 10534 |  -46.89   |
| 2015 | HYUNDAI | 6788  |  -55.19   |
| 2016 | HYUNDAI | 6970  |    2.61   |
| 2017 | HYUNDAI | 9200  |   24.24   |
| 2018 | HYUNDAI | 3400  | -170.59   |

Como se muestra un ejemplo de la diferencia porcentual entre cada año para la marca HYUNDAI

Entonces en base al porcentaje anual de venta y el porcentaje anual de venta por marca crearemos los siguientes flags de tipo boolean (1 ó 0)

* flag_raise: 1 si el porcentaje de venta anual por marca es positivo
* flag_raise_against_global: 1 si el porcentaje de venta anual por la marca fue positivo y el porcentaje global del año fue negativo
* flag_raise_over_global: 1 si el porcentaje de venta anual por la marca fue mayor y positivo con respecto al porcentaje global
* flag_decline_against_global: 1 si la marca bajó sus ventas con respecto al año anterior mientras que las ventas globales fueron positivas respecto al año anterior.
* flag_decline_over_global: 1 si la marca y la global decayeron y además la ventas de la marca cayeron por sobre la caída global del año
* consecutive_raise: años consecutivos que la marca fué en aumento
* consecutive_decline: años consecutivos que la marca fué bajando sus ventas.

Considerando los flags consecutive_raise y consecutive_decline, obtendremos los siguientes resultados:

| marca      | consecutive_times_raise | last_year_raise |
|------------|-------------------------|-----------------|
| MAZDA      | 6                       | 2017            |
| PEUGEOT    | 4                       | 2017            |
| RENAULT    | 4                       | 2017            |
| DFSK       | 3                       | 2018            |
| CHERY      | 3                       | 2017            |
| DFM        | 3                       | 2017            |
| JAC        | 3                       | 2017            |
| BRILLIANCE | 2                       | 2017            |
| FIAT       | 2                       | 2017            |

A modo de ejemplo, la marca MAZDA ha aumentado sus ventas año a año de manera consecutiva, dónde el último año que aumentó fue el 2017, por ende se concluye que sus ventas fueron en aumento desde el 2010 al 2017.

| marca      | consecutive_decline | last_year_decline |
|------------|---------------------|-------------------|
| DODGE      | 6                   | 2018              |
| MINI       | 5                   | 2018              |
| CHRYSLER   | 5                   | 2017              |
| JEEP       | 4                   | 2018              |
| KIA        | 4                   | 2018              |
| LAND ROVER | 4                   | 2018              |
| PORSCHE    | 4                   | 2018              |
| SSANGYONG  | 4                   | 2018              |
| SUZUKI     | 4                   | 2018              |

Por otro lado, CHRYSLER ha caído en sus ventas 5 años consecutivos, y el último año que cortó esta tendencia fué el 2017, por lo que el 2018 cambió la pendiente de manera positiva.

# Conclusión
1. El fenómeno de preferencia y recambio de automóviles en Chile indica que la marca MAZDA, PEUGEOT y RENAULT han presentado aumento los últimos años y se vieron negativamente afectados por la baja venta del año 2018. Dejando a Japón y Francia como los grandes ganadores.
2. Por otro lado DFSK lleva 3 años consecutivos en ascenso y este aumentó inclusive sobre la caída de las ventas del año 2018, por lo que esta marca denota una clara tendencia positiva.
3. La marca DODGE ha sido la que ha perdido posicionamiento 6 años consecutivos, liderando el ranking.
4. CHRYSLER es la única marca que cambio su pendiente de manera positiva cortando los 5 años consecutivos de caídas en sus ventas anuales.

* # Complementar
Para este análisis se realizó de manera general, la data enriquecida acompaña a reforzar los análsis tales como:
* evaluar el fenómeno por zonas (NORTE, CENTRO, SUR y metropolitana)
* complementar el fenómenos utilizando otros flags, como estudiar un horizonte distinto al año, como bien podría ser la edad.

NOTA: Más que utilizar respaldo estadístico para estudiar el fenómeno, como ingeniero de datos quise demostrar que el valor de la información es inherente a las herramientas y que el ingenio es un factor predominante. Y que al desconocer la formación del usuario, facilita un entendimiento mas general que explicar un fenòmeno a través de regresiones o histogramas.
