CREATE OR ALTER PROCEDURE sp_getTableSizes
    @DatabaseName NVARCHAR(128)
AS
BEGIN
    -- Validate the input database name
    IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = @DatabaseName)
    BEGIN
        RAISERROR('Invalid database name.', 16, 1);
        RETURN;
    END;

    -- Declare a variable to hold the dynamic SQL query
    DECLARE @SQL NVARCHAR(MAX);

    -- Construct the dynamic SQL query
    SET @SQL = '
    USE [' + @DatabaseName + '];
    SELECT
        DB_NAME() AS DatabaseName,
        s.name AS SchemaName,
        t.name AS TableName,
        p.rows AS RowCount,
        CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00 / 1024.00), 2) AS DECIMAL(10,2)) AS TotalSpaceGB,
        CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00 / 1024.00), 2) AS DECIMAL(10,2)) AS UsedSpaceGB,
        CAST(ROUND(((SUM(a.data_pages) * 8) / 1024.00 / 1024.00), 2) AS DECIMAL(10,2)) AS DataSpaceGB,
        t.create_date AS DateCreated,
        t.modify_date AS LastModified
    FROM sys.tables t
    INNER JOIN sys.indexes i ON t.object_id = i.object_id
    INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
    INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
    GROUP BY t.name, s.name, t.create_date, t.modify_date, p.rows
    ORDER BY TotalSpaceGB DESC;';

    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL;
END;
GO
