import pandas as pd
import uuid

# Función para generar un identificador único de SQL Server
def generate_unique_identifier():
    return str(uuid.uuid4())

# Leer el archivo CSV
df = pd.read_csv('nombre_docentes_dividido.csv')

# Crear un diccionario para almacenar el id de cada docente
docente_ids = {}

# Lista para almacenar los ids
ids = []

# Recorrer cada fila del DataFrame
for index, row in df.iterrows():
    docente_key = (row['FirstName'], row['LastName'])
    if docente_key not in docente_ids:
        docente_ids[docente_key] = generate_unique_identifier()
    ids.append(docente_ids[docente_key])

# Agregar la columna id al DataFrame
df['id'] = ids

# Guardar el DataFrame actualizado en un nuevo archivo CSV
df.to_csv('docentes_con_id.csv', index=False)

print("Archivo CSV actualizado con IDs únicos guardado como 'docentes_con_id.csv'")

