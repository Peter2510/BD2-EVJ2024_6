import pandas as pd

def remove_duplicate_rows(input_csv, output_csv):
    print(f"Leyendo datos del archivo {input_csv}...")
    # Leer el archivo CSV
    df = pd.read_csv(input_csv)
    print(f"Datos leídos correctamente. Total de registros: {len(df)}")

    # Eliminar filas duplicadas basadas en las columnas 'Id' y 'CourseCodCourse'
    df_deduplicated = df.drop_duplicates(subset=['TutorId', 'CourseCodCourse'], keep='first')
    print(f"Número de registros después de eliminar duplicados: {len(df_deduplicated)}")

    # Guardar el DataFrame modificado en un nuevo archivo CSV
    print(f"Guardando datos modificados en el archivo {output_csv}...")
    df_deduplicated.to_csv(output_csv, index=False)
    print(f'Datos guardados en {output_csv}. Proceso completado.')

if __name__ == '__main__':
    input_csv = 'CourseTutor.csv'  # Ruta del archivo CSV de entrada
    output_csv = 'CourseTutor_.csv'  # Ruta del archivo CSV de salida
    remove_duplicate_rows(input_csv, output_csv)

