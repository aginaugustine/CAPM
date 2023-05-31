namespace com.us330.db;


using {com.us330.db.master,com.us330.db.transaction} from './datamodel';

context CDSViews {
    define view ![POWorklist] as //![] to make name casesensitive
    select from transaction.purchaseorder {
        key PO_ID as ![PurchaseOrderId],
        PARTNER_GUID.BP_ID as ![PartnerId],
        PARTNER_GUID.COMPANY_NAME as ![CompanyName],
        GROSS_AMOUNT as ![GrossAmount],
        CURRENCY_CODE as ![CurrencyCode],
        LIFECYCLE_STATUS as ![POStatus],
        key Items.PO_ITEM_POS as ![ItemPosition],
        Items.PRODUCT_GUID.PRODUCT_ID as ![ProductId]
    };
    //VALUE HELP cds views
    define view ProductValueHelp as
    select from master.product{
        //define the ui text using annotations
        @EndUserText.label:[
            {
                language:'EN',
                text:'Product ID'
            },
            {
                    language:'DE',
                text:'Prodekt ID'
            }
        ]
        PRODUCT_ID as ![ProductId],
        @EndUserText.label:[
            {
                language:'EN',
                text:'Product Description'
            },
            {
                language:'DE',
                text:'Prodekt Beschreibung'
            }
        ]
        DESCRIPTION as![Description]
    };
    //items view
    define view ![POItems] as 
    select from transaction.poitems{
        PARENT_KEY.PARTNER_GUID.NODE_KEY as![Partner],
        PRODUCT_GUID.NODE_KEY as ![ProductId],
        CURRENCY_CODE as ![CurrencyCode],
        GROSS_AMOUNT as ![GrossAmount],
        NET_AMOUNT as ![NETAMOUNT],
        TAX_AMOUNT as ![TAXAMOUNT],
        PARENT_KEY.OVERALL_STATUS as ![POStatus]
    };

    //Aggregation
    define view ProductViewSales as
    select from master.product as prod {
      key  PRODUCT_ID as ![ProductId],
        texts.DESCRIPTION as ![Description],
        cast((
            select from transaction.poitems as a {
                SUM(a.GROSS_AMOUNT) as sum
            }where a.PRODUCT_GUID.NODE_KEY = prod.NODE_KEY
        ) as Decimal) as SUM    // or SUM:Decimal(15,2);
    };

    //exposed association and aggregation
    define view ProductView as 
    select from master.product
    mixin {   ///exposed association similar to abap cds
        Product : Association[*] to POItems on
        Product.ProductId = $projection.PRODUCT_ID
    } into {
        NODE_KEY as ![PRODUCT_ID],
        DESCRIPTION as ![DESCRIPTION],
        CATEGORY as ![CATEGORY],
        PRICE as ![PRICE],
        TYPE_CODE as ![TYPECODE],
        SUPPLIER_GUID.BP_ID as ![BPID],
        SUPPLIER_GUID.COMPANY_NAME as ![COMPANYNAME],
        SUPPLIER_GUID.ADDRESS_GUID.CITY as ![CITY],
        SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as ![COUNTRY],
        //exposed association
        //when this view is read,Product association is not read ,untill its been requested/consume.
        Product
    };

    //calculation view to display the sum of gross_amount
    define view CProductGrossAmountView as
    select from ProductView {
        PRODUCT_ID as ![ProductId],
        COUNTRY as ![Country],
        Product.CurrencyCode as ![CurrencyCode],
        CAST(SUM(Product.GrossAmount) as Decimal) as ![ProductGrossAmount]   // in cds define a type for the aggregated value else during run time cds engine will throw error saying missing type for these fields.
    }group by PRODUCT_ID,COUNTRY,Product.GrossAmount
}