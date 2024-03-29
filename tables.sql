USE [1208_MaratonMszana]
GO
/****** Object:  Table [dbo].[Administratorzy]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Administratorzy](
	[reg_id] [int] IDENTITY(1,1) NOT NULL,
	[reg_imie] [varchar](50) NULL,
	[reg_nazwisko] [varchar](50) NULL,
	[reg_login] [varchar](50) NULL,
	[reg_password] [varchar](max) NULL,
	[reg_aktywne] [bit] NULL,
 CONSTRAINT [PK_Administratorzy] PRIMARY KEY CLUSTERED 
(
	[reg_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Dystans]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Dystans](
	[dys_id] [int] IDENTITY(1,1) NOT NULL,
	[dys_wartosc] [varchar](50) NULL,
	[dys_aktywny] [bit] NULL,
	[info_id] [int] NULL,
 CONSTRAINT [PK_Dystans] PRIMARY KEY CLUSTERED 
(
	[dys_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[dystans_info]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dystans_info](
	[info_id] [int] IDENTITY(1,1) NOT NULL,
	[info_start_time] [varchar](50) NULL,
	[info_start_date] [varchar](50) NULL,
	[info_oplata] [varchar](50) NULL,
 CONSTRAINT [PK_dystans_info] PRIMARY KEY CLUSTERED 
(
	[info_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Exception_Table]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Exception_Table](
	[er_id] [int] IDENTITY(1,1) NOT NULL,
	[er_name] [varchar](50) NULL,
	[er_description] [varchar](300) NULL,
	[er_Date] [datetime] NULL,
 CONSTRAINT [PK_Exception_Table] PRIMARY KEY CLUSTERED 
(
	[er_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[grupa_kolarska]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[grupa_kolarska](
	[grupa_id] [int] IDENTITY(1,1) NOT NULL,
	[grupa_nazwa] [varchar](50) NULL,
 CONSTRAINT [PK_grupa_kolarska] PRIMARY KEY CLUSTERED 
(
	[grupa_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[kartoteka_TMP]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[kartoteka_TMP](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[imie] [varchar](50) NULL,
	[nazwisko] [varchar](50) NULL,
	[email] [varchar](50) NULL,
	[dataRej] [datetime] NULL,
	[limitCzasu] [int] NULL,
	[dataKoncowa] [datetime] NULL,
	[rejestracja] [int] NULL,
 CONSTRAINT [PK_kartoteka_TMP] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[kartoteka2]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[kartoteka2](
	[kart_id] [int] IDENTITY(1,1) NOT NULL,
	[kart_imie] [varchar](50) NOT NULL,
	[kart_nazwisko] [varchar](50) NOT NULL,
	[kart_email] [varchar](50) NOT NULL,
	[kart_telefon] [varchar](50) NULL,
	[kart_uwagi] [varchar](100) NULL,
	[plec_id] [int] NULL,
	[dys_id] [int] NULL,
	[grup_id] [int] NULL,
	[kart_dataUr] [date] NULL,
	[kart_dataRej] [datetime] NULL,
	[kart_wpis_rejestacja] [bit] NULL,
	[kart_wpis_oplata] [bit] NULL,
	[kart_wpis_rezerwowa] [bit] NULL,
 CONSTRAINT [PK_kartoteka2] PRIMARY KEY CLUSTERED 
(
	[kart_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_kartoteka2] UNIQUE NONCLUSTERED 
(
	[kart_imie] ASC,
	[kart_nazwisko] ASC,
	[kart_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Plec]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Plec](
	[plec_id] [int] NOT NULL,
	[plec_opis] [varchar](50) NULL,
 CONSTRAINT [PK_Plec] PRIMARY KEY CLUSTERED 
(
	[plec_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [participant].[Result]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [participant].[Result](
	[result_id] [int] IDENTITY(1,1) NOT NULL,
	[result_time] [time](7) NULL,
	[zaw_id] [int] NULL,
 CONSTRAINT [PK_Result] PRIMARY KEY CLUSTERED 
(
	[result_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [participant].[Start_List]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [participant].[Start_List](
	[list_id] [int] IDENTITY(1,1) NOT NULL,
	[list_nazwa] [varchar](50) NULL,
	[list_iloscMaks] [int] NULL,
	[list_ilosc] [int] NULL,
	[list_data] [date] NULL,
	[list_czas] [time](7) NULL,
	[list_zamknieta] [bit] NULL,
	[dys_id] [int] NULL,
	[list_start] [bit] NULL,
 CONSTRAINT [PK_Start_List] PRIMARY KEY CLUSTERED 
(
	[list_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [participant].[Tag_Number]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [participant].[Tag_Number](
	[tag_id] [int] IDENTITY(1,1) NOT NULL,
	[tag_IdNumber] [varchar](20) NULL,
	[tag_LabelNumber] [int] NULL,
 CONSTRAINT [PK_Tag_Number] PRIMARY KEY CLUSTERED 
(
	[tag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [participant].[Time_Registration]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [participant].[Time_Registration](
	[time_id] [int] IDENTITY(1,1) NOT NULL,
	[time_registration] [datetime] NULL,
	[zaw_id] [int] NULL,
	[time_counter] [int] NULL,
 CONSTRAINT [PK_Time_Registration] PRIMARY KEY CLUSTERED 
(
	[time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [participant].[Zawodnik]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [participant].[Zawodnik](
	[zaw_id] [int] IDENTITY(1,1) NOT NULL,
	[zaw_aktywny] [bit] NULL,
	[kartoteka_id] [int] NULL,
	[list_id] [int] NULL,
	[tag_id] [int] NULL,
	[time_id] [int] NULL,
 CONSTRAINT [PK_zawodnik] PRIMARY KEY CLUSTERED 
(
	[zaw_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [register].[PasswordTable]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [register].[PasswordTable](
	[pass_id] [int] IDENTITY(1,1) NOT NULL,
	[pass_haslo] [varchar](300) NULL,
	[pass_data] [datetime] NULL,
	[pass_haslo2] [varchar](300) NULL,
	[pass_aktywny] [bit] NULL,
 CONSTRAINT [PK_PasswordTable] PRIMARY KEY CLUSTERED 
(
	[pass_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [register].[UserTable]    Script Date: 2019-07-13 23:02:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [register].[UserTable](
	[usesr_id] [int] IDENTITY(1,1) NOT NULL,
	[user_login] [varchar](50) NOT NULL,
	[user_imie] [varchar](50) NOT NULL,
	[user_nazwisko] [varchar](50) NOT NULL,
	[user_rejestracja] [datetime] NOT NULL,
	[user_aktywny] [bit] NOT NULL,
	[pass_id] [int] NULL,
 CONSTRAINT [PK_uzytkownik] PRIMARY KEY CLUSTERED 
(
	[usesr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [IX_UserTable] UNIQUE NONCLUSTERED 
(
	[user_login] ASC,
	[user_imie] ASC,
	[user_nazwisko] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Dystans]  WITH CHECK ADD  CONSTRAINT [FK_Dystans_dystans_info] FOREIGN KEY([info_id])
REFERENCES [dbo].[dystans_info] ([info_id])
GO
ALTER TABLE [dbo].[Dystans] CHECK CONSTRAINT [FK_Dystans_dystans_info]
GO
ALTER TABLE [dbo].[kartoteka2]  WITH CHECK ADD  CONSTRAINT [FK_kartoteka2_Dystans] FOREIGN KEY([dys_id])
REFERENCES [dbo].[Dystans] ([dys_id])
GO
ALTER TABLE [dbo].[kartoteka2] CHECK CONSTRAINT [FK_kartoteka2_Dystans]
GO
ALTER TABLE [dbo].[kartoteka2]  WITH CHECK ADD  CONSTRAINT [FK_kartoteka2_grupa_kolarska] FOREIGN KEY([grup_id])
REFERENCES [dbo].[grupa_kolarska] ([grupa_id])
GO
ALTER TABLE [dbo].[kartoteka2] CHECK CONSTRAINT [FK_kartoteka2_grupa_kolarska]
GO
ALTER TABLE [dbo].[kartoteka2]  WITH CHECK ADD  CONSTRAINT [FK_kartoteka2_Plec] FOREIGN KEY([plec_id])
REFERENCES [dbo].[Plec] ([plec_id])
GO
ALTER TABLE [dbo].[kartoteka2] CHECK CONSTRAINT [FK_kartoteka2_Plec]
GO
ALTER TABLE [participant].[Result]  WITH CHECK ADD  CONSTRAINT [FK_Result_Zawodnik] FOREIGN KEY([zaw_id])
REFERENCES [participant].[Zawodnik] ([zaw_id])
GO
ALTER TABLE [participant].[Result] CHECK CONSTRAINT [FK_Result_Zawodnik]
GO
ALTER TABLE [participant].[Start_List]  WITH CHECK ADD  CONSTRAINT [FK_dystans] FOREIGN KEY([dys_id])
REFERENCES [dbo].[Dystans] ([dys_id])
GO
ALTER TABLE [participant].[Start_List] CHECK CONSTRAINT [FK_dystans]
GO
ALTER TABLE [participant].[Time_Registration]  WITH CHECK ADD  CONSTRAINT [FK_Time_Registration_Zawodnik] FOREIGN KEY([zaw_id])
REFERENCES [participant].[Zawodnik] ([zaw_id])
GO
ALTER TABLE [participant].[Time_Registration] CHECK CONSTRAINT [FK_Time_Registration_Zawodnik]
GO
ALTER TABLE [participant].[Zawodnik]  WITH CHECK ADD  CONSTRAINT [FK_Zawodnik_Start_List] FOREIGN KEY([list_id])
REFERENCES [participant].[Start_List] ([list_id])
GO
ALTER TABLE [participant].[Zawodnik] CHECK CONSTRAINT [FK_Zawodnik_Start_List]
GO
ALTER TABLE [participant].[Zawodnik]  WITH CHECK ADD  CONSTRAINT [FK_Zawodnik_Tag_Number] FOREIGN KEY([tag_id])
REFERENCES [participant].[Tag_Number] ([tag_id])
GO
ALTER TABLE [participant].[Zawodnik] CHECK CONSTRAINT [FK_Zawodnik_Tag_Number]
GO
ALTER TABLE [register].[UserTable]  WITH CHECK ADD  CONSTRAINT [FK_haslo] FOREIGN KEY([pass_id])
REFERENCES [register].[PasswordTable] ([pass_id])
GO
ALTER TABLE [register].[UserTable] CHECK CONSTRAINT [FK_haslo]
GO
