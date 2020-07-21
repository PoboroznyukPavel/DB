-- ================================================
-- Template generated from Template Explorer using:
-- Create Trigger (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- See additional Create Trigger templates for more
-- examples of different Trigger statements.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		GnK+SA
-- Create date: 30.05.2020
-- Description:	Триггер, который выдаёт ошибку если при добавлении или изменении значений пол не будет женским или мужским
-- =============================================
CREATE TRIGGER dbo.GenderRestriction 
   ON  dbo.Patient 
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
	Declare @NewS varchar(70) = (select Sex from inserted)

	IF (@NewS != 'ж') or (@NewS != 'м')
Update Patient SET Sex = 'м' where ID_P = (select ID_P from inserted)
END
GO
