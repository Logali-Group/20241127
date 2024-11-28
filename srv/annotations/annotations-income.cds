using {LogaliGroup as projection} from '../service';

annotate projection.Income with {
    createdAt @title : 'Creation Date';
    quantity @title : 'Quantity';
    price @title : 'Price per Unit' @Measures.Unit: currency;
    currency @title : 'Currency' @Common.IsUnit;
};

annotate projection.Income with @(
    UI.HeaderInfo  : {
        $Type : 'UI.HeaderInfoType',
        TypeName : 'Income',
        TypeNamePlural : 'Income'
    },
    UI.LineItem: [
        {
            $Type : 'UI.DataField',
            Value : createdAt,
        },
        {
            $Type : 'UI.DataField',
            Value : quantity
        },
        {
            $Type : 'UI.DataField',
            Value : price
        }
    ],
    UI.FieldGroup #Income:{
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : quantity
            },
            {
                $Type : 'UI.DataField',
                Value : price
            }
        ]
    },
    UI.Facets:[
        {
            $Type : 'UI.ReferenceFacet',
            Target : '@UI.FieldGroup#Income',
        }
    ]
);

