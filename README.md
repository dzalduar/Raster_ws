# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo;
2. Implementar un algoritmo de anti-aliasing para sus aristas; y,
3. Hacer shading sobre su superficie.

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/framesjs/releases).

## Integrantes

Máximo 3.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|Oscar Parra | odparraj    |
|Alejandra Zaldua|dzalduar |

## Discusión

Describa los resultados obtenidos. Qué técnicas de anti-aliasing y shading se exploraron? Adjunte las referencias. Discuta las dificultades encontradas.

Primero se rasterizó el triángulo usando la estrategia de evaluar si el centro de cada pixel estaba adentro o afuera de la figura. También trabajamos coloreando el pixel si uno de sus cuatro vértices estaba dentro de la figura. Finalmente decidimos que la primera aproximación era mejor porque reflejaba la figura que queríamos rasterizar con mayor fidelidad. El triángulo rasterizado se ve en blanco.

En cuanto a anti-aliasing, usamos la técnica de subdivisión de los pixeles dados en la grilla original. En este caso ya no recorrimos toda la grilla principal para hacer la subdivisión pixel a pixel, sino que tuvimos en cuenta únicamente los pixeles que ya estaban coloreados de blanco. El efecto de anti-aliasing se ve presionando la tecla "a" y es posible aumentar la cantidad de sub-pixeles con la tecla "p" y se disminuye con la tecla "n". Es posible variar los subpixeles entre 4 y 64 (es decir, el lado de un pixel varía entre 2 y 8 subpixeles). Para valores de subdivisión muy grandes, la capacidad de procesamiento de nuestras máquinas era superada, y el programa dejaba de responder.

Para implementar la función de shading, tuvimos que guardar en un arreglo de tamaño variable (lista) los subpixeles que se encontraban dentro del triángulo. Luego de guardarlos, se calcula el promedio de color del pixel principal (no los subpixeles) donde nos encontramos, y coloreamos los subpixeles con ese promedio de color, para que se pueda observar un efecto de suavizado. Este efecto se activa y desactiva presionando la tecla "s".

## Entrega

* Modo de entrega: [Fork](https://help.github.com/articles/fork-a-repo/) la plantilla en las cuentas de los integrantes (de las que se tomará una al azar).
* Plazo: 1/4/18 a las 24h.
