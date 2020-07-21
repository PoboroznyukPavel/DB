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
-- Author:		GNK+AS
-- Create date: 30.05.2020
-- Description:	Что то там про суррогатные ключи
-- =============================================
CREATE TRIGGER dbo.SurrKey 
   ON  dbo.Medicine 
   AFTER INSERT,UPDATE
AS 
BEGIN
	DECLARE @newID int

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here

	Select @newID = max(ID_M) from Medicine
	set @newID = @newID + 1
	IF NOT((select ID_M from inserted) = @newID)
	Update Medicine set ID_M = @newID where ID_M = (select ID_M from inserted)

END
GO
