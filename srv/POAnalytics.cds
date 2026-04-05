//consume reference of my DB tables
using { anubhav.cds as spiderman } from '../db/CDSViews';

service POAnalytics @(path:'POAnalytics') {

    ///SELECT * FROM view
    entity PurchaseAnalytics as projection on spiderman.CDSViews.POWorkList{
        *
    };
    

    //As we see that it is not possible to use template to create fiori ALP app using CAP entity
    //it is now expecting a aggregation entity - SUM, MIN, MAX, AVG, COUNT, DISTINCT
    //These annotations are crucial for Fiori tools to properly recognize and support ALP
    annotate POAnalytics.PurchaseAnalytics with @(
        Aggregation.ApplySupported: {
            Transformations : [
                'aggregate',
                'identity',
                'topcount',
                'bottomcount',
                'concat',
                'groupby',
                'filter',
                'expand',
                'search'
            ],
            GroupableProperties: [
                CompanyName,
                Description,
                CurrencyCode,
                Country
            ],
            AggregatableProperties :[
                {
                    $Type : 'Aggregation.AggregatablePropertyType',
                    Property : GrossAmount,
                },
            ],

        },

        Analytics : { 
            AggregatedProperty #GrossAmount : {
                $Type : 'Analytics.AggregatedPropertyType',
                Name: 'GrossAmount',
                AggregationMethod : 'sum',
                AggregatableProperty : GrossAmount,
                @Common.Label : 'Total Purchase'
            },
         },

    );
    

    //Block 3: Visual filter - where user gets a chart in filter bar to filter data
    //presentation variant and value list, and chart annotation block
        ///Block 4 - To add the chart in the middle area
    //Company name - X axis - Dimention - #Category
    //Gross Amount - Y axis - Measure - #AXIS1
    annotate POAnalytics.PurchaseAnalytics with @(
        UI.Chart #spiderman:{
            $Type : 'UI.ChartDefinitionType',
            ChartType : #Bar,
            Title : 'Filter by Country',
            Dimensions: [ Country ],
            DimensionAttributes: [
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : Country,
                    Role: #Category
                }
            ],
            DynamicMeasures: [
                ![@Analytics.AggregatedProperty#GrossAmount]
            ],
            MeasureAttributes : [
                {
                    $Type : 'UI.ChartMeasureAttributeType',
                    DynamicMeasure: ![@Analytics.AggregatedProperty#GrossAmount],
                    Role: #Axis1
                },
            ],
        },
        //Initially when UI loads, whether we show chart on the screen or Not
        UI.PresentationVariant #pvSpiderman: {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.Chart#spiderman',
            ],
        },
    ){
        Country @Common : { 
            ValueList #vlCountry: {
                $Type : 'Common.ValueListType',
                CollectionPath: 'PurchaseAnalytics',
                Parameters: [
                    {
                        $Type : 'Common.ValueListParameterInOut',
                        LocalDataProperty : Country,
                        ValueListProperty : 'Country',
                    },
                ],
                PresentationVariantQualifier: 'pvSpiderman'
            },

         }
    };


    ///Block 4 - To add the chart in the middle area
    //Company name - X axis - Dimention - #Category
    //Gross Amount - Y axis - Measure - #AXIS1
    annotate POAnalytics.PurchaseAnalytics with @(
        UI.Chart :{
            $Type : 'UI.ChartDefinitionType',
            ChartType : #Column,
            Title : 'Total Purchase by Company',
            Dimensions: [ CompanyName ],
            DimensionAttributes: [
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : CompanyName,
                    Role: #Category
                },
                {
                    $Type : 'UI.ChartDimensionAttributeType',
                    Dimension : Country,
                    Role : #Series,
                },
            ],
            DynamicMeasures: [
                ![@Analytics.AggregatedProperty#GrossAmount]
            ],
            MeasureAttributes : [
                {
                    $Type : 'UI.ChartMeasureAttributeType',
                    DynamicMeasure: ![@Analytics.AggregatedProperty#GrossAmount],
                    Role: #Axis1
                },
            ],
        },
        //Initially when UI loads, whether we show chart on the screen or Not
        UI.PresentationVariant: {
            $Type : 'UI.PresentationVariantType',
            Visualizations : [
                '@UI.Chart',
            ],
        },
    );
    

    ///It will add a selection field and table columns - Block 1 and 5
    annotate POAnalytics.PurchaseAnalytics with @(
        UI: {
            SelectionFields  : [
                PurchaseOrderId,
                CompanyName,
                CurrencyCode,
                Description,
                Country
            ],
            LineItem  : [
                {
                    $Type : 'UI.DataField',
                    Value : PurchaseOrderId,
                },
                {
                    $Type : 'UI.DataField',
                    Value : ItemPosition,
                },
                {
                    $Type : 'UI.DataField',
                    Value : CompanyName,
                },
                {
                    $Type : 'UI.DataField',
                    Value : GrossAmount,
                },
                {
                    $Type : 'UI.DataField',
                    Value : CurrencyCode,
                },
                {
                    $Type : 'UI.DataField',
                    Value : Description,
                },
                {
                    $Type : 'UI.DataField',
                    Value : OverallStatus,
                },
                {
                    $Type : 'UI.DataField',
                    Value : Country,
                },
            ],
        }

    );
    

}