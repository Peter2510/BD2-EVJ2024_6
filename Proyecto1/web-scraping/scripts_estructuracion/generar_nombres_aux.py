import pandas as pd
import requests

def fetch_random_name():
    """Fetch a random name from randomuser.me API with settings for Mexican names."""
    url = 'https://randomuser.me/api/?nat=mx&inc=name'
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        name_info = data['results'][0]['name']
        name = f"{name_info['first']} {name_info['last']}".upper()
        return name
    else:
        raise Exception(f"API request failed with status code {response.status_code}")

def main():
    input_csv = 'unique_courses.csv'  # Ruta del archivo CSV de entrada
    output_csv = 'output.csv'  # Ruta del archivo CSV de salida

    print(f"Leyendo datos del archivo {input_csv}...")
    # Leer el archivo CSV
    df = pd.read_csv(input_csv)
    print(f"Datos leídos correctamente. Total de registros: {len(df)}")

    # Contar cuántos "xxx" hay en la columna 'auxiliar'
    num_xxx = df['auxiliar'].value_counts().get('xxx', 0)
    print(f"Número de 'xxx' encontrados en la columna 'auxiliar': {num_xxx}")

    # Reemplazar "xxx" con nombres aleatorios únicos
    if num_xxx > 0:
        used_names = set()  # Para asegurarnos de que no se repiten nombres
        replaced_count = 0

        def replace_xxx(value):
            nonlocal replaced_count
            if value == 'xxx':
                name = fetch_random_name()
                while name in used_names:
                    name = fetch_random_name()
                used_names.add(name)
                replaced_count += 1
                print(f"Reemplazando 'xxx' con el nombre: {name} ({replaced_count}/{num_xxx})")
                return name
            return value

        df['auxiliar'] = df['auxiliar'].apply(replace_xxx)

    # Guardar el DataFrame modificado en un nuevo archivo CSV
    print(f"Guardando datos modificados en el archivo {output_csv}...")
    df.to_csv(output_csv, index=False)
    print(f'Datos guardados en {output_csv}. Proceso completado.')

if __name__ == '__main__':
    main()

