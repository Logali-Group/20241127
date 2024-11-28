using {LogaliGroup as projection} from '../service';

annotate projection.VH_Categories with {
    ID @title : 'Categories' @Common : { 
        Text : category,
        TextArrangement : #TextOnly
     }
};
