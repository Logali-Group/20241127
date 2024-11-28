using {com.logaligroup as entities} from '../db/schema';
using {API_BUSINESS_PARTNER as remote} from './external/API_BUSINESS_PARTNER';

service LogaliGroup {

    type Dialog {
        quantity : Integer;
        price    : Decimal(6, 2);
        currency : String(3);
    }

    entity ProducstSet      as projection on entities.Products
        actions {
            @cds.odata.bindingparameter.name: '_it'
            @Common.SideEffects : {
                $Type : 'Common.SideEffectsType',
                TargetProperties : [
                    '_it/stock_code',
                    '_it/criticality'
                ]
            }
            action add(
                    quantity    : Dialog:quantity,
                    price       : Dialog:price,
                    currency    : Dialog:currency
             )
        };

    @readonly
    entity Income           as projection on entities.Income;

    @readonly
    entity VH_Categories    as projection on entities.Categories;

    @readonly
    entity VH_SubCategories as projection on entities.SubCategories;

    @readonly
    entity VH_Suppliers     as projection on entities.Suppliers;

    @readonly
    entity VH_Stock         as projection on entities.Stock;

    @readonly
    entity VH_currencies    as projection on entities.Currencies;

    @cds.persistence.exists
    @cds.persistence.skip
    entity Suppliers as projection on remote.A_Supplier {
        key Supplier as ID,
            SupplierName,
            SupplierFullName
    };
}
