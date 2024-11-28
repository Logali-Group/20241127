using {LogaliGroup as projection} from '../service';

annotate projection.Suppliers with {
    ID @title : 'Suppliers' @Common : { 
        Text : SupplierName,
        TextArrangement : #TextOnly
     }
};
