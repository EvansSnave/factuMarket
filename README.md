# ✨FactuMarket S.A✨

## Programas necesarios

- Rails version 8.0♦️
- Oracle Database 23ai FREE🔥
- MongoCompass🍃
- SQLplus🔑

## Preparacion inicial💎

### Para los microsevicios de clientes y facturas
Estos microservicios usan dos bases de datos de Oracle, una para desarrollo y otra para testeo.  La base de datos de desarrollo se llama ```C##free_dev``` para el microservicio de clientes y ```C##bills``` para el microservicio de 
facturas. La base de datos de pruebas para ambos microservicios se llama ```C##free_test```\
\
Entrar a SQLplus desde la terminal

<img width="1103" height="380" alt="image" src="https://github.com/user-attachments/assets/857762c2-4853-4dc1-972f-88332031d8a9" />

Crear la base de datos para desarrollo para clientes con el siguiente comando
```
CREATE USER C##free_dev IDENTIFIED BY 122
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;
```
Darle los permisos necesarios
```
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE VIEW TO C##free_dev;
GRANT CREATE PROCEDURE TO C##free_dev;
```
Hacer lo mismo para la base de datos de desarrollo para facturas y testeo, solo se debe cambiar el nombre C##free_dev a C##bills para la base de datos de facturas y C##free_dev a C##free_test para la
base de datos de testeo. Con esto, las bases de datos de oracle estan listas para ser usadas por los microservicios

Clonar el repositorio en la carpeta deseada ```git clone https://github.com/EvansSnave/factuMarket.git .```
<img width="700" height="169" alt="image" src="https://github.com/user-attachments/assets/4f9846be-2f95-40b3-a957-6153606a0a9b" /><br>
El repositorio contiene los tres microservicios, cada uno en su propia carpeta<br>
<img width="295" height="142" alt="image" src="https://github.com/user-attachments/assets/ae704c13-5311-4afe-b8d1-641f105689d2" /><br>
En la terminal, entrar al microservicio *clients*<br>
<img width="356" height="66" alt="image" src="https://github.com/user-attachments/assets/737f5cd0-2a27-432c-8089-347e1a34461a" /><br>
Instalar las dependencias con ```bundle i```<br>
<img width="511" height="112" alt="image" src="https://github.com/user-attachments/assets/4b38bce9-6ce9-4b3b-83d1-ccd654587920" /><br>
Migrar las bases de datos ```rails db:migrate``` y luego prepararlas con ```rails db:prepare```. Hacer lo mismo para el microservicio de facturas

### Para el microservicio de auditorias

Ahora, para la base de datos de auditorias, usamos MongoDB: Necesitamos una conexion con ```mongodb://localhost:27017/``` y ahi creamos la base de datos con el nombre ```audit``` y una coleccion llamada ```events```<br>
<img width="301" height="215" alt="image" src="https://github.com/user-attachments/assets/35ba119a-c47f-4cc6-a141-33405fa59b84" /><br>
En el repositorio, entramos a el microservicio ```audit``` e instalamos las dependencias<br>
<img width="355" height="37" alt="image" src="https://github.com/user-attachments/assets/e5d7001c-5ad5-4429-a85f-e89212eda29d" /><br>

## Microservicios🎉

### Clients microservice👌

<img width="1905" height="948" alt="image" src="https://github.com/user-attachments/assets/2d8e36de-caa7-4105-b095-76d243e850fe" />

Este microservicio se encarga de manejar la entidad "Cliente" (User en codigo) Sus responsabilidades son crear clientes validos, enviar una lista con todos los clientes y enviar un cliente por id. Cuenta con persistencia en una 
base de datos en Oracle donde cada usuario es almacenado. Cada vez que se llame cualquier endpoint de este microservicio, se crea una auditoria registrando lo sucedido en el microservicio de auditoria. 
La entidad principal aqui es **User** la cual representa a los clientes. Este es el esquema de la entidad User:
```
user: {
  name: string,
  email: email,
  password: string,
  password_confirmation: string,
  identification: integer
}
```
Para que un cliente sea valido, el email debe tener un formato de email y debe ser unico, la contraseña y confirmacion de contraseña deben ser iguales y la identificacion debe ser unica. La contraseña y confirmacion de contarseña se guardan con
```password_digest``` por seguridad.\
El puerto en donde  este microservicio corre es ```3000``` asi que la url base de es ```http://[::1]:3000```\

***Endpoints***🥇

<img width="1030" height="495" alt="image" src="https://github.com/user-attachments/assets/812e43c2-0ffa-4fca-92c3-422f23b4cde6" />

Para poder crear un cliente nuevo, se necesita pasar como parametro un cliente valido al siguiente enpoint:
```
POST /clientes
```
Por ejemplo, este usuario seria valido si el email e identificacion son unicos:
```
user: {
  name: Kevin,
  email: kein@example.com,
  password: 123,
  password_confirmation: 123,
  identification: 1000000
}
```
Y se envia a ```http://[::1]:3000/clientes``` Esta action creara y guardara este usuario en la base de datos de Oracle C##free_dev y creara un registro de CREACION DE USUARIO exitoso

<img width="460" height="467" alt="image" src="https://github.com/user-attachments/assets/56dc7d72-bd69-4ef9-94be-0da49793eb15" />

```
GET /clientes
```
Este endpoint devuelve una lista de todos los usuarios en la base de datos con un registro en auditoria\
De esta manera: ```http://[::1]:3000/clientes```\
\
<img width="446" height="436" alt="image" src="https://github.com/user-attachments/assets/03b3a8b1-52f9-4e07-95b8-72d7ed534df6" />

```
GET /clientes/:id
```
Este endpoint devuelve un usuario en la base de datos por id con un registro en auditoria\
De esta manera: ```http://[::1]:3000/clientes```

### Bills microservice💵

<img width="1899" height="955" alt="image" src="https://github.com/user-attachments/assets/4098c2df-7738-4323-8597-bae16a7984f2" />

Este microservicio se encarga de manejar la entidad "Factura" (Bill en codigo) Sus responsabilidades son crear facturas validas, enviar una lista con todas las facturas en un rango de fechas y enviar una factura por id. Cuenta con persistencia en una 
base de datos en Oracle donde cada factura es almacenada. Cada vez que se llame cualquier endpoint de este microservicio, se crea una auditoria registrando lo sucedido en el microservicio de auditoria. 
La entidad principal aqui es **Bill** la cual representa las facturas. Este es el esquema de la entidad Bill:
```
bill: {
  user_id: integer,
  description: string,
  amount: integer,
  product: string,
  bill_date: date
}
```
Para que una factura sea valida, el ID del cliente debe existir en la base de datos del microservicio de clientes y la cantidad debe ser mayor a 0\
El puerto en donde este microservicio corre es ```3002``` asi que la url base de es ```http://[::1]:3002```\

***Endpoints***🥇

<img width="453" height="496" alt="image" src="https://github.com/user-attachments/assets/8d0308de-abad-45a2-b160-d1447069aab6" />

Para poder crear una factura nueva, se necesita pasar como parametro una factura valida al siguiente enpoint:
```
POST /facturas
```
Por ejemplo, esta factura seria valida si hay un cliente con ID = 1 en la base de datos del microservicio de clientes y la cantidad es mayor a 0
```
bill: {
  user_id: 1,
  description: "Compra exitosa",
  amount: 1000,
  product: "Shoes,
  bill_date: "2025-11-15"
}
```
Y se envia a ```http://[::1]:3002/facturas``` Esta action creara y guardara esta factura en la base de datos de Oracle C##bills y creara un registro de CREACION DE FACTURA exitoso

<img width="449" height="468" alt="image" src="https://github.com/user-attachments/assets/9b23d102-1295-4d18-aa78-8d063885821b" />

```
GET /facturas?fechaInicio=&fechaFin=
```
Este endpoint devuelve una lista de todas las facturas en el rango de fechas especificado y un registro en auditoria\
De esta manera: ```http://[::1]:3002/facturas?fechaInicio=2025-11-14&fechaFin=2025-11-15``` nos dara como resultado todas las facturas desde la fecha inicial hasta la fecha final\
\
<img width="1030" height="228" alt="image" src="https://github.com/user-attachments/assets/415f2316-aa55-457f-8e72-658323b033f4" />

```
GET /facturas/:id
```
Este endpoint devuelve una factura en la base de datos por id con un registro en auditoria\
De esta manera: ```http://[::1]:3000/facturas/:id```

### Audit microservice🔍

<img width="845" height="386" alt="image" src="https://github.com/user-attachments/assets/3d1743dd-e752-4297-ab06-6f7e63b055eb" />

Este microservicio se encarga de manejar la entidad "Evento" (Event en codigo) Sus responsabilidades son crear eventos por que describan una action ejecutada en los otros microservicios y guardas estos eventos en la base de datos noSQL
. Cuenta con persistencia en una base de datos en MongoDB donde cada evento es almacenada. Cada vez que se crea un cliente o factura o cada vez que se envian un cliente o una factura o una lista de clientes o facturas o cada vez que ocurre algun
error en cualquiera de estas acciones, un evento es almacenado en MongoDB
La entidad principal aqui es **Event** la cual representa un evento. Este es el esquema de la entidad Event:
```
bill: {
  entity_id: integer,
  service: string,
  type: string,
  description: string,
  payload: hash
}
```

Para que un evento sea valido, el ID del cliente debe existir en la base de datos del microservicio de clientes y la cantidad debe ser mayor a 0\
El puerto en donde este microservicio corre es ```3002``` asi que la url base de es ```http://[::1]:3002```\

***Endpoints***🥇

Este microservicio tiene dos endpoints, uno para crear ueventos y el otro para devolver todos los eventos relacionados con una factura por ID
```
POST /auditoria
```
Este podira ser un evento para este endpoint
```
bill: {
  entity_id: 0,
  service: "bills-microservice",
  type: "FACTURA_CREADA,
  description: "Una factura fue creada exitosamente,
  payload: {
    bill: {
      user_id: 1,
      description: "Compra exitosa",
      amount: 1000,
      product: "Shoes,
      bill_date: "2025-11-15"
    }
  }
}
```
Y se envia a ```http://[::1]:3001/auditoria``` Esta action creara y guardara este evento en la base de datos de MongoDB

<img width="449" height="468" alt="image" src="https://github.com/user-attachments/assets/9b23d102-1295-4d18-aa78-8d063885821b" />

```
GET /auditoria/:id
```
Este endpoint devuelve una lista de todos los eventos relacionados a la factura con id=:id\
De esta manera: ```http://[::1]:3001/auditoria/1``` nos dara como resultado todos los eventos relacionados a la factura con id=1\
