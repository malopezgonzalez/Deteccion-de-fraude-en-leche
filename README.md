# **Detección de fraude alimentario en leche**
## **Análisis de especiación de leche y detección de leche de cabra adulterada con leches de menor calidad empleando aprendizaje automático e implementación en aplicación web**
##### _Trabajo de final de máster 2023. Miguel Ángel López González_
##### _Máster en bioinformática y bioestadística UOC-UB_

En este repositorio se pueden encontrar varios elementos:

- **Resultados parciales:** Son archivos en formato Rmarkdown (_.rmd_) donde consta el código comentando todos los pasos seguidos en el planteamiento: carga de los datos, implantación de lo algoritmos, mejora y elección de los mejores modelos y escenarios de trabajo. Consta de un archivo por estudio, los cuales se encuentran en las carpetas de cada estudio, _1.Estudio_especiacion_ y _2.Estudio_adulteracion_.

- **Conjuntos de datos:** Se adjuntan los conjuntos de datos en formato _.csv_ con los cuales se ha llevado a cabo el estudio y se ha entrenado y validado el modelo. Se encuentran en las carpetas de cada estudio, _1.Estudio_especiacion_ y _2.Estudio_adulteracion_.

- **Aplicación web:** Se adjunta el código de la aplicación web en formato _.R _y los archivos dependientes. Se encuentran en la carpeta _3.WebApp._ Se puede acceder a la aplicación web mediante el siguiente enlace:
https://miguelangellg.shinyapps.io/detectorFraudeLeche/

- **Espacios de trabajo:** Archivos en formato _.Rdata_. que contienen los modelos y funciones para ser usados en la aplicación web. Se encuentran en la carpeta _3.WebApp_. Además, se adjunta el código empleado para su obtención, que es una selección del código esencial de los resultados parciales en la carpeta _4.codigo_espacios_trabajo_.

## **Sobre el trabajo**

Se trata de un trabajo de final de máster que se basa en los datos empleados por Piras y Cramer en su estudio <a href ='https://doi.org/10.1038/s41598-021-82846-5'> <i>Speciation and milk adulteration analysis by rapid ambient liquid MALDI mass spectrometry profiling using machine learning</i></a> tratando de reproducir el mismo análisis empleado algoritmos de <i>machine learning</i> alternativos afrontando el problema de la escasedad de muestras y alta dimensionalidad de los datos aplicando la técnica de aumento de muestras <i>SMOTE</i> y de reducción de la dimensionalidad <i>principal component analysis</i>.

El modelo empleado final empleado esta basado en el algoritmo <i>support vector machines</i> empleando un kernel lineal tanto para la tarea de detección de especie como la tarea de adulteración y entrenados empleando los conjuntos de datos del anterior estudio y que se alojan en el repositorio abierto de la <a href='https://doi.org/10.17864/1947.232'><i>University of Reading</i></a>.
