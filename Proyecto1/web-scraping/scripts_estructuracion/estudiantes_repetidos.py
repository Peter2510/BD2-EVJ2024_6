#input_csv = '/home/peterg/Documentos/2024/Junio/Laboratorio/BD2-EVJ2024_6/Proyecto1/web-scraping/docentes.csv'

import pandas as pd

# Leer el archivo CSV existente con codificación UTF-8
input_csv = '../estudiantes.csv'
df = pd.read_csv(input_csv, encoding='utf-8')

# Limpiar datos: eliminar espacios en blanco y convertir a mayúsculas
df['Name'] = df['Name'].astype(str).str.strip().str.upper()

# Eliminar duplicados basados en 'FullName', manteniendo solo la primera aparición
df.drop_duplicates(subset=['Name'], keep='first', inplace=True)

# Guardar el archivo CSV modificado con codificación UTF-8
output_csv = './CSVTemporales/output_unique_names_docentes.csv'
df.to_csv(output_csv, index=False, encoding='utf-8')

print(f'Archivo guardado como {output_csv}')





