USE [QA]
GO
/****** Object:  StoredProcedure [dbo].[SalesBySubCategory]    Script Date: 2/8/2024 4:05:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SalesBySubCategory]
AS
BEGIN
SELECT SubCategory,SUM(StandardCost) AS TOTAL_COST
FROM [SALES].[Product]
GROUP BY Subcategory
END