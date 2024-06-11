CREATE  database clinicaMedica;
use clinicaMedica;
create table habitacion(
	idHabitacion int not null,
	habitacion varchar(50),
	primary key(idHabitacion)
);
create table paciente(
	idPaciente int not null,
	edad int,
	genero varchar(20),
	primary key(idPaciente)
);
create table log_actividad(
	id_log_actividad int not null auto_increment,
	timestamp varchar(100),
	actividad varchar(500),
	idPaciente int,
	idHabitacion int,
	primary key(id_log_actividad),
	foreign key (idPaciente) references paciente(idPaciente),
	foreign key (idHabitacion) references habitacion(idHabitacion)
);
create table log_habitacion(
	timestamp varchar(100),
	status varchar(45),
	idHabitacion int,
	primary key(timestamp),
	foreign key (idHabitacion) references habitacion(idHabitacion)
);

