from datetime import datetime
from typing import Optional
from fastapi import FastAPI, UploadFile, Form, File, HTTPException, Depends
from sqlalchemy import create_engine, Column, Integer, String, TIMESTAMP, ForeignKey, DECIMAL
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from pydantic import BaseModel, Field, EmailStr
from  fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
import shutil
import os
import enum
import hashlib
import requests

app = FastAPI()
app.mount("/uploads",StaticFiles(directory="uploads"),name="uploads")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DATABASE_URL = "mysql+pymysql://root:@localhost/db_paquexpress"
engine=create_engine(DATABASE_URL)

SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

class Usuario(Base):
    __tablename__="usuarios"
    id_usr = Column(Integer, primary_key=True, index=True)
    nom_usr = Column(String(255), nullable=False)
    correo = Column(String(255), nullable=False)
    passw_hash = Column(String(255))
    rol = Column(Integer, nullable=False)

class Paquete(Base):
    __tablename__ = "paquetes"
    id_paq = Column(Integer, primary_key=True, index=True)
    descrip = Column(String(255))
    direccion = Column(String(255))
    latitud_p = Column(DECIMAL(10,8))
    longitud_p = Column(DECIMAL(11,8))
    id_usu = Column(Integer, ForeignKey("usuarios.id_usr"))
    user = relationship("Usuario")

class Entrega(Base):
    __tablename__ = "entregas"
    id_ent = Column(Integer, primary_key=True, index= True)
    latit_ent = Column(DECIMAL(10,8), nullable=False)
    long_ent = Column(DECIMAL(11,8), nullable=False)
    fecha_ent = Column(TIMESTAMP, default=datetime.utcnow)
    direc = Column(String(255))
    id_paq = Column(Integer, ForeignKey("paquetes.id_paq"))
    paq = relationship("Paquete")


class Foto(Base):
    __tablename__ = "fotos"
    id_foto = Column(Integer, primary_key=True, index=True)
    ruta_foto = Column(String(255), nullable=False)
    fecha = Column(TIMESTAMP, default=datetime.utcnow)
    id_ent = Column(Integer, ForeignKey("entregas.id_ent"))
    entrega = relationship("Entrega")

Base.metadata.create_all(bind=engine)

class RegistroUsuModel(BaseModel):
    # id_usr: int
    nom_usr: str=Field(...,min_length=2)
    correo: EmailStr
    passw_hash: str
    rol: int

class LoginModel(BaseModel):
    correo:EmailStr
    passw_hash: str

class PaqueteSchema(BaseModel):
    # id_paq: int
    descrip: str=Field(...,min_length=3)
    latitud_p: float
    longitud_p: float
    id_usu: int

class EntregaModel(BaseModel):
    id_paq: int
    latit_ent: float
    long_ent: float
    # estatus: EstatusEntrega = EstatusEntrega.pendiente
    class Config:
        from_attributes=True

class FotoModel(BaseModel):
    id_foto: int
    ruta_foto: str
    # fecha: Optional[datetime]
    id_ent: int
    class Config:
        from_attributes=True
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
#Función para encriptar con MDS
def md5_hash(passw_hash: str) -> str:
    return hashlib.md5(passw_hash.encode()).hexdigest()

#Endpoint registrar usuario
@app.post("/registrar/")
def agregar_usu(data:RegistroUsuModel, db=Depends(get_db)):
    hashed_pw = md5_hash(data.passw_hash) #Encriptación con MD5
    user = Usuario(
        nom_usr=data.nom_usr,correo=data.correo,rol=data.rol,passw_hash=hashed_pw
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return{"msg":"Agente registrado correctamente","id_usr":user.id_usr,"nom_usr":user.nom_usr}

@app.get("/usuarios/")
def obtener_usuarios(db=Depends(get_db)):
    usuarios = db.query(Usuario).all()
    db.close()
    return usuarios

@app.get("/usuarioslista/")
def obtener_usuarios(db=Depends(get_db)):
    usuarios = db.query(Usuario).all()
    db.close()
    return [
        {
            "id_usr": u.id_usr,
            "nom_usr":u.nom_usr,
        }
        for u in usuarios
    ]

#Endpoint inicio de sesión
@app.post("/login/")
def login(data: LoginModel, db=Depends(get_db)):
    user = db.query(Usuario).filter(Usuario.correo == data.correo).first()
    if not user or user.passw_hash != md5_hash(data.passw_hash):
        raise HTTPException(status_code=400, detail="Credenciales inválidas")
    return {"msg":"Login exitoso","id_usr":user.id_usr,"rol":user.rol,"nom_usr":user.nom_usr}

#Endpoint paquetes
@app.post("/paquetes/")
def agregar_paquete(data:PaqueteSchema,db=Depends(get_db)):
    try:
        #Consumir API pública de Nominatim con cabecera obligatoria
        url = f"https://nominatim.openstreetmap.org/reverse?format=json&lat={data.latitud_p}&lon={data.longitud_p}"
        headers = {"User-Agent": "FastAPIApp/1.0"} #Cabecera requerida
        response = requests.get(url, headers=headers)
        #Validar que la respuesta sea JSON
        if response.status_code == 200:
            result = response.json()
            address = result.get("display_name","Dirección no disponible")
        else:
            address = "Error al obtener dirección"
        #Guardar registro en BD
        record = Paquete(
            descrip=data.descrip,
            direccion=address,
            latitud_p=data.latitud_p,
            longitud_p=data.longitud_p,
            id_usu=data.id_usu,
        )
        db.add(record)
        db.commit()
        db.refresh(record)
        return{
            "msg": "Registro guardado",
            "id_paq": record.id_paq,
            "direccion": address,
            "id_usu":record.id_usu,
            "nom_usr": record.user.nom_usr
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno {str(e)}")
    
@app.get("/paquetes/lista")
def obtener_paquetes(db=Depends(get_db)):
    paquetes = db.query(Paquete).all()

    return paquetes

@app.get("/paquetes/{id_usr}/")
def paquetes_usr(id_usr: int, db=Depends(get_db)):
    paquetes = db.query(Paquete).filter(Paquete.id_usu == id_usr).all()
    if not paquetes:
        return []
    return [
        {
            "id_paq": p.id_paq,
            "descripcion": p.descrip,
            "direccion": p.direccion,
            "latitud": p.latitud_p,
            "longitud": p.longitud_p,
        }
        for p in paquetes
    ]

# Endpoint: Entrega registrada
@app.post("/entrega/")
def agregar_entrega(data: EntregaModel, db=Depends(get_db)):
    try:
        paquete = db.query(Paquete).filter(Paquete.id_paq == data.id_paq).first()
        if not paquete:
            raise HTTPException(status_code=400, detail="Paquete inexistente")
        
        url = f"https://nominatim.openstreetmap.org/reverse?format=json&lat={data.latit_ent}&lon={data.long_ent}"
        headers = {"User-Agent": "FastAPIApp/1.0"}
        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            result = response.json()
            address = result.get("display_name", "Dirección no disponible")
        else:
            address = "Error al obtener dirección"

        record = Entrega(
            latit_ent=float(data.latit_ent),
            long_ent=float(data.long_ent),
            direc=address,
            id_paq=data.id_paq
        )
        db.add(record)
        db.commit()
        db.refresh(record)
        return {
            "msg": "Entrega registrada",
            "id_ent": record.id_ent,
            "direccion": address,
            "latit_ent": record.latit_ent,
            "long_ent": record.long_ent,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(e)}")

@app.get("/entrega/{id_usr}")
def entrega_usu(id_usr:int, db=Depends(get_db)):
    paqusu = db.query(Paquete).filter(Paquete.id_usu==id_usr).all()
    if not paqusu:
        return []
    lista_ids = [p.id_paq for p in paqusu]
    entregas = db.query(Entrega).filter(Entrega.id_paq.in_(lista_ids)).all()
    return entregas
#Enpoints para fotos
@app.post("/fotos/{id_ent}")
async def subir_foto(id_ent:int,file: UploadFile = File(...),db=Depends(get_db)):
    try:
        ruta = f"uploads/{file.filename}"
        os.makedirs("uploads",exist_ok=True)

        with open(ruta,"wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        nueva_foto = Foto(ruta_foto=ruta,id_ent=id_ent)
        db.add(nueva_foto)
        db.commit()
        db.refresh(nueva_foto)

        return{
            "msg": "Foto subida correctamente",
            "foto": {"id_foto":nueva_foto.id_foto, "ruta":nueva_foto.ruta_foto},
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error interno: {str(e)}")
    finally:
        db.close()

@app.get("/entrega/lista/")
def lista_entregas(db = Depends(get_db)):
    try:
        entregas = db.query(Entrega).all()
        resultado = []

        for ent in entregas:
            foto = db.query(Foto).filter(Foto.id_ent == ent.id_ent).first()

            resultado.append({
                "id_ent": ent.id_ent,
                "id_paq": ent.id_paq,
                "fecha_ent": ent.fecha_ent,
                "direc": ent.direc,
                "lat": ent.latit_ent,
                "lon": ent.long_ent,
                "foto": foto.ruta_foto
            })
        
        return resultado
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
