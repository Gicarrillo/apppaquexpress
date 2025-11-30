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
