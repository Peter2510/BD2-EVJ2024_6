import pandas as pd

def generate_tutor_code(first_name, last_name):
    """Genera el código de tutor basado en el nombre y apellido."""
    return f"tut{first_name[:3].lower()}{last_name[:3].lower()}"

def add_tutor_code(input_csv, output_csv):
    print(f"Leyendo datos del archivo {input_csv}...")
    # Leer el archivo CSV
    df = pd.read_csv(input_csv)
    
    # Verificar si las columnas 'FirstName' y 'LastName' existen en el DataFrame
    if 'FirstName' not in df.columns or 'LastName' not in df.columns:
        raise KeyError("Las columnas 'FirstName' y/o 'LastName' no existen en el archivo CSV.")
    
    print(f"Datos leídos correctamente. Total de registros: {len(df)}")

    # Generar la columna 'TutorCode'
    df['TutorCode'] = df.apply(lambda row: generate_tutor_code(row['FirstName'], row['LastName']), axis=1)
    print("Columna 'TutorCode' generada correctamente.")

    # Guardar el DataFrame modificado en un nuevo archivo CSV
    print(f"Guardando datos modificados en el archivo {output_csv}...")
    df.to_csv(output_csv, index=False)
    print(f'Datos guardados en {output_csv}. Proceso completado.')

if __name__ == '__main__':
    input_csv = 'TutorProfile.csv'  # Ruta del archivo CSV de entrada
    output_csv = 'TutoPro.csv'  # Ruta del archivo CSV de salida
    add_tutor_code(input_csv, output_csv)

