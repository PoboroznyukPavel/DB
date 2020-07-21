USE [3курс2семестрБД]
GO
/****** Object:  Trigger [dbo].[GenderRestriction]    Script Date: 30.05.2020 17:34:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		GnK+SA
-- Create date: 30.05.2020
-- Description:	Триггер, который выдаёт ошибку если при добавлении или изменении значений пол не будет женским или мужским
-- =============================================
ALTER TRIGGER [dbo].[GenderRestriction] 
   ON  [dbo].[Patient] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	Declare @NewS varchar(70) = (select Sex from inserted)

	IF (@NewS != 'ж') or (@NewS != 'м')
BEGIN
PRINT 'Пол должен быть либо м, либо ж'
ROLLBACK TRAN
END
END
