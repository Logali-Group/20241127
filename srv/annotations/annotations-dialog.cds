using {LogaliGroup as projection} from '../service';

annotate projection.Dialog with {
    quantity @title : 'Quantity' @assert.range:[1,100];
    price @title : 'Price';
    currency @title : 'Currency';
};

annotate projection.Dialog with {
    currency @Common : { 
        ValueList : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'VH_currencies',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : currency,
                    ValueListProperty : 'code'
                },
                {
                    $Type : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty : 'currency'
                }
            ]
        }
     }
};

