-- created_at: 2026-11-03T15:25:33.521198+00:00
-- finished_at: 2026-11-03T15:25:33.526840+00:00
-- elapsed: 5ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.analisi_citta.source_not_null_flusso_ordini_order_id.383d6cabbb
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.analisi_citta.source_not_null_flusso_ordini_order_id.383d6cabbb", "profile_name": "analisi_citta", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select order_id
from "flusso"."main"."ordini"
where order_id is null



  
  
      
    ) dbt_internal_test;

-- created_at: 2026-11-03T15:25:33.521199+00:00
-- finished_at: 2026-11-03T15:25:33.526847+00:00
-- elapsed: 5ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.analisi_citta.source_not_null_flusso_ordini_customer_id.4a9ed060b9
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.analisi_citta.source_not_null_flusso_ordini_customer_id.4a9ed060b9", "profile_name": "analisi_citta", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_id
from "flusso"."main"."ordini"
where customer_id is null



  
  
      
    ) dbt_internal_test;

-- created_at: 2026-11-03T15:25:33.521198+00:00
-- finished_at: 2026-11-03T15:25:33.529580+00:00
-- elapsed: 8ms
-- outcome: success
-- dialect: duckdb
-- node_id: test.analisi_citta.source_relationships_flusso_ordini_customer_id__customer_id__source_flusso_clienti_.6785c960d4
-- query_id: not available
-- desc: execute adapter call
/* {"app": "dbt", "dbt_version": "2.0.0", "node_id": "test.analisi_citta.source_relationships_flusso_ordini_customer_id__customer_id__source_flusso_clienti_.6785c960d4", "profile_name": "analisi_citta", "target_name": "dev"} */

    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with child as (
    select customer_id as from_field
    from "flusso"."main"."ordini"
    where customer_id is not null
),

parent as (
    select customer_id as to_field
    from "flusso"."main"."clienti"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null



  
  
      
    ) dbt_internal_test;

