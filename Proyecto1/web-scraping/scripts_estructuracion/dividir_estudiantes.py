import csv

input_file = '../ArchivosCSVDivididos/estudiantes.csv'  # Reemplaza con la ruta de tu archivo de texto
output_csv = './CSVTemporales/output_names_split_estudiantes.csv'  # Nombre del archivo CSV de salida

# Lista para almacenar los datos divididos
data = []

# Abrir el archivo de texto e iterar sobre cada línea
with open(input_file, 'r', encoding='utf-8') as file:
    for line in file:
        line = line.strip()  # Eliminar espacios en blanco al inicio y final
        parts = line.split()  # Dividir la línea en partes por espacios
        
        # Determinar cómo dividir en nombres y apellidos
        if len(parts) == 5:
            # Caso: NOMBRE1 NOMBRE2 NOMBRE3 APELLIDO1 APELLIDO2
            first_names = ' '.join(parts[:3])  # NOMBRE1 NOMBRE2 NOMBRE3
            last_names = ' '.join(parts[3:])   # APELLIDO1 APELLIDO2
        elif len(parts) >= 4:
            # Caso: NOMBRE1 NOMBRE2 APELLIDO1 APELLIDO2
            first_names = ' '.join(parts[:-2])  # NOMBRE1 NOMBRE2
            last_names = ' '.join(parts[-2:])   # APELLIDO1 APELLIDO2
        elif len(parts) == 3:
            # Caso: NOMBRE1 APELLIDO1 APELLIDO2
            first_names = parts[0]  # NOMBRE1
            last_names = ' '.join(parts[1:])  # APELLIDO1 APELLIDO2
        else:
            # Caso inesperado, manejar según tus requerimientos
            first_names = ' '.join(parts[:-1])  # Primeros nombres
            last_names = parts[-1]  # Último nombre o apellido
        
        # Agregar los nombres y apellidos divididos a la lista de datos
        data.append([first_names, last_names])

# Escribir los datos en un archivo CSV
with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['FirstName', 'LastName'])  # Escribir encabezados
    writer.writerows(data)  # Escribir datos divididos

print(f'Se ha creado el archivo CSV: {output_csv}')

