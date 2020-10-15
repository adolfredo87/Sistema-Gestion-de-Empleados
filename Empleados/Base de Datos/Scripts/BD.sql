USE [master]
GO

/****** Object:  Database [DemoEmpleados]    Script Date: 02/27/2018 00:52:21 ******/
IF  EXISTS (SELECT name FROM sys.databases WHERE name = N'DemoEmpleados')
DROP DATABASE [DemoEmpleados]
GO

USE [master]
GO

/****** Object:  Database [DemoEmpleados]    Script Date: 02/27/2018 00:52:21 ******/
CREATE DATABASE [DemoEmpleados] ON  PRIMARY 
( NAME = N'DemoEmpleados', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER2008\MSSQL\DATA\DemoEmpleados.mdf' , SIZE = 7104KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'DemoEmpleados_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER2008\MSSQL\DATA\DemoEmpleados_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO

ALTER DATABASE [DemoEmpleados] SET COMPATIBILITY_LEVEL = 100
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DemoEmpleados].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [DemoEmpleados] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [DemoEmpleados] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [DemoEmpleados] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [DemoEmpleados] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [DemoEmpleados] SET ARITHABORT OFF 
GO

ALTER DATABASE [DemoEmpleados] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [DemoEmpleados] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [DemoEmpleados] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [DemoEmpleados] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [DemoEmpleados] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [DemoEmpleados] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [DemoEmpleados] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [DemoEmpleados] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [DemoEmpleados] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [DemoEmpleados] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [DemoEmpleados] SET  ENABLE_BROKER 
GO

ALTER DATABASE [DemoEmpleados] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [DemoEmpleados] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [DemoEmpleados] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [DemoEmpleados] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [DemoEmpleados] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [DemoEmpleados] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [DemoEmpleados] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [DemoEmpleados] SET  READ_WRITE 
GO

ALTER DATABASE [DemoEmpleados] SET RECOVERY FULL 
GO

ALTER DATABASE [DemoEmpleados] SET  MULTI_USER 
GO

ALTER DATABASE [DemoEmpleados] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [DemoEmpleados] SET DB_CHAINING OFF 
GO

USE [DemoEmpleados]
GO

/****** Object:  Table [dbo].[tipoContracto]    Script Date: 10/25/2016 15:51:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tipoContracto](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](255) NULL,
	[Descripcion] [varchar](255) NULL,
	[MultiploAnual] [int] NULL,
	[Estatus] [int] NOT NULL DEFAULT (1),
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  Table [dbo].[empleado]    Script Date: 10/25/2016 15:51:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[empleado](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DNI] [varchar](255) NOT NULL,
	[Nombre] [varchar](255) NOT NULL,
	[Telefono] [varchar](255) NULL,
	[Correo] [varchar](255) NULL,
	[Direccion] [varchar](255) NULL,
	[Sueldo] [float] NOT NULL,
	[SueldoAnual] [float] NOT NULL,
	[Estatus] [int] NOT NULL DEFAULT (1),
	[IDTipo] [int] NOT NULL,
	CONSTRAINT [FK_TipoContracto] FOREIGN KEY([IDTipo]) REFERENCES [dbo].[tipoContracto] ([ID]),
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  StoredProcedure [dbo].[USP_INCTIPOCONTRATO]    Script Date: 02/23/2018 17:20:56 ******/
SET QUOTED_IDENTIFIER ON
GO
SET NUMERIC_ROUNDABORT OFF;
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON;
GO
CREATE PROCEDURE [dbo].[USP_INCTIPOCONTRATO]
(           
  @VCODIGO AS VARCHAR(200), @VDESCRIPCION AS VARCHAR(200), @IMULTIPLOANUAL AS INT, @IESTATUS AS INT = 1
)
AS          
          
SET NOCOUNT ON                  
DECLARE @ERRORMESSAGE NVARCHAR(4000)          
DECLARE @ERRORSEVERITY INT          
DECLARE @ERRORSTATE INT      
          
BEGIN TRY          
          
  IF EXISTS (          
              SELECT *          
              FROM [DemoEmpleados].[dbo].[tipoContracto] WITH (NOLOCK)          
              WHERE [Codigo] = @VCODIGO        
            )          
    BEGIN          
            
      SET @ERRORMESSAGE = 'El codigo del tipo del contrato que esta intentando registrar ya se encuentra en uso'          
      SET @ERRORSEVERITY = 16         
      SET @ERRORSTATE = 1             
      GOTO ERROR              
              
    END
  ELSE
  
    BEGIN
    
      BEGIN TRAN
      
        INSERT INTO [DemoEmpleados].[dbo].[tipoContracto]
          (Codigo, Descripcion, MultiploAnual, Estatus)
        VALUES
          (@VCODIGO, @VDESCRIPCION, @IMULTIPLOANUAL, @IESTATUS)
      
      COMMIT TRAN
    
    END
    
END TRY          
          
BEGIN CATCH          
              
  SET @ERRORMESSAGE = 'ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + '. LINEA ' + CAST(ERROR_LINE() AS VARCHAR(10)) + '. ' + ERROR_MESSAGE()          
  SET @ERRORSEVERITY = ERROR_SEVERITY()            
  SET @ERRORSTATE = ERROR_STATE()        
  GOTO ERROR          
          
END CATCH          
          
SET NOCOUNT OFF          
          
RETURN        
ERROR:        
  IF XACT_STATE() <> 0 ROLLBACK TRAN        
  RAISERROR (@ERRORMESSAGE, @ERRORSEVERITY, @ERRORSTATE)
GO

/****** Object:  StoredProcedure [dbo].[USP_MODTIPOCONTRATO]    Script Date: 02/23/2018 16:20:47 ******/
SET QUOTED_IDENTIFIER ON
GO
SET NUMERIC_ROUNDABORT OFF;
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON;
GO
CREATE PROCEDURE [dbo].[USP_MODTIPOCONTRATO]
( 
  @IID AS INT, @VCODIGO AS VARCHAR(200), @VDESCRIPCION AS VARCHAR(200), @IMULTIPLOANUAL AS INT, @IESTATUS AS INT = 1
)
AS

SET NOCOUNT ON
DECLARE @ERRORMESSAGE NVARCHAR(4000)  
DECLARE @ERRORSEVERITY INT  
DECLARE @ERRORSTATE INT  

BEGIN TRY

    BEGIN
    
      BEGIN TRAN
      
      UPDATE A1
      SET	A1.Codigo = @VCODIGO,
			A1.Descripcion = @VDESCRIPCION, 
			A1.MultiploAnual = @IMULTIPLOANUAL, 
			A1.Estatus = @IESTATUS 
      FROM [DemoEmpleados].[dbo].[tipoContracto] A1
      WHERE A1.ID = @IID
      
      COMMIT TRAN
      
    END

END TRY

BEGIN CATCH

  SET @ERRORMESSAGE = 'ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + '. LINEA ' + CAST(ERROR_LINE() AS VARCHAR(10)) + '. ' + ERROR_MESSAGE()
  SET @ERRORSEVERITY = ERROR_SEVERITY()  
  SET @ERRORSTATE = ERROR_STATE()  
  GOTO ERROR
  
END CATCH

SET NOCOUNT OFF

RETURN
ERROR:
  IF XACT_STATE() <> 0 ROLLBACK TRAN
  RAISERROR (@ERRORMESSAGE, @ERRORSEVERITY, @ERRORSTATE)
GO

/****** Object:  StoredProcedure [dbo].[USP_ELITIPOCONTRATO]    Script Date: 03/03/2018 01:56:59 ******/
SET QUOTED_IDENTIFIER ON
GO
SET NUMERIC_ROUNDABORT OFF;
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON;
GO
CREATE PROCEDURE [dbo].[USP_ELITIPOCONTRATO]
( 
  @IID AS INT, @VCODIGO AS VARCHAR(200), @VDESCRIPCION AS VARCHAR(200), @IMULTIPLOANUAL AS INT, @IESTATUS AS INT = 1
)
AS

SET NOCOUNT ON
DECLARE @ERRORMESSAGE NVARCHAR(4000)  
DECLARE @ERRORSEVERITY INT  
DECLARE @ERRORSTATE INT  

BEGIN TRY          
          
  IF EXISTS (          
              SELECT *          
              FROM [DemoEmpleados].[dbo].[empleado] WITH (NOLOCK)          
              WHERE [IDTipo] = @IID        
            )          
    BEGIN
            
      SET @ERRORMESSAGE = 'El tipo del contrato que esta intentando eliminar ya se encuentra en uso en otra tabla.'          
      SET @ERRORSEVERITY = 16         
      SET @ERRORSTATE = 1             
      GOTO ERROR              
              
    END
  ELSE
  
    BEGIN
    
      BEGIN TRAN
      
        DELETE FROM [DemoEmpleados].[dbo].[tipoContracto] WHERE [ID] = @IID  
      
      COMMIT TRAN
    
    END
    
END TRY          
          
BEGIN CATCH          
              
  SET @ERRORMESSAGE = 'ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + '. LINEA ' + CAST(ERROR_LINE() AS VARCHAR(10)) + '. ' + ERROR_MESSAGE()          
  SET @ERRORSEVERITY = ERROR_SEVERITY()            
  SET @ERRORSTATE = ERROR_STATE()        
  GOTO ERROR          
          
END CATCH          
          
SET NOCOUNT OFF          
          
RETURN        
ERROR:        
  IF XACT_STATE() <> 0 ROLLBACK TRAN        
  RAISERROR (@ERRORMESSAGE, @ERRORSEVERITY, @ERRORSTATE)
GO

/****** Object:  StoredProcedure [dbo].[USP_INCempleado]    Script Date: 02/23/2018 16:11:21 ******/
SET QUOTED_IDENTIFIER ON
GO
SET NUMERIC_ROUNDABORT OFF;
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON;
GO
CREATE PROCEDURE [dbo].[USP_INCEMPLEADO]
( 
  @VDNI AS VARCHAR(100), @VNOMBRE AS VARCHAR(100), @VTELEFONO AS VARCHAR(50), @VCORREO AS VARCHAR(200), 
  @VDIRECCION AS VARCHAR(200), @FSUELDO AS FLOAT, @FSUELDOANUAL AS FLOAT, @IIDTIPO AS INT, @IESTATUS AS INT = 1
)
AS

SET NOCOUNT ON
DECLARE @ERRORMESSAGE NVARCHAR(4000)  
DECLARE @ERRORSEVERITY INT  
DECLARE @ERRORSTATE INT  

BEGIN TRY

  IF EXISTS (
              SELECT *
              FROM [DemoEmpleados].[dbo].[empleado] WITH (NOLOCK)
              WHERE [DNI] = @VDNI
            )
    BEGIN
    
      SET @ERRORMESSAGE = 'El DNI que esta intentando registrar ya se encuentra asignado a otro empleado'
      SET @ERRORSEVERITY = 16 
      SET @ERRORSTATE = 1     
      GOTO ERROR
    
    END
    
  ELSE
    BEGIN
    
      BEGIN TRAN
      
        SET @FSUELDOANUAL = @FSUELDO * (SELECT [MultiploAnual] FROM [DemoEmpleados].[dbo].[tipoContracto] A1 WHERE A1.ID = @IIDTIPO)
		
		INSERT INTO [DemoEmpleados].[dbo].[empleado]
          (DNI, Nombre, Telefono, Correo, Direccion, Sueldo, SueldoAnual, IDTipo, Estatus)
        VALUES
          (@VDNI, @VNOMBRE, @VTELEFONO, @VCORREO, @VDIRECCION, @FSUELDO, @FSUELDOANUAL, @IIDTIPO, @IESTATUS)
      
      COMMIT TRAN
    
    END

END TRY

BEGIN CATCH

  SET @ERRORMESSAGE = 'ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + '. LINEA ' + CAST(ERROR_LINE() AS VARCHAR(10)) + '. ' + ERROR_MESSAGE()
  SET @ERRORSEVERITY = ERROR_SEVERITY()  
  SET @ERRORSTATE = ERROR_STATE()  
  GOTO ERROR  

END CATCH

SET NOCOUNT OFF

RETURN
ERROR:
  IF XACT_STATE() <> 0 ROLLBACK TRAN
  RAISERROR (@ERRORMESSAGE, @ERRORSEVERITY, @ERRORSTATE)
GO

/****** Object:  StoredProcedure [dbo].[USP_MODEMPLEADO]    Script Date: 02/23/2018 16:20:47 ******/
SET QUOTED_IDENTIFIER ON
GO
SET NUMERIC_ROUNDABORT OFF;
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON;
GO
CREATE PROCEDURE [dbo].[USP_MODEMPLEADO]
( 
  @IEMPLEADO AS INT, @VDNI AS VARCHAR(100), @VNOMBRE AS VARCHAR(100), @VTELEFONO AS VARCHAR(50), @VCORREO AS VARCHAR(200), 
  @VDIRECCION AS VARCHAR(200), @FSUELDO AS FLOAT, @FSUELDOANUAL AS FLOAT, @IIDTIPO AS INT, @IESTATUS AS INT = 1
)
AS

SET NOCOUNT ON
DECLARE @ERRORMESSAGE NVARCHAR(4000)  
DECLARE @ERRORSEVERITY INT  
DECLARE @ERRORSTATE INT  

BEGIN TRY

    BEGIN
    
      BEGIN TRAN
      
      SET @FSUELDOANUAL = @FSUELDO * (SELECT [MultiploAnual] FROM [DemoEmpleados].[dbo].[tipoContracto] A1 WHERE A1.ID = @IIDTIPO)

	  UPDATE A1
      SET A1.Nombre = @VNOMBRE,
          A1.Telefono = @VTELEFONO,
          A1.Correo = @VCORREO, 
          A1.Direccion = @VDIRECCION, 
		  A1.Sueldo = @FSUELDO, 
		  A1.SueldoAnual = @FSUELDOANUAL, 
		  A1.IDTipo = @IIDTIPO, 	
          A1.Estatus = @IESTATUS
      FROM [DemoEmpleados].[dbo].[empleado] A1
      WHERE A1.DNI = @VDNI
    
      COMMIT TRAN
      
    END

END TRY

BEGIN CATCH

  SET @ERRORMESSAGE = 'ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + '. LINEA ' + CAST(ERROR_LINE() AS VARCHAR(10)) + '. ' + ERROR_MESSAGE()
  SET @ERRORSEVERITY = ERROR_SEVERITY()  
  SET @ERRORSTATE = ERROR_STATE()  
  GOTO ERROR
  
END CATCH

SET NOCOUNT OFF

RETURN
ERROR:
  IF XACT_STATE() <> 0 ROLLBACK TRAN
  RAISERROR (@ERRORMESSAGE, @ERRORSEVERITY, @ERRORSTATE)
GO

/****** Object:  StoredProcedure [dbo].[USP_ELIEMPLEADO]    Script Date: 03/03/2018 01:56:59 ******/
SET QUOTED_IDENTIFIER ON
GO
SET NUMERIC_ROUNDABORT OFF;
GO
SET QUOTED_IDENTIFIER, ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT ON;
GO
CREATE PROCEDURE [dbo].[USP_ELIEMPLEADO]
( 
  @IEMPLEADO AS INT, @VDNI AS VARCHAR(100), @VNOMBRE AS VARCHAR(100), @VTELEFONO AS VARCHAR(50), @VCORREO AS VARCHAR(200), 
  @VDIRECCION AS VARCHAR(200), @FSUELDO AS FLOAT, @FSUELDOANUAL AS FLOAT, @IIDTIPO AS INT, @IESTATUS AS INT = 1
)
AS

SET NOCOUNT ON
DECLARE @ERRORMESSAGE NVARCHAR(4000)  
DECLARE @ERRORSEVERITY INT  
DECLARE @ERRORSTATE INT  

BEGIN TRY          
          
    BEGIN
    
      BEGIN TRAN
      
        DELETE FROM [DemoEmpleados].[dbo].[empleado] WHERE [DNI] = @VDNI 
      
      COMMIT TRAN
    
    END  
    
END TRY          
          
BEGIN CATCH          
              
  SET @ERRORMESSAGE = 'ERROR ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + '. LINEA ' + CAST(ERROR_LINE() AS VARCHAR(10)) + '. ' + ERROR_MESSAGE()          
  SET @ERRORSEVERITY = ERROR_SEVERITY()            
  SET @ERRORSTATE = ERROR_STATE()        
  GOTO ERROR          
          
END CATCH          
          
SET NOCOUNT OFF          
          
RETURN        
ERROR:        
  IF XACT_STATE() <> 0 ROLLBACK TRAN        
  RAISERROR (@ERRORMESSAGE, @ERRORSEVERITY, @ERRORSTATE)
GO

EXEC [DemoEmpleados].[dbo].[USP_INCTIPOCONTRATO] 'TPCON1', 'SALARIO POR MES', 12, 1
EXEC [DemoEmpleados].[dbo].[USP_INCTIPOCONTRATO] 'TPCON2', 'SALARIO POR HORA', 1440, 1
GO

EXEC [DemoEmpleados].[dbo].[USP_INCEMPLEADO] '35407804', 'Tyrion Lannister','0234-2313098','tyrion@gmail.com', 'Los Cortijos', 2500, 1, 1, 1
EXEC [DemoEmpleados].[dbo].[USP_INCEMPLEADO] '54235461', 'Arya Stark','0424-5308590','aryagot@hotmail.com', 'Sabana Grande', 2350, 1, 1, 1
EXEC [DemoEmpleados].[dbo].[USP_INCEMPLEADO] '25435931', 'Jon Snow','0254-8004554','jonsnow@gmail.com', 'Urb. Altamira', 50, 1, 2, 1
EXEC [DemoEmpleados].[dbo].[USP_INCEMPLEADO] '40024613', 'Jaime Lannister','0409-8902368','jaime@gmail.com', 'Plaza Venezuela', 70, 1, 2, 1
EXEC [DemoEmpleados].[dbo].[USP_INCEMPLEADO] '10546936', 'Sansa Stark','090-2368450','sansagot@gmail.com', 'Plaza Bolivar', 2300, 1, 1, 1

GO