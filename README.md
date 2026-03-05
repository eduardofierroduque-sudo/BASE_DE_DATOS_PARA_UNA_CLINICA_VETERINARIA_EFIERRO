Hola este es el proyecto final del **Módulo 3**, donde el objetivo principal fue diseñar y gestionar una base de datos relacional para una clínica veterinaria. Aquí encontrarás la estructura de las tablas, la inserción de datos reales y consultas SQL para la toma de decisiones.

El desarrollo se dividió en cuatro grandes etapas:

1.  **Diseño y Creación:** Se construyó la base de datos `clinica_veterinaria` definiendo tablas para **Dueños, Mascotas, Profesionales y Atenciones**. Se aplicaron restricciones de integridad mediante llaves primarias y foráneas para asegurar que los datos estén bien conectados.
2.  **Poblamiento de Datos:** Se cargó la información inicial de prueba (nombres de dueños, tipos de mascotas y especialistas) respetando las relaciones entre tablas.
3.  **Consultas e Inteligencia:** Se redactaron consultas SQL para:
    * Vincular mascotas con sus respectivos dueños.
    * Ver el historial de atenciones detallando qué profesional atendió a cada animal.
    * Contabilizar la carga de trabajo por especialista.
4.  **Gestión y Transacciones:** Se practicaron actualizaciones de datos, eliminaciones y el uso de **Transacciones (BEGIN/COMMIT)** para garantizar que procesos complejos (como agregar una mascota y su primera atención al mismo tiempo) se realicen de forma segura.

Se realizo en:

* **Motor de Base de Datos:** PostgreSQL. versión 18
* **Gestor:** pgAdmin 4.
* **Lenguaje:** SQL
* <img width="1908" height="952" alt="image" src="https://github.com/user-attachments/assets/136b5e3d-e412-4492-835d-ef85af23eb2a" />

