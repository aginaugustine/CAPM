namespace com.us330.db.aspects;

using {
    sap,
    Currency,
    temporal,
    managed
} from '@sap/cds/common';

type Gender      : String(1) enum {
    male          = 'M';
    female        = 'F';
    nonBinary     = 'N';
    noDisclousure = 'D';
    selfDescribe  = 'S';
};

//validation
type phoneNumber : String(30) @assert.format: '^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
type Email       : String(255) @assert.format: '[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+';

type AmountT:Decimal(15, 2)@(
    Semantics.amount.currencycode:'CURRENCY_CODE ',
    sap.unit:'CURRENCY_CODE '
);
//reusable structure
abstract entity Amount {
    CURRENCY_CODE : String(5);
    GROSS_AMOUNT  : AmountT;
    NET_AMOUNT    : AmountT;
    TAX_AMOUNT    : AmountT;
}
