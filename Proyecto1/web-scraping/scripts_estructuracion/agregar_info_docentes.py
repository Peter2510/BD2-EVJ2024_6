import csv
import random
from datetime import datetime, timedelta
import uuid  # Importar el módulo UUID para generar uniqueidentifier

input_file = 'output_names_split_docentes.csv'  # Nombre del archivo de texto de entrada
output_csv = './CSVTemporales/docentes_info_general.csv'  # Nombre del archivo CSV de salida

# Lista para almacenar los datos modificados
data = []

# Función para generar un email aleatorio
def generate_random_email(first_names, last_names):
    first_names = first_names.lower().replace(' ', '.')
    last_names = last_names.lower().replace(' ', '.')
    domain = '@example.com'
    return first_names + '.' + last_names + domain

# Función para generar una contraseña aleatoria
def generate_random_password():
    characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
    password = ''.join(random.choice(characters) for i in range(12))
    return password

# Función para generar una fecha de nacimiento aleatoria
def generate_random_date_of_birth():
    start_date = datetime(1950, 1, 1)
    end_date = datetime(2005, 12, 31)
    random_date = start_date + timedelta(days=random.randint(0, (end_date - start_date).days))
    return random_date.strftime('%Y-%m-%d')

# Abrir el archivo de texto e iterar sobre cada línea
try:
    with open(input_file, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        headers = next(reader)  # Leer encabezados
        if headers != ['FirstName', 'LastName']:
            raise ValueError("Los encabezados del archivo CSV no son válidos.")
        
        for row in reader:
            if len(row) < 2:
                continue  # Ignorar líneas que no tienen suficientes datos
            
            first_names = row[0]
            last_names = row[1]
            
            # Generar datos adicionales
            id = uuid.uuid4()  # Generar un UUID único
            email = generate_random_email(first_names, last_names)
            password = generate_random_password()
            date_of_birth = generate_random_date_of_birth()
            last_changes = datetime.now().strftime('%Y-%m-%d')
            email_confirmed = '0'  # Puede ser una cadena ya que será escrita como texto en el CSV
            
            # Agregar los datos a la lista de datos
            data.append([id, first_names, last_names, email, password, date_of_birth, last_changes, email_confirmed])

    # Escribir los datos en un archivo CSV
    with open(output_csv, 'w', newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['Id', 'FirstName', 'LastName', 'Email', 'Password', 'DateOfBirth', 'LastChanges', 'EmailConfirmed'])  # Escribir encabezados
        writer.writerows(data)  # Escribir datos modificados

    print(f'Se ha creado el archivo CSV: {output_csv}')

except FileNotFoundError:
    print(f'Error: No se encontró el archivo "{input_file}".')

except ValueError as ve:
    print(f'Error: {ve}')

except Exception as e:
    print(f'Error inesperado: {str(e)}')

