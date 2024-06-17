import pandas as pd
import numpy as np


input_csv = '../modificacion_curso.csv'

df = pd.read_csv(input_csv, encoding='utf-8')

# Limpiar datos: eliminar espacios en blanco y convertir a minúsculas
df['CodCourse'] = df['CodCourse'].astype(str).str.strip().str.lower()

# Convertir 'Name' a mayúsculas
df['Name'] = df['Name'].astype(str).str.strip().str.upper()

# Eliminar duplicados basados en 'CodCourse' y 'Name'
df.drop_duplicates(subset=['CodCourse', 'Name'], inplace=True)

# Generar números aleatorios del 1 al 10 para cada fila
np.random.seed(0)
df['CreditsRequired'] = np.random.randint(1, 11, df.shape[0])

# Guardar el archivo CSV modificado con codificación UTF-8
output_csv = '../ArchivosCSVDivididos/Tablas/Course.csv' 
df.to_csv(output_csv, index=False, encoding='utf-8')

print(f'Archivo guardado como {output_csv}')






