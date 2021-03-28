CREATE database l2_empresa_v2 ;
use l2_empresa_v2;

-- Tabla Cliente
CREATE TABLE cliente (
  DPI INT NOT NULL identity(1,1),
  Nombre VARCHAR(45) NULL,
  Apellido VARCHAR(45) NULL,
  Direccion TEXT NULL,
  FechaNacimiento DATETIME NULL,
  PRIMARY KEY (DPI));

-- Tabla Proveedor
CREATE TABLE proveedor (
  nit INT NOT NULL,
  direccion TEXT NULL,
  nombre VARCHAR(45) NULL,
  PRIMARY KEY (nit));


-- Tabla Producto
CREATE TABLE producto (
codigo INT NOT NULL,
precio int not null,
constraint NoNegativos CHECK(precio >= 0),
PRIMARY KEY (codigo));

--tabla Compra
CREATE TABLE compra (
  Idcompra INT NOT NULL identity(1,1),
  TotalDeCompra FLOAT NULL,
  FechaDeCompra VARCHAR(45) NULL,
  FK_CodigoProducto INT NOT NULL,
  FK_DPIComprador INT NOT NULL,
  PRIMARY KEY (Idcompra, FK_DPIComprador, FK_CodigoProducto),
  INDEX FK_CodigoProducto_idx (FK_CodigoProducto ASC),
  INDEX FK_DPIComprador_idx (FK_DPIComprador ASC),
  CONSTRAINT FK_CodigoProducto
    FOREIGN KEY (FK_CodigoProducto)
    REFERENCES producto (codigo)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FK_DPIComprador
    FOREIGN KEY (FK_DPIComprador)
    REFERENCES cliente (DPI)
    ON DELETE CASCADE
    ON UPDATE CASCADE);

 -- tabla Delivery

CREATE TABLE delivery (
  idDelivery INT NOT NULL identity(1,1),
  FechaDeCompra DATETIME NULL,
  TotalDeCompra FLOAT NULL,
  deliverycol VARCHAR(45) NULL,
  FK_NIT INT NOT NULL,
  FK_Codigo INT NOT NULL,
  PRIMARY KEY (idDelivery, FK_NIT, FK_Codigo),
  INDEX FK_NIT_idx (FK_NIT ASC),
  INDEX FK_Codigo_idx (FK_Codigo ASC),
  CONSTRAINT FK_NIT
    FOREIGN KEY (FK_NIT)
    REFERENCES proveedor (NIT)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT FK_Codigo
    FOREIGN KEY (FK_Codigo)
    REFERENCES producto (codigo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);