USE [1208_MaratonMszana]
GO
/****** Object:  UserDefinedFunction [dbo].[fLiczIloscList]    Script Date: 2019-07-13 23:07:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[fLiczIloscList]
(
	@ilosc int
)
RETURNS int
AS
BEGIN
	declare @wynik int
	select @wynik = cast(ceiling(cast(@ilosc as real) / 15) as int);
	-- Return the result of the function
	RETURN @wynik
END
GO
/****** Object:  UserDefinedFunction [participant].[fCalculateDistanse]    Script Date: 2019-07-13 23:07:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [participant].[fCalculateDistanse]
(
	@param1 int
)
RETURNS varchar(10)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @result varchar(10) = 'brak'

	if(@param1 = 2 )
		return '50 km'
	if(@param1 = 3)
		return '100 km'
	if(@param1 = 4)
		return '150 km'
	if(@param1 = 5)
		return '200 km'
	if(@param1 = 7)
		return '300 km'
	if(@param1 = 9)
		return '400 km'
	if(@param1 = 11)
		return '500 km'
	if(@param1 = 13)
		return '600 km'
	if(@param1 = 15)
		return '700 km'
	if(@param1 = 16)
		return '750 km'
	if(@param1 = 17)
		return '800 km'
	-- Return the result of the function
	RETURN @result

END
GO
/****** Object:  UserDefinedFunction [participant].[fSetNumberOfCheckPoint]    Script Date: 2019-07-13 23:07:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--set number of checkpoints in distances dependency
create FUNCTION [participant].[fSetNumberOfCheckPoint]
(
      @dys_id int
)
RETURNS int
AS
BEGIN
	declare	@result int = 0

		if( @dys_id = 1) begin set @result = 2 end  
		if( @dys_id = 2) begin set @result = 3 end
		if( @dys_id = 3) begin set @result = 4 end  
		if( @dys_id = 4) begin set @result = 5 end
		if( @dys_id = 5) begin set @result = 7 end  
		if( @dys_id = 6) begin set @result = 9 end
		if( @dys_id = 7) begin set @result = 11 end  
		if( @dys_id = 8) begin set @result = 13 end
		if( @dys_id = 9) begin set @result = 15 end  
		if( @dys_id = 10) begin set @result = 16 end
		if( @dys_id = 10) begin set @result = 17 end   
		return @result
END
GO
/****** Object:  UserDefinedFunction [participant].[fTimeSegment]    Script Date: 2019-07-13 23:07:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [participant].[fTimeSegment]
(
       @czas1 datetime,
       @czas2 datetime
)
RETURNS varchar(8)
AS
BEGIN
       declare @wynik varchar(8)
       declare @hh int
       declare @mm int
       declare @ss int
       select
             @hh = (DATEDIFF(SECOND, @czas1, @czas2))/3600,
             @mm = (DATEDIFF(second, @czas1, @czas2)%3600)/60,
             @ss = (DATEDIFF(SECOND, @czas1,@czas2)%3600)%60
       select
             @wynik = cast(@hh as varchar)
             + ':' + cast(@mm as varchar)
             + ':' + cast(@ss as varchar)
        RETURN @wynik
END
GO
