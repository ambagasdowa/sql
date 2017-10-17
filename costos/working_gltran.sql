-- ==================================================================================================================== --
-- ===========================    	             Prepare the Costos Web	             ================================== --
-- ==================================================================================================================== --
-- NOTE Example of the menu of selection
-- TODO --> OF	   select * from sistemas.dbo.mr_source_mains where "_key" = 'OF'

  select
       criteria.RowDetailID,criteria.RowLinkID,criteria.DisplayOrder
       ,criteria.Low as 'rangeaccounta',criteria.High as 'rangeaccountb'
       ,zero.Low as 'segmenta', zero.High as 'segmentb'
       ,'OF' as "_key"
  from
      ManagementReporter.dbo.ControlRowCriteria as criteria
  left join ManagementReporter.dbo.ControlRowCriteria as zero
  on
      zero.RowDetailID = criteria.RowDetailID
  and
      zero.DimensionCode = 'Segment_04'
  and
      zero.DisplayOrder = criteria.DisplayOrder
  where
      criteria.RowDetailID = (
            select ID from ManagementReporter.dbo.ControlRowDetail
            where RowFormatID = (select ID from ManagementReporter.dbo.ControlRowMaster where Name = 'Edoresv1.1')
            and RowCode = '734'
          )
  and
      criteria.DimensionCode = 'Natural'


  select * from sistemas.dbo.reporter_table_keys

  -- NOTE Report
  -- Search the id of the Report
  -- NOTE take the the ID by name and ID sets to RowFormatID
  -- NAMED main report names , select the id => RowFormatID
  select
           ( row_number() over(order by "ControlRowMaster".ID) ) as 'index_id'
          ,"ControlRowMaster".ID,"ControlRowMaster".name,"ControlRowMaster".Description
  from
          "ManagementReporter"."dbo".ControlRowMaster as "ControlRowMaster"
  --  NOTE Subreport
  --  TODO search the id of the rows
  --  NOTE < ID is needed for a selection limited by RowCode>

  select
        ID,RowFormatID,RowNumber,RowCode,Description,RelatedRows
        ,case
          when OverrideIndent = 3
            then '1'
            else '0'
          end as 'type_of_block'
  from ManagementReporter.dbo.ControlRowDetail
  where RowFormatID = '92F18DAA-7CE4-45D1-9E29-5A4CD1A82C7D' order by RowNumber


  -- NOTE when select the needed report can get the id as ControlRowDetailId this is needed for get the accounts

  select top(100)
    convert( nvarchar(36),ID ) as 'ControlRowDetailId',RowFormatID,RowNumber,RowCode,Description,RelatedRows
    ,case
      when OverrideIndent = 3
        then '1'
        else '0'
     end as 'type_of_block'
  from ManagementReporter.dbo.ControlRowDetail
  where RowFormatID = '92F18DAA-7CE4-45D1-9E29-5A4CD1A82C7D'
  and RowCode = '734'

-- for print into php
-- convert(nvarchar(36), requestID) as requestID
