USE [integraapp]
GO
/****** Object:  Trigger [dbo].[ZProveedor_fromVendor_Add]    Script Date: 6/15/2017 4:49:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Trigger [dbo].[ZProveedor_fromVendor_Add]
       On [dbo].[Vendor]
       After Insert
As

-- Desa vSL2011, DSAN, Poncho, Abril del 2013, eliminar uso de REFACC,
-- Desa vSL2011, DSAN, Poncho, Marzo del 2013,

  Declare @Vendor_ClassID  Char(10)
  Declare @Vendor_State    Char(3)
  Declare @Vendor_Status   Char(1)
  Declare @Vendor_TaxID00  Char(10)
  Declare @Vendor_Terms    Char(2)
  Declare @Vendor_VendID   Char(15)
  Set @Vendor_ClassID  = ''
  Set @Vendor_State    = ''
  Set @Vendor_Status   = ''
  Set @Vendor_TaxID00  = ''
  Set @Vendor_Terms    = ''
  Set @Vendor_VendID   = ''
  
  Select  @Vendor_ClassID  = ISNULL(ClassID, ''),
		  @Vendor_State    = ISNULL(State, ''),
		  @Vendor_Status   = ISNULL(Status, ''),
		  @Vendor_TaxID00  = ISNULL(TaxID00, ''),
		  @Vendor_Terms    = ISNULL(Terms, ''),
		  @Vendor_VendID   = ISNULL(VendID, '')
    From Inserted  -- Vendor,
    
  If @Vendor_Status = 'A'  -- Status Proveedor,
  Begin --(Status: Activo),
    If LTRIM(RTRIM(@Vendor_ClassID)) = 'CASETA' Or  -- Tipo Proveedor,
       LTRIM(RTRIM(@Vendor_ClassID)) = 'DISGAS' Or
       LTRIM(RTRIM(@Vendor_ClassID)) = 'MANEXT'
--     LTRIM(RTRIM(@Vendor_ClassID)) = 'REFACC'
    Begin --(ClassID: DISGAS, CASETA, MANEXT, REFACC),
      
      Declare @XVendor_LongName  Char(100)
      Set @XVendor_LongName = ''
      
      Select @XVendor_LongName = ISNULL(LongName, '')
        From XVendor
        Where VendID = @Vendor_VendID
      
      Declare @State_Descr  Char(30)
      Set @State_Descr = ''
      
      Select @State_Descr = ISNULL(Descr, '')
        From State
        Where StateProvID = @Vendor_State
      
      Declare @SalesTax_TaxRate00  Float
      Set @SalesTax_TaxRate00 = 0.00
      
      Select @SalesTax_TaxRate00 = ISNULL(TaxRate, 0.00)
        From SalesTax
        Where TaxID = @Vendor_TaxID00
      
      Declare @Terms_DueIntrv  Smallint
      Set @Terms_DueIntrv = 0
      
      Select @Terms_DueIntrv = ISNULL(DueIntrv, 0)
        From Terms
        Where TermsID = @Vendor_Terms
      
      Declare @VendClass_Descr  Char(30)
      Set @VendClass_Descr = ''
      
      Select @VendClass_Descr = ISNULL(Descr, '')
        From VendClass
        Where ClassID = @Vendor_ClassID
      
    -- para Compañía "bonampakdb",
    
      Insert Into ZProveedor
        Select
            -- Identity Field,			-- id_zProveedor,	int,
               ISNULL(Name, ''),		-- pr_nombre,		varchar(60),
               @XVendor_LongName,		-- nombre,			varchar(100),
               'bonampakdb',			-- Cpny,			varchar(30),
               ISNULL(VendID, ''),		-- rfc,				varchar(15),
               ISNULL(Attn, ''),		-- nom_contacto,	varchar(30),
               ISNULL(Addr1, ''),		-- dir1,			varchar(60),
               ISNULL(Addr2, ''),		-- dir2,			varchar(60),
               ISNULL(City, ''),		-- ciudad,			varchar(30),
               @State_Descr,			-- estado,			varchar(30),
               ISNULL(Zip, ''),			-- CP,				varchar(10),
               CASE WHEN LEN(LTRIM(RTRIM(ISNULL(Phone, '')))) >= 20
                 THEN SUBSTRING(LTRIM(Phone), 1, 20)
                 ELSE SUBSTRING(LTRIM(Phone), 1, LEN(LTRIM(RTRIM(ISNULL(Phone, '')))))
               END,						-- Tel,				varchar(20),
               CASE WHEN LEN(LTRIM(RTRIM(ISNULL(Fax, '')))) >= 20
                 THEN SUBSTRING(LTRIM(Fax), 1, 20)
                 ELSE SUBSTRING(LTRIM(Fax), 1, LEN(LTRIM(RTRIM(ISNULL(Fax, '')))))
               END,						-- Fax,				varchar(20),
               CONVERT(Float, ROUND(@SalesTax_TaxRate00 * 1.000000, 6)),	-- porc_imp,		float,
               'SL',					-- sist_origen,		varchar(2),
               ISNULL(EMailAddr, ''),	-- dir_correo,		varchar(80),
               CONVERT(Float, @Terms_DueIntrv),								-- dias_creditos,	float,
             --@VendClass_Descr,		-- tipo_proveedor,	varchar(30),
               @Vendor_ClassID,			-- tipo_proveedor,	varchar(30),
               @Vendor_Status,			-- estatus_prov,	varchar(1),
               0,						-- estatus,			int, 
               'A ',  -- Alta,			-- tmov,			char(2),
               getdate(),				-- fecmovSL			smalldatetime,
               ' '						-- fecmovLIS		smalldatetime,
          From Inserted  --Vendor,
      
    -- para Compañía "macuspanadb",
    
      Insert Into ZProveedor
        Select
            -- Identity Field,			-- id_zProveedor,	int,
               ISNULL(Name, ''),		-- pr_nombre,		varchar(60),
               @XVendor_LongName,		-- nombre,			varchar(100),
               'macuspanadb',			-- Cpny,			varchar(30),
               ISNULL(VendID, ''),		-- rfc,				varchar(15),
               ISNULL(Attn, ''),		-- nom_contacto,	varchar(30),
               ISNULL(Addr1, ''),		-- dir1,			varchar(60),
               ISNULL(Addr2, ''),		-- dir2,			varchar(60),
               ISNULL(City, ''),		-- ciudad,			varchar(30),
               @State_Descr,			-- estado,			varchar(30),
               ISNULL(Zip, ''),			-- CP,				varchar(10),
               CASE WHEN LEN(LTRIM(RTRIM(ISNULL(Phone, '')))) >= 20
                 THEN SUBSTRING(LTRIM(Phone), 1, 20)
                 ELSE SUBSTRING(LTRIM(Phone), 1, LEN(LTRIM(RTRIM(ISNULL(Phone, '')))))
               END,						-- Tel,				varchar(20),
               CASE WHEN LEN(LTRIM(RTRIM(ISNULL(Fax, '')))) >= 20
                 THEN SUBSTRING(LTRIM(Fax), 1, 20)
                 ELSE SUBSTRING(LTRIM(Fax), 1, LEN(LTRIM(RTRIM(ISNULL(Fax, '')))))
               END,						-- Fax,				varchar(20),
               CONVERT(Float, ROUND(@SalesTax_TaxRate00 * 1.000000, 6)),	-- porc_imp,		float,
               'SL',					-- sist_origen,		varchar(2),
               ISNULL(EMailAddr, ''),	-- dir_correo,		varchar(80),
               CONVERT(Float, @Terms_DueIntrv),								-- dias_creditos,	float,
             --@VendClass_Descr,		-- tipo_proveedor,	varchar(30),
               @Vendor_ClassID,			-- tipo_proveedor,	varchar(30),
               @Vendor_Status,			-- estatus_prov,	varchar(1),
               0,						-- estatus,			int, 
               'A ',  -- Alta,			-- tmov,			char(2),
               getdate(),				-- fecmovSL			smalldatetime,
               ' '						-- fecmovLIS		smalldatetime,
          From Inserted  --Vendor,
      
    -- para Compañía "tespecializadadb",
    
      Insert Into ZProveedor
        Select
            -- Identity Field,			-- id_zProveedor,	int,
               ISNULL(Name, ''),		-- pr_nombre,		varchar(60),
               @XVendor_LongName,		-- nombre,			varchar(100),
               'tespecializadadb',		-- Cpny,			varchar(30),
               ISNULL(VendID, ''),		-- rfc,				varchar(15),
               ISNULL(Attn, ''),		-- nom_contacto,	varchar(30),
               ISNULL(Addr1, ''),		-- dir1,			varchar(60),
               ISNULL(Addr2, ''),		-- dir2,			varchar(60),
               ISNULL(City, ''),		-- ciudad,			varchar(30),
               @State_Descr,			-- estado,			varchar(30),
               ISNULL(Zip, ''),			-- CP,				varchar(10),
               CASE WHEN LEN(LTRIM(RTRIM(ISNULL(Phone, '')))) >= 20
                 THEN SUBSTRING(LTRIM(Phone), 1, 20)
                 ELSE SUBSTRING(LTRIM(Phone), 1, LEN(LTRIM(RTRIM(ISNULL(Phone, '')))))
               END,						-- Tel,				varchar(20),
               CASE WHEN LEN(LTRIM(RTRIM(ISNULL(Fax, '')))) >= 20
                 THEN SUBSTRING(LTRIM(Fax), 1, 20)
                 ELSE SUBSTRING(LTRIM(Fax), 1, LEN(LTRIM(RTRIM(ISNULL(Fax, '')))))
               END,						-- Fax,				varchar(20),
               CONVERT(Float, ROUND(@SalesTax_TaxRate00 * 1.000000, 6)),	-- porc_imp,		float,
               'SL',					-- sist_origen,		varchar(2),
               ISNULL(EMailAddr, ''),	-- dir_correo,		varchar(80),
               CONVERT(Float, @Terms_DueIntrv),								-- dias_creditos,	float,
             --@VendClass_Descr,		-- tipo_proveedor,	varchar(30),
               @Vendor_ClassID,			-- tipo_proveedor,	varchar(30),
               @Vendor_Status,			-- estatus_prov,	varchar(1),
               0,						-- estatus,			int, 
               'A ',  -- Alta,			-- tmov,			char(2),
               getdate(),				-- fecmovSL			smalldatetime,
               ' '						-- fecmovLIS		smalldatetime,
          From Inserted  --Vendor,
      
    End --(ClassID),
  End --(Status),
