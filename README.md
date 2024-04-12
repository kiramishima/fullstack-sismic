# Fullstack sismic

Codigo creado para el challenge en Frogmi. Incluye Backend en ruby and Frontend con Nuxt 3.

## Requerimientos

- [Docker](https://www.docker.com/products/docker-desktop/)

## Directorios

- **api_sisms**
    - Contiene el backend hecho con Sinatra.
- **sismic-front**
    - Contiene el frontend creado con Vue & Nuxt3.
- **postgres_data**
    - Volumen para Postgres

## Pasos

### Env File

Crear el archivo `.env`. El archivo `dev.env` contiene un ejemplo de variables de entorno que se pueden configurar.

### Construir imagenes del Backend y Frontend

Para levantar los servicios, asegurese de tener instalado docker.

Ejecute el comando:

```sh
docker compose build
docker compose up -d
```

Esto construira las imagenes para el backend y el frontend, y levantara los servicios.

### Migraciones

Para ejecutar las migraciones, ejecute el siguiente comando:

```sh
docker compose up migrate
```

Esto ejecutara las migraciones con [migrate](https://github.com/golang-migrate/migrate)

Despues ejecutar el siguiente comando:

```sh
docker compose up api_sisms -d 
```

### Obtener data de Earthquake API

Para realizar la ingesta de datos, sera necesario ejecutar el siguiente comando:

```sh
# si el servicio de api_sisms se encuentra apagado, ejecutar: docker compose up api_sisms -d
# antes de ejecutar este comando, para levantar el contenedor del servicio api_sisms 
docker compose exec api_sisms rake earthquake:get_data_from_earthquake
```

## Links

- API: [localhost:3000](http://localhost:3000/api/features)
- Frontend: [localhost:4000](http://localhost:4000)
- PGAdmin: [localhost:8080](http://localhost:8080)
    - user: admin@admin.com
    - password: root
    - host: pg-database
    - db_user: postgres
    - db_password: postgres
    - db: sismic



