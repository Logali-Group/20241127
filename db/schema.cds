namespace com.logaligroup;
using {API_BUSINESS_PARTNER as remote} from '../srv/external/API_BUSINESS_PARTNER';

using {
    cuid,
    managed,
    sap.common.CodeList
} from '@sap/cds/common';

entity Categories : cuid {
    category        : String(40);
    description     : LargeString;
    toSubCategories : Association to many SubCategories
                          on toSubCategories.category = $self;
};

entity SubCategories : cuid {
    subCategory : String(40);
    description : LargeString;
    category    : Association to Categories;
};

entity Suppliers : cuid {
    supplier     : String(9);
    supplierName : String(40);
    webAddress   : String;
};

entity Stock : CodeList {
    key code : String enum {
            InStock         = 'In Stock';
            NotInStock      = 'Not In Stock';
            LowAvailability = 'Low Availability';
            Pending         = 'Pending';
        }
}

entity Products : cuid {
    key product     : String(9);
        productName : String(40);
        description : LargeString;
        category    : Association to Categories;
        subCategory : Association to SubCategories;
        supplier    : Association to remote.A_Supplier;
        rating      : Decimal(4, 2);
        min         : Integer default 30;
        max         : Integer default 100;
        value       : Integer default 0;
        criticality : Integer;
        stock       : Association to Stock default 'Pending';
        price       : Decimal(6, 2);
        currency    : String(3) default 'USD';
        toIncome    : Association to many Income
                          on toIncome.product = $self;
};

entity Currencies {
    key code     : String(3);
        currency : String(40);
};

entity Income : cuid, managed {
    quantity : Integer;
    price    : Decimal(6, 2);
    currency : String(3);
    product  : Association to Products;
};
