# table-size-analyzer

# SQL Table Size Analysis Tool

This repository contains a SQL Server stored procedure that provides detailed size analysis for all tables in a specified database. The procedure `sp_getTableSizes` generates comprehensive information about table sizes, including space usage, row counts, and temporal metadata.

## Features

- Detailed size analysis for all tables in the specified database
- Space usage metrics in gigabytes (GB)
- Row count for each table
- Creation and modification dates
- Schema-aware organization
- Results sorted by total space usage

## Requirements

- SQL Server 2016 or later
- Appropriate permissions to:
  - Execute stored procedures
  - Access system views
  - Read database metadata

## Installation

1. Open SQL Server Management Studio (SSMS) or your preferred SQL client
2. Connect to your SQL Server instance
3. Execute the script `get_table_sizes.sql` to create or update the stored procedure

## Usage

```sql
EXEC sp_getTableSizes @DatabaseName = 'YourDatabaseName';
```

### Parameters

- `@DatabaseName` (NVARCHAR(128)): The name of the database you want to analyze

### Output Columns

| Column Name    | Description                                  | Data Type      |
|---------------|----------------------------------------------|----------------|
| DatabaseName  | Name of the analyzed database                | NVARCHAR       |
| SchemaName    | Schema name containing the table             | NVARCHAR       |
| TableName     | Name of the table                           | NVARCHAR       |
| RowCount      | Number of rows in the table                 | BIGINT         |
| TotalSpaceGB  | Total space allocated (including indexes)    | DECIMAL(10,2)  |
| UsedSpaceGB   | Actually used space                         | DECIMAL(10,2)  |
| DataSpaceGB   | Space used by data (excluding indexes)      | DECIMAL(10,2)  |
| DateCreated   | Table creation date                         | DATETIME       |
| LastModified  | Last modification date                      | DATETIME       |

## Error Handling

The procedure includes basic error handling:
- Validates the input database name
- Raises an error if an invalid database name is provided

## Example

```sql
-- Get size information for the AdventureWorks database
EXEC sp_getTableSizes @DatabaseName = 'AdventureWorks';
```

## Performance Considerations

- The procedure reads system views and metadata, which is generally lightweight
- For very large databases with many tables, the execution might take longer
- Results are ordered by total space usage to highlight the largest tables first
