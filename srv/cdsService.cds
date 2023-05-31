using {com.us330.db.CDSViews} from '../db/cdsviews';

service CDSService@(path:'com/us330/db/cdsviews') {

    entity POWorklits@(title:'POWorklist') as projection on CDSViews.POWorklist;
    entity ProductOrders as projection on CDSViews.ProductViewSales;
    entity ProductAggregation as projection on CDSViews.CProductGrossAmountView;

}