USE [1208_MaratonMszana]
GO
/****** Object:  View [participant].[vResultList]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [participant].[vResultList]
as
with source as
(
select K2.kart_id, D.dys_id , Z.zaw_id, TG.tag_id,R.time_id,
K2.kart_nazwisko,K2.kart_imie, D.dys_wartosc,TG.tag_LabelNumber,R.time_registration,
(K2.kart_nazwisko + ' ' + K2.kart_imie +' '+ D.dys_wartosc + ' ' 
+ Cast(TG.tag_LabelNumber as varchar)) as dane
 from participant.Time_Registration R
inner join participant.Zawodnik Z on Z.zaw_id = R.zaw_id
inner join participant.Tag_Number TG on TG.tag_id = Z.tag_id
inner join dbo.kartoteka2 K2 on K2.kart_id = Z.kartoteka_id
inner join Dystans D on D.dys_id = K2.dys_id
),
TimeSum as
(
	select (select [participant].[fTimeSegment](MIN(time_registration),MAX(time_registration)))  as suma_czas,zaw_id,
			(select DATEDIFF(SECOND, MIN(time_registration), MAX(time_registration))) as sum_seconds
	from participant.Time_Registration 
	where 
		time_registration is not null
	group by zaw_id
),
countCheckPoints as
(
	select max(time_counter) as ilosc,zaw_id 
		from participant.Time_Registration 
	group by zaw_id
	having 
		 max(time_counter) > 0
)
select distinct S.kart_id,dys_id,tag_id,kart_nazwisko,S.zaw_id,kart_imie,dys_wartosc,dane,
TS.suma_czas, TS.sum_seconds, 0 as rzeczywistaIloscOdbic, S.tag_LabelNumber,CCP.ilosc as iloscOdbic,
participant.fCalculateDistanse(CCP.ilosc) as 'realDistance'
 from source S
inner join TimeSum TS on TS.zaw_id = S.zaw_id
inner join countCheckPoints CCP on CCP.zaw_id = S.zaw_id
GO
/****** Object:  View [marathonOffice].[vListParticipantsInOfficeRegisterCondition]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [marathonOffice].[vListParticipantsInOfficeRegisterCondition] as
select K2.kart_id,K2.kart_nazwisko, K2.kart_imie, K2.kart_email,K2.kart_dataUr,
	   D.dys_wartosc,TG.tag_LabelNumber,SL.list_nazwa,K2.kart_wpis_oplata,K2.kart_wpis_rezerwowa,
	   VRL.suma_czas,VRL.iloscOdbic,VRL.realDistance
 from kartoteka2 K2
inner join Dystans D on D.dys_id = K2.dys_id
left join participant.Zawodnik Z on Z.kartoteka_id = K2.kart_id
left join participant.Tag_Number TG on Z.tag_id = TG.tag_id
left join participant.Start_List SL on SL.list_id = Z.list_id
left join participant.vResultList VRL on VRL.kart_id = K2.kart_id
where 
	K2.kart_wpis_rejestacja = 1
GO
/****** Object:  View [participant].[VStartingLists]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [participant].[VStartingLists] 
as
with source as
(
  select SL.list_nazwa,SL.list_data, SL.list_czas,SL.list_ilosc, SL.list_id,
		K2.kart_nazwisko, K2.kart_imie,TN.tag_LabelNumber,D.dys_wartosc from participant.Start_List SL
  inner join dbo.Dystans D on D.dys_id = SL.dys_id
  inner join participant.Zawodnik Z on Z.list_id = SL.list_id
  inner join dbo.kartoteka2 K2 on K2.kart_id = Z.kartoteka_id
  inner join participant.Tag_Number TN on TN.tag_id = Z.tag_id
)
select ROW_NUMBER() over(partition by S.list_id order by S.kart_nazwisko) as Id, S.* from source S
GO
/****** Object:  View [participant].[VviewForStartParticipantFromList]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [participant].[VviewForStartParticipantFromList]
as
SELECT 
      V.list_id
	  ,V.dys_wartosc
     ,count(V.tag_LabelNumber) as ilosc 
	 ,SL.list_zamknieta
  FROM [1208_MaratonMszana].[participant].[VStartingLists] V
  inner join participant.Start_List SL on SL.list_id = V.list_id
  where 
		SL.list_start = 0 and SL.list_ilosc > 0
group by V.list_id,V.dys_wartosc ,SL.list_zamknieta
GO
/****** Object:  View [1208_Maraton].[vParticipantResult]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [1208_Maraton].[vParticipantResult]
as
select K2.kart_imie, k2.kart_nazwisko,d.dys_wartosc,R.result_time , TN.tag_LabelNumber, 
(k2.kart_nazwisko + K2.kart_imie  + d.dys_wartosc 
+ cast(R.result_time as varchar)+ cast(TN.tag_LabelNumber as varchar)) as dane  from participant.Result R
inner join participant.Zawodnik Z on Z.zaw_id = R.zaw_id
inner join kartoteka2 K2 on K2.kart_id = z.kartoteka_id
inner join Dystans D on D.dys_id = k2.kart_id
inner join participant.Tag_Number TN on TN.tag_id = Z.tag_id
GO
/****** Object:  View [marathonOffice].[ListForMarthonOfiice]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [marathonOffice].[ListForMarthonOfiice]
as
select Upper(K2.kart_imie) as Imie ,Upper(K2.kart_nazwisko) as nazwisko,isNULL(TN.tag_LabelNumber,1000) as numer,dys_wartosc, 
case
when K2.kart_wpis_oplata = 1 then 'opłacony'
when K2.kart_wpis_oplata is null then ' '
end 
as oplata 
from kartoteka2 K2
inner join Dystans D on D.dys_id = K2.dys_id
left join participant.Zawodnik Z on Z.kartoteka_id = K2.kart_id
left join participant.Tag_Number TN on TN.tag_id = Z.tag_id
where K2.kart_wpis_rejestacja = 1
GO
/****** Object:  View [participant].[ViewForStartedParticipant]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [participant].[ViewForStartedParticipant]
as
select Z.list_id, K2.kart_imie, K2.kart_nazwisko, TN.tag_LabelNumber, TR.time_registration, D.dys_wartosc
 from participant.Zawodnik Z
inner join kartoteka2 K2 on K2.kart_id = Z.kartoteka_id
inner join participant.Tag_Number TN on TN.tag_id = Z.tag_id
left join participant.Time_Registration TR on TR.zaw_id = Z.zaw_id
inner join Dystans D on K2.dys_id = D.dys_id
where 
TR.time_counter = 1
GO
/****** Object:  View [participant].[vParticipantResult]    Script Date: 2019-07-13 23:06:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [participant].[vParticipantResult]
as
select K2.kart_imie, k2.kart_nazwisko,d.dys_wartosc,R.result_time , TN.tag_LabelNumber, 
(k2.kart_nazwisko + K2.kart_imie  + d.dys_wartosc 
+ cast(R.result_time as varchar)+ cast(TN.tag_LabelNumber as varchar)) as dane  from participant.Result R
inner join participant.Zawodnik Z on Z.zaw_id = R.zaw_id
inner join kartoteka2 K2 on K2.kart_id = z.kartoteka_id
inner join Dystans D on D.dys_id = k2.kart_id
inner join participant.Tag_Number TN on TN.tag_id = Z.tag_id
GO
