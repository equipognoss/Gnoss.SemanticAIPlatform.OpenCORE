![](https://content.gnoss.ws/imagenes/proyectos/personalizacion/7e72bf14-28b9-4beb-82f8-e32a3b49d9d3/cms/logognossazulprincipal.png)

# Parametros de configuración de GNOSS Platform a través del archivo appsettings.json

A continuación describimos las configuraciones posibles a través del archivo de configuración appsettings.json: 


* ConnectionStrings: Sección del json con las cadenas de conexión
    * acid: cadena de conexión a la base de datos donde está el esquema principal de las tablas de Gnoss.
    * virtuosoConnectionString: cadena de conexión de virtuoso.
    * virtuosoConnectionString_home: cadena de conexión de virtuoso para actividad reciente, si no está configurada se usa la cadena de conexión configurada en virtuosoConnectionString.
    * base: cadena de conexión a la  base de datos donde están las tablas de ColaCorreo y ColaCorreoDestinatrio así como los RDF.
    * AzureStorageConnectionString: cadena de conexión para azure.
    * connectionType: número que indica el tipo de base de datos; 0 para SqlServer, 1 para Oracle y 2 para Postgres.
    * oauth: cadena de conexión a la base de datos donde están las tablas necesarias para la autenticación oauth.
    * redis: Seccion para la conexión con redis.
        * redis: Sección para la conexión con redis del pool de redis.
* ip-master: ip de redis tanto de escritura como de lectura.
* ip-read: ip de redis de lectura para este pool. Esta configuración es opcional, pero hay que tener configurada la ip__master de este pool.
* bd: número de la base de datos para este pool.
* timeout: tiempo de espera.
        * recursos: Sección para la conexión con redis del pool de recursos.
* ip-master: ip de redis tanto de escritura como de lectura.
* ip-read: ip de redis de lectura para este pool. Esta configuración es opcional, pero hay que tener configurada la ip__master de este pool.
* bd: número de la base de datos para este pool.
* timeout: tiempo de espera.
        * liveUsuarios: Sección para la conexión con redis del pool de liveUsuarios.
* ip-master: ip de redis tanto de escritura como de lectura.
* ip-read: ip de redis de lectura para este pool. Esta configuración es opcional, pero hay que tener configurada la ip__master de este pool.
* bd: número de la base de datos para este pool.
* timeout: tiempo de espera.
        * bandeja: Sección para la conexión con redis del pool de bandeja.
* ip-master: ip de redis tanto de escritura como de lectura.
* ip-read: ip de redis de lectura para este pool. Esta configuración es opcional, pero hay que tener configurada la ip__master de este pool.
* bd: número de la base de datos para este pool.
* timeout: tiempo de espera.
    * Virtuoso: sección para cadenas de conexión de virtuoso referentes a la replicación
        * Escritura: sección para cadenas de conexión de escritura
* VirtuosoLecturaPruebasGnoss_v3: esta configuración es el nombre de una cola de Rabbit, cuyo valor es la cadena de conexión para el virtuoso de escritura de la replicación bidireccional, con el nombre de la cola de Rabbit VirtuosoLecturaPruebasGnoss_v3.
* VirtuosoLecturaPruebasGnoss_v4: esta configuración es el nombre de una cola de Rabbit, cuyo valor es la cadena de conexión para el virtuoso de escritura de la replicación bidireccional, con el nombre de la cola de Rabbit VirtuosoLecturaPruebasGnoss_v4.
    * VirtuosoHome: sección para virtuoso home
        * VirtuosoEscrituraHome: cadena de conexión para escritura del virtuoso home. Si este parámetro está configurado tiene que estar la replicacionActivdaHome a true.
    * BidirectionalReplication: sección para la configuración de la replicación bidireccional
        * VirtuosoLecturaPruebasGnoss_v3: hace referencia a la cola a la cual tiene que insertar el servicio que lee de esta cola, este valor es el opuesto al que hace referencia este nombre, es decir, en este caso estamos en la cola  VirtuosoLecturaPruebasGnoss_v3, el valor seria VirtuosoLecturaPruebasGnoss_v4, que es el opuesto. Solo para la replicación bidireccional.
        * VirtuosoLecturaPruebasGnoss_v4: hace referencia a la cola a la cual tiene que insertar el servicio que lee de esta cola, este valor es el opuesto al que hace referencia este nombre, es decir, en este caso estamos en la cola  VirtuosoLecturaPruebasGnoss_v4, el valor seria VirtuosoLecturaPruebasGnoss_v3, que es el opuesto. Solo para la replicación bidireccional.
* replicacionActivada: booleano que indica si está la replicación de recursos activada (true por defecto).
* replicacionActivadaHome: booleano para indicar si la replicación de la actividad reciente (true por defecto).
* ColaReplicacionMaster: Seccion para la replicación
    * ColaReplica1: configuración tanto para la replicación normal como para la bidireccional, este valor ColaReplica1 hace referencia a una cola de Rabbit. Esta configuración va a leer del nombre de la cola, en este caso ColaReplica1 y va insertar en el virtuoso que tenga configurado este parámetro, ya que su valor es una cadena de conexión de virtuoso.
    * ColaReplica2: configuración tanto para la replicación normal como para la bidireccional, este valor ColaReplica2 hace referencia a una cola de Rabbit. Esta configuración va a leer del nombre de la cola, en este caso ColaReplica2 y va insertar en el virtuoso que tenga configurado este parámetro, ya que su valor es una cadena de conexión de virtuoso.
* ColaReplicacionMasterHome
    * ColaReplicaHome1: configuración tanto para la replicación normal como para la bidireccional de la home, este valor ColaReplicaHome1 hace referencia a una cola de Rabbit Esta configuración va a leer del nombre de la cola, en este caso ColaReplicaHome1 y va insertar en el virtuoso que tenga configurado este parámetro, ya que su valor es una cadena de conexión de virtuoso
* RabbitMQ: configuración de Rabbit.
    * colaReplicacion: cadena de conexión de Rabbit que se va a usar para la replicación.
    * colaServiciosWin: cadena de conexión de Rabbit que van a usar los servicios.
* https: booleano para indicar si está instalado con https, por defecto a true.
* dominio: dominio de la aplicación.
* idiomas: lista de idiomas soportados por la aplicación. Los elementos de la lista irán separados entre comas y cada elemento tendrá el siguiente patrón, abreviatura del idioma|nombre del idioma; Ej: "es|Español,en|English".
* Servicios: Sección para configurar las url de los servicios.
    * urlOauth: url donde se aloja el servicio de autenticación oauth.
    * urlArchivos: url donde se aloja el servicio de ontologías o de archivos.
    * urlResultados: url donde se aloja el servicio de resultados.
    * urlFacetas: url donde se aloja el servicio de facetas.
    * contextosHome: url donde se aloja el servicio de contextos.
    * etiquetadoAutomatico: url donde se aloja el servicio de etiquetado automático.
    * urlDocuments: url donde se aloja el servicio de documentos.
    * urlLogin: url donde se aloja el servicio de login.
    * urlInterno: url donde se aloja el servicio interno.
    * urlContent: url donde se aloja los elementos personalizados.
    * autocompletar: url donde se aloja el servicio de autocompletar.
    * urlLucene: url donde se aloja el servicio de índices de lucene.
    * urlBase: url principal de la aplicación.
* IpServicioSocketsOffline: ip del servicio visit registry.
* PuertoServicioSocketsOffline: puerto del servicio visit registry.
* show500Error:
* ProyectoGnoss: guid para determinar el proyecto ID de la meta comunidad, si no se configura coge por defecto un Guid con todo unos.
* intervalo: segundos durante los que un proceso se queda dormido, por defecto 60.
* ruta: ruta de los ficheros para la carga masiva.
* Virtuoso: Configuración para dbpedia.
    * virtuosoEndpointEN: url del endpoint de dbpedia en inglés, por defecto http://dbpedia.org/sparql.
    * virtuosoEndpointES: url del endpoint de dbpedia en español, por defecto  http://es.dbpedia.org/sparql.
* rutaMapping: ruta donde va a estar el mapeo del tesauro.
* rutaOntologias: ruta donde se van a encontrar las ontologías.
* ProyectoConexion: comunidad principal del proyecto, necesario para configurar la urlCorta.
* DesplegadoDocker: Booleano para indicar si se ha desplegado en docker, por defecto false.
* UbicacionIndiceLucene: Ubicación donde se va a guardar el índice de lucene.
* JSYCSSunificado: booleano que indica si hay que coger los ficheros unificados, por defecto false. 
* UrlIntraGnoss: obtiene la url de intragnoss.
* hilosAplicacion: configuración para el oauth, obtiene los hilos que va a arrancar la aplicación.
* scopeIdentity: espacio al que tiene acceso la aplicación.
* clientIDIdentity: nombre del cliente para autentificar la petición.
* clientSecretIdentity: nombre del secret para autentificar la petición.
