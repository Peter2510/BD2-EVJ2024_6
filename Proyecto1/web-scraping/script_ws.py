import requests
from bs4 import BeautifulSoup
import json
import re

# URL de la página a scrapear
website = "https://usuarios.ingenieria.usac.edu.gt/horarios/semestre/1"

# Solicitud GET a la página
resultado = requests.get(website)
content = resultado.content

# Parsear el contenido HTML con BeautifulSoup
soup = BeautifulSoup(content, 'html.parser')

# Encontrar todas las filas de la tabla
rows = soup.find_all('tr')

# Lista para almacenar los cursos
courses = []

# Recorrer las filas y extraer la información deseada
for row in rows:
    columns = row.find_all('td')
    if len(columns) > 0:
        # Separar el código y el nombre del curso
        course_info = columns[0].text.strip()
        match = re.match(r'(\d+)\s+(.*)', course_info)
        if match:
            course_code = match.group(1)
            course_name = match.group(2)
        else:
            course_code = ''
            course_name = course_info

        # Definir un valor por defecto para 'auxiliar' si está vacío
        auxiliar_value = 'xxx' if len(columns) > 9 and columns[9].text.strip() == '' else columns[9].text.strip()

        course = {
            'codigo_curso': course_code,
            'nombre_curso': course_name,
            'catedratico': columns[8].text.strip(),
            'auxiliar': auxiliar_value
        }
        courses.append(course)

# Guardar la información en un archivo JSON con la codificación adecuada
with open('cursos.json', 'w', encoding='utf-8') as f:
    json.dump(courses, f, ensure_ascii=False, indent=4)

print("Datos guardados correctamente en 'cursos3.json'.")
