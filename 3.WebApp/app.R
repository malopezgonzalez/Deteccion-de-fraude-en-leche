
# Carga de librerías

library(shiny)
library(dplyr)
library(rsconnect)
library(caret)
library(shinythemes)
library(shinyvalidate)
library(shinyjs)
library(shinyalert)
library(kernlab)


ui <- fluidPage(
    theme = shinytheme("sandstone"),
    # Título de la aplicación
    titlePanel("Detector de fraude alimentario en leche"),
    
    sidebarLayout(
        sidebarPanel(
            
            # Botón para escoger el tipo de predicción
            radioButtons(inputId = "formFraude",
                         label = "¿Qué desea hacer?",
                         choices = list("Determinar especie" = "esp", "Detectar adulteración (solo para leche de cabra)" = "adu"),
                         inline = T,
                         selected = "esp",
            ),
            
            # Botón para escoger la forma de predicción
            radioButtons("numPred", label = "¿Cuántas predicciones desea hacer?",
                         inline = TRUE,
                         choices = list("Individual" = "individual", 
                                        "Múltiple" = "multiple"), 
                         selected = "multiple"),
            
            # Botón para escoger el tipo de carga de datos
            conditionalPanel('input.numPred == "individual"',
                             radioButtons("formCarga", label = "Seleccione tipo de carga de datos",
                                          inline = TRUE,
                                          choices = list("Archivo" = "archivo",
                                                         "Manual" = "manual"),
                                          selected = "archivo"),
            ), 
            
            # Panel para carga de datos manual
            conditionalPanel('input.numPred == "individual"  & input.formCarga == "manual"',
                             textAreaInput("formTxt", label = "Pegue aquí su muestra:", placeholder = "0.000396852476875171,0.000573389491313757,"),
            ),
            
            # Panel para cargar los datos por archivo
            conditionalPanel('input.numPred == "multiple"  | (input.numPred == "individual"  & input.formCarga == "archivo")',
                             
                             fileInput("formArchivo", "Escoja archivo CSV:",
                                       accept = ".csv"),
                             checkboxInput("formEnc", "Mis datos contienen encabezados" , value = F),
            ),
            # Panel para indicar si los datos contienen algún identificador y en qué columna se emplazan
            checkboxInput("formEtq", "Mis datos están identificados" , value = F),
            conditionalPanel("input.formEtq == 1",
                             numericInput("formEtqcol", label = "Indique la columna dónde se encuentra el identificador", value = 1, min = 1, max = NA ),
            ),
            
            # Panel para el formato de las muestras
            radioButtons("formSep", label = "Separador de columnas",
                         inline = TRUE,
                         choices = list("Coma [ , ]" = ",",
                                        "Punto y coma [ ; ]" = ";"),
                         selected = ","),
            
            radioButtons("formDec", label = "Decimales",
                         inline = TRUE,
                         choices = list("Coma [ , ]" = ",",
                                        "Punto [ . ]" = "."),
                         selected = "."),
            
            # Panel para enviar y borrar el contenido
            actionButton("borrar", "Borrar"),
            actionButton("analizar", "Analizar")
            
        ), # Final sidebarPanel
        
        mainPanel(
            tabsetPanel(
                tabPanel("Instrucciones", 
                         HTML("<br>
                              <p class=instrucciones> En primer lugar escoja el tipo de fraude a analizar:
                              
                              <ul>
                              <li><b>Determinar la especie origen de la leche:</b></li>
                              Devuelve la especie de la cual proviene la leche. El modelo ha sido entrenado
                              con datos de espectrometría de masas AP-MALDI sobre líquidos, en el rango m/z 
                              que va de 400.5 a 999.5. Para ejectuar el análisis es necesario introducir un
                              conjunto de datos medido en dicho rango con un total de 600 variables y un paso
                              de m/z entre variables de 1.
                              
                              <li><b>Determinar la posible adulteración de la leche:</b></li>
                              Devuelve si la leche está adulterada o no. Esta opción es exclusiva para determinar
                              adulteración en leche de cabra. El modelo ha sido entrenado con datos de espectrometría
                              de masas AP-MALDI sobre líquidos, en el rango m/z que va de 400 a 1999. Para ejectuar 
                              el análisis es necesario introducir un conjunto de datos medido en dicho rango con un 
                              total de 1600 variables y un paso de m/z entre variables de 1.
                              </ul>
                              
                              A continuación indique el número de predicciones que desea hacer:
                              <ul>
                              <li><b>Predicción individual:</b></li>
                              Predice la clase de una sola muestra. Puedes introducir los datos mediante la carga de
                              de un archivo en fromato <i>.csv</i> o bien manualmente copiando la muestra en formato
                              texto en el correspondiente cuadro.
                              
                              <li><b>Determinar la posible adulteración de la leche:</b></li>
                              Predice la clase de tantas muestras como se hayan cargado. Con esta opción únicamente se pueden.
                              introducir los datos mediante carga de un archivo en formato <i>.csv</i>.
                              </ul>
                              
                              En cualquiera de las dos opciones deberá indicar el carácter separador de columnas (coma [ , ] o 
                              punto y coma [ ; ]) y el carácter separador de decimales (coma [ , ] o punto [ . ]). Para cualquier
                              otro valor, por favor, modifique su conjunto de datos a alguna de las opciones disponibles.<br>
                              <br>
                              
                              Indique si los datos cargados contienen encabezados e indique si sus datos están
                              identificados introduciendo el número de la columna dónde se encuentra el identificador.<br>
                              <br>
                              
                              Una vez introducidos todos los datos ejecute el análisis con el botón <i>Analizar</i> y revise
                              la pestaña <i>Resultados</i> para ver el resultado del análisis. El tiempo de cálculo puede
                              variar dependiendo del número de muestras analizadas. Puede devolver los campos a sus valores
                              por defecto accionando el botón <i>Borrar</i>.<br>
                              <br>
                              </p>")),
                tabPanel("Resultados",
                         dataTableOutput("res")),
                tabPanel("Sobre la aplicación",
                         HTML("<br>
                              <p> Esta aplicación ha sido creada en 2023 por <a href ='https://www.linkedin.com/in/miguelangellg/'> 
                              Miguel Ángel López González</a> en el marco del trabajo de final de máster
                              <i>Detección de fraude alimentario en leche: Análisis de especiación de leche y detección de leche de cabra 
                              adulterada con leches de menor calidad empleando aprendizaje automático.</i>
                              del máster en bioinformática y bioestádistica ofrecido por la Universitat Oberta de Catalunya
                              y la Universitat de Barcelona. <br>
                              <br>
                              
                              El presente trabajo de final de máster se basa en los datos empleados por 
                              Piras y Cramer en su estudio <a href ='https://doi.org/10.1038/s41598-021-82846-5'>
                              <i>Speciation and milk adulteration analysis by rapid ambient liquid MALDI mass spectrometry
                              profiling using machine learning</i></a> tratando de reproducir
                              el mismo análisis empleado algoritmos de <i>machine learning</i> alternativos afrontando el problema
                              de la escasedad de muestras y alta dimensionalidad de los datos aplicando la técnica de aumento de muestras
                              <i>SMOTE</i> y de reducción de la dimensionalidad <i>principal component analysis</i>.
                              
                              El modelo empleado para esta aplicación esta basado en el algoritmo <i>support vector machines</i>
                              empleando un kernel lineal tanto para la tarea de detección de especie como la tarea de adulteración
                              y entrenados empleando los conjuntos de datos del anterior estudio y que se alojan en el repositorio
                              abierto de la <a href='https://doi.org/10.17864/1947.232'><i>University of Reading</i></a>.
                              
                              Puede consultarse públicamente el código y los archivos dependientes empleados para el desarrollo de esta aplicación en
                              el repositorio que se indica a continuación. En este también se adjunta en formato <i>.Rmarkdown</i> el proceso realizado para la obtención de los modelos que
                              aquí se implementan, así como los conjuntos de datos originales a partir de los cuales se han entrenado y validado los modelos:<br>
                              <a href='https://github.com/malopezgonzalez/Deteccion-de-fraude-en-leche'>github.com/malopezgonzalez/Deteccion-de-fraude-en-leche</a><br>
                              <br>
                              La confección de la presente aplicación ha estado inspirada por los trabajos de:
                              <ul>
                              <li>Damaris Alarcón Vallejo con su <a href='https://github.com/DamarisA91/Predictor_de_la_salud_lumbar/blob/main/App/app.R'> Predictor de salud lumbar<a>:</li>
                              <a href='https://damaris24.shinyapps.io/Predictor_de_salud_lumbar/'>damaris24.shinyapps.io/Predictor_de_salud_lumbar/</a>
                              <li>Santiago González Berruga con su <a href='https://github.com/santigberruga/Predict-Liver-Disease/blob/main/WebApp/app.R'> Liver disease predictor<a>:</li>
                              <a href='https://gonzalezberrugasantiago.shinyapps.io/Predict_Liver_Disease/'>gonzalezberrugasantiago.shinyapps.io/Predict_Liver_Disease/</a>
                              <li>Chanin Nantasenamat con su <a href='https://github.com/dataprofessor/rshiny_freecodecamp'> tutorial de shiny para la ciencia de datos<a>:</li>
                              <a href='https://youtu.be/9uFQECk30kA'>R Shiny for Data Science Tutorial – Build Interactive Data-Driven Web Apps</a>
                              </ul>
                              a los que se les agradece públicamente su aporte para el desarrollo de la aplicación.<br>
                              <br>
                              </p>")),
                tabPanel("Datos para probar la aplicación",
                         HTML('<br>
                              <p class=prueba> Es posible descargar diferentes conjuntos de datos para probar la aplicación haciendo
                              click en el siguiente botón. Se descargará un archivo <i>.zip</i> el cual contiene diferentes
                              conjuntos de datos en formato <i>.csv</i>. El nombre del archivo describe si es un conjunto de datos para funcionalidad
                              de especiación (esp) o bien para la funcionalidad de adulteración (adu). En la tabla que se muestra a continuación
                              se describe la codificación de decimales y separadores de columna de cada archivo, así como la función y 
                              si estos contienen una fila de encabezados o una columna identificativa:<br>
                              <style type="text/css">
                              .tg  {border-collapse:collapse;border-spacing:0;}
                              .tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
                                overflow:hidden;padding:10px 5px;word-break:normal;}
                              .tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
                                font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
                              .tg .tg-rsui{border-color:inherit;font-size:13px;text-align:right;vertical-align:bottom}
                              .tg .tg-1a22{border-color:inherit;font-size:13px;font-weight:bold;text-align:center;vertical-align:bottom}
                              .tg .tg-2k8k{border-color:inherit;font-size:13px;font-weight:bold;text-align:center;vertical-align:top}
                              .tg .tg-9k9h{border-color:inherit;font-size:13px;font-style:italic;font-weight:bold;text-align:left;vertical-align:bottom}
                              .tg .tg-znh0{border-color:inherit;font-size:13px;text-align:right;vertical-align:top}
                              </style>
                              <table class="tg" style="undefined;table-layout: fixed; width: 817px">
                              <colgroup>
                              <col style="width: 212px">
                              <col style="width: 228px">
                              <col style="width: 116px">
                              <col style="width: 77px">
                              <col style="width: 92px">
                              <col style="width: 92px">
                              </colgroup>
                              <thead>
                                <tr>
                                  <th class="tg-1a22">Archivo</th>
                                  <th class="tg-1a22">Funcionalidad</th>
                                  <th class="tg-1a22">Separador columnas</th>
                                  <th class="tg-1a22">Separador decimal</th>
                                  <th class="tg-2k8k">Encabezado</th>
                                  <th class="tg-2k8k">Identificador</th>
                                </tr>
                              </thead>
                              <tbody>
                                <tr>
                                  <td class="tg-9k9h">adu.csv</td>
                                  <td class="tg-rsui">Testeo de la predicción</td>
                                  <td class="tg-rsui">Coma [ , ]</td>
                                  <td class="tg-rsui">Punto [ . ]</td>
                                  <td class="tg-znh0">Si</td>
                                  <td class="tg-znh0">Si, columna 1</td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">adu_NA.csv</td>
                                  <td class="tg-rsui">Testeo validación de datos (el conjunto contiene un valor NA)</td>
                                  <td class="tg-rsui">Coma [ , ]</td>
                                  <td class="tg-rsui">Punto [ . ]</td>
                                  <td class="tg-znh0">Si</td>
                                  <td class="tg-znh0"><span style="font-weight:400;font-style:normal">Si, columna 1</span></td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">adu_muestra_unica.csv</td>
                                  <td class="tg-rsui">Testeo de la predicción individual mediante carga y cuadro de texto (el conjunto contiene una única muestra)</td>
                                  <td class="tg-rsui">Coma [ , ]</td>
                                  <td class="tg-rsui">Punto [ . ]</td>
                                  <td class="tg-znh0">Si</td>
                                  <td class="tg-znh0"><span style="font-weight:400;font-style:normal">Si, columna 1</span></td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">esp.csv</td>
                                  <td class="tg-rsui">Testeo de la predicción</td>
                                  <td class="tg-rsui">Coma [ , ]</td>
                                  <td class="tg-znh0">Punto [ . ]</td>
                                  <td class="tg-znh0">Si</td>
                                  <td class="tg-znh0"><span style="font-weight:400;font-style:normal">Si, columna 1</span></td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">esp_sin_ID.csv</td>
                                  <td class="tg-rsui">Testeo de la asignación de identificadores</td>
                                  <td class="tg-rsui">Punto y coma [ ; ]</td>
                                  <td class="tg-znh0">Punto [ . ]</td>
                                  <td class="tg-znh0">Si</td>
                                  <td class="tg-znh0">No</td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">esp_sin_encabezado.csv</td>
                                  <td class="tg-rsui">Testeo de la predicción sin encabezados de datos</td>
                                  <td class="tg-rsui">Coma [ , ]</td>
                                  <td class="tg-znh0">Punto [ . ]</td>
                                  <td class="tg-znh0">No</td>
                                  <td class="tg-znh0"><span style="font-weight:400;font-style:normal">Si, columna 1</span></td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">esp_sin_encabezado_ni_ID.csv</td>
                                  <td class="tg-rsui">Testeo de la asignación de IDs y predicción sin encabezados de datos</td>
                                  <td class="tg-rsui">Punto y coma [ ; ]</td>
                                  <td class="tg-znh0">Punto [ . ]</td>
                                  <td class="tg-znh0">No</td>
                                  <td class="tg-znh0">No</td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">esp_no_numerico.csv</td>
                                  <td class="tg-rsui">Testeo validación de datos (el conjunto contiene un valor cadena)</td>
                                  <td class="tg-rsui">Coma [ , ]</td>
                                  <td class="tg-znh0">Punto [ . ]</td>
                                  <td class="tg-znh0">Si</td>
                                  <td class="tg-znh0">Si, columna 1</td>
                                </tr>
                                <tr>
                                  <td class="tg-9k9h">esp_NA.csv</td>
                                  <td class="tg-rsui">Testeo validación de datos (el conjunto contiene un valor NA)</td>
                                  <td class="tg-rsui">Coma [ , ]</td>
                                  <td class="tg-znh0">Punto [ . ]</td>
                                  <td class="tg-znh0">Si</td>
                                  <td class="tg-znh0">Si, columna 1</td>
                                </tr>
                              </tbody>
                              </table>
                              <br>
                              Para el testeo de la subida del conjunto de datos correcto y para el testeo de la cantidad de variables adecuadas para cada tipo de 
                              predicción (tanto especiación como adulteración), se pueden emplear los conjuntos de datos de manera cruzada. Es decir: usar el conjunto
                              de testeo para adulteración en modo de predicción de especiación, permitirá comprobar si la aplicación lanza un mensaje error de número de 
                              variables incorrectas para la predicción que se quiere llevar a cabo. De forma análoga pero inversa, también se puede testear este hecho en el modo 
                              de predicción de adulteración, empleando el conjunto de datos destinado a la tarea de especiación. Hay que comentar que para llevar a cabo
                              una predicción de adulteración se requiere un espectro con 1600 variables y que para llevar una predicción de especiación se requiere un espectro
                              de 600 variables, por lo que se pueden testear los mensajes de error subiendo cualquier archivo que no cumpla con esta cantidad
                              de variables.<br>
                              </p>'),
                         downloadButton("downloadData", "Descargue aquí los conjuntos de datos de prueba"),
                         HTML('<br>
                              <br>')),
                selected = "Resultados"
            ),
  
            shinyjs::useShinyjs(), # Necesario para el uso de las funciones de shinyjs
            
        ), # Final mainPanel
        
    ), # Final sidebarLayout
    
    tags$footer(align = "center",
                HTML("<b>Detector de fraude alimentario en leche <br> Aplicación creada en 2023 por Miguel Ángel López González</b>"),
       div(actionLink("linkedin", icon = icon("linkedin"),
                           label= a(href ="https://www.linkedin.com/in/miguelangellg/", "Sígueme en LinkedIn")),
                ),
       img(src="logouoc.png", align = "center", height = '38.74px', width = '150px'),
       img(src="logoub.png", align = "center", height = '40.98px', width = '150px'),
       HTML('<br><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Licencia de Creative Commons" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />
            Este obra está bajo una <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">licencia de Creative Commons Reconocimiento-NoComercial-CompartirIgual 4.0 Internacional</a>'),
           )
    
)  # Final UI


server <- function(input, output) {
    
    # Botón de descarga de conjuntos de datos de prueba
    output$downloadData <- downloadHandler(
        filename = "datos_test_app.zip",
        content = function(file) {
            zip(file, "datos_test_app")
        })
    # Validación de datos en formulario (número de columna)
    validador <- InputValidator$new()
    validador$add_rule("formEtqcol", sv_required(message = "Valor requerido"))
    validador$add_rule("formEtqcol", sv_gt(0, message_fmt = "Valores permitidos mayores que 0"))
    validador$add_rule("formEtqcol", sv_integer(message = "Solo se permiten valores enteros"))
    validador$enable()
    
    
    # Carga de datos
    datos <- reactiveValues(data = NULL) # Se crea el valor reactivo de datos
    id <- reactiveValues(data = NULL) # Se crea el valor reactivo de identificador
    
    # Carga de datos
    observeEvent(input$analizar,{
        if(input$formCarga == "archivo"){
            req(input$formArchivo)
            datos$data <- data.frame(read.csv(input$formArchivo$datapath,
                                              sep = input$formSep,
                                              header = input$formEnc))
        }
        else{
            req(input$formTxt)
            datos$data <- read.table(text = input$formTxt,
                                     sep = input$formSep,
                                     header = F) %>%
                mutate_if(is.character, as.numeric)
        }
        
        # Definición del identificador supeditado a la validez del valor de columna
        if(validador$is_valid()){if(input$formEtq == F){
            id$data <- c(paste("Muestra", 1:nrow(datos$data), sep = "_"))
            datos$data <- datos$data %>% mutate_if(is.character, as.numeric)
        }
            else{
                req(input$formEtqcol)
                id$data <- datos$data[,input$formEtqcol]
                datos$data <- datos$data[,-input$formEtqcol] %>% 
                    mutate_if(is.character, as.numeric)
            }}
    }) # Fin de carga de datos
    
    # Validaciones de datos
    v <- reactiveVal(0) # Creamos un contador de validaciones
    observeEvent(input$analizar,{
        v(0) # Aquí se reinicializa el contador a 0 para que no haya problemas
            # cuando se vuelve a ejecutar la aplicación después de un error.
        
        req(datos$data)
        
        # Se comprueban que los valores del conjunto de datos son numéricos
        if (sum(lapply(datos$data, is.numeric)==FALSE) > 0) {
            shinyalert(
                title = "Los datos contienen valores no numéricos",
                text = "Por favor, introduzca un conjunto de datos válido y revise que todos los datos introducidos son numéricos.",
                size = "m",
                closeOnEsc = TRUE,
                closeOnClickOutside = TRUE,
                html = TRUE,
                type = "error",
                showConfirmButton = TRUE,
                showCancelButton = FALSE,
                confirmButtonText = "Ok",
                confirmButtonCol = "red",
                timer = 0,
                imageUrl = "",
                animation = FALSE)
        } else {nv <- v() + 1 # Si es correcto se aumenta el contador de validaciones en 1
        v(nv)}
        
        # Se comprueban los valores NULL
        if (sum(is.null(datos$data)) > 0) {
            shinyalert(
                title = "Los datos contienen valores nulos",
                text = "Por favor, introduzca un conjunto de datos válido y revise que todos los datos introducidos son numéricos.",
                size = "m",
                closeOnEsc = TRUE,
                closeOnClickOutside = TRUE,
                html = TRUE,
                type = "error",
                showConfirmButton = TRUE,
                showCancelButton = FALSE,
                confirmButtonText = "Ok",
                confirmButtonCol = "red",
                timer = 0,
                imageUrl = "",
                animation = FALSE)
        } else {nv <- v() + 1 # Si es correcto se aumenta el contador de validaciones en 1
        v(nv)}
        
        # Se comprueban los valores NA
        if (sum(is.na(datos$data)) > 0) {
            shinyalert(
                title = "Los datos contienen valores perdidos",
                text = "Por favor, introduzca un conjunto de datos válido y revise que todos los datos introducidos son numéricos.",
                size = "m",
                closeOnEsc = TRUE,
                closeOnClickOutside = TRUE,
                html = TRUE,
                type = "error",
                showConfirmButton = TRUE,
                showCancelButton = FALSE,
                confirmButtonText = "Ok",
                confirmButtonCol = "red",
                timer = 0,
                imageUrl = "",
                animation = FALSE)
        } else {nv <- v() + 1 # Si es correcto se aumenta el contador de validaciones en 1
        v(nv)}
        
        # Se comprueba el número del conjunto de variables
        if(input$formFraude == "esp"){
            num_var <-  600} else {num_var <-  1600}
        
        # Validación para datos con más variables
        if (ncol(datos$data) > num_var & validador$is_valid()) {
            shinyalert(
                title = "Número de variables superior a las estipuladas",
                text = "Por favor, introduzca un conjunto de datos válido, revise que ha empleado los separadores de columnas y decimales correctos o bien si sus datos contienen una cilumna identificativa o no.",
                size = "m",
                closeOnEsc = TRUE,
                closeOnClickOutside = TRUE,
                html = TRUE,
                type = "error",
                showConfirmButton = TRUE,
                showCancelButton = FALSE,
                confirmButtonText = "Ok",
                confirmButtonCol = "red",
                timer = 0,
                imageUrl = "",
                animation = FALSE)
        } else {nv <- v() + 1 # Si es correcto se aumenta el contador de validaciones en 1
        v(nv)}
        
        # Validación para datos con menos variables
        if (ncol(datos$data) < num_var & validador$is_valid()) {
            shinyalert(
                title = "Número de variables inferior a las estipuladas",
                text = "Por favor, introduzca un conjunto de datos válido, revise que ha empleado los separadores de columnas y decimales correctos o bien si sus datos contienen una cilumna identificativa o no.",
                size = "m",
                closeOnEsc = TRUE,
                closeOnClickOutside = TRUE,
                html = TRUE,
                type = "error",
                showConfirmButton = TRUE,
                showCancelButton = FALSE,
                confirmButtonText = "Ok",
                confirmButtonCol = "red",
                timer = 0,
                imageUrl = "",
                animation = FALSE)
        } else {nv <- v() + 1 # Si es correcto se aumenta el contador de validaciones en 1
        v(nv)}
        
        # Validación del indicador de columna
        if (input$formEtqcol <= 0 | sum(is.na(input$formEtqcol)) > 0) {
            shinyalert(
                title = "Valor de la columna de identificador incorreto",
                text = "Por favor, introduzca un valor dentro del rango estipulado.",
                size = "m",
                closeOnEsc = TRUE,
                closeOnClickOutside = TRUE,
                html = TRUE,
                type = "error",
                showConfirmButton = TRUE,
                showCancelButton = FALSE,
                confirmButtonText = "Ok",
                confirmButtonCol = "red",
                timer = 0,
                imageUrl = "",
                animation = FALSE)
        } else if (!is.integer(input$formEtqcol)) {
            shinyalert(
                title = "Valor de la columna de identificador incorreto",
                text = "Por favor, introduzca un número entero como valor.",
                size = "m",
                closeOnEsc = TRUE,
                closeOnClickOutside = TRUE,
                html = TRUE,
                type = "error",
                showConfirmButton = TRUE,
                showCancelButton = FALSE,
                confirmButtonText = "Ok",
                confirmButtonCol = "red",
                timer = 0,
                imageUrl = "",
                animation = FALSE)
        } else {nv <- v() + 1 # Si es correcto se aumenta el contador de validaciones en 1
        v(nv)}
    }) # Fin de validaciones de datos
    
    # Predicciones
    resultados <- reactive({
        if(v()==6){ # La ejecución de la predicción está condicionada 
                    # a que todas las validaciones sean correctas.
                    # el valor tiene que ser igual a 6 que es el número de ítems que se evalúan
            if (input$formFraude == "esp"){ # Selección del modelo
                load("esp.RData")
            }
            else {
                load("adu.RData")
            }
            req(datos$data)
            names(datos$data) <- name_var # Se renombran las variables con 
            # los mismos nombres empleados en la 
            # construcción del modelo de reuducción de las dimensiones
            datos_esc <- z_sc(datos$data, mean, sd)$data_scaled
            datos_red <- predict(pca, datos_esc)[,1:PCs]
            if(input$numPred == "individual"){datos_red = t(datos_red)} # Si la predicción es individual 
            # es necesario transponer datos_red
            # al tener un formato vertical y no horizontal
            predicciones <- cbind.data.frame("Muestra" = id$data, "Predicción" = predict(svmpca, datos_red))
            v(0) # Se reinicia el contador de inputs válidos a 0
            print(predicciones)
        }
    }) # Fin de predicciones
    
    # Renderizado de los resultados
    output$res <- renderDataTable({
        if (input$analizar > 0){
            isolate(resultados())
        }
    }) # Fin de renderizado
    
    # Botón borrar
    observeEvent(input$borrar, {
        shinyjs::reset("formEtqcol")
        shinyjs::reset("formArchivo")
        shinyjs::reset("formTxt")
    })  
    
} # Fin de server

# Ejecución de la aplicación 
shinyApp(ui = ui, server = server)
