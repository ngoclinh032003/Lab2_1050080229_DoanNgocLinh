/*
    LAB 2 - MA HOA DOI XUNG HIEN DAI
    Script tong hop tao CSDL, bang, tai khoan ket noi va kiem tra du lieu.
    Cach chay: mo SQL Server Management Studio (SSMS), ket noi bang tai khoan
    co quyen tao database/login, mo file nay va nhan Execute.

    Luu y:
    - Script mau dung tai khoan lab2_user va mat khau LabUser@2026 de dong bo
      voi huong dan trong README/project.
    - Chi dung mat khau nay trong moi truong hoc tap cuc bo.
    - Neu doi mat khau tai day, hay cap nhat cung mat khau trong cau hinh
      ket noi SQL Server cua ung dung Java.
*/

USE master;
GO

/* PHAN 1. TAO DATABASE */
IF DB_ID(N'LAB2_MaHoaHienDai') IS NULL
BEGIN
    CREATE DATABASE LAB2_MaHoaHienDai;
END;
GO

USE LAB2_MaHoaHienDai;
GO

/* PHAN 2. TAO BANG TAI KHOAN UNG DUNG */
IF OBJECT_ID(N'dbo.app_users', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.app_users
    (
        user_id INT IDENTITY(1,1) PRIMARY KEY,
        username NVARCHAR(40) NOT NULL UNIQUE,
        salt VARBINARY(16) NOT NULL,
        password_hash VARBINARY(32) NOT NULL,
        created_at DATETIME2(0) NOT NULL
            CONSTRAINT DF_app_users_created_at DEFAULT SYSUTCDATETIME()
    );
END;
GO

/* PHAN 3. TAO BANG LICH SU MA HOA */
IF OBJECT_ID(N'dbo.crypto_history', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.crypto_history
    (
        history_id BIGINT IDENTITY(1,1) PRIMARY KEY,
        algorithm NVARCHAR(40) NOT NULL,
        operation NVARCHAR(16) NOT NULL,
        app_username NVARCHAR(40) NULL,
        input_length INT NOT NULL,
        output_length INT NOT NULL,
        created_at DATETIME2(0) NOT NULL
            CONSTRAINT DF_crypto_history_created_at DEFAULT SYSUTCDATETIME()
    );
END;
GO

/* PHAN 4. TAO SQL LOGIN */
USE master;
GO

IF SUSER_ID(N'lab2_user') IS NULL
BEGIN
    CREATE LOGIN lab2_user
    WITH PASSWORD = 'LabUser@2026',
         CHECK_POLICY = ON;
END;
GO

/* PHAN 5. TAO DATABASE USER VA CAP QUYEN */
USE LAB2_MaHoaHienDai;
GO

IF DATABASE_PRINCIPAL_ID(N'lab2_user') IS NULL
BEGIN
    CREATE USER lab2_user FOR LOGIN lab2_user;
END;
GO

IF IS_ROLEMEMBER(N'db_datareader', N'lab2_user') = 0
BEGIN
    ALTER ROLE db_datareader ADD MEMBER lab2_user;
END;
GO

IF IS_ROLEMEMBER(N'db_datawriter', N'lab2_user') = 0
BEGIN
    ALTER ROLE db_datawriter ADD MEMBER lab2_user;
END;
GO

/* PHAN 6. KIEM TRA DATABASE VA CAC BANG */
USE LAB2_MaHoaHienDai;
GO

SELECT DB_NAME() AS DatabaseDangSuDung;

SELECT name AS TenBang
FROM sys.tables
WHERE name IN (N'app_users', N'crypto_history');

SELECT TOP 20
    user_id, username, created_at
FROM dbo.app_users
ORDER BY user_id DESC;

SELECT TOP 50
    history_id, algorithm, operation, app_username,
    input_length, output_length, created_at
FROM dbo.crypto_history
ORDER BY history_id DESC;
GO

/*
    CAU HINH KET NOI THAM KHAO CHO UNG DUNG:
    Server/Host : 127.0.0.1
    Port        : 14333 (neu da cau hinh TCP/IP theo huong dan)
    Database    : LAB2_MaHoaHienDai
    Username    : lab2_user
    Password    : LabUser@2026 (mat khau mau cua bai lab)
*/
