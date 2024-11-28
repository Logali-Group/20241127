using {LogaliGroup as projection} from '../service';
using from './annotations-income';

annotate projection.ProducstSet with @odata.draft.enabled;

annotate projection.ProducstSet with {
    product      @title: 'Product';
    productName  @title: 'Product Name';
    description  @title: 'Description'  @UI.MultiLineText;
    supplier     @title: 'Supplier';
    category     @title: 'Category';
    subCategory  @title: 'Sub-Category';
    rating       @title: 'Rating';
    stock        @title: 'Stock';
    price        @title: 'Price'        @Measures.Unit: currency;
    currency     @title: 'Currency'     @Common.IsUnit;
};

annotate projection.ProducstSet with {
    subCategory @Common: {
        Text           : subCategory.subCategory,
        TextArrangement: #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_SubCategories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterIn',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'category_ID'
                },
                {
                    $Type : 'Common.ValueListParameterOut',
                    LocalDataProperty : subCategory_ID,
                    ValueListProperty : 'ID'
                }
            ]
        }
    };
    category    @Common: {
        Text           : category.category,
        TextArrangement: #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_Categories',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : category_ID,
                    ValueListProperty : 'ID'
                }
            ]
        }
    };
    supplier    @Common: {
        Text           : supplier.SupplierName,
        TextArrangement: #TextOnly,
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Suppliers',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : supplier_Supplier,
                    ValueListProperty : 'ID'
                }
            ]
        }
    };
    stock       @Common: {
        Text           : stock.name,
        TextArrangement: #TextOnly
    };
    currency @Common.FieldControl: {
        $edmJson: {
            $If: [

                {
                    $Eq: [
                        {
                            $Path: 'IsActiveEntity'
                        },
                        false
                    ]   
                },
                1,
                3
            ]
        }
    }
};


annotate projection.ProducstSet with @(
    UI.HeaderInfo: {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Product',
        TypeNamePlural : 'Products',
        Title : {
            $Type : 'UI.DataField',
            Value : productName
        },
        Description : {
            $Type : 'UI.DataField',
            Value : product
        }
    },
    UI.SelectionFields  : [
        supplier_Supplier,
        category_ID,
        subCategory_ID
    ],
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: product
        },
        {
            $Type: 'UI.DataField',
            Value: productName
        },
        {
            $Type: 'UI.DataField',
            Value: supplier_Supplier
        },
        {
            $Type: 'UI.DataField',
            Value: category_ID
        },
        {
            $Type: 'UI.DataField',
            Value: subCategory_ID
        },
        {
            $Type                : 'UI.DataFieldForAnnotation',
            Target               : '@UI.DataPoint#RatingIndicator',
            Label                : 'Rating',
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type                : 'UI.DataField',
            Value                : stock_code,
            Label                : 'Stock',
            Criticality          : criticality,
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '10rem'
            }
        },
        {
            $Type                : 'UI.DataField',
            Value                : price,
            ![@HTML5.CssDefaults]: {
                $Type: 'HTML5.CssDefaultsType',
                width: '6rem'
            }
        },
        {
            $Type : 'UI.DataFieldForAction',
            Action : 'LogaliGroup.add',
            Label : 'Add Product',
            Criticality : #Positive,
            Inline : true
        }
    ],
    UI.DataPoint #RatingIndicator: {
        $Type        : 'UI.DataPointType',
        Visualization: #Rating,
        Value        : rating,
    },
    UI.FieldGroup #ProductInformation  : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : product
            },
            {
                $Type : 'UI.DataField',
                Value : productName
            },
            {
                $Type : 'UI.DataField',
                Value : description
            },
            {
                $Type : 'UI.DataField',
                Value : supplier_Supplier
            },
            {
                $Type : 'UI.DataField',
                Value : category_ID
            },
            {
                $Type : 'UI.DataField',
                Value : subCategory_ID
            },
            {
                $Type : 'UI.DataField',
                Value : rating
            },
            {
                $Type : 'UI.DataField',
                Value : price
            }
        ]
    },
    UI.Facets  : [
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#ProductInformation',
            Label : 'Product Information'
        },
        {
            $Type : 'UI.ReferenceFacet',
            Target : 'toIncome/@UI.LineItem',
            Label : 'Income'
        }
    ]
);
