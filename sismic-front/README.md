# Sismic Frontend

Contiene el proyecto realizado con [Nuxt](https://nuxt.com/).

## Requerimientos

- [Node.js](https://nodejs.org/en)
- [Docker](https://www.docker.com/products/docker-desktop/)

## Directorios

- **pages**
    - Contiene las paginas utilizadas en la aplicación.

## Ejecución

1. Ejecutar los servicios de `api_sisms`.
2. Ejecutar el comando.
    - `npm run dev`
3. Abrir en una ventana de navegador [localhost:4000](http://localhost:4000)

## Ejecución con Docker

1. Ejecutar los servicios de `api_sisms`.
2. Ejecutar el comando.
    - `npm run dev`
3. Construir la imagen del contenedor:
    - `docker build -t sismicfront:v1 -f .\sismic-front\Dockerfile .` .
4. Ejecutar el contenedor
    - `docker run -p 4000:4000 sismicfront:v1`
5. Abrir en una ventana de navegador [localhost:4000](http://localhost:4000)
