

Este archiov ha sido creado con la finalidad de proveer las instrucciones para el testeo de la aplicación web "Detector de fraude en leche" 
que puede entontrarse en el siguiente enlace:

https://miguelangellg.shinyapps.io/detectorFraudeLeche/

En este se indica la funcionalidad que tiene, para el testeo de la aplicación, cada archivo formato .csv que se encuentra en la presente
carpeta: 

+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
|            Archivo           |                       Funcionalidad                       | Separador columnas | Separador decimal | Encabezado | Identificador |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
| adu.csv                      | Testeo de la predicción                                   | Coma [ , ]         | Punto [ . ]       | Si         | Si, columna 1 |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
|                              | Testeo validación de datos (el conjunto contiene un       |                    |                   | Si         | Si, columna 1 |
| adu_NA.csv                   | valor NA)                                                 | Coma [ , ]         | Punto [ . ]       |            |               |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
|                              | Testeo de la predicción individual mediante carga y       |                    |                   | Si         | Si, columna 1 |
| adu_muestra_unica.csv        | cuadro de texto (el conjunto contiene una única muestra)  | Coma [ , ]         | Punto [ . ]       |            |               |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
| esp.csv                      | Testeo de la predicción                                   | Coma [ , ]         | Punto [ . ]       | Si         | Si, columna 1 |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
| esp_sin_ID.csv               | Testeo de la asignación de identificadores                | Punto y coma [ ; ] | Punto [ . ]       | Si         | No            |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
| esp_sin_encabezado.csv       | Testeo de la predicción sin encabezados de datos          | Coma [ , ]         | Punto [ . ]       | No         | Si, columna 1 |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
|                              | Testeo de la asignación de IDs y predicción               |                    | Punto [ . ]       | No         | No            |
| esp_sin_encabezado_ni_ID.csv | sin encabezados de datos                                  | Punto y coma [ ; ] |                   |            |               |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
|                              | Testeo validación de datos (el conjunto contiene un valor |                    | Punto [ . ]       | Si         | Si, columna 1 |
| esp_no_numerico.csv          | cadena)                                                   | Coma [ , ]         |                   |            |               |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+
|                              | Testeo validación de datos (el conjunto contiene un       |                    | Punto [ . ]       | Si         | Si, columna 1 |
| esp_NA.csv                   | valor NA)                                                 | Coma [ , ]         |                   |            |               |
+------------------------------+-----------------------------------------------------------+--------------------+-------------------+------------+---------------+

Para el testeo de la subida del conjunto de datos correcto y para el testeo de la cantidad de variables adecuadas para cada tipo de 
predicción (tanto especiación como adulteración), se pueden emplear los conjuntos de datos de manera cruzada. Es decir, usar el conjunto
de testeo para adulteración en modo de predicción de especiación permitirá comprobar si la aplicación lanza un mensaje error de número de 
variables incorrectas para la predicción que se quiere llevar a cabo. De forma inversa, también se puede testear este hecho en el modo 
de predicción de adulteración, empleando el conjunto de datos destinado a la tarea de especiación. Hay que comentar que para llevar a cabo
una predicción de adulteración se requieren un espectro con 1600 y que para llevar una predicción de especiación se requiere un espectro
de 600 variables.