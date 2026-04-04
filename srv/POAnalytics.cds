//consume reference of my DB tables
using { anubhav.cds as spiderman } from '../db/CDSViews';

service POAnalytics @(path:'POAnalytics') {

    ///SELECT * FROM view
    entity PurchaseAnalytics as projection on spiderman.CDSViews.POWorkList{
        *
    };

}