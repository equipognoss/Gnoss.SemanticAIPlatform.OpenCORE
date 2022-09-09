![](https://content.gnoss.ws/imagenes/proyectos/personalizacion/7e72bf14-28b9-4beb-82f8-e32a3b49d9d3/cms/logognossazulprincipal.png)

# Despliegue de Hércules MA con Kubernetes y Helm

El despliegue de EDMA-Hercules requiere de varios pasos

## Paso 1: Desplegar Nginx Ingress Controller

Hay diferentes formas de desplegar Nginx ingress controller:

Con Helm se puede desplegar con el siguiente comando:
  * helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace

O sino con Kubectl:
  * kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml

Manual: https://kubernetes.github.io/ingress-nginx/deploy/


## Paso 2: Desplegar RabbitMQ

Para desplegar RabbitMQ primero clonaremos el contenido del repositorio RabbitMQ.

* Primero crearemos el namespace donde realizaremos el despliegue de nuestra plataforma. **¡¡IMPORTANTE!!** Éste generará un namespace con nombre **"edma-hercules"**.
  * kubectl apply -f ./namespace.yaml 
 
* Segundo, aplicamos las reglas RBAC:
  * kubectl apply -f rbac.yaml 

* Tercero, aplicaremos el archivo configmap.yaml para aplicar una configuración básica en el nodo para nuestro RabbitMQ:
  *  kubectl apply -f configmap.yaml

* Cuarto, crearemos los secretos para poder dar nombre de usuario y contraseña al administrador de RabbitMQ y a sus Erlang Cookie:
  - Nos aseguramos que estamos trabajando en nuestro namespace:
    - kubectl config set-context --current --namespace=edma-hercules
  - Para aplicar los secretos usaremos:
    - kubectl apply -f .\mysecret.yaml
    - **!!IMPORTANTE!!** Si modificamos los valores de usuario y password debermos aplicar estos mismos cambios en la cadena de conexión a Rabbit del despliege Edma-Hercules.

* Quinto, crearemos el servicio para RabbitMQ. Este servicio será de tipo ClusterIP y preparará los puertos 4369, 25672, 5672 y 15672 para la administración y gestión de RabbitMQ. **¡¡IMPORTANTE!!** Este servicio debe ser creado antes de aplicar el statefulset de RabbitMQ:
  - kubectl apply -f ./service_rabbit.yaml

* Sexto, desplegamos RabbitMQ utilizando un statefulset para mantener la persistencia de datos:
  - kubectl apply -f statefulset.yaml

* Septimo, creamos si lo necesitamos un ingress para poder acceder a la administración de RabbitMQ. Por defecto la URL es rabbit.hercules.com
  - kubectl apply -f ingress.yaml

## Paso 3 Desplegar EDMA-HERCULES.

El despliegue de EDMA-HERCULES está preparado para ser realizado con HELM. 

* Primero utilizaremos el comando.
  * helm install <nombre_despligue> oci://docker.gnoss.com/helm-charts/edma-gnoss

* Segundo. Una vez que PostgreSQL está desplegado debemos volcar la base de datos para que empiece a trabajar con ella.
Para ello usaremos el archivo “pg_dump_backup.sqlc” ubicado en la carpeta PostgreSQL.
  * Primero obtenemos el nombre de nuestro pod con:
    * kubectl get pod

  * Ahora ponemos el archivo dentro del contendor:
    * kubectl cp <local_file_path> <pod_name>:/var/lib/postgresql/data –c postgresql
 
  * Ahora ingresamos en el contenedor mediante el comando:
    * kubectl exec –it <pod_name> -c postgresql -- /bin/bash
 
  * Y nos dirigimos a “/var/lib/postgresql/data” que es donde hemos alojado nuestro backup:
    * cd /var/lib/postgresql/data

  * Y realizamos un volcado de este que consta de tres pasos:

    * 1-	Borrar la base  
      * psql -U postgres template1 -c 'drop database postgres;'

    * 2- Crearla de nuevo  
      * psql -U postgres template1 -c 'create database postgres;'

    * 3-	Volcarla  
      * pg_restore -C --clean --no-acl --no-owner -U "postgres" -d "postgres" < "./pg_dump_backup.sqlc"

 
* Tercero. Después copiamos los archivos de la base de datos de virtuoso en su contenedor:
  * kubectl cp <local_file_path> <namespace_name>/virtuoso:/opt/virtuoso-opensource/database –c virtuoso

Finalmente todo debería estar correctamente desplegado. Observar que hasta que las bases de datos no estén volcadas 
en sus contenedores se realizarán varios reinicios de los contenedores ya que necesitan de los datos de ellas.

# Paso 4 Abastecer las imagenes.

Ahora debemos colocar el contenido de la carpeta "imagenes" dentro del Statefulset de Interno.

Para ello usaremos el comando:
  * kubectl cp <local_file_path> <pod_name_interno>:/app/imagenes

# Paso 5 Abastecer archivo OAuthV3.

En este paso debemos colocar el archivo OAuthV3.config. Para ello utilizaremos el Pod con el contenedor "editorcv" el cual usa un PVC compartido con los diferentes Pods que necesitan de este archivo.
  * kubectl cp <local_file_path> <pod_name_editorcv>:/app/Config/ConfigOAuth/
 
 # Paso 6 Abastecer el contenido del Pod con Documents.
 
 En este paso debemos colocar el contenido de la carpeta "documentacion" dentro del Statefulset de Documents.
 
 Para ello usaremos el comando:
   * kubectl cp <local_file_path> <pod_name_documents>:/app/Documentacion
 
 # Paso 7 Abastecer el contenido del Pod con Archivo.
 
  En este paso debemos colocar el contenido de la carpeta "ontologias" dentro del Statefulset de Archivos.
 
 Para ello usaremos el comando:
   * kubectl cp <local_file_path> <pod_name_archivos>:/app/Ontologias
