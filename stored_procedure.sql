USE [1208_MaratonMszana]
GO
/****** Object:  StoredProcedure [dbo].[pAddInfoError]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pAddInfoError](
@info varchar(200),
@name varchar(50)
)
as
begin
	INSERT INTO [dbo].[Exception_Table]
           ([er_name]
           ,[er_description]
           ,[er_Date])
     VALUES
           (@name,@info,getDAte())
end

GO
/****** Object:  StoredProcedure [dbo].[pDodajGrupa]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- MJ
-- 03.07.2018
-- dodanie nowej grupy dla bezpieczenstawa procedura
-- =============================================
CREATE PROCEDURE [dbo].[pDodajGrupa](
 @grupa varchar(50)
)
AS
BEGIN
	INSERT INTO [dbo].[grupa_kolarska]
           ([grupa_nazwa])
     VALUES
           (@grupa)
END




GO
/****** Object:  StoredProcedure [dbo].[pInitilizationParticipant]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- przepisanie do tabeli zawodnik
-- nadanie numeru
-- generacja pustych list
-- polaczenie zawodnika z listami
-- =============================================
CREATE PROCEDURE [dbo].[pInitilizationParticipant]
AS
BEGIN
	exec [participant].[pInsertKartotekaIdToZawodnik]
	exec  [participant].[pJoinZawodnikAndTagNumber]
	--exec [participant].[pCreateEmptyStartList]
	exec [participant].[pPolaczZawodnikow_z_Listami]
END
GO
/****** Object:  StoredProcedure [dbo].[pKartotekaZawodnikaDodaj]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- MJ
-- 03.07.2018
-- Procedura dodawania zawodnika, baz zmyslnych warunkow jak poprzednio
-- proceura wywolywana przez weba:
-- true - rejestracja
-- true - lista rezerwowa
-- 22.08.2018 - blad zwiazany z dodanie nulla do kolumny rezerwa mialo byc true
--			  -	oplata null		
-- =============================================
CREATE PROCEDURE [dbo].[pKartotekaZawodnikaDodaj](
@imie varchar(50),
@nazwisko varchar(50),
@email varchar(50),
@dataU Date,
@plec_id int,
@fafon varchar(15),
@uwagi varchar(100),
@dys_id int,
@grupa_id int,
@rejestrcja bit,
@rezerwa bit
) 
AS
BEGIN
	
	INSERT INTO [dbo].[kartoteka2]
           ([kart_imie],[kart_nazwisko],[kart_email],[kart_telefon],[kart_uwagi],[plec_id]
           ,[dys_id],[grup_id],[kart_dataUr],[kart_dataRej],[kart_wpis_rejestacja]
           ,[kart_wpis_oplata],[kart_wpis_rezerwowa])
     VALUES
           (@imie,@nazwisko,@email,@fafon,@uwagi,@plec_id,@dys_id,@grupa_id,@dataU,GETDATE()
           ,@rejestrcja,null,@rezerwa)
END


GO
/****** Object:  StoredProcedure [dbo].[pStartingFee]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--oplata startowa
CREATE procedure [dbo].[pStartingFee](
@name varchar(50),
@surname varchar(50),
@email varchar(50)
)
as
begin
declare @kart_id int

set @kart_id = (select kart_id from kartoteka2 where kart_imie = @name and kart_nazwisko = @surname and kart_email = @email)
	if(@kart_id > 0)
	begin
		update kartoteka2 set
			kart_wpis_oplata = 1
		where
			kart_id = @kart_id
	end 
	else
	begin
	declare @komunikat varchar(200) = @name + ' ' + @surname +' ' + @email + ' nie istenieje'
		exec dbo.pAddInfoError @komunikat,'pDodajZawodnikaDoListy'
	end 
end
GO
/****** Object:  StoredProcedure [marathonOffice].[pChangeStartGroupTooParticipant]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [marathonOffice].[pChangeStartGroupTooParticipant](
 @kart_id int,
 @list_id_target int
)
as
begin
	--local variables
	
	declare @list_id_actual int
	declare @dys_participant int
	declare @dys_in_list int 
	declare @zaw_id int
	declare @amount_participant_in_actual_list int
	declare @amount_participant_in_target_list int
	declare @list_is_started bit
	declare @list_is_started2 bit
	 
	declare @info varchar(200)

	select @zaw_id = zaw_id, @list_id_actual = list_id from participant.Zawodnik where kartoteka_id = @kart_id
	select @amount_participant_in_actual_list = list_ilosc from participant.Start_List where list_id = @list_id_actual
	select @amount_participant_in_target_list = list_ilosc, @list_is_started = list_start from participant.Start_List where list_id = @list_id_target
	select @dys_participant = dys_id from kartoteka2 where kart_id = @kart_id
	select @dys_in_list = dys_id from participant.Start_List where list_id = @list_id_target 

	if(@zaw_id is null)
	begin
		set @info = 'Zawodnik nieoplacony: ' +  CAST(@kart_id as varchar)
		exec dbo.pAddInfoError @info,' zmiana grupy startowej '
		return
	end

	if(@amount_participant_in_target_list >= 15)
	begin
		set @info = 'Lista docelowa pe³na nr listy: ' +  CAST(@list_id_target as varchar)
		exec dbo.pAddInfoError @info,' zmiana grupy startowej '
		return
	end

	if(@dys_in_list <> @dys_participant)
	begin
		set @info = 'Lista: ' +CAST(@list_id_target as varchar) +' ma inny dystans ni¿ zawodnik: ' +  CAST(@kart_id as varchar)
		exec dbo.pAddInfoError @info,' zmiana grupy startowej '
		return
	end

	if(@list_is_started = 1)
	begin
		set @info = 'Lista docelowa: ' +CAST(@list_id_target as varchar) +' wystartowa³a: ' 
		exec dbo.pAddInfoError @info,' zmiana grupy startowej '
		return
	end

	if(@list_is_started2 = 1)
	begin
		set @info = 'Lista Ÿród³owa: ' +CAST(@list_id_actual as varchar) +' wystartowa³a ' 
		exec dbo.pAddInfoError @info,' zmiana grupy startowej '
		return
	end

	update participant.Zawodnik set list_id = @list_id_target where zaw_id = @zaw_id and kartoteka_id = @kart_id
	update participant.Start_List set list_ilosc =  @amount_participant_in_actual_list - 1 where list_id = @list_id_actual
	update participant.Start_List set list_ilosc =  @amount_participant_in_target_list + 1 where list_id = @list_id_target

end
GO
/****** Object:  StoredProcedure [marathonOffice].[pDeactivatingParticipant]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [marathonOffice].[pDeactivatingParticipant](
 @kart_id int 
)
as
begin
declare @list_id int
declare @zaw_id int
declare @dane varchar(150)


  select @list_id = list_id,@zaw_id = Z.zaw_id, @dane = (K2.kart_imie + ' ' + K2.kart_nazwisko + ' ' + K2.kart_email)	
   from participant.Zawodnik Z
  left join kartoteka2 K2 on K2.kart_id = Z.kartoteka_id 
  where 
	K2.kart_id = @kart_id 
if(@list_id > 0)
	begin
		begin transaction
		update participant.Start_List set list_ilosc = (select list_ilosc from participant.Start_List where list_id = @list_id) - 1 where list_id = @list_id
		update participant.Zawodnik set 
				list_id = null,
				tag_id = 0,
				zaw_aktywny = 0		
			   where zaw_id = @zaw_id

		update kartoteka2 set
				kart_wpis_oplata = null,
				kart_wpis_rejestacja = 0, 
				kart_wpis_rezerwowa = null 
				where kart_id = @kart_id
		commit transaction
		declare @info3 varchar(200)
		set @info3 =  'zawodnik wyczyszczony, ustawiony nieaktywny ' + @dane
		exec dbo.pAddInfoError @info3,'usuniecie zawodnika'
		
	end
else
	begin
		declare @info2 varchar(200)
		set @info2 =  'zawodnik nie ma listy, deaktywacja zawodnika w kartotece'
		
		update kartoteka2 set
				kart_wpis_oplata = null,
				kart_wpis_rejestacja = null,
				kart_wpis_rezerwowa = null
				where kart_id = @kart_id
				
		exec dbo.pAddInfoError @info2,'usuniecie zawodnika'
	end
end
GO
/****** Object:  StoredProcedure [participant].[getZawodnikDane]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [participant].[getZawodnikDane] (
 @tag varchar(20),
 @imie varchar(50) out,
 @nazwisko varchar(50)out,
 @numer int out
)

AS
BEGIN
	select @imie = K2.kart_imie,@nazwisko = K2.kart_nazwisko,@numer = TN.tag_LabelNumber from participant.Zawodnik Z
	inner join participant.Tag_Number TN on TN.tag_id = Z.tag_id
	inner join dbo.kartoteka2 K2 on K2.kart_id = Z.kartoteka_id
	where
		TN.tag_IdNumber = @tag
END

GO
/****** Object:  StoredProcedure [participant].[pChangeDistanceAndStartingGroupForParticipant]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [participant].[pChangeDistanceAndStartingGroupForParticipant](
@dys_id int,
@kart_id int 
)
as 
begin
declare @list_id int = -1
declare @zaw_id int = -1
declare @dane varchar(100)
declare @dys_opis varchar(10)

select @list_id = VS.list_id, @zaw_id = Z.zaw_id,@dane = (VS.kart_imie + ' ' + VS.kart_nazwisko + ' kart_id =' + cast(Z.kartoteka_id as varchar) ) 
 from participant.VStartingLists VS
inner join participant.Zawodnik Z on Z.list_id = VS.list_id 
 where kartoteka_id = @kart_id 
select @dys_opis = dys_wartosc from Dystans where dys_id = @dys_id

if(@list_id < 0)
begin
	update kartoteka2 set dys_id = @dys_id where kart_id = @kart_id
	declare @info1 varchar(200)
	set @info1 =  'nieprzypisana lista startowa ' + @dane + ' ' + @dys_opis + ' -> zawodnik nie ma grupy startowej'
	exec dbo.pAddInfoError @info1,'zmiana dystansu '
	return 
end

if(@dys_id > 0)
begin

	update participant.Zawodnik set list_id = null where zaw_id = @zaw_id
	update participant.Start_List set list_ilosc = (select list_ilosc from participant.Start_List where list_id = @list_id) - 1 where list_id = @list_id
	update kartoteka2 set dys_id = @dys_id where kart_id = @kart_id

	exec participant.pPolaczZawodnikow_z_Listami
	declare @info varchar(200)
	set @info =  'zmiana dystansu, usunioecie z dotychczasowej grupy startowej ' + @dane + ' nowy dys:' + @dys_opis + ' gr_s' + CAST(@list_id as varchar)
	exec dbo.pAddInfoError @info,'zmiana dystansu i grupy startowej'
	 select K2.kart_imie,K2.kart_nazwisko,K2.kart_email from participant.zawodnik Z
	inner join dbo.kartoteka2 K2 on K2.kart_id = Z.kartoteka_id
	 where Z.zaw_aktywny = 1 and Z.list_id is null ;
end
else
begin
	declare @info2 varchar(200)
	set @info2 =  'błędny dystans ' + @dane + ' nowy dystans: ' + @dys_opis
	exec dbo.pAddInfoError @info2,'zmiana dystansu i grupy startowej'
end

end
GO
/****** Object:  StoredProcedure [participant].[pCreateEmptyStartList]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- procedura tworzy puste listy startowe ilosc zalezna
-- od ilosc aktywnych zawodnikow majacych polaczenie
-- z numerem, czasem i wynikami
--trzeba zabezpieczyc sie przed ciaglym dodawaniem list
--czyli np przypadkowe uruchomienie
--najlepiej sprawdzic czy listy istnieja i sa puste lub pelne
--nie jest wziete pod uwage jeszcze dystanse przy dodawaniu list trzeba
--by podzial zrobic na zwodnikow z odpowiendimi dystansami
-- i dla nich robic podzial list
-- usunołem jedna linijke taka jak byla w funkcji
-- czemu to trza sie pytac autora czyli mnie
--13.02.2017
--zmian algorytmu generowania list startowych, teraz generuje
--z wpisaniem dystansu
--17.03.2017 - dodanie warunku pobierajego tylko zwodnikow ktorzy nie sa na zadnej liscie
--18.05.2018 - dodanie nowego dystansu w while
--19.03.2019 - dodanie dystansu w nazwie listy
-- =============================================
CREATE PROCEDURE [participant].[pCreateEmptyStartList]
AS
BEGIN
declare @ilosc int
declare @wynik int = 0
declare @i int = 1
declare @dys varchar(10)
declare @j int = 1

while @i <= 10
begin

	
	select @wynik = dbo.fLiczIloscList(count(Z.zaw_id))
	 from participant.zawodnik Z
	 inner join dbo.kartoteka2 K2 on K2.kart_id = Z.kartoteka_id
	where
		K2.dys_id = @i and Z.list_id is null
	group by K2.dys_id

	while (@j <= @wynik)
	begin
			select @dys = dys_wartosc  from dbo.Dystans where dys_id = @i
		 insert into participant.Start_List
         (list_nazwa,list_iloscMaks,list_ilosc,list_data,list_zamknieta,dys_id,list_start)
          values
		  ('numer' + cast(@j as varchar) + '_' + @dys,15,0,GETDATE(),0,@i,0)
          set @j = @j + 1
	end
	set @i = @i + 1 
	set @j = 1
end 


END

GO
/****** Object:  StoredProcedure [participant].[pDodajZawodnikaDoListyNew]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [participant].[pDodajZawodnikaDoListyNew]
(
	@imie varchar(50),
	@nazwisko varchar(50),
	@email varchar(50),
	@komunikat varchar(50) output
)
as
begin
	declare @idZaw int
	declare @idDystans int
	declare @idListy int
	declare @idListyZaw int
	declare @ilosc int
	declare @kart_id int
	--declare @komunikat varchar(50)
	select @idDystans = dys_id, @kart_id = kart_id from kartoteka2 
	where kart_imie = @imie and kart_nazwisko = @nazwisko and kart_email = @email
	
	if(@kart_id = 0 or @kart_id = null)
	begin
		set @komunikat = 'brak zawodnika w kartotece'
		exec dbo.pAddInfoError @komunikat,'pDodajZawodnikaDoListy'
		return 0
	end

	if(@idDystans = 0 or @idDystans = null)
	begin
		set @komunikat = 'dystans nie przypisany do zawodnika'
		exec dbo.pAddInfoError @komunikat,'pDodajZawodnikaDoListy'
		return 0
	end

	select @idZaw = zaw_id, @idListyZaw = list_id from participant.Zawodnik where kartoteka_id = @kart_id

	if(@idZaw > 0)
	begin
		if(@idListyZaw is null)
		begin
			if(@idDystans > 0)
			begin
				select Top(1) @idListy = list_id from participant.Start_List
				where dys_id = @idDystans and list_zamknieta = 0 and list_ilosc < 13
				if(@idListy > 0)
				begin
					select @ilosc = list_ilosc  from participant.Start_List where list_id = @idListy

					update participant.Zawodnik set list_id = @idListy where zaw_id = @idZaw

					update participant.Start_List set list_ilosc = @ilosc + 1 where list_id = @idListy

					select @ilosc = list_ilosc  from participant.Start_List where list_id = @idListy
					--po dodaniu zawodnika do listy ilosc miejsc wzrosla do 15
					if(@ilosc >= 13)
					begin
						declare @dys2 varchar(10)
						select @dys2 = dys_wartosc  from dbo.Dystans where dys_id = @idDystans

						update participant.Start_List set list_zamknieta = 1 where list_id = @idListy
						INSERT INTO [participant].[Start_List]
							([list_nazwa],[list_iloscMaks],[list_ilosc],[list_data],[list_czas],[list_zamknieta],[dys_id],[list_start])
						VALUES
						   ('nazwa' + @dys2,15,0,cast(GETDATE() as date), GETDATE(),0,@idDystans,0) 
					end
				end
				else
				begin
					--dodaje nowa liste
					select Top(1) @idListy = list_id from participant.Start_List
					where dys_id = @idDystans and list_ilosc = 13 
					if(@idListy > 0)
					begin
						update participant.Start_List set list_zamknieta = 1 where list_id = @idListy
						INSERT INTO participant.Start_List
							([list_nazwa],[list_iloscMaks],[list_ilosc],[list_data],[list_czas],[list_zamknieta],[dys_id],[list_start])
						VALUES
						   ('nazwa',15,0,cast(GETDATE() as date),GETDATE(),0,@idDystans,0) 
					end
					else
					begin
						declare @dys varchar(10)
						select @dys = dys_wartosc  from dbo.Dystans where dys_id = @idDystans
						insert into participant.Start_List
						 (list_nazwa,list_iloscMaks,list_ilosc,list_data,list_zamknieta,dys_id,list_start)
						  values
						  ('numer 1'  + '_' + @dys,15,0,GETDATE(),0,@idDystans,0)
						set @komunikat = 'utworzono dodatkowa liste dystans =' + @dys
						exec dbo.pAddInfoError @komunikat,'pDodajZawodnikaDoListy'
					end			
				end	
			end
			else
			begin
				set @komunikat = 'brak dystansu'
				exec dbo.pAddInfoError @komunikat,'pDodajZawodnikaDoListy'
			end
		end
		else
		begin
			set @komunikat = 'zawodnik przypisany do listy: ' + cast(@idListyZaw as varchar)
			exec dbo.pAddInfoError @komunikat,'pDodajZawodnikaDoListy'
		end
	end
	else
	begin
		set @komunikat = 'Brak zawodnika '
		exec dbo.pAddInfoError @komunikat,'pDodajZawodnikaDoListy'
	end
end
GO
/****** Object:  StoredProcedure [participant].[pInsertKartotekaIdToZawodnik]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [participant].[pInsertKartotekaIdToZawodnik]
as 
begin


 insert into participant.Zawodnik (kartoteka_id,zaw_aktywny)
select kart_id,1 from kartoteka2 where kart_wpis_oplata = 1 and kart_wpis_rejestacja = 1 and kart_wpis_rezerwowa = 1;
 
update kartoteka2 set
	kart_wpis_rezerwowa = 0
where kart_wpis_oplata = 1 and kart_wpis_rejestacja = 1 and kart_wpis_rezerwowa = 1

 
end
GO
/****** Object:  StoredProcedure [participant].[pInsertTime_Register]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [participant].[pInsertTime_Register](
@rejestracja datetime,
@zaw_id int,
@licznik int
)
as
begin
	INSERT INTO [participant].[Time_Registration]
           ([time_registration]
           ,[zaw_id]
           ,[time_counter])
     VALUES
           (@rejestracja,@zaw_id,@licznik)
end

GO
/****** Object:  StoredProcedure [participant].[pJoinZawodnikAndTagNumber]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [participant].[pJoinZawodnikAndTagNumber]
as 
begin
declare @info varchar(50)
Declare @zaw_id int; -- zmienna do wczytywania kolumny z cursora
Declare @tag_id int
Declare c1 Cursor For
	select zaw_id,tag_id from participant.Zawodnik
where 
	zaw_aktywny = 1 and tag_id is null
Open c1; --> Otwarcie
Fetch Next From c1 Into @zaw_id, @tag_id; -- Pobranie z wiersza cursora do zmiennej
While @@FETCH_STATUS = 0 -- test końca kursora
Begin
    UPDATE [participant].Zawodnik
		SET 
			tag_id =  (
						select top 1 TN2.tag_id from participant.Tag_Number TN2 
						left join participant.Zawodnik ZP on ZP.tag_id = TN2.tag_id
						where
							ZP.tag_id is null 
					  )
		from [participant].Tag_Number TG
		where
			zaw_id = (select top 1 ZZ.zaw_id from participant.Zawodnik ZZ where ZZ.tag_id is null)
			 and Zawodnik.tag_id is null
	set @info = 'zawodnik numer : ' +cast(@zaw_id as varchar) + ' polaczenie zawodnika z numerem'
	exec dbo.pAddInfoError @info,'pJoinZawodnikAndTagNumber'

    Fetch Next From c1 Into @zaw_id,@tag_id; --kolejne czytanie
End
Close c1; -- zamknięcie ( do tej chwili kursor może być obracany )
DeAllocate c1; -- zwolnienie cursora !!!

end
GO
/****** Object:  StoredProcedure [participant].[pPolaczZawodnikow_z_Listami]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Batch submitted through debugger: SQLQuery19.sql|7|0|C:\Users\M679F~1.JUR\AppData\Local\Temp\~vs5BEB.sql
-- cursor ktory laczy zawodnika z lista
--21.02.2019 - nowa baza, select z kartoteki i zawodnika
--19.03.2019 - blad w cursorze select imie, imie, email, 
--			 - poprawiona na imie , nazwisko, email
-- =============================================
CREATE PROCEDURE [participant].[pPolaczZawodnikow_z_Listami]
AS
BEGIN
	declare @dane varchar(150)
	Declare @imie varchar(50); -- zmienna do wczytywania kolumny z cursora
	Declare @nazwisko varchar(50)
	Declare @email varchar(50)
Declare c1 Cursor For
    select K2.kart_imie,K2.kart_nazwisko,K2.kart_email from participant.zawodnik Z
	inner join dbo.kartoteka2 K2 on K2.kart_id = Z.kartoteka_id
	 where Z.zaw_aktywny = 1 and Z.list_id is null ;
Open c1; --> Otwarcie
Fetch Next From c1 Into @imie,@nazwisko,@email; -- Pobranie z wiersza cursora do zmiennej
While @@FETCH_STATUS = 0 -- test końca kursora
Begin
    exec participant.pDodajZawodnikaDoListyNew @imie,@nazwisko,@email,null
	set @dane = @imie + '' + @nazwisko + ' ' + @email
	exec dbo.pAddInfoError @dane,'pPolaczZawodnikow_z_Listami'
    Fetch Next From c1 Into @imie,@nazwisko,@email; --kolejne czytanie
End
Close c1; -- zamknięcie ( do tej chwili kursor może być obracany )
DeAllocate c1; -- zwolnienie cursora !!!
END
GO
/****** Object:  StoredProcedure [participant].[pStartParticipantFromList]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [participant].[pStartParticipantFromList](
@list_id int
)
as
begin
	

	Declare @zaw_id int; -- zmienna do wczytywania kolumny z cursora
	Declare @rejestracja datetime 
	Declare c1 Cursor For

		select  zaw_id,getdate() as rejestracja from participant.Zawodnik Z
		inner join participant.Start_List SL on SL.list_id = Z.list_id
		 where Z.list_id = @list_id and Z.zaw_aktywny = 1 and SL.list_start = 0
	
	Open c1; --> Otwarci
	 Fetch Next From c1 Into @zaw_id,@rejestracja; -- Pobranie z wiersza cursora do zmiennej

	While @@FETCH_STATUS = 0 -- test końca kursora
	Begin
		exec  participant.pInsertTime_Register @rejestracja,@zaw_id,1 
		Fetch Next From c1 Into @zaw_id,@rejestracja; --kolejne czytanie
	End
	Close c1; -- zamknięcie ( do tej chwili kursor może być obracany )
	DeAllocate c1; -- zwolnienie cursora !!!!
	
	select TR.zaw_id from Time_Registration TR 
	inner join Zawodnik Z on Z.zaw_id = TR.zaw_id
	where Z.list_id = @list_id

	update participant.Start_List set list_start = 1 where list_id = @list_id
end
GO
/****** Object:  StoredProcedure [participant].[RegistrationTimeAndCheck]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- rejestracja czasu
CREATE procedure [participant].[RegistrationTimeAndCheck](
@zaw_id int,
@rejestracja datetime
)
as
begin
	--declare @zaw_id int = 1 --testy
	declare @iloscRejestracji int
	declare @odbicie datetime
	--declare @rejestracja datetime = '2018-09-05 17:05:00' --testy
	declare @roznicaCzasu int
	declare @licznik int
	declare @resultPeriod time
	--
	select @iloscRejestracji = count(time_id) from Time_Registration
	where zaw_id = @zaw_id

	if(@iloscRejestracji > 0)
	begin
		   select top 1 @odbicie = time_registration from Time_Registration
	where zaw_id = @zaw_id order by time_registration desc
		   select @roznicaCzasu = DATEDIFF(minute,@odbicie,@rejestracja)
		   if( @roznicaCzasu > 30 )
		   begin
					 --mozliwosc inserta
				select @licznik = time_counter from Time_Registration
				where zaw_id = @zaw_id
				set @licznik = @licznik + 1

				INSERT INTO [participant].[Time_Registration]
				   ([time_registration],[time_counter],[zaw_id])
				VALUES
				   (@rejestracja,@licznik,@zaw_id)
						print 'czas zarejestrowany'

				--insert do tabeli z wynikami
				select @resultPeriod = [participant].[fTimeSegment](@odbicie,@rejestracja)
				insert into [participant].[Result]
					([result_time],[zaw_id])
				values
					(@resultPeriod,@zaw_id)
				print 'odcinek czasu w tabeli result'
		   end
		   else
		   begin
				 print 'brak mozliwosci odbicia - limit czasu'
		   end
	end
	else
	begin
	--pierwsza rejestracja - start
		   INSERT INTO [participant].[Time_Registration]
			   ([time_registration],[time_counter],[zaw_id])
		 VALUES
			   (GETDATE(),1,@zaw_id)

		   print 'start zawodnika'
	end
end



GO
/****** Object:  StoredProcedure [participant].[RegistrationTimeAndCheckWithTagNumber]    Script Date: 2019-07-13 23:07:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- rejestracja czasu
-- dodanie wyszukiwania po numerze dyskietki 
CREATE procedure [participant].[RegistrationTimeAndCheckWithTagNumber](
@tagNumber varchar(20)
)
as
begin
	--declare @zaw_id int = 1 --testy
	declare @iloscRejestracji int
	declare @odbicie datetime
	--declare @rejestracja datetime = '2018-09-05 17:05:00' --testy
	declare @roznicaCzasu int
	declare @licznik int
	declare @resultPeriod time
	declare @zaw_id int
	declare @tag_id int
	declare @rejestracja datetime
	--
	select @tag_id = tag_id from participant.Tag_Number where tag_IdNumber = @tagNumber
	select @zaw_id = zaw_id from participant.Zawodnik where tag_id = @tag_id
	if(@zaw_id > 0)
	begin
		--
		set @rejestracja = getdate()
		--
		select @iloscRejestracji = count(time_id) from participant.Time_Registration
		where zaw_id = @zaw_id

		if(@iloscRejestracji > 0)
		begin
			   select top 1 @odbicie = time_registration from participant.Time_Registration
					where zaw_id = @zaw_id order by time_registration desc

			   select @roznicaCzasu = DATEDIFF(minute,@odbicie,@rejestracja)
			   if( @roznicaCzasu > 30 )
			   begin
					--insert to table time registration
					select @licznik = time_counter from participant.Time_Registration
					where zaw_id = @zaw_id
					set @licznik = @licznik + 1
					exec [participant].[pInsertTime_Register] @rejestracja,@zaw_id,@licznik
			   end
			   else
			   begin
					declare @tresc varchar(200)
					set @tresc  = 'brak mozliwosci odbicia - limit czasu' + CAST(@zaw_id as varchar)
					exec dbo.pAddInfoError	'RegistrationTimeAndCheckWithTagNumber', @tresc
			   end
		end
		else
		begin
			--first registration start
			declare @Start_odbicie datetime =  GETDATE()
			--exec [participant].[pInsertTime_Register] @Start_odbicie,@zaw_id,@licznik
			declare @tresc2 varchar(200)
			set @tresc2  = 'test dyskietki' + CAST(@zaw_id as varchar)
			exec dbo.pAddInfoError	'RegistrationTimeAndCheckWithTagNumber',  @tresc2
		end
	end
	else
	begin
		 exec dbo.pAddInfoError 'RegistrationTimeAndCheckWithTagNumber','karta nie przypisana do zawodnika'
	end
	
	
end
GO
