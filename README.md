# apppaquexpress
Evaluación Unidad 3 \
Requisitos de instalación: \
--- Para la correcta ejecución de la API se necesita la instalación de algunas librerías para ello se tienen algunos comandos de instalación \
Para crear el entorno virtual: python -m venv env \
Para ejecutarlo: ./env/Scripts/activate \
Para la instalación de las librerías: \
pip install fastapi \
pip install uvicorn \
pip install sqlalchemy \
pip install pymysql \
pip install aiofile \
pip install pydantic \
pip install python-multipart \
pip install requests \
En caso de que pydantic no pueda obtener o hacer que funcione EmailStr se instala:\
pip install "pydantic[email]" \

Para la ejecución de la API y visualizarla en postman o en /docs se aplica el comando:\
uvicorn main:app --host 0.0.0.0 --port 8000\

Para abrir la aplicación desde la terminal: \
cd nombreapp  > para abrir la carpeta donde se creo \
code .  > para abrirlo en otra ventana \

Dentro de la aplicación ya se incluyen las librerías para la geolocalización y la imagen, en caso de que no se encontrarán se agregan en el archivo pubspec.yaml, en la parte de dependencies alineado con flutter, se ve algo como: \
dependencies: \
  flutter: \
    sdk: flutter \
  http: ^0.13.6   > para la api, con http\
  image_picker: ^1.1.2   > para subir la imagen\
  geolocator: ^9.0.2    > para obtener la ubicación del dispositivo\
  flutter_map: ^4.0.0   > para ver el mapa en la aplicación con las coordenadas obtenidas\