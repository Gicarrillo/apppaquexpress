create database if not exists db_paquexpress;
use db_paquexpress;

 create table usuarios(
    id_usr int auto_increment primary key,
    nom_usr varchar(255) NOT NULL,
    correo varchar(255) NOT NULL,
    passw_hash varchar(255),
    rol int not null
);
create table paquetes(
    id_paq int auto_increment primary key,
    descrip varchar(255),
    direccion varchar(255),
    latitud_p DECIMAL(10,8),
    longitud_p DECIMAL(11,8),
    id_usu int,
    foreign key (id_usu) references USUARIOS(id_usr)
);
create table entregas(
    id_ent int auto_increment primary key,
    latit_ent DECIMAL(10,8) not null,
    long_ent DECIMAL(11,8) not null,
    fecha_ent TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    direc varchar(255),
    id_paq int,
    estatus ENUM('Pendiente','Entregado'),
    foreign key (id_paq) references PAQUETES(id_paq)
);
create table fotos(
    id_foto int auto_increment primary key,
    ruta_foto varchar(255) not null,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_ent int,
    foreign key (id_ent) references ENTREGAS(id_ent)
);