# Práctica: La batalla sevillana (Rebujito vs Manzanilla).

Para conseguir este reto vamos a necesitar completar dos fases. La primera de ellas consiste en escribir un `Dockerfile` para uno de los servicios de nuestra aplicación. La segunda se basa en la escritura de un archivo `docker-compose.yml`, para conseguir desplegar nuestra aplicación.

Nuestra aplicación anteriormente funcionaba perfectamente, pero ayer un usuario malicioso conocido en GitHub como @RebujitoLover AKA Germán Torres, borró con nocturnidad y alevosía el `Dockerfile` del servicio de voto y el `docker-compose.yml` que se encargaba de desplegar nuestra aplicacion, porque el rebujito estaba perdiendo la batalla.

Para entender cómo funciona nuestra aplicación por dentro necesitamos saber que el stack es bastante completo, usamos Python, Node.js, .NET, con Redis para la comunicación and Postgres para almacenar nuestro datos. El diagrama donde representemos a todos los servicios y a ti (si hij@, eres ese monigote), nos quedaría tal que así: 

<p align="center">
<img src="architecture.excalidraw.png">
</p>

## Fase 1: Creación de un `Dockerfile`.

Afortunadamente, podemos volver a restablecer el servicio sin problema creando desde 0 nuestro `Dockerfile` para por fin acabar con el debate de la papagorda. Antes de eso, reconozcamos la estructura de un archivo 'Dockerfile':

```dockerfile
# 1. Definir la imagen base (El sistema operativo de partida)
FROM <imagen>:<tag> AS <nombre_etapa>
# 2. Definir el directorio de trabajo (La carpeta donde ocurrirá todo)
WORKDIR /ruta/de/la/app
# 3. Copiar archivos desde tu ordenador al contenedor
COPY <archivo_en_mi_pc> <ruta_en_el_contenedor>
# 4. Ejecutar comandos (Instalar paquetes, librerías, etc.)
RUN <comando_de_consola>
# 5. Definir variables de entorno (Configuraciones de la app)
ENV <CLAVE>=<valor>
# 6. Informar el puerto que usa la aplicación (Documentación)
EXPOSE <numero_puerto>
# 7. El comando que arranca la aplicación (Solo puede haber uno)
CMD ["ejecutable", "parametro1", "parametro2"]

# --- MULTI-STAGE (Etapas avanzadas) ---
# Iniciar una nueva etapa heredando de una anterior
FROM <etapa_anterior> AS <nueva_etapa>
# Copiar archivos generados en otra etapa distinta
COPY --from=<etapa_origen> <ruta_origen> <ruta_destino>
```
---

Ahora que tenemos la estructura básica de un `Dockerfile` tenemos que volver a configurar el nuestro:

### Etapa 1: Base común (stage `base`).

1. Nuestra aplicación usaba `python:3.11-slim` y la definía como `base`.
2. También ejecutaba un healthcheck con los siguientes comandos:
```bash
apt-get update
apt-get install -y --no-install-recommends curl
rm -rf /var/lib/apt/lists/*
```
3. Definía el workspace en `/usr/local/app`.
4. Copiaba el archivo `requirements.txt` dentro del contenedor.
5. Instalaba los requisitos usando `pip' y el tag `--no-cache-dir`.

### Etapa 2: Desarrollo (stage `dev`).

1. Creaba una nueva etapa llamada `dev` que heredaba de `base`.
2. Instalaba el paquete `watchdog` con pip (para detectar cambios en archivos).
3. Configuraba la variable de entorno `FLASK_ENV=development`.
4. Ejecutaba el comando de inicio `python app.py`.

### Etapa 3: Producción (stage `final`).

1. Creaba una etapa final llamada `final` que también heredaba de `base`.
2. (Provisional) Definía dos variables de entorno para las opciones de votación:
    - `OPTION_A=Rebujito`
    - `OPTION_B=Manzanilla`
3. Copiaba todo el código de la aplicación al directorio de trabajo del contenedor (`.`).
4. Exponía el puerto `80` para que la aplicación sea accesible.
5. El comando final usaba Gunicorn (servidor de producción para Python) con estos parámetros:
    - Aplicación: `app:app`
    - Bind: `0.0.0.0:80`
    - Log file: `-` (stdout)
    - Access log file: `-` (stdout)
    - Workers: `4`
    - Keep alive: `0`

Asi que, crea el archivo `vote/Dockerfile` siguiendo las instrucciones anteriores. El archivo debe tener **tres etapas** (base, dev, final) usando multi-stage builds.

---

### Pistas:

**Ejecutar múltiples comandos en un solo RUN (más eficiente):**
```dockerfile
RUN comando1 && \
    comando2 && \
    comando3
```

**Heredar de una etapa anterior:**
```dockerfile
FROM nombre_etapa_anterior AS nueva_etapa
```

**Formato del CMD con lista (recomendado):**
```dockerfile
CMD ["ejecutable", "arg1", "arg2", "arg3"]
```

**Ejemplo de un comando con gunicorn**:
```bash
gunicorn app:app -b 0.0.0.0:80 --log-file - --access-logfile - --workers 4 --keep-alive 0
```
---
### Comprueba que funciona:

```bash
# Construye la imagen (usa stage "final" por defecto)
docker build -t vote-app .

# Ejecuta el contenedor
docker run -p 8080:80 vote-app

# Abre en el navegador
# http://localhost:8080
```

---

### ¿Por qué multi-stage?

El multi-stage build nos permite tener:
- **base**: Configuración común compartida
- **dev**: Optimizado para desarrollo (hot-reload, debugging)
- **final**: Optimizado para producción (Gunicorn, sin herramientas de desarrollo)

Esto hace que la imagen de producción sea más pequeña y segura, mientras que la de desarrollo es más cómoda para trabajar.


---

## Fase 2: Orquestación con Docker Compose.

Ahora, ya tenemos funcionando nuestro servicio de voto solo nos queda volver a crear nuestro archivo `docker-compose.yml`. Para ello te recomiendo usar la extensión de Docker para VSCode, que ayuda mucho a la hora de crear estos archivos.


### Estructura básica de docker-compose.yml

Antes de empezar, reconozcamos los vestigios del archivo `docker-compose.yml` que @RebujitoLover dejó:

```yaml
services:
  vote:
    # Borrado por @RebujitoLover, el rebujito es mejor.

  result:
    # Borrado por @RebujitoLover, el rebujito es mejor.

  worker:
    build:
      context: ./worker
    depends_on:
      redis:
        condition: service_healthy 
      db:
        condition: service_healthy 
    networks:
      - # Borrado por @RebujitoLover, el rebujito es mejor.

  redis:
    image: redis:alpine
    volumes:
      - "./healthchecks:/healthchecks"
    healthcheck:
      test: /healthchecks/redis.sh
      interval: "5s"
    networks:
      - # Borrado por @RebujitoLover, el rebujito es mejor.

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
    volumes:
      - "db-data:/var/lib/postgresql/data"
      - "./healthchecks:/healthchecks"
    healthcheck:
      test: /healthchecks/postgres.sh
      interval: "5s"
    networks:
      - # Borrado por @RebujitoLover, el rebujito es mejor.

  # this service runs once to seed the database with votes
  # it won't run unless you specify the "seed" profile
  # docker compose --profile seed up -d
  seed:
    build: ./seed-data
    profiles: ["seed"]
    depends_on:
      vote:
        condition: service_healthy 
    networks:
      - # Borrado por @RebujitoLover, el rebujito es mejor.
    restart: "no"

volumes:
  db-data:

networks:
  # Borrado por @RebujitoLover, el rebujito es mejor.

```

Como podemos observar, @RebujitoLover eliminó por completo el servicio de voto y el de resultados, para así imposibilitar tanto la votación como el escrutinio. Afortunadamente, tenemos la especificación que en su día se hizo para el archivo.

---

### Etapa 1: Servicio de voto.

1. Nuestro servicio de voto se construía en base `./vote` con el tag `dev`.
2. Dependía de que el servicio de `redis`estuviese sano.
3. Era quien de verdad se encargaba de definir las opciones que declaramos anteriormente en el Dockerfile con `environment:`.
4. Posteriormente, hacía un healthcheck configurado de la siguiente manera:

```yaml
test: ["CMD", "curl", "-f", "http://localhost"]
interval: 15s
timeout: 5s
retries: 3
start_period: 10s
```
5. Definía un volume `./vote:/usr/local/app`.
6. Finalmente, exponía el puerto `8080:80`.

### Etapa 2: Servicio de escrutinio.

1. El servicio se construía en base a `./result`.
2. Tenía un entrypoint definido `nodemon --inspect=0.0.0.0 server.js`.
3. Dependía de que el servicio de la base de datos estuviera `service_healthy`.
4. Al igual que el servicio de voto, definía las opciones en el entornocon:
```yml
      - OPTION_A=Rebujito
      - OPTION_B=Manzanilla
```
5. Definía un volume en `./result:/usr/local/app`.
6. Finalmente, exponía los puertos `8081:80` y `127.0.0.1:9229:9229`.

### Etapa 3: Creación de redes.

1. El archivo docker-compose.yml definía dos redes, `front-tier` y `back-tier`.
2. Cada servicio tenía acceso a una o ambas redes. Aquí se especifica el acceso: 
```js
vote: front-tier, back-tier
result: front-tier, back-tier
worker: back-tier
redis: back-tier
db: back-tier
seed: front-tier
```

Si has seguido los pasos bien, deberías poder desplegar la aplicación usando el comando:
```bash
docker compose up
```

Si entras en http://localhost:8080 deberías ver el servicio de voto, y al entrar en http://localhost:8081 verás el servicio de escrutinio.
