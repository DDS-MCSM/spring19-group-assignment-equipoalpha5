# Group Assignment - Data Driven Security

Group Assignment base repository for the Data Driven Security subject of the [CyberSecurity Management Msc](https://www.talent.upc.edu/ing/professionals/presentacio/codi/221101/cybersecurity-management/).

## Análisis de ataques phishing con localización geográfica de empresas atacadas y volumen de ataques sufridos por empresa

### Project Description

A partir de un data frame conteniendo urls maliciosas de phising, observamos los dominios correspondientes y los geolocalizamos creando un data frame que vincula ips y dominios y empresas target atacadas.
Adicionalmente, observamos el número total de ataques por empresas suplantadas.


### Goals

Observar y reflejar en un mapa la ubicación geográfica de los servidores utilizados en los ataques.
Cuantificar el volumen de ataques sufrido por cada empresa suplantada

### Data acquisition

A partir de un data set localizado en la página https://www.phishtank.com/developer_info.php, utilizamos el data frame del fichero online-valid.csv que contiene más de 15.000 urls maliciosas que se han verficado que tienen phishing y que se actualiza diariamente.

### Cleansing and transformations

A partir del data frame de las urls maliciosas conteniendo phising, creamos otro data frame relacionando los dominios  de las empresas suplantadas con las ips desde donde se lanzan los ataques. Utilizamos el fichero de maxmind.rda para parsear las urls y creamos una nueva columna de IPs.
Utilizamos múltiples CPU´s para geolocalizar IPs en rangos. Creamos una columna sloc2 con las IPs que no se han podido localizar correctamente.
DEscargamos el data set PTDData para encontrar la ip a partir de la url de phishing y parseamos la url para quedarnos solo con el dominio. Pasamos de hostname a IP y tomamos la primera de la lista si nos da múltiples valores.
Se contabiliza el número de ataques recibidos por empresa

### Data analysis

De las más de 15.000 urls maliciosas se detecta que el número de empresas suplantadas son 509

### Results / Conclusions.

Para las conclusiones se puede obsservar que empresas reciben mas suplantaciones de ataques phishing, en que paises estan situados los servidores que contienen las URL maliciosas y con un analisis mas exhaustivo se podria hacer un analisis por tiempo viendo si existe algun patron de ataques.

Para un uso professional se podria usar este estudio para bloquear las ips de origen de los ataques, para que una IP maliciosa conocida no pueda intentar realizar este tipo de ataque.
