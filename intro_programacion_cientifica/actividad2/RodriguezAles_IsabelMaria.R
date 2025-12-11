#EJERCICIO 7
#Creacion variable vector10
#Forma 1:
Vector10 <- seq(1, 10)

#Forma 2:
Vector10 <- rep(seq(1, 10), times = 1)

#Forma 3, la más sencilla:
Vector10 <- 1:10

#Creacion variable Vector3
Vector3 <- c("hola", 10, TRUE)
class(Vector3)
#Como se puede observar, al aplicar la función class, vemos que es de tipo character. Esto se debe a que en R todos los elementos de 
#un vector deben ser del mismo tipo, por lo que al intentar mezclar distintos tipos, R forzará una conversión automática.

#Creación variable Lista3
Lista3 <- list("mundo", 13, FALSE)
class(Lista3)
class(Lista3[[2]])
class(Lista3[[1]])

#Como podemos observar al aplicar class, en este caso sí que se mantienen los tipos originales de los elementos de la lista.

#Creacion Matriz_Resultado
MatrizA <- matrix(1:12, nrow = 4, ncol = 3)
MatrizB <- matrix(12:23, nrow = 4, ncol = 3)
Matriz_Resultado <- MatrizA + MatrizB

#EJERCICIO 8.
#Creacion del vector_random
vector_random <- runif(50)

#Valores max y min
max_value <- max(vector_random)
min_value <- min(vector_random)

#Media y mediana
media <- mean(vector_random)
mediana <- median(vector_random)

#Desviacion
desviacion <- sd(vector_random)

#Ordemar asc y desc
ascendente <- sort(vector_random)
descendente <- sort(vector_random, decreasing = TRUE)

#Suma y producto de elementos
suma_total <- sum(vector_random)
producto_total <- prod(vector_random)

#EJERCICIO 9 -> Respondido en la memoria pdf

#EJERCICIO 10
# Lectura del nucleótido
nucleotido <- toupper(readline("Introduce un nucleótido (A, T, C, G): "))

# Evaluación con if - else if - else
if (nucleotido == "A") {
  cat("El nucleótido es Adenina (A)\n")
} else if (nucleotido == "T") {
  cat("El nucleótido es Timina (T)\n")
} else if (nucleotido == "C") {
  cat("El nucleótido es Citosina (C)\n")
} else if (nucleotido == "G") {
  cat("El nucleótido es Guanina (G)\n")
} else {
  cat("Error: el nucleótido no es válido.\n")
}


#EJERCICIO 11.
#Para resulver el problema he usado un bucle for
suma <- 0

for (i in 50:100) {
  suma <- suma + i
}

suma

#EJERCICIO 12.
#Para resolver el problema he usado un bucle for. La condicion i %% 2 == 0 es lo que comprueba que el numero sea par

suma_pares <- 0
contador <- 0

for (i in 1:50) {
  if (i %% 2 == 0) {
    suma_pares <- suma_pares + i
    contador <- contador + 1
  }
}

promedio_pares <- suma_pares / contador

suma_pares
promedio_pares

#EJERCICIO 13.
#Este ejercicio básicamente es el código del ejercicio 10 pero metido en una función
Deteccion_Nucleotido <- function() {
  
  # Leer nucleótido ingresado por el usuario
  nucleotido <- toupper(readline("Introduce un nucleótido (A, T, C, G): "))
  
  # Evaluación con if - else if - else
  if (nucleotido == "A") {
    cat("El nucleótido es Adenina (A)\n")
    
  } else if (nucleotido == "T") {
    cat("El nucleótido es Timina (T)\n")
    
  } else if (nucleotido == "C") {
    cat("El nucleótido es Citosina (C)\n")
    
  } else if (nucleotido == "G") {
    cat("El nucleótido es Guanina (G)\n")
    
  } else {
    cat("Error: el nucleótido no es válido.\n")
  }
}

#La funcion se usaria metiendo en consola Deteccion_Nucleotido()
