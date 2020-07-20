:new.account_type in ( select ct_code_user from contract_types where contract_category=:table_name)

fixing_next_date > pack_install.get_reporting_date

value_date <= pack_install.get_reporting_date or (value_date > pack_install.get_reporting_date and balance=0)

((:new.coa_account_name = nvl(:old.coa_account_name,'fake') and :new.table_name = nvl(:old.table_name,'fake') and :new.contract_ref = nvl(:old.contract_ref,'fake')) or ((select /*+ FIRST_ROWS(1) */ instrument_type from coa_account where partition_key = :new.partition_key and coa_account_name = :new.coa_account_name and rownum<=1) = pack_coa.get_instrument_type (:new.partition_key_data, :new.table_name,:new.contract_ref)))

:new.name not in ('ASSETS_FILTER', 'LIABILITIES_FILTER') or ((select nvl(category, 'AE') from ae_alloc_set where set_name = :new.set_name) = 'AE' and  pack_utils.is_where_valid(v_table_name => 'AE_SR', v_where_clause => :new.value) = 'Y') or ((select nvl(category, 'NSFR') from ae_alloc_set where set_name = :new.set_name) = 'NSFR' and  pack_utils.is_where_valid(v_table_name => 'T_LSR', v_where_clause => :new.value) = 'Y')

:new.pldg_contract_type IS NULL OR (SELECT COUNT(1) FROM TABLE (pack_utils.str2table(:new.pldg_contract_type)) a WHERE NOT EXISTS (SELECT 1 FROM contract_types WHERE contract_category = :new.pldg_table_name AND :new.pldg_table_name != 'SECURITY_POSITIONS' AND ct_code_user = a.column_value UNION ALL SELECT 1 FROM contract_types WHERE contract_category IN ('BOND', 'EQUITY', 'COMMODITY', 'TRANCHE') AND :new.asst_table_name = 'SECURITY_POSITIONS')) = 0

NOT((SELECT case when bmx.amount_type='A' then 'A' else bmx.matrix_type end FROM behavior_factor_seg bfs, behavior_factor bf, behavior_matrix bmx WHERE bfs.factor_seg_id=:new.factor_seg_id1 and bfs.factor_id=bf.factor_id and bf.matrix_id=bmx.matrix_id) = 'P' AND (SELECT bm.model_type FROM behavior_factor_seg bfs, behavior_factor bf, behavior_matrix bmx, behavior_model bm where bfs.factor_seg_id=:new.factor_seg_id1 and bfs.factor_id=bf.factor_id and bf.matrix_id=bmx.matrix_id and bm.name = bmx.model_name) IN ('prepayment', 'runoff', 'facility_drawdown', 'facility_reimburse', 'facility_usage') AND :new.val NOT BETWEEN 0 AND 1)", "message"=>"The value for this type of MFBM must be >= 0.00 and <= 1.00

:new.value_from is null or 'T'=(select case when t.range_type='tenor' then is_valid_tenor(:new.value_from,'Y') else 'T' end from behavior_factor f join behavior_factor_tmplt t on f.factor_template_id=t.factor_template_id where f.factor_id=:new.factor_id)

end_tenor_from is null or end_tenor_to is null or pack_tenor.compare(end_tenor_from,end_tenor_to,pack_install.get_reporting_date)<=0

not exists (select /*+ first_rows(1) */ 1 from instrument_param where table_name=:table_name and volatility_type is null) or ((:new.delta is not null and :new.gamma is not null and :new.vega is not null) or (:new.volatility is not null or :new.replacement_cost is not null) or :new.volatility_type is not null)