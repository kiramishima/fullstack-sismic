# API Sisms

Contiene el proyecto realizado con [Sinatra](https://sinatrarb.com/) mediante el CLI [Sinator](https://github.com/kuntoaji/sinator).

## Requerimientos

- [ruby](https://www.ruby-lang.org/es/)
- [Docker](https://www.docker.com/products/docker-desktop/)
- [postgresql](https://www.postgresql.org/)

## Directorios

- **app**
    - Contiene los controllers y models de la aplicación.
- **config**
    - Contiene el archivo `database.yml`, donde se configura la conexión a la base de datos.
- **db/migrations**
    - Contiene las migraciones realizadas con [migrate](https://github.com/golang-migrate/migrate)

## Ejecución

1. Crear la base de datos `sismic` en PostgreSQL.
    - `CREATE DATABASE sismic;`
2. Ejecutar las migraciones mediante migrate.
    - `migrate -path=db/migrations -database="postgres://<db_user>:<db_password>@<db_host>/sismic?sslmode=disable" up`
        - Ejemplo: `migrate -path=db/migrations -database="postgres://postgres:123456@192.168.100.47/sismic?sslmode=disable" up`
3. Ejecutar el comando:
    - `bundle exec puma -p 3000` . Esto levantara el api en el puerto 3000.

## Ejecución con Docker

1. Crear la base de datos `sismic` en PostgreSQL.
    - `CREATE DATABASE sismic;`
2. Ejecutar las migraciones mediante migrate.
    - `migrate -path=db/migrations -database="postgres://<db_user>:<db_password>@<db_host>/sismic?sslmode=disable" up`
        - Ejemplo: `migrate -path=db/migrations -database="postgres://postgres:123456@192.168.100.47/sismic?sslmode=disable" up`
3. Construir la imagen del contenedor:
    - `docker build -t sismic:v1 -f ./api_sisms/Dockerfile .` .
4. Ejecutar el contenedor
    - `docker run -p 3000:3000 sismic:v1`

## Endpoints

### Endpoint: Listado de Features 


- Path: `/api/features`
- Method: `GET`
- Response: Regresa un listado de features.
- Params:
    - page: Pagina a obtener
    - per_page: Elementos por pagína
    - mag_type[]: Filtrado por tipo de mag type.

Ejemplo Respuesta:

```json
{
    "data": [
        {
            "id": 1,
            "type": "feature",
            "attributes": {
                "external_id": "nc74033106",
                "magnitude": 2.63,
                "place": "8 km NE of Gilroy, CA",
                "time": "1712903037460",
                "tsunami": 0,
                "mag_type": "md",
                "title": "M 2.6 - 8 km NE of Gilroy, CA",
                "coordinates": {
                    "longitude": -121.5110016,
                    "latitude": 37.0660019
                }
            },
            "links": {
                "external_url": "https://earthquake.usgs.gov/earthquakes/eventpage/nc74033106"
            }
        }
        ...
    ],
    "pagination": {
        "curret_page": 1,
        "total": 9678,
        "per_page": 20
    }
}
```

### Endpoint: Listado de Comentarios realizados a un feature


- Path: `/api/features/:id/comments`
- Method: `GET`
- Response: Regresa un listado de comentarios realizados a un feature.
- Params:
    - id: Id del feature

Ejemplo Respuesta:

```json
{
    "data": [
        {
            "comment": "This is a comment",
            "created_at": "2024-04-12 07:08:16 +0000"
        }
        ...
    ]
}
```

### Endpoint: Enviar comentario a un feature


- Path: `/api/features/:id/comments`
- Method: `POST`
- Response: Agrega un comentario a un feature.
- Params:
    - id: Id del feature
- Form:
    - Content-Type: `application/json`
    - Body: `{body: "This is a comment"}`

Ejemplo Respuesta:

```json
{"message": "Comentario enviado correctamente"}
```