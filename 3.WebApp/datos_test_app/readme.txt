

Este archvio ha sido creado con la finalidad de proveer las instrucciones para el testeo de la aplicación web "Detector de fraude en leche" 
que puede entontrarse en el siguiente enlace:

https://miguelangellg.shinyapps.io/detectorFraudeLeche/

En este se indica la funcionalidad que tiene, para el testeo de la aplicación, cada archivo formato .csv que se encuentra en la presente
carpeta: 

+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
|                              |                                     |      Separador     |  Separador  |                             |
|            Archivo           |            Funcionalidad            |      columnas      |   decimal   |       Características       |
+==============================+=====================================+====================+=============+=============================+
| adu.csv                      |             Testeo de la predicción |         Coma [ , ] | punto [ . ] | Conjunto sin modificaciones |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
| adu_NA.csv                   |          Testeo validación de datos |         Coma [ , ] | punto [ . ] |        Contiene un valor NA |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
|                              |  Testeo de la predicción individual |                    |             |                             |
| adu_muestra_unica.csv        |    mediante carga y cuadro de texto |         Coma [ , ] | punto [ . ] |           Una única muestra |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
| esp.csv                      |             Testeo de la predicción |         Coma [ , ] | punto [ . ] | Conjunto sin modificaciones |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
|                              |          Testeo de la asignación de |                    |             |        Conjunto sin columna |
| esp_sin_ID.csv               |                     identificadores | Punto y coma [ ; ] | punto [ . ] |            de identificador |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
|                              |         Testeo de la predicción sin |                    |             |                             |
| esp_sin_encabezado.csv       |                encabezados de datos |         Coma [ , ] | punto [ . ] |    Conjunto sin encabezados |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
|                              |    Testeo de la asignación de IDs y |                    |             |   Conjunto sin encabezados  |
| esp_sin_encabezado_ni_ID.csv | predicción sin encabezados de datos | Punto y coma [ ; ] | punto [ . ] |             ni identificado |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+
| esp_no_numerico.csv          |          Testeo validación de datos |         Coma [ , ] | punto [ . ] |    Contiene un valor cadena |
+------------------------------+-------------------------------------+--------------------+-------------+-----------------------------+

Para el testeo de la subida del conjunto de datos correcto y para el testeo de la cantidad de variables adecuadas para cada tipo de 
predicción (tanto especiación como adulteración), se pueden emplear los conjuntos de datos de manera cruzada. Es decir, usar el conjunto
de testeo para adulteración en modo de predicción de especiación permitirá comprobar si la aplicación lanza un mensaje error de número de 
variables incorrectas para la predicción que se quiere llevar a cabo. De forma inversa, también se puede testear este hecho en el modo 
de predicción de adulteración, empleando el conjunto de datos destinado a la tarea de especiación. Hay que comentar que para llevar a cabo
una predicción de adulteración se requieren un espectro con 1600 y que para llevar una predicción de especiación se requiere un espectro
de 600 variables.