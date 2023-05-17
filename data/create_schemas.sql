USE IDI;
GO

DROP TABLE IF EXISTS [ir_clean].[ird_ems];
GO

DROP SCHEMA IF EXISTS [ir_clean];
GO

CREATE SCHEMA [ir_clean] AUTHORIZATION admin
  CREATE TABLE [ird_ems] (
    snz_uid INT NOT NULL,
    snz_ird_uid INT NOT NULL PRIMARY KEY
  )
  GRANT SELECT ON [ird_ems] TO terourou;
GO

-- insert into ird_ems from "/data/Final datasets/[ir_clean]_[ird_ems].csv"
BULK INSERT [IDI].[ir_clean].[ird_ems]
FROM '/data/Final datasets/[ir_clean]_[ird_ems].csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2
);
GO

SELECT TOP 10 *
FROM [IDI].[ir_clean].[ird_ems];
GO
