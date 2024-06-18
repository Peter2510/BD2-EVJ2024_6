import pandas as pd

# Leer el archivo CSV
df = pd.read_csv('auxiliares_con_id.csv')

# Eliminar filas duplicadas basadas en la columna 'id', manteniendo solo la primera aparición
df_unique = df.drop_duplicates(subset=['Id'])

# Guardar el DataFrame actualizado en un nuevo archivo CSV
df_unique.to_csv('auxiliares_unicos.csv', index=False)

print("Archivo CSV actualizado y sin duplicados guardado como 'auxiliares_unicos.csv'")

