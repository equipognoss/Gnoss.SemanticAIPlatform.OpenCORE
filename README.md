![](https://content.gnoss.ws/imagenes/proyectos/personalizacion/7e72bf14-28b9-4beb-82f8-e32a3b49d9d3/cms/logognossazulprincipal.png)

# Gnoss.Platform.OpenCORE

GNOSS Semantic AI Platform es un framework de desarrollo semántico (GNOSS Knowledge Graph Builder) que permite desarrollar soluciones de IA semántica que explotan grafos de conocimiento y un servidor de aplicaciones (GNOSS Semantic Application Server) que posibilita su publicación, despliegue y operación con las máximas garantías de seguridad, disponibilidad y rendimiento.

Gnoss Platform es una plataforma Web compleja que esta fromada por múltiples aplicaciones y usa varios sistemas de bases de datos. En este documento se explica cómo desplegar esta infraestructura a través de Docker, cómo y dónde establecer los parámetros de configuración de todas las aplicaciones de Gnoss Platform y qué parámetros configurar en el primer arranque de la aplicación. 

# Instalación de los sistemas de base de datos
Gnoss Platform usa distintos sistemas de bases de datos. En esta sección describimos cómo desplegar cada uno de ellos de manera rápida con Docker Compose. Para cada aplicación, se especifica un archivo docker-compose.yml. Para arrancar las aplicaciones definidas en un archivo docker-compose.yml, basta con subirla a un servidor que tenga docker instalado, situarse en la carpeta donde está almacenado el archivo docker-compose.yml y ejecutar la siguiente instrucción: 
docker-compose up -d
Esa instrucción busca un archivo de nombre docker-compose.yml y arranca las aplicaciones definidas en el. Si el archivo no se llama exactamente docker-compose.yml, o no estás en el directorio donde lo has almacenado, puedes pasar el atributo -f “path/docker-compose-name.yml”.  

## PostgreSQL
Para desplegar una instancia PostgreSQL con docker compose se puede usar este archivo docker-compose.yml: 
version: '3'

```yml
services:
  dbpostgresql:
    image: postgres:13.5
    restart: always
    ports:
      - 5432:5432
    environment:
      POSTGRES_PASSWORD: 'postgres'
    volumes:
      - /home/docker/postgresql/data:/var/lib/postgresql/data
volumes:
  database_data:
    driver: local
```

## Redis
Para desplegar una instancia Redis con docker compose se puede usar este archivo docker-compose.yml:
version: '3.8'

```yml
services:
  redis:
    image: redis:6.2.6
    restart: always
    ports:
     - 6379:6379
    environment:
     save: 60 1
     loglevel: warning
    volumes:
     - ./data:/data
```

## RabbitMQ
Para desplegar una instancia RabbitMQ con docker compose se puede usar este archivo docker-compose.yml:
version: "3.2"

```yml
services:
  rabbitmq:
    image: rabbitmq:3-management-alpine
    container_name: 'rabbitmq'
    hostname: 'rabbitmq'
    ports:
     - 5672:5672
     - 15672:15672
    volumes:
     - ~/.docker-conf/rabbitmq/data/:/var/lib/rabbitmq/
     - ~/.docker-conf/rabbitmq/log/:/var/log/rabbitmq
     - ~/rabbitmq.conf:/etc/rabbitmq/rabbitmq.conf
    restart: always
```

Este archivo de configuración docker-compose.yml hace referencia a un archivo de configuración rabbitmq.conf que en este caso hemos ubicado en el mismo directorio que el archivo docker-compose.yml anterior, cuyo contenido recomendado es este: 

```conf
loopback_users.guest = false

listeners.tcp.default = 5672

management.tcp.port = 15672


## Consumer timeout
## If a message delivered to a consumer has not been acknowledge before this timer
## triggers the channel will be force closed by the broker. This ensure that
## faultly consumers that never ack will not hold on to messages indefinitely.
## 60 minutes in milliseconds
consumer_timeout = 3600000
```

## Virtuoso
Para desplegar una instancia Virtuoso con docker compose se puede usar este archivo docker-compose.yml:

```yml
version: "3"
services:
    virtuoso:
        container_name:
            virtuoso
        image:
            openlink/virtuoso-opensource-7:latest
        environment:
            DBA_PASSWORD: dba      
            VIRTUOSO_INI_FILE:            
            VIRT_Parameters_NumberOfBuffers: 680000
            VIRT_Parameters_MaxDirtyBuffers: 500000
            VIRT_Parameters_MaxClientConnections: 100
            VIRT_Parameters_DirsAllowed: "./dumps"
            VIRT_HTTPServer_MaxClientConnections: 50
            VIRT_HTTPServer_ServerIdString: "virtuoso"
            VIRT_Zero Config_ServerName: "virtuoso"
            VIRT_I18N_XAnyNormalization: 3
        ports:
            - "1111:1111"
            - "8890:8890"
        volumes:
            - /var/container-data/virtuoso/db:/database   
        restart: always
```

# Listado de aplicaciones de Gnoss Platform Open CORE
En gnoss platform podríamos distinguir 3 tipos de aplicaciones: 
*	Web: Aplicación web principal que se encarga de guiar y validar todas las actividades de los usuarios. Orquesta al resto de aplicaciones de la plataforma mediante peticiones AJAX, peticiones REST o mensajes a través de colas. 
*	Microservicios Web: Conjunto de aplicaciones Web con una responsabilidad única y bien definida. Algunos de ellos son usados exclusivamente por la propia Web a través de peticiones REST (OAuth, Interno, Archivos, GestorDocumental), otros sólo se usan a través de peticiones AJAX (autocompletar, login, contextos…), y otros son mixtos, reciben peticiones vía AJAX y via petición REST a través de la Web (facetas y resultados). 
*	Tareas en segundo plano: Conjunto de aplicaciones que ejecutan tareas periódicas o están esperando a que se produzca determinado evento para realizar determinadas acciones en función del evento. Ejemplos: 
    *	Cada vez que se registra un usuario, se envía un evento al servicio de correo para enviar un email de validación. 
    *	Cada vez que se crea un recurso, se envía un mensaje al servicio SearchGraphGeneration para que genere los índices de búsqueda necesarios. 
    *	Etc. 

## Web
Es la aplicación principal de la plataforma GNOSS. Se encarga de gestionar la autorización de los usuarios a las páginas de la plataforma, la navegación por la web, mantener la sesión del usuario, la carga del menú de la aplicación web con las opciones que el usuario tiene disponibles, etc. 

## Microservicios Web
### Gnoss.Web.Api.OpenCORE 
Aplicación Web que ofrece un interfaz de programación para que otras aplicaciones puedan realizar consultas o modificaciones en los datos almacenados en la plataforma de manera automatizada. Permite crear y gestionar comunidades, recursos, usuarios, etc.
### Gnoss.Web.Autocomplete.OpenCORE
Aplicación Web que se encarga de generar las sugerencias de búsqueda de una faceta concreta. Por ejemplo, si en la faceta (o filtro de búsqueda) de país, el usuario empieza a teclear “espa”, esta aplicación le sugiere “España”.

### Gnoss.Web.Documents.OpenCORE
Aplicación Web que se encarga de almacenar y servir los documentos que suben los usuarios a la plataforma, tales como archivos Word, PDF, hojas de cálculo, archivos comprimidos, etc. Esta aplicación NO debe ser accesible desde el exterior de la plataforma GNOSS, sólo debe estar disponible para que el resto de aplicaciones puedan hacer peticiones Web a ella.

### Gnoss.Web.Facets.OpenCORE
Aplicación Web que se encarga de mostrar los filtros de búsqueda (facetas) disponibles en una página de búsqueda.

### Gnoss.Web.Intern.OpenCORE
Aplicación Web que se encarga de almacenar el contenido estático (imágenes, vídeos y pdfs principalmente) que suben los usuarios desde la Web. Esta aplicación NO debe ser accesible desde el exterior de la plataforma GNOSS, sólo debe estar disponible para que el resto de aplicaciones puedan hacer peticiones Web a ella.

### Gnoss.Web.Labeler.OpenCORE
Aplicación Web que ofrece etiquetas a partir de un título y/o una descripción. Se usa en la edición de recursos para proponerle etiquetas al usuario.

### Gnoss.Web.Login.OpenCORE
Aplicación Web que se encarga de autenticar al usuario, validar su contraseña y enviar las credenciales a la Web.

Si en una misma plataforma existen varios dominios (ej: community.gnoss.com, forum.gnoss.com, myorg.gnoss.com, …), el servicio de login es también un Single Sign On y se encarga de conectar y desconectar al usuario en todos los dominios de la plataforma en los que el usuario acceda.

### Gnoss.Web.OAuth.OpenCORE
Aplicación Web que se encarga de validar las firmas Oauth que le llegan a la Web o el API. Esta aplicación NO debe ser accesible desde el exterior de la plataforma GNOSS, sólo debe estar disponible para que el resto de aplicaciones puedan hacer peticiones Web a ella.

Esta aplicación está protegida por OAuth 1.0 y cualquier petición que se realice a ella debe ir firmada bajo ese protocolo.

### Gnoss.Web.Ontologies.OpenCORE
Aplicación Web que se encarga de almacenar y servir las ontologías de la plataforma. Esta aplicación NO debe ser accesible desde el exterior de la plataforma GNOSS, sólo debe estar disponible para que el resto de aplicaciones puedan hacer peticiones Web a ella.

### Gnoss.Web.Results.OpenCORE
Aplicación Web que se encarga de mostrar los resultados en una página de búsqueda. Los resultados pueden ser recursos, instancias de objetos de conocimiento, personas, grupos, etc.


## Tareas en segundo plano

### Gnoss.BackgroundTask.SocialSearchGraphGeneration.OpenCORE
Aplicación de segundo plano que se encarga de insertar en el grafo de búsqueda de cada usuario los triples de los mensajes que envía y recibe dentro de la plataforma.

### Gnoss.BackgroundTask.Mail.OpenCORE
Aplicación de segundo plano que se encarga de enviar todos los emails que se mandan a través de la plataforma.

### Gnoss.BackgroundTask.CacheRefresh.OpenCORE
Aplicación de segundo plano que se encarga de invalidar las cachés que necesitan ser actualizadas. Por ejemplo, actualiza las primeras páginas de búsqueda, los componentes de recursos de la home de una comunidad cuando se ha publicado un recurso nuevo, etc., para que aparezcan los nuevos recursos.

### Gnoss.BackgroundTask.CommunityWall.OpenCORE
Aplicación de segundo plano que se encarga de generar la actividad reciente de cada comunidad.

### Gnoss.BackgroundTask.Distributor.OpenCORE
Aplicación de segundo plano que recibe un evento de creación o edición de un recurso y notifica al resto de servicios que tienen que realizar alguna acción. Por ejemplo, Community Wall, User Wall, etc.

### Gnoss.BackgroundTask.Newsletters.OpenCORE
Aplicación de segundo plano que se encarga de enviar a todos los usuarios de una comunidad los emails de una newsletter.

### Gnoss.BackgroundTask.Replication.OpenCORE
Aplicación de segundo plano que permite la alta disponibilidad de lectura. Se encarga de replicar las instrucciones que se han insertado en un servidor de Virtuoso en tantos servidores de Virtuoso réplica como haya configurados.

### Gnoss.BackgroundTask.SearchGraphGeneration.OpenCORE
Aplicación de segundo plano que se encarga de insertar en el grafo de búsqueda los triples de cada elemento que se cree en la comunidad (recurso, persona, etc).

### Gnoss.BackgroundTask.SocialCacheRefresh.OpenCORE
Aplicación de segundo plano que se encarga de invalidar las cachés de la bandeja de mensajes de un usuario cada vez que recibe un mensaje nuevo, para que las bandejas de mensajes estén siempre actualizadas.

### Gnoss.BackgroundTask.SubscriptionsMail.OpenCORE
Aplicación de segundo plano que se encarga de generar los boletines de suscripciones de los usuarios que tienen alguna suscripción activa. Una vez generado el boletín de un usuario, registra su envío en la cola del servicio Gnoss Mail Service para que lo envíe.

### Gnoss.BackgroundTask.ThumbnailGenerator.OpenCORE
Aplicación de segundo plano que se encarga de generar las miniaturas de las imágenes que suben los usuarios a los recursos.

### Gnoss.BackgroundTask.UserWall.OpenCORE
Aplicación de segundo plano que se encarga de generar la actividad reciente relativa a todas las comunidades que pertenece un usuario en su muro de la plataforma, habitualmente en la home de la plataforma.

### Gnoss.BackgroundTask.VisitCluster.OpenCORE
Aplicación de segundo plano que se encarga de insertar en base de datos las visitas que ha contabilizado el servicio Visit Registry. Espera un tiempo especificado (por defecto 5 minutos) para registrar las visitas transcurridas en ese período de tiempo.

### Gnoss.BackgroundTask.VisitRegistry.OpenCORE
Aplicación de segundo plano que expone un puerto UDP, al que la Web le envía las visitas a cada recurso. Este servicio se encarga de agruparlas y enviarlas cada poco tiempo al servicio Visit Cluster para que las contabilice en base de datos.


Estamos preparando el código fuente de todas estas aplicaciones para que sea liberado, en breve cada aplicación estará enlazada a su respectivo repositorio en GitHub. 

# Despliegue de las aplicaciones de Gnoss Platform
Coming soon...
