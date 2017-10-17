--Adding a server for use with openquery



exec sp_dropserver 'LARSA\local'

-- exec sp_addserver  'Server',local

--name      |network_name                   |status                           |id   |collation_name |connect_timeout |query_timeout |
--------|-------------------------------|---------------------------------|-----|---------------|----------------|--------------|
--INTEGRABD |INTEGRABD                      |rpc,rpc out,use remote collation |0    |               |0               |0             |
--local     |                               |data access,use remote collation |1    |               |0               |0             |


exec sp_addlinkedserver
@server = 'local',
@srvproduct=N'',
@provider=N'SQLNCLI'


exec sp_helpserver