CREATE DATABASE clinicaMedica;

USE clinicaMedica;

CREATE TABLE habitacion(
 idHabitacion INT NOT NULL,
 habitacion VARCHAR(50),
 PRIMARY KEY(idHabitacion)
);

CREATE TABLE paciente(
 idPaciente INT NOT NULL,
 edad INT,
 genero VARCHAR(20),
 PRIMARY KEY(idPaciente)
);

CREATE TABLE log_actividad(
 id_log_actividad INT,
 timestampx VARCHAR(100),
 actividad VARCHAR(500),
 idPaciente INT,
 idHabitacion INT,
 PRIMARY KEY(id_log_actividad),
 FOREIGN key (idPaciente) REFERENCES paciente(idPaciente),
 FOREIGN key (idHabitacion) REFERENCES habitacion(idHabitacion)
);

CREATE TABLE log_habitacion(
 timestampx VARCHAR(100),
 statusx VARCHAR(45),
 idHabitacion INT,
 PRIMARY KEY(idPaciente),
 FOREIGN KEY (idHabitacion) REFERENCES habitacion(idHabitacion)
);

