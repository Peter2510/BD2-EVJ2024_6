# Comandos
## Para Back Up
### creacion
```sh
mysqldump -u root -p clinicaMedica > /home/alexxus/Documentos/SISTEMAS/Bases2/practica/fullbackUpActividad3.sql
```
### carga
```sh
mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad1/fullBackUpActividad1.sql
mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad4/fullBackUpActividad4.sql
```
## Para Back Up incremental
### creacion
```sh
mysqldump -u root -p clinicaMedica log_actividad> /home/alexxus/Documentos/SISTEMAS/Bases2/practica/incrementalbackUpActividad3.sql
```
### carga
```sh
  mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad1/incrementalBackUpActividad1.sql 
  mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad2/incrementalBackUpActividad2.sql 
  mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad3/incrementalbackUpActividad3.sql 
  mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad4/incrementalBackUpActividad4.sql 
  mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad5/incrementalBackUpActividad5.sql
```

## Tiempos

```sh
  time mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad1/incrementalBackUpActividad1.sql 
  time mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad2/incrementalBackUpActividad2.sql 
  time mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad3/incrementalbackUpActividad3.sql 
  time mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad4/incrementalBackUpActividad4.sql 
  time mysql -u root -ppassword clinicaMedica < ./Practica1/Actividad5/incrementalBackUpActividad5.sql 
```

