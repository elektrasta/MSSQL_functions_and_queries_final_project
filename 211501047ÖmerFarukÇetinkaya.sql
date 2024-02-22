USE [master]
GO
/****** Object:  Database [sikayetcim]    Script Date: 18.06.2023 08:44:40 ******/
CREATE DATABASE [sikayetcim]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'sikayetcim', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sikayetcim.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'sikayetcim_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\sikayetcim_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [sikayetcim] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [sikayetcim].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [sikayetcim] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [sikayetcim] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [sikayetcim] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [sikayetcim] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [sikayetcim] SET ARITHABORT OFF 
GO
ALTER DATABASE [sikayetcim] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [sikayetcim] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [sikayetcim] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [sikayetcim] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [sikayetcim] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [sikayetcim] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [sikayetcim] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [sikayetcim] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [sikayetcim] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [sikayetcim] SET  DISABLE_BROKER 
GO
ALTER DATABASE [sikayetcim] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [sikayetcim] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [sikayetcim] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [sikayetcim] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [sikayetcim] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [sikayetcim] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [sikayetcim] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [sikayetcim] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [sikayetcim] SET  MULTI_USER 
GO
ALTER DATABASE [sikayetcim] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [sikayetcim] SET DB_CHAINING OFF 
GO
ALTER DATABASE [sikayetcim] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [sikayetcim] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [sikayetcim] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [sikayetcim] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [sikayetcim] SET QUERY_STORE = ON
GO
ALTER DATABASE [sikayetcim] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [sikayetcim]
GO
/****** Object:  UserDefinedFunction [dbo].[SikayetlerinOrtalamaBegeniSayisi]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SikayetlerinOrtalamaBegeniSayisi] ()
RETURNS INT
AS
BEGIN
    DECLARE @OrtalamaBegeniSayisi INT

    SELECT @OrtalamaBegeniSayisi = AVG(BegeniSayisi) FROM Sikayet

    RETURN @OrtalamaBegeniSayisi
END
GO
/****** Object:  Table [dbo].[Firma_Cozum]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Firma_Cozum](
	[CozumID] [int] IDENTITY(1,1) NOT NULL,
	[FirmaID] [int] NULL,
	[Aciklama] [nvarchar](max) NULL,
	[Kullanici_Sikayet_ID] [int] NULL,
	[YayinlanmaTarihi] [smalldatetime] NULL,
 CONSTRAINT [PK_Cozumler] PRIMARY KEY CLUSTERED 
(
	[CozumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Firma]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Firma](
	[FirmaID] [int] IDENTITY(1,1) NOT NULL,
	[Adi] [nvarchar](50) NULL,
	[Adres] [nvarchar](max) NULL,
	[Telefon] [nvarchar](11) NULL,
	[Mail] [nvarchar](50) NULL,
 CONSTRAINT [PK_Firmalar] PRIMARY KEY CLUSTERED 
(
	[FirmaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[SikayetCozumleriniListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SikayetCozumleriniListele] (
    @SikayetID INT
)
RETURNS TABLE
AS
RETURN
    SELECT fc.CozumID, f.Adi AS FirmaAdi, fc.Aciklama, fc.YayinlanmaTarihi
    FROM Firma_Cozum fc
    INNER JOIN Firma f ON fc.FirmaID = f.FirmaID
    WHERE fc.Kullanici_Sikayet_ID = @SikayetID
GO
/****** Object:  Table [dbo].[Kullanici_Sikayet]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kullanici_Sikayet](
	[Kullanici_Sikayet_ID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[SikayetID] [int] NULL,
 CONSTRAINT [PK_Kullanici_Sikayet] PRIMARY KEY CLUSTERED 
(
	[Kullanici_Sikayet_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sikayet]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sikayet](
	[SikayetID] [int] IDENTITY(1,1) NOT NULL,
	[FirmaID] [int] NULL,
	[Konu] [nvarchar](50) NULL,
	[Aciklama] [nvarchar](max) NULL,
	[YayinlanmaTarihi] [smalldatetime] NULL,
	[BegeniSayisi] [int] NULL,
 CONSTRAINT [PK_Sikayetler] PRIMARY KEY CLUSTERED 
(
	[SikayetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[KullaniciSikayetleriniListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[KullaniciSikayetleriniListele] (
    @KullaniciID INT
)
RETURNS TABLE
AS
RETURN
    SELECT s.SikayetID, f.Adi AS FirmaAdi, s.Konu, s.Aciklama, s.YayinlanmaTarihi, s.BegeniSayisi
    FROM Sikayet s
    INNER JOIN Firma f ON s.FirmaID = f.FirmaID
    INNER JOIN Kullanici_Sikayet ks ON s.SikayetID = ks.SikayetID
    WHERE ks.KullaniciID = @KullaniciID
GO
/****** Object:  Table [dbo].[Kullanici]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Kullanici](
	[KullaniciID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciAdi] [nvarchar](50) NULL,
	[Parola] [nvarchar](50) NULL,
	[Ad] [nvarchar](50) NULL,
	[Soyad] [nvarchar](50) NULL,
	[Mail] [nvarchar](50) NULL,
	[Telefon] [nvarchar](11) NULL,
	[Cinsiyet] [nvarchar](2) NULL,
 CONSTRAINT [PK_Kullanicilar] PRIMARY KEY CLUSTERED 
(
	[KullaniciID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sikayet_Yorumu]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sikayet_Yorumu](
	[YorumID] [int] IDENTITY(1,1) NOT NULL,
	[KullaniciID] [int] NULL,
	[Kullanici_Sikayet_ID] [int] NULL,
	[SikayetYorumu] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Yorumlar] PRIMARY KEY CLUSTERED 
(
	[YorumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[SikayetYorumlariniListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SikayetYorumlariniListele] (
    @SikayetID INT
)
RETURNS TABLE
AS
RETURN
    SELECT sy.YorumID, k.KullaniciAdi, sy.SikayetYorumu
    FROM Sikayet_Yorumu sy
    INNER JOIN Kullanici k ON sy.KullaniciID = k.KullaniciID
    WHERE sy.Kullanici_Sikayet_ID = @SikayetID
GO
/****** Object:  View [dbo].[vw_KullaniciSikayetleri]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_KullaniciSikayetleri] AS
SELECT K.KullaniciID, K.KullaniciAdi, S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi,
       F.FirmaID, F.Adi AS FirmaAdi, F.Adres, F.Telefon, F.Mail
FROM Kullanici K
JOIN Kullanici_Sikayet KS ON K.KullaniciID = KS.KullaniciID
JOIN Sikayet S ON KS.SikayetID = S.SikayetID
JOIN Firma F ON S.FirmaID = F.FirmaID;
--	Kullanıcının tüm şikayetleriyle birlikte şikayet detaylarını ve firma bilgilerini içeren view:
GO
/****** Object:  View [dbo].[vw_KullaniciSikayetYorumlari]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_KullaniciSikayetYorumlari] AS
SELECT K.KullaniciID, K.KullaniciAdi, S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi,
       SY.YorumID, SY.SikayetYorumu
FROM Kullanici K
JOIN Kullanici_Sikayet KS ON K.KullaniciID = KS.KullaniciID
JOIN Sikayet S ON KS.SikayetID = S.SikayetID
LEFT JOIN Sikayet_Yorumu SY ON K.KullaniciID = SY.KullaniciID AND KS.Kullanici_Sikayet_ID = SY.Kullanici_Sikayet_ID;
--Bir kullanıcının tüm şikayetleri ve bu şikayetlere yapılan yorumları içeren view:
GO
/****** Object:  View [dbo].[vw_FirmaSikayetTarihleri]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_FirmaSikayetTarihleri] AS
SELECT f.Adi, s.Aciklama, s.YayinlanmaTarihi
FROM Firma f
JOIN Sikayet s ON f.FirmaID = s.FirmaID;
--Bir firma hakkındaki şikayetlerin tarihlerini ve açıklamalarını içeren view:
GO
/****** Object:  View [dbo].[vw_KullaniciSikayetTarihleri]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_KullaniciSikayetTarihleri] AS
SELECT k.KullaniciAdi, s.Konu, s.YayinlanmaTarihi
FROM Kullanici k
JOIN Kullanici_Sikayet ks ON k.KullaniciID = ks.KullaniciID
JOIN Sikayet s ON ks.SikayetID = s.SikayetID;
--Bir kullanıcının yaptığı şikayetlerin tarihlerini ve şikayet konularını içeren view:
GO
/****** Object:  View [dbo].[vw_KullaniciSikayetSayisi]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_KullaniciSikayetSayisi] AS
SELECT k.KullaniciID, k.KullaniciAdi, COUNT(*) AS SikayetSayisi
FROM Kullanici k
JOIN Kullanici_Sikayet ks ON k.KullaniciID = ks.KullaniciID
GROUP BY k.KullaniciID, k.KullaniciAdi;
--Bir kullanıcının yaptığı şikayetlerin sayısını içeren view:
GO
/****** Object:  View [dbo].[vw_SikayetYorumlari]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SikayetYorumlari] AS
-- view ismini olusturdum
SELECT sy.*, k.KullaniciAdi
-- kullanıcıadı seçim yapıcam ve aşağıdaki tabloları birleştiricem
FROM Sikayet_Yorumu sy
-- şikayet yorumu tablosu
JOIN Kullanici k ON sy.KullaniciID = k.KullaniciID;
-- 'Kullanici' tablosu 'Sikayet_Yorumu' tablosuyla 'KullaniciID' sütunu üzerinden birleştiriliyor.
GO
/****** Object:  View [dbo].[KullaniciSikayetDetaylari]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[KullaniciSikayetDetaylari] AS
SELECT Kullanici.KullaniciID, Kullanici.KullaniciAdi, Sikayet.Konu, Sikayet.Aciklama, Sikayet.YayinlanmaTarihi
FROM Kullanici
JOIN Kullanici_Sikayet ON Kullanici.KullaniciID = Kullanici_Sikayet.KullaniciID
JOIN Sikayet ON Kullanici_Sikayet.SikayetID = Sikayet.SikayetID;
--KullaniciSikayetDetaylari
GO
/****** Object:  View [dbo].[FirmaCozumDetaylari]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FirmaCozumDetaylari] AS
SELECT Firma.FirmaID, Firma.Adi, Firma_Cozum.Aciklama, Firma_Cozum.YayinlanmaTarihi
FROM Firma
JOIN Firma_Cozum ON Firma.FirmaID = Firma_Cozum.FirmaID;
--FirmaCozumDetaylari
GO
/****** Object:  View [dbo].[FirmaSikayetSayilari]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[FirmaSikayetSayilari] AS
SELECT Firma.Adi, COUNT(Sikayet.SikayetID) AS SikayetSayisi
FROM Firma
LEFT JOIN Sikayet ON Firma.FirmaID = Sikayet.FirmaID
GROUP BY Firma.Adi;
--firma sikayet sayılarını verir
GO
/****** Object:  View [dbo].[KullaniciYapilanYorumlar]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[KullaniciYapilanYorumlar] AS
SELECT Kullanici.KullaniciAdi, Sikayet.Konu, Sikayet_Yorumu.SikayetYorumu
FROM Kullanici
JOIN Sikayet_Yorumu ON Kullanici.KullaniciID = Sikayet_Yorumu.KullaniciID
JOIN Kullanici_Sikayet ON Sikayet_Yorumu.Kullanici_Sikayet_ID = Kullanici_Sikayet.Kullanici_Sikayet_ID
JOIN Sikayet ON Kullanici_Sikayet.SikayetID = Sikayet.SikayetID;
--kullanıcının yaptığı yorumları listeler
GO
/****** Object:  Table [dbo].[YedeklerSikayet]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[YedeklerSikayet](
	[SikayetID] [int] NOT NULL,
	[FirmaID] [int] NULL,
	[Konu] [varchar](50) NULL,
	[Aciklama] [varchar](50) NULL,
	[YayinlanmaTarihi] [smalldatetime] NULL,
	[BegeniSayisi] [int] NULL,
 CONSTRAINT [PK_YedeklerSikayetler] PRIMARY KEY CLUSTERED 
(
	[SikayetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Firma] ON 
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (1, N'biletal', N'www.biletal.com', N'08503603258', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (2, N'heybilet', N'www.heybilet.com', N'08503022573', N'info@heybilet.com')
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (3, N'turkishairlines', N'www.turkishairlines.com', N'02124636363', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (4, N'flixsbus', N'www.flixbus.com', NULL, NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (5, N'biletinial', N'www.biletinial.com', N'08503339911', N'info@biletinial.com')
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (6, N'ziraatbank', N'www.ziraatbank.com.tr', N'08502200000', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (7, N'vakıfbank', N'www.vakifbank.com.tr', N'08502220724', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (8, N'garantibank', N'www.garantibbva.com.tr', N'4440333', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (9, N'işbank', N'www.isbank.com.tr', N'08507240724', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (10, N'halkbank', N'www.halkbank.com.tr', N'08502220400', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (11, N'gratis', N'www.gratis.com', N'08502106900', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (12, N'eve iletişim merkezi', NULL, N'08503931000', NULL)
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (13, N'rossmann iletişim merkezi', N'www.rossmann.com.tr', N'08002617766', N'info@rossmann.com.tr')
GO
INSERT [dbo].[Firma] ([FirmaID], [Adi], [Adres], [Telefon], [Mail]) VALUES (14, N'sarayhalı', N'akçakoca/düzce', N'05393715347', N'halı@gmail.com')
GO
SET IDENTITY_INSERT [dbo].[Firma] OFF
GO
SET IDENTITY_INSERT [dbo].[Firma_Cozum] ON 
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (1, 1, N'Değerli Kullanıcımız,

İletmiş olduğunuz mesaj biletall.com Destek Ekibimize iletilmiş olup, 24 saat içerisinde tarafınıza dönüş yapılacaktır.

Saygılarımızla,
biletall.com Ekibi.', 8, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (2, 2, N'Değerli Kullanıcımız,

İletmiş olduğunuz mesaj heybilet.com Destek Ekibimize iletilmiş olup, 24 saat içerisinde tarafınıza dönüş yapılacaktır.

Saygılarımızla,
heybilet.com Ekibi.', 9, CAST(N'2024-02-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (3, 3, N'Değerli Kullanıcımız,

İletmiş olduğunuz mesaj www.turkishairlines.com Destek Ekibimize iletilmiş olup, 24 saat içerisinde tarafınıza dönüş yapılacaktır.

Saygılarımızla,
www.turkishairlines.com Ekibi.', 6, CAST(N'2024-02-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (4, 4, N'Değerli Kullanıcımız,

İletmiş olduğunuz mesaj flixbus.com Destek Ekibimize iletilmiş olup, 24 saat içerisinde tarafınıza dönüş yapılacaktır.

Saygılarımızla,
flixbus.com Ekibi.', 2, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (5, 7, N'Değerli Müşterimiz,

Bildiriminiz değerlendirmeye alınmış olup, sonucu hakkında bankamızda kayıtlı iletişim bilgilerinizden tarafınıza detaylı bilgi iletilecektir.

Bankamızda kayıtlı iletişim bilgilerinizde değişiklik olması durumunda 0850 222 0724 Telefon Şubemiz, Şubelerimiz ya da vakıfbank Direkt İnternet üzerinden bilgilerinizi güncelleyebilirsiniz.

Bankamız ürün ve hizmetleri ile ilgili paylaşmak istediğiniz tüm şikayet, öneri ve istekleriniz için vakifbank.com.tr internet sitemizde yer alan “Bize Ulaşın” formunu kullanabilirsiniz.

Saygılarımızla
Vakıfbank', 4, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (6, 8, N'Değerli Müşterimiz,

Bildiriminiz değerlendirmeye alınmış olup, sonucu hakkında bankamızda kayıtlı iletişim bilgilerinizden tarafınıza detaylı bilgi iletilecektir.

Bankamızda kayıtlı iletişim bilgilerinizde değişiklik olması durumunda 444 0 333 Telefon Şubemiz, Şubelerimiz ya da garantibbva Direkt İnternet üzerinden bilgilerinizi güncelleyebilirsiniz.

Bankamız ürün ve hizmetleri ile ilgili paylaşmak istediğiniz tüm şikayet, öneri ve istekleriniz için garantibbva.com.tr internet sitemizde yer alan “Bize Ulaşın” formunu kullanabilirsiniz.

Saygılarımızla
Garantibbva', 11, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (7, 10, N'Değerli Müşterimiz,

Bildiriminiz değerlendirmeye alınmış olup, sonucu hakkında bankamızda kayıtlı iletişim bilgilerinizden tarafınıza detaylı bilgi iletilecektir.

Bankamızda kayıtlı iletişim bilgilerinizde değişiklik olması durumunda 0850 222 0400 Telefon Şubemiz, Şubelerimiz ya da halkbank Direkt İnternet üzerinden bilgilerinizi güncelleyebilirsiniz.

Bankamız ürün ve hizmetleri ile ilgili paylaşmak istediğiniz tüm şikayet, öneri ve istekleriniz için halkbank.com.tr internet sitemizde yer alan “Bize Ulaşın” formunu kullanabilirsiniz.

Saygılarımızla
Halkbank', 1, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (8, 11, N'Değerli müşterimiz Hatice Ç.,

Geri bildiriminiz ile ilgili sizlere en kısa süre içerisinde dönüş yapılacaktır.

Gratis ile ilgili düşüncelerinizi ve deneyimlerinizi haftanın 7 günü saat 09:00-22:00 arasında 0 850 210 69 00 nolu telefondan bizimle paylaşabilirsiniz.

Gratis Ailesi olarak güzel günler dileriz,
Gratis İletişim Merkezi', 5, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (9, 13, N'Değerli müşterimiz Beyza A.,

Geri bildiriminiz ile ilgili sizlere en kısa süre içerisinde dönüş yapılacaktır.

Rossmannile ilgili düşüncelerinizi ve deneyimlerinizi haftanın 7 günü saat 09:00-22:00 arasında 0800 261 77 66 nolu telefondan bizimle paylaşabilirsiniz.

Rossmann Ailesi olarak güzel günler dileriz,
Rossmann İletişim Merkezi', 3, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (10, 5, N'Değerli Kullanıcımız,

İletmiş olduğunuz mesaj biletall.com Destek Ekibimize iletilmiş olup, 24 saat içerisinde tarafınıza dönüş yapılacaktır.

Saygılarımızla,
biletall.com Ekibi.', 7, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (11, 5, N'Değerli Kullanıcımız,

İletmiş olduğunuz mesaj biletall.com Destek Ekibimize iletilmiş olup, 24 saat içerisinde tarafınıza dönüş yapılacaktır.

Saygılarımızla,
biletall.com Ekibi.', 10, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Firma_Cozum] ([CozumID], [FirmaID], [Aciklama], [Kullanici_Sikayet_ID], [YayinlanmaTarihi]) VALUES (12, 2, N'hemen ilgileniyoruz', 5, CAST(N'2024-01-01T00:00:00' AS SmallDateTime))
GO
SET IDENTITY_INSERT [dbo].[Firma_Cozum] OFF
GO
SET IDENTITY_INSERT [dbo].[Kullanici] ON 
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (1, N'elektrasta', N'ömer123', N'Ömer Faruk', N'Çetinkaya', N'omer@gmail.com', N'05393715378', N'E')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (2, N'cakcakbaba', N'hatice123', N'Hatice', N'Çakıcı', N'hatice@gmail.com', N'05057412596', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (3, N'efsun.1618', N'efsund*8978', N'Efsun', N'Aydemir', N'efsun@gmail.com', N'05687415935', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (8, N'sevgi.47', N'49AJU7', N'Sevgi', N'Güngöz', N'sevgi@gmail.com', N'05489745618', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (9, N'furkan.d', N'fD25', N'Furkan', N'Deniz', N'furkan@gmail.com', N'05485621009', N'E')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (10, N'gökhan.4', N'IKL002', N'Gökhan', N'Arslan', N'gökhan@gmail.com', N'05469802749', N'E')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (11, N'gizem14', N'gizem5859', N'Gizem', N'Karaca', N'gizem@gmail.com', N'05489200127', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (12, N'alimala_8', N'A45A7', N'Almila', N'Akarsu', N'akarsu@gmail.com', N'05963210548', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (13, N'talha17', N'talha.G', N'Talha', N'Gündüz', N'talha@gmail.com', N'05054982314', N'E')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (14, N'ülkübayka', N'ülkü123', N'Ülkü', N'Baykal', N'baykal@gmail.com', N'05679513548', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (15, N'beyza.a', N'beyza123', N'Beyza', N'Avcı', N'beyza@gmail.com', N'05847956210', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (17, N'ilaydaçet', N'benenguzelkizim', N'İlayda', N'Çetin', N'ilayda@gmail.com', N'05055055505', N'K')
GO
INSERT [dbo].[Kullanici] ([KullaniciID], [KullaniciAdi], [Parola], [Ad], [Soyad], [Mail], [Telefon], [Cinsiyet]) VALUES (18, N'cupid', N'sezenikosemefix', N'Sezen', N'Doğan', N'sezen@gmail.com', N'05057896341', N'K')
GO
SET IDENTITY_INSERT [dbo].[Kullanici] OFF
GO
SET IDENTITY_INSERT [dbo].[Kullanici_Sikayet] ON 
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (1, 1, 2)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (2, 3, 4)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (3, 2, 1)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (4, 8, 11)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (5, 8, 10)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (6, 10, 5)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (7, 11, 3)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (8, 12, 6)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (9, 13, 7)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (10, 14, 8)
GO
INSERT [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID], [KullaniciID], [SikayetID]) VALUES (11, 18, 9)
GO
SET IDENTITY_INSERT [dbo].[Kullanici_Sikayet] OFF
GO
SET IDENTITY_INSERT [dbo].[Sikayet] ON 
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (1, 13, N'ödeme yapılmadı olarak gözüküyor', N'ödeme yapıldığı halde sistemde ödeme yapılmadı diye gözüküyor', CAST(N'2023-09-15T00:00:00' AS SmallDateTime), 3)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (2, 10, N'para transferi', N'sistemde gözükse bile açılmıyor ve hata veriyor', CAST(N'2023-08-22T00:00:00' AS SmallDateTime), 6)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (3, 5, N'rezerve', N'bilet rezerve edilmiyor', CAST(N'2023-06-03T00:00:00' AS SmallDateTime), 2)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (4, 4, N'iade', N'biletim iade zamanı dolmadığı halde iade işlemini gerçekleştiremiyorum', CAST(N'2023-08-07T00:00:00' AS SmallDateTime), 14)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (5, 3, N'indirim', N'indirimim olmasına rağmen indirim yapılmıyor', CAST(N'2023-03-14T00:00:00' AS SmallDateTime), 15)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (6, 1, N'sorun', N'ikiden fazla bilat alınmıyor', CAST(N'2023-05-05T00:00:00' AS SmallDateTime), 3)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (7, 2, N'paramı geri verin', N'biletimin ödemesini yapmama rağmen sistemde aktif biletim bulunmuyor', CAST(N'2023-08-06T00:00:00' AS SmallDateTime), 25)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (8, 5, N'bilet alamıyorum', N'bilet almak için sms ile doğrulama kodu gönderiliyor bu kodu girdiğim halde onaylama alamıyorum', CAST(N'2023-02-24T00:00:00' AS SmallDateTime), 7)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (9, 8, N'nakit avans', N'ilk yeni müşterilerine nakit avans desteği sağlanacığı söylenmişti başvuru yaptım onaylandı ama sistemde gözükmüyor', CAST(N'2023-12-05T00:00:00' AS SmallDateTime), 22)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (10, 11, N'gratis çok kötü', N'ürünlerimden bir tanesi eksik geldi ve fiş çıkmadı', CAST(N'2023-12-12T00:00:00' AS SmallDateTime), 5)
GO
INSERT [dbo].[Sikayet] ([SikayetID], [FirmaID], [Konu], [Aciklama], [YayinlanmaTarihi], [BegeniSayisi]) VALUES (11, 7, N'kredi kartım', N'iptal olan üyeliğime rağmen kartımdan para çekiliyor', CAST(N'2023-05-08T00:00:00' AS SmallDateTime), 9)
GO
SET IDENTITY_INSERT [dbo].[Sikayet] OFF
GO
SET IDENTITY_INSERT [dbo].[Sikayet_Yorumu] ON 
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (1, 1, 1, N'bende de aynı sorun var lütfen yardım edin')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (2, 2, 2, N'bu sorun bende de oluştu yardım ediniz lütfen')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (3, 3, 3, N'böyle sorunlar hep benim basıma gelirdi sanardım :)')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (6, 8, 4, N'bu ne biçim bir sorun ya çözülmedi gitti')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (7, 10, 5, N'hiç çözülmüyor benim şikayetlerim üzülüyorum')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (8, 11, 6, N'bende ki sorun çözüldü kankam sende çözülürse yaz diğer agalara help olsun')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (9, 12, 7, N'bende ki çözüldü ahaha')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (10, 13, 8, N'bu firmayı severdim artık sevmiyorum')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (11, 14, 9, N'inş yakın zamanda çözülür ne diyim')
GO
INSERT [dbo].[Sikayet_Yorumu] ([YorumID], [KullaniciID], [Kullanici_Sikayet_ID], [SikayetYorumu]) VALUES (12, 18, 10, N'allah razı olsun bendekini çözdüler')
GO
SET IDENTITY_INSERT [dbo].[Sikayet_Yorumu] OFF
GO
ALTER TABLE [dbo].[Firma_Cozum]  WITH CHECK ADD  CONSTRAINT [FK_Firma_Cozum_Firma] FOREIGN KEY([FirmaID])
REFERENCES [dbo].[Firma] ([FirmaID])
GO
ALTER TABLE [dbo].[Firma_Cozum] CHECK CONSTRAINT [FK_Firma_Cozum_Firma]
GO
ALTER TABLE [dbo].[Firma_Cozum]  WITH CHECK ADD  CONSTRAINT [FK_Firma_Cozum_Kullanici_Sikayet] FOREIGN KEY([Kullanici_Sikayet_ID])
REFERENCES [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID])
GO
ALTER TABLE [dbo].[Firma_Cozum] CHECK CONSTRAINT [FK_Firma_Cozum_Kullanici_Sikayet]
GO
ALTER TABLE [dbo].[Kullanici_Sikayet]  WITH CHECK ADD  CONSTRAINT [FK_Kullanici_Sikayet_Kullanici] FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanici] ([KullaniciID])
GO
ALTER TABLE [dbo].[Kullanici_Sikayet] CHECK CONSTRAINT [FK_Kullanici_Sikayet_Kullanici]
GO
ALTER TABLE [dbo].[Kullanici_Sikayet]  WITH CHECK ADD  CONSTRAINT [FK_Kullanici_Sikayet_Sikayet] FOREIGN KEY([SikayetID])
REFERENCES [dbo].[Sikayet] ([SikayetID])
GO
ALTER TABLE [dbo].[Kullanici_Sikayet] CHECK CONSTRAINT [FK_Kullanici_Sikayet_Sikayet]
GO
ALTER TABLE [dbo].[Sikayet]  WITH CHECK ADD  CONSTRAINT [FK_Sikayet_Firma] FOREIGN KEY([FirmaID])
REFERENCES [dbo].[Firma] ([FirmaID])
GO
ALTER TABLE [dbo].[Sikayet] CHECK CONSTRAINT [FK_Sikayet_Firma]
GO
ALTER TABLE [dbo].[Sikayet_Yorumu]  WITH CHECK ADD  CONSTRAINT [FK_Sikayet_Yorumu_Kullanici] FOREIGN KEY([KullaniciID])
REFERENCES [dbo].[Kullanici] ([KullaniciID])
GO
ALTER TABLE [dbo].[Sikayet_Yorumu] CHECK CONSTRAINT [FK_Sikayet_Yorumu_Kullanici]
GO
ALTER TABLE [dbo].[Sikayet_Yorumu]  WITH CHECK ADD  CONSTRAINT [FK_Sikayet_Yorumu_Kullanici_Sikayet] FOREIGN KEY([Kullanici_Sikayet_ID])
REFERENCES [dbo].[Kullanici_Sikayet] ([Kullanici_Sikayet_ID])
GO
ALTER TABLE [dbo].[Sikayet_Yorumu] CHECK CONSTRAINT [FK_Sikayet_Yorumu_Kullanici_Sikayet]
GO
/****** Object:  StoredProcedure [dbo].[EnCokSikayetAlanFirmalar]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EnCokSikayetAlanFirmalar]
    @Limit int
AS
BEGIN
    SELECT TOP (@Limit) F.FirmaID, F.Adi, COUNT(S.SikayetID) AS SikayetSayisi
    FROM Firma AS F
    INNER JOIN Sikayet AS S ON F.FirmaID = S.FirmaID
    GROUP BY F.FirmaID, F.Adi
    ORDER BY SikayetSayisi DESC
END
GO
/****** Object:  StoredProcedure [dbo].[EnPopulerSikayetler]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EnPopulerSikayetler]
    @Limit int
AS
BEGIN
    SELECT TOP (@Limit) S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet AS S
    ORDER BY S.BegeniSayisi DESC
END
GO
/****** Object:  StoredProcedure [dbo].[EnYeniSikayetler]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EnYeniSikayetler]
    @Limit int
AS
BEGIN
    SELECT TOP (@Limit) S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet AS S
    ORDER BY S.YayinlanmaTarihi DESC
END
GO
/****** Object:  StoredProcedure [dbo].[EnYeniSikayetYorumlariListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EnYeniSikayetYorumlariListele]
AS
BEGIN
    SELECT SY.YorumID, SY.SikayetYorumu, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet_Yorumu AS SY
    INNER JOIN Kullanici_Sikayet AS KS ON SY.Kullanici_Sikayet_ID = KS.Kullanici_Sikayet_ID
    INNER JOIN Sikayet AS S ON KS.SikayetID = S.SikayetID
    ORDER BY SY.YorumID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FirmaBilgiGuncelle]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FirmaBilgiGuncelle]
    @FirmaID int,
    @Adi nvarchar(50),
    @Adres nvarchar(MAX),
    @Telefon nvarchar(11),
    @Mail nvarchar(50)
AS
BEGIN
    UPDATE Firma
    SET Adi = @Adi, Adres = @Adres, Telefon = @Telefon, Mail = @Mail
    WHERE FirmaID = @FirmaID
END
GO
/****** Object:  StoredProcedure [dbo].[FirmaEkle]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FirmaEkle]
    @Adi nvarchar(50),
    @Adres nvarchar(MAX),
    @Telefon nvarchar(11),
    @Mail nvarchar(50)
AS
BEGIN
    INSERT INTO Firma (Adi, Adres, Telefon, Mail)
    VALUES (@Adi, @Adres, @Telefon, @Mail)
END
GO
/****** Object:  StoredProcedure [dbo].[FirmaSikayetDetay]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FirmaSikayetDetay]
    @FirmaID int
AS
BEGIN
    SELECT S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi, F.Adi AS FirmaAdi
    FROM Sikayet AS S
    INNER JOIN Firma AS F ON S.FirmaID = F.FirmaID
    WHERE S.FirmaID = @FirmaID
END
GO
/****** Object:  StoredProcedure [dbo].[FirmaSikayetFiltrele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FirmaSikayetFiltrele]
    @FirmaID int,
    @MinBegeniSayisi int,
    @MinYayinlanmaTarihi date
AS
BEGIN
    SELECT S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet AS S
    WHERE S.FirmaID = @FirmaID AND S.BegeniSayisi >= @MinBegeniSayisi AND S.YayinlanmaTarihi >= @MinYayinlanmaTarihi
END
GO
/****** Object:  StoredProcedure [dbo].[FirmaSikayetleriniBegeniyeGoreSirala]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FirmaSikayetleriniBegeniyeGoreSirala]
    @FirmaID int
AS
BEGIN
    SELECT S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet AS S
    WHERE S.FirmaID = @FirmaID
    ORDER BY S.BegeniSayisi DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FirmaSikayetListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FirmaSikayetListele]
    @FirmaID int
AS
BEGIN
    SELECT S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet AS S
    WHERE S.FirmaID = @FirmaID
END
GO
/****** Object:  StoredProcedure [dbo].[FirmaSikayetOrtalamaBegeni]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FirmaSikayetOrtalamaBegeni]
    @FirmaID int,
    @OrtalamaBegeni int OUTPUT
AS
BEGIN
    SELECT @OrtalamaBegeni = AVG(BegeniSayisi)
    FROM Sikayet
    WHERE FirmaID = @FirmaID
END
GO
/****** Object:  StoredProcedure [dbo].[KullaniciEkle]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[KullaniciEkle]
    @KullaniciAdi nvarchar(50),
    @Parola nvarchar(50),
    @Ad nvarchar(50),
    @Soyad nvarchar(50),
    @Mail nvarchar(50),
    @Telefon nvarchar(11),
    @Cinsiyet nvarchar(1)
AS
BEGIN
    INSERT INTO Kullanici (KullaniciAdi, Parola, Ad, Soyad, Mail, Telefon, Cinsiyet)
    VALUES (@KullaniciAdi, @Parola, @Ad, @Soyad, @Mail, @Telefon, @Cinsiyet)
END
GO
/****** Object:  StoredProcedure [dbo].[KullaniciListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[KullaniciListele]
AS
BEGIN
    SELECT KullaniciID, KullaniciAdi, Ad, Soyad, Mail, Telefon, Cinsiyet
    FROM Kullanici
END
GO
/****** Object:  StoredProcedure [dbo].[KullaniciSikayetleri]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[KullaniciSikayetleri]
    @KullaniciID int
AS
BEGIN
    SELECT S.SikayetID, S.FirmaID, F.Adi AS FirmaAdi, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet AS S
    INNER JOIN Firma AS F ON S.FirmaID = F.FirmaID
    INNER JOIN Kullanici_Sikayet AS KS ON S.SikayetID = KS.SikayetID
    WHERE KS.KullaniciID = @KullaniciID
END
GO
/****** Object:  StoredProcedure [dbo].[KullaniciSikayetListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[KullaniciSikayetListele]
    @KullaniciID int
AS
BEGIN
    SELECT S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi, F.Adi AS FirmaAdi
    FROM Sikayet AS S
    INNER JOIN Kullanici_Sikayet AS KS ON S.SikayetID = KS.SikayetID
    INNER JOIN Firma AS F ON S.FirmaID = F.FirmaID
    WHERE KS.KullaniciID = @KullaniciID
END
GO
/****** Object:  StoredProcedure [dbo].[SikayetDetay]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SikayetDetay]
    @SikayetID int
AS
BEGIN
    SELECT S.SikayetID, S.FirmaID, F.Adi AS FirmaAdi, F.Adres, F.Telefon, F.Mail, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi
    FROM Sikayet AS S
    INNER JOIN Firma AS F ON S.FirmaID = F.FirmaID
    WHERE S.SikayetID = @SikayetID
END
GO
/****** Object:  StoredProcedure [dbo].[SikayetListele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SikayetListele]
AS
BEGIN
    SELECT SikayetID, FirmaID, Konu, Aciklama, YayinlanmaTarihi, BegeniSayisi
    FROM Sikayet
END
GO
/****** Object:  StoredProcedure [dbo].[SikayetOlustur]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SikayetOlustur]
    @FirmaID int,
    @Konu nvarchar(100),
    @Aciklama nvarchar(max),
    @YayinlanmaTarihi date
AS
BEGIN
    INSERT INTO Sikayet (FirmaID, Konu, Aciklama, YayinlanmaTarihi)
    VALUES (@FirmaID, @Konu, @Aciklama, @YayinlanmaTarihi)
END
GO
/****** Object:  StoredProcedure [dbo].[SikayetTarihFiltrele]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SikayetTarihFiltrele]
    @BaslangicTarihi date,
    @BitisTarihi date
AS
BEGIN
    SELECT S.SikayetID, S.Konu, S.Aciklama, S.YayinlanmaTarihi, S.BegeniSayisi, F.Adi AS FirmaAdi
    FROM Sikayet AS S
    INNER JOIN Firma AS F ON S.FirmaID = F.FirmaID
    WHERE S.YayinlanmaTarihi BETWEEN @BaslangicTarihi AND @BitisTarihi
END
GO
/****** Object:  StoredProcedure [dbo].[SikayetYorumlari]    Script Date: 18.06.2023 08:44:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SikayetYorumlari]
    @SikayetID int
AS
BEGIN
    SELECT Y.YorumID, Y.KullaniciID, Y.Kullanici_Sikayet_ID, Y.SikayetYorumu
    FROM Sikayet_Yorumu AS Y
    INNER JOIN Kullanici_Sikayet AS KS ON Y.Kullanici_Sikayet_ID = KS.Kullanici_Sikayet_ID
    WHERE KS.SikayetID = @SikayetID
END
GO
USE [master]
GO
ALTER DATABASE [sikayetcim] SET  READ_WRITE 
GO
