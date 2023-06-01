using {com.us330.db.master,com.us330.db.transaction} from '../db/datamodel';
//creation of odata service.by default crud operation is supported in capm.
service catalogService@(path:'/com.us330.DataCatalog'){
    //using capabilities annottation we can control the activities on the entity set
    @Capabilities : { Insertable,Deletable:false,Updatable }
    entity EmployeeSet as projection on master.employees;
    entity AddressSet as projection on master.address;
    entity ProductSet as projection on master.product;
    entity BPSet as projection on master.businesspartner;
//exposing associations as part of entity set.
    entity POs @(title:'Purchase Orders') as projection
     on transaction.purchaseorder{
        *,
        Items:redirected to POItems   //give entity set name and not table names as navigation property will not be resolved succesfully.
    }

    entity POItems @(
        title:'Purchase Order Items'
    ) as projection on transaction.poitems
    {
        *,
        PARENT_KEY :redirected to POs,
        PRODUCT_GUID :redirected to ProductSet
    }
}