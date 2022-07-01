/* Ex1 (slides) Select the fields below from table DimEmployee:
EmployeeKey, FirstName, LastName, BaseRate, VacationHours, SickLeaveHours
And then:
Generate a new field named “FullName” which is equal to:
FirstName + ‘ ’ + LastName
Generate a new field named “VacationLeavePay” which is equal to:
BaseRate * VacationHours 
Generate a new field named “SickLeavePay” which is equal to:
BaseRate * VacationHours 
Generate a new field named “TotalLeavePay” which is equal to:
VacationLeavePay+SickLeavePay
*/ 
select EmployeeKey, FirstName, LastName, BaseRate, VacationHours, SickLeaveHours,
	   FirstName + isnull(' ' + MiddleName + ' ', ' ') + LastName as FullName,
	   BaseRate * VacationHours as VacationLeavePay,
	   BaseRate * SickLeaveHours as SickLeavePay,
	   BaseRate * VacationHours + BaseRate * SickLeaveHours as TotalLeavePay
from DimEmployee;


/* Ex2: Write a query to get SalesOrderNumber, ProductKey, OrderDate from FactInternetSales then caculate:
- Total Revenue equal to OrderQuantity*UnitPrice
- Total Cost equal to ProductStandardCost + DiscountAmount
- Profit equal to Total Revenue - Total Cost
- Profit margin equal (Total Revenue - Total Cost)/Total Revenue
*/
select SalesOrderNumber, ProductKey, OrderDate,
       OrderQuantity * UnitPrice as TotalRevenue,
	   ProductStandardCost + DiscountAmount as TotalCost,
	   OrderQuantity * UnitPrice - (ProductStandardCost + DiscountAmount) as Profit,
	   (OrderQuantity * UnitPrice - (ProductStandardCost + DiscountAmount)) / (OrderQuantity * UnitPrice) as ProfitMargin
from FactInternetSales;


/* Ex3: Write a query to get DateKey, ProductKey from FactProductInventory then caculate
- Number of product end of day equal to UnitsBalance + UnitsIn - UnitsOut
- Total Cost equal to Number of product end of day * UnitCost
*/ 
select DateKey, ProductKey,
       UnitsBalance + UnitsIn - UnitsOut as ProductEndDay,
	   (UnitsBalance + UnitsIn - UnitsOut) * UnitCost as TotalCost
from FactProductInventory;



/* Ex4: From DimProduct, Display all Product currently sell (Status = Current) 
and weight more than 500 G (Weight; WeightUnitMeasureCode) */

select *
from DimProduct
where Status = 'Current' and Weight > 500 and WeightUnitMeasureCode = 'G';


/*Ex5: From dbo.FactInternetSales and dbo.DimSalesTerritory, Write a query displaying the sales orders where the sales amount exceeds $1,000. 
Retrieve only those rows where the territory region is Canada. */

select *
from FactInternetSales
where SalesAmount > 1000 and SalesTerritoryKey in (select SalesTerritoryKey from DimSalesTerritory where SalesTerritoryRegion = 'Canada');


/*Ex6: From dbo.DimProduct and DimProductSubcategory, Write a query displaying the Product key,  
EnglishProductName, and Color columns from rows in the dbo.DimProduct table 
which has EnglishProductSubCategoryName is 'Mountain Bikes'.
and ListPrice > 1000*/

select dp.ProductKey, EnglishProductName, Color
from DimProduct as dp
left join DimProductSubcategory as dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
where EnglishProductSubcategoryName = 'Mountain Bikes' and ListPrice > 1000;

/*Ex7: From dbo.DimPromotion, 
Write a query display ProductKey from dbo.FactInternetSale which has discount percentage >= 20% */

select ProductKey
from DimPromotion as dp
left join FactInternetSales as fis on dp.PromotionKey = fis.PromotionKey
where DiscountPct >= 0.20;


/*Ex8: From dbo.DimProduct, dbo.DimPromotion, dbo.FactInternetSales, 
Write a query display EnglishProductName which has discount percentage >= 20%*/

select EnglishProductName
from FactInternetSales as fis
left join DimProduct as dp on fis.ProductKey = dp.ProductKey
left join DimPromotion as dpr on fis.PromotionKey = dpr.PromotionKey
where DiscountPct >= 0.2;


/*Ex9: From DimCustomer, FactInternetSales, 
Display First Name of customer in FactInternetSale 
who have English Education is Bachelors or High School*/

select FirstName
from FactInternetSales as fis
left join DimCustomer as dc on fis.CustomerKey = dc.CustomerKey
where EnglishEducation in ('Bachelors', 'High School');


/*Ex10: From FactInternetSales and FactResellerSale, DimProduct 
Find all SalesOrderNumber  which EnglishProductName contains 'Road' in name and Color is Yellow */ 


select fis.SalesOrderNumber
from FactInternetSales as fis
left join DimProduct as dp on fis.ProductKey = dp.ProductKey
left join FactResellerSales as frs on dp.ProductKey = frs.ProductKey
where  EnglishProductName like '%Road%' and  Color = 'Yellow';




/* Ex 11: From dbo.FactInternetSales and dbo.FactInternetSalesReason tables, Write a query displaying the SalesOrderNumber, SalesOrderLineNumber 
where the SalesReasonKey equal to 2 or 5 */

select  fis.SalesOrderNumber, fis.SalesOrderLineNumber
from FactInternetSales as fis
left join FactInternetSalesReason as fisr on fis.SalesOrderNumber = fisr.SalesOrderNumber
                                          and fis.SalesOrderLineNumber = fisr.SalesOrderLineNumber
where SalesReasonKey in (2,5);



/* Ex 12: From dbo.FactInternetSales, dbo.FactInternetSalesReason, DimSalesReason, DimProduct, DimProductCategory
Write a query displaying the
SalesOrderNumber, SalesOrderLineNumber, ProductKey, Quantity, EnglishProductName, Color, EnglishProductCategoryName
where SalesReasonReasonType is 'Marketing' 
and EnglishProductSubcategoryName contains 'Bikes' */

select fis.SalesOrderNumber, fis.SalesOrderLineNumber, fis.ProductKey, fis.OrderQuantity, EnglishProductName, Color, EnglishProductCategoryName
from FactInternetSales as fis
left join FactInternetSalesReason as fisr on fis.SalesOrderNumber = fisr.SalesOrderNumber
                                          and fis.SalesOrderLineNumber = fisr.SalesOrderLineNumber
left join DimProduct as dp on fis.ProductKey = dp.ProductKey
left join DimSalesReason as dsr on fisr.SalesReasonKey = dsr.SalesReasonKey
left join DimProductSubcategory as dps on dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
left join DimProductCategory as dpc on dps.ProductCategoryKey = dpc.ProductCategoryKey
where SalesReasonReasonType = 'Marketing'
and EnglishProductSubcategoryName like '%Bikes%';



/* Ex 13: From DimDepartmentGroup, Write a query display DepartmentGroupName and
their parent DepartmentGroupName */ 


select child.DepartmentGroupName, parent.DepartmentGroupName as ParentDepartmentGroupName
from DimDepartmentGroup as child
left join DimDepartmentGroup as parent on child.ParentDepartmentGroupKey = parent.DepartmentGroupKey;


/* Ex 14: From FactInternetSales, DimProduct 
Display ProductKey, EnglishProductName of products which never have been ordered and 
ProductCategory is 'Bikes'*/

select dp.ProductKey, EnglishProductName
from DimProduct as dp
left join FactInternetSales as fis on fis.ProductKey = dp.ProductKey
left join DimProductSubcategory as dps on dps.ProductSubcategoryKey = dp.ProductSubcategoryKey
left join DimProductCategory as dpc on dpc.ProductCategoryKey = dps.ProductCategoryKey
where dp.ProductKey not in (select distinct ProductKey from FactInternetSales)
and EnglishProductCategoryName  = 'Bikes';



/* Ex 15: From FactFinance, DimOrganization, DimScenario
Write a query display OrganizationKey, OrganizationName, Parent OrganizationKey, Parent OrganizationName, Amount
where ScenarioName is 'Actual' */ 

select do.OrganizationKey, 
	   do.OrganizationName, 
	   do.ParentOrganizationKey, 
	   dop.OrganizationName as ParentOrgainzationName,
       Amount
from FactFinance as ff
left join DimOrganization as do on do.OrganizationKey = ff.OrganizationKey
left join DimOrganization as dop on do.ParentOrganizationKey = dop.OrganizationKey
left join DimScenario as ds on ds.ScenarioKey = ff.ScenarioKey
where ScenarioName = 'Actual';


/*Ex 16: Write a query joining the DimCustomer, and FactInternetSales tables to
return a list of the customer with their number of order */

select fis.CustomerKey,
	   FirstName + isnull(' ' + MiddleName + ' ', ' ') + LastName as FullName,
       count(distinct fis.SalesOrderNumber) as Number_of_Order
from FactInternetSales as fis
left join DimCustomer as dc on fis.CustomerKey = dc.CustomerKey
group by fis.CustomerKey,
         FirstName + isnull(' ' + MiddleName + ' ', ' ') + LastName
order by Number_of_Order;



/* Ex 17: From FactInternetSale, DimProduct,
Write a query that create new Color_group, if product color is 'Black' or 'Silver' or 'Silver/Black' leave 'Basic',
else keep Color.
Then Caculate total SalesAmount by new Color_group */


select Color,
       case
			when Color in ('Black', 'Silver', 'Silver/Black') then 'Basic'
			else Color
	   end as Color_group
from FactInternetSales as fis
left join DimProduct as dp on dp.ProductKey = fis.ProductKey;


/* Ex 18: From FactInternetSales, DimProduct
Write a query display SaleOrderNumber, EnglishProductName, OrderQuantity, SalesAmount.
Then generate a column name 'Order Type' with
values (“Under 10” or “10–19” or “20–29” or “30–39” or “40 and over”) from SalesAmount */

select SalesOrderNumber, EnglishProductName, OrderQuantity, SalesAmount,
       case
	       when SalesAmount < 10 then 'Under 10'
		   when SalesAmount >= 10 and SalesAmount <= 19 then '10-19'
		   when SalesAmount >= 20 and SalesAmount <= 29 then '20-29'
		   when SalesAmount >= 30 and SalesAmount <= 39 then '30-39'
		   when SalesAmount >= 40 then '40 and over'
	   end as 'Order Type'
from FactInternetSales as fis
left join DimProduct as dp on dp.ProductKey = fis.ProductKey



/* Ex 19: From the FactInternetsales and Resellersales tables, retrieve saleordernumber, productkey,
orderdate, shipdate of orders in October 2011, along with sales type ('Resell' or 'Internet') */


(select SalesOrderNumber, ProductKey, OrderDate, ShipDate, 'Internet' as SaleType
from FactInternetSales
where ShipDate between '2011-10-01' and '2011-10-31')
union
(select SalesOrderNumber, ProductKey, OrderDate, ShipDate, 'Reseller' as SaleType
from FactResellerSales
where ShipDate between '2011-10-01' and '2011-10-31')
order by SaleType;


  
  /* Ex 20: From database
Display ProductKey, EnglishProductName, Total OrderQuantity (caculate from OrderQuantity in Quarter 3 of 2013)
of product sold in London for each Sales type ('Resell' and 'Internet')*/


(select fis.ProductKey, EnglishProductName,
       sum(OrderQuantity) as Total_Order_Quantity,
	    'Internet' as Sale_type
from FactInternetSales as fis
left join DimProduct as dp on dp.ProductKey = fis.ProductKey
left join DimCustomer as dc on dc.CustomerKey= fis.CustomerKey
left join DimGeography as dg on dg.GeographyKey = dc.GeographyKey
where OrderDate between '2013-06-01' and '2013-09-30'
      and City = 'London'
group by fis.ProductKey, EnglishProductName
)
union
(select frs.ProductKey, EnglishProductName,
       sum(OrderQuantity) as Total_Order_Quantity,
	    'Reseller' as Sale_type
from FactResellerSales as frs
left join DimProduct as dp on dp.ProductKey = frs.ProductKey
left join DimReseller as dr on dr.ResellerKey= frs.ResellerKey
left join DimGeography as dg on dg.GeographyKey = dr.GeographyKey
where OrderDate between '2013-06-01' and '2013-09-30'
      and City = 'London'
group by frs.ProductKey, EnglishProductName
)
order by Sale_type, Total_Order_Quantity desc;



/* Ex 21: Find out 5 SaleOrderNumber  with highest SalesAmount by month in InternetSales tables. */ 


with monthly_sales as
(select SalesOrderNumber,
       year(OrderDate) as year,
	   month(OrderDate) as month,
	   sum(SalesAmount) as TotalSale,
	   row_number () over (partition by year(OrderDate), month(OrderDate) order by sum(SalesAmount)) as row_no   
from FactInternetSales
group by SalesOrderNumber, year(OrderDate), month(OrderDate))
select * from monthly_sales where row_no <=5;


/* Ex 22 : From database, retrieve total SalesAmount monthly of internet_sales and reseller_sales.

-- Danh sách cột: Year, Month, Internet_Sale_amount, Reseller_Sale_amount
 --OUTPUT:  Year, Month, Internet_Sale_amount, Reseller_Sale_amount
 --INPUT1 = Year, Month, Internet_Sale_amount */

with inter as
(select year(OrderDate) as year,
        month(OrderDate) as month,
		sum(SalesAmount) as Internet_Sale_Amount   
 from FactInternetSales
 group by year(OrderDate), month(OrderDate)
),
 reseller as
(select year(OrderDate) as year,
        month(OrderDate) as month,
		sum(SalesAmount) as Reseller_Sale_Amount   
 from FactResellerSales
 group by year(OrderDate), month(OrderDate)
)
select inter.year, inter.month, Internet_Sale_Amount, Reseller_Sale_Amount
from inter
full join reseller on inter.year = reseller.year
                 and inter.month = reseller.month
order by inter.year desc, inter.month desc;
