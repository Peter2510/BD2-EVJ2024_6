import json
import csv

# Leer el archivo JSON
with open('cursos.json', 'r', encoding='utf-8') as f:
    courses = json.load(f)

# Especificar los nombres de las columnas para el CSV
fieldnames = ['codigo_curso', 'nombre_curso', 'catedratico', 'auxiliar']

# Crear y escribir en el archivo CSV
with open('cursos.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    # Escribir la cabecera
    writer.writeheader()

    # Escribir los datos
    for course in courses:
        writer.writerow(course)

print("Archivo CSV creado exitosamente.")
