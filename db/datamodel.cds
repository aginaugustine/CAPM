namespace com.us330.db;
using { cuid,managed,temporal,Currency} from '@sap/cds/common';
using {com.us330.db.aspects} from './common';
type us330_string : String(32);

context master {
    entity businesspartner {
        key NODE_KEY      : us330_string;
            BP_ROLE       : String(2);
            EMAIL_ADDRESS : String(64);
            PHONE_NUMBER  : String(14);
            FAX_NUMBER    : String(14);
            WEB_ADDRESS   : String(64);
            ADDRESS_GUID  : Association to address;
            BP_ID         : String(116);
            COMPANY_NAME  : String(80);
              }

    entity address {
        key NODE_KEY        : us330_string;
            CITY            : String(64);
            POSTAL_CODE     : String(14);
            STREET          : String(64);
            BUILDING        : String(64);
            COUNTRY         : String(2);
            ADDRESS_TYPE    : String(120);
            VAL_START_DATE  : Date;
            VAL_END_DATE    : Date;
            LATITUDE        : Decimal;
            LONGITUDE       : Decimal;
            businesspartner : Association to one businesspartner
                                  on businesspartner.ADDRESS_GUID = $self;
    }

    entity product {
       key NODE_KEY       : us330_string;
        PRODUCT_ID     : String(15);
        TYPE_CODE      : String(5);
        CATEGORY       : String(15);
        SUPPLIER_GUID  : Association to master.businesspartner;
        TAX_TARIF_CODE : String(15);
        MEASURE_UNIT   : String(15);
        WEIGHT_MEASURE : Decimal;
        WEIGHT_UNIT    : String(15);
        CURRENCY_CODE  : String(5);
        PRICE          : Decimal;
        WIDTH          : Decimal;
        DEPTH          : Decimal;
        HEIGHT         : Decimal;
        DIM_UNIT       : String(5);
        DESCRIPTION    : localized String(255);
      
    }
//using localized option ,no need to maintain seperate language transalation tables.
  /*  entity prodtext {
        NODE_KEY : us330_string;
        LANGUAGE : String(5);
        TEXT     : String(250);
    } */
    entity employees : cuid {
      nameFirst: us330_string;
      nameMiddle: us330_string;
      nameLast: us330_string;
      nameInitials: us330_string;
      sex: aspects.Gender; //from custom aspect
      language: String(5);
      phoneNumber:aspects.phoneNumber;
      email: aspects.Email;
      loginName:us330_string;
      currency: Currency;
      salaryAmount: aspects.AmountT;
      accountNumber: String(75);
      bankId: String(50);
      bankName: String(75); 
    }
    //annotate the entity and fields ,to enrich the way the fields are displayed in the UI.
    annotate employees with {
        nameFirst @title : '{i18n>fname}';
        nameLast @title : '{i18n>lname}';
    };
    
}

context transaction {
    entity purchaseorder:aspects.Amount {
       key ID                    : String(32);
        PO_ID                 : String(15);
        PARTNER_GUID: Association to master.businesspartner;
       
        LIFECYCLE_STATUS      : String(5);
        OVERALL_STATUS        : String(15);
        Items:Association to many poitems on Items.PARENT_KEY = $self;
    }

    entity poitems:aspects.Amount {
       key ID                    : String(32);
        PARENT_KEY         : Association to purchaseorder;
        PO_ITEM_POS           : String(5);
        PRODUCT_GUID: Association to master.product;
    }
}
