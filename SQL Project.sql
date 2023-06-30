/*1. Write a query to display customer full name with their title (Mr/Ms),
 both first name and last name are in upper case, customer email id, customer 
 creation date and display customer’s category after applying below categorization rules: i) IF
 customer creation date Year <2005 Then Category A ii) IF customer creation date Year >=2005 and <2011 Then
 Category B iii)IF customer creation date Year>= 2011 Then Category C Hint: Use CASE statement, 
no permanent change in table required. [NOTE: TABLES to be used - ONLINE_CUSTOMER TABLE]*/

USE ORDERS;
SELECT  
CUSTOMER_EMAIL, CUSTOMER_CREATION_DATE, 
CONCAT ( (case when CUSTOMER_GENDER ='M' 
                       then  'Mr '
                       else 'Ms '
                       end
                  ),
             CONCAT_WS(" ", UPPER(CUSTOMER_FNAME), UPPER(CUSTOMER_LNAME)) 
               )
       AS FullName,
       CASE 
       WHEN CUSTOMER_CREATION_DATE < '2005-01-01' 
       THEN 'A'
       WHEN '2005-01-01' <= CUSTOMER_CREATION_DATE AND CUSTOMER_CREATION_DATE< '2011-01-01'
       THEN 'B'
       WHEN CUSTOMER_CREATION_DATE > '2011-01-01'
       THEN 'C'
       END AS Category

from ONLINE_CUSTOMER;

/*2. Write a query to display the following information for the products, 
which have not been sold: product_id, product_desc, product_quantity_avail, 
product_price, inventory values (product_quantity_avail*product_price), 
New_Price after applying discount as per below criteria. 
Sort the output with respect to decreasing value of Inventory_Value. 
i) IF Product Price > 200,000 then apply 20% discount 
ii) IF Product Price > 100,000 then apply 15% discount 
iii) IF Product Price =< 100,000 then apply 10% discount 
# Hint: Use CASE statement, no permanent change in table required. [NOTE: TABLES to be used - PRODUCT, ORDER_ITEMS TABLE] */

SELECT 
PRODUCT_ID, ORDER_ID ,PRODUCT_DESC, PRODUCT_QUANTITY_AVAIL,PRODUCT_PRICE, PRODUCT_QUANTITY_AVAIL*PRODUCT_PRICE AS INVENTORY_VALUES,
CASE 
	WHEN PRODUCT_PRICE>200000 THEN PRODUCT_PRICE-(PRODUCT_PRICE*0.2)
    WHEN PRODUCT_PRICE>100000 THEN PRODUCT_PRICE-(PRODUCT_PRICE*0.15)
    WHEN PRODUCT_PRICE<=100000 THEN PRODUCT_PRICE-(PRODUCT_PRICE*0.1)
    END AS NEW_PRICE
FROM PRODUCT LEFT JOIN ORDER_ITEMS using (PRODUCT_ID) WHERE ORDER_ID IS NULL
ORDER BY PRODUCT_PRICE DESC;

/*3. Write a query to display Product_class_code, Product_class_description, Count of Product type in each productclass, 
Inventory Value (p.product_quantity_avail*p.product_price). Information should be displayed for only those product_class_code 
which have more than 1,00,000. Inventory Value. Sort the output with respect to decreasing value of Inventory_Value. 
[NOTE: TABLES to be used - PRODUCT, PRODUCT_CLASS_CODE]*/

SELECT PC.PRODUCT_CLASS_CODE, PC.PRODUCT_CLASS_DESC, COUNT(PRODUCT_CLASS_DESC) AS COUNT_OF_PRODUCT_TYPE,
(P.PRODUCT_QUANTITY_AVAIL*P.PRODUCT_PRICE) AS INVENTORY_VALUES
FROM PRODUCT_CLASS PC LEFT JOIN PRODUCT P 
ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
WHERE (PRODUCT_QUANTITY_AVAIL*PRODUCT_PRICE)> 100000
ORDER BY INVENTORY_VALUES DESC;

/*4.Write a query to display customer_id, full name, customer_email, 
customer_phone and country of customers who have cancelled all the orders placed by them 
(USE SUB-QUERY)[NOTE: TABLES to be used - ONLINE_CUSTOMER, ADDRESSS, ORDER_HEADER]*/

SELECT 
	OC.CUSTOMER_ID,UCASE(CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME)) AS FULL_NAME , OC.CUSTOMER_EMAIL,OC.CUSTOMER_PHONE,AD.COUNTRY,OH.ORDER_STATUS
FROM 
	ONLINE_CUSTOMER OC LEFT JOIN ADDRESS AD ON OC.ADDRESS_ID=AD.ADDRESS_ID 
	JOIN ORDER_HEADER OH ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
WHERE 
	ORDER_STATUS IN
(SELECT OH.ORDER_STATUS FROM ORDER_HEADER OH 
LEFT JOIN ONLINE_CUSTOMER OC ON OH.CUSTOMER_ID=OC.CUSTOMER_ID WHERE OH.ORDER_STATUS LIKE 'Cancelled');

/*5.Write a query to display Shipper name, City to which it is catering, 
num of customer catered by the shipper in the city and number of consignments 
delivered to that city for Shipper DHL [NOTE: TABLES to be used - SHIPPER,ONLINE_CUSTOMER, ADDRESSS, ORDER_HEADER]*/

SELECT S.SHIPPER_NAME, S.SHIPPER_ID,AD.CITY,COUNT(OH.ORDER_STATUS)AS NUMBER_OF_CONSIGNMENTS,COUNT(OC.CUSTOMER_ID) AS NUMBER_OF_CUST_CATERED_IN_CITY 
FROM SHIPPER S 
LEFT JOIN ORDER_HEADER OH ON S.SHIPPER_ID=OH.SHIPPER_ID
LEFT JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
LEFT JOIN ADDRESS AD ON AD.ADDRESS_ID=OC.ADDRESS_ID
WHERE SHIPPER_NAME LIKE 'DHL' GROUP BY CITY;

/*6.Write a query to display product_id, product_desc, product_quantity_avail, 
quantity sold, quantity available and show inventory Status of products as below as per below condition:
 a. For Electronics and Computer categories, if sales till date is Zero then show 
 'No Sales in past, give discount to reduce inventory',
 if inventory quantity is less than 10% of quantity sold,show 
 'Low inventory, need to add inventory', if inventory quantity 
 is less than 50% of quantity sold, show 'Medium inventory, need to add some inventory',
 if inventory quantity is more or equal to 50% of quantity sold, show 'Sufficient inventory' 
 b. For Mobiles and Watches categories, if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
 if inventory quantity is less than 20% of quantity sold, show 'Low inventory, need to add inventory', 
 if inventory quantity is less than 60% of quantity sold, show 'Medium inventory, need to add some inventory', 
 if inventory quantity is more or equal to 60% of quantity sold, show 'Sufficient inventory' 
 c. Rest of the categories, if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
 if inventory quantity is less than 30% of quantity sold, show 'Low inventory, need to add inventory', 
 if inventory quantity is less than 70% of quantity sold, show 'Medium inventory, need to add some inventory', 
 if inventory quantity is more or equal to 70% of quantity sold, show 'Sufficient inventory'
 -- (USE SUB-QUERY) -- [NOTE: TABLES to be used - PRODUCT, PRODUCT_CLASS, ORDER_HEADER]*/
 
 SELECT*FROM PRODUCT;
 SELECT*FROM PRODUCT_CLASS;
 SELECT*FROM ORDER_HEADER;
 
SELECT 
	P.PRODUCT_ID, P.PRODUCT_DESC, P.PRODUCT_QUANTITY_AVAIL , PC.PRODUCT_CLASS_CODE 
FROM
	PRODUCT P LEFT JOIN  PRODUCT_CLASS PC ON P.PRODUCT_CLASS_CODE=PC.PRODUCT_CLASS_CODE;
    




/*7. Write a query to display order_id and volume of the biggest order (in terms of volume) 
that can fit in carton id 10 -- [NOTE: TABLES to be used - CARTON, ORDER_ITEMS, PRODUCT]*/

SELECT
	OI.ORDER_ID,
	MAX(OI.PRODUCT_QUANTITY) AS Biggest_Order,
    (P.WEIGHT*P.WIDTH*P.HEIGHT) AS Volume,
    C.CARTON_ID
FROM
	ORDER_ITEMS OI LEFT JOIN PRODUCT P ON OI.PRODUCT_ID=P.PRODUCT_ID
    LEFT JOIN CARTON C ON OI.PRODUCT_ID=P.PRODUCT_ID
WHERE
	CARTON_ID = "10";
    
/*8.Write a query to display customer id, customer full name, total quantity and total value (quantity*price) 
shipped where mode of payment is Cash and customer last name starts with 'G' 
--[NOTE: TABLES to be used - ONLINE_CUSTOMER, ORDER_ITEMS, PRODUCT, ORDER_HEADER]*/

SELECT
	OC.CUSTOMER_ID,
    UCASE(CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME)) AS CUSTOMER_FULL_NAME,
    (OI.PRODUCT_QUANTITY),
    (OI.PRODUCT_QUANTITY * P.PRODUCT_PRICE) AS TOTAL_VALUE_SHIPPED,
    OH.PAYMENT_MODE
FROM
	PRODUCT P  LEFT JOIN ORDER_ITEMS OI USING (PRODUCT_ID)
    JOIN ORDER_HEADER OH ON OH.ORDER_ID=OI.ORDER_ID 
	JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
WHERE
	OH.PAYMENT_MODE LIKE "CASH" AND OC.CUSTOMER_LNAME LIKE "G%" ;
    
    
/*9.Write a query to display product_id, product_desc and total quantity of products 
which are sold together with product id 201 and are not shipped to city Bangalore 
and New Delhi. Display the output in descending order with respect to the tot_qty. 
-- (USE SUB-QUERY) -- [NOTE: TABLES to be used - order_items, product,order_head, online_customer, address]*/

SELECT
	P.PRODUCT_ID,
    P.PRODUCT_DESC,
    SUM(OI.PRODUCT_QUANTITY) AS TOTAL_QUANTITY ,
    AD.CITY
FROM
	PRODUCT P INNER JOIN ORDER_ITEMS OI ON P.PRODUCT_ID=OI.PRODUCT_ID
    INNER JOIN ORDER_HEADER OH ON OH.ORDER_ID=OI.ORDER_ID
    INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
    INNER JOIN ADDRESS AD ON AD.ADDRESS_ID=OC.ADDRESS_ID
WHERE
	P.PRODUCT_ID=201 AND AD.CITY NOT IN ("BANGALORE","NEW DELHI") ORDER BY TOTAL_QUANTITY DESC;
	

/*10.Write a query to display the order_id,customer_id and customer fullname, 
total quantity of products shipped for order ids which are even and shipped to 
address where pincode is not starting with "5" -- [NOTE: TABLES to be used - online_customer,Order_header, order_items,address]*/

SELECT
	OH.ORDER_ID,
    OC.CUSTOMER_ID,
    UCASE(CONCAT(OC.CUSTOMER_FNAME," ",OC.CUSTOMER_LNAME)) AS CUSTOMER_FULL_NAME,
    SUM(PRODUCT_QUANTITY) AS TOTAL_QUANTITY,
    AD.PINCODE
FROM
	ORDER_HEADER OH LEFT JOIN ONLINE_CUSTOMER OC ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
    LEFT JOIN ORDER_ITEMS OI  ON OI.ORDER_ID=OH.ORDER_ID
    LEFT JOIN ADDRESS AD ON OC.ADDRESS_ID=AD.ADDRESS_ID
WHERE 
	MOD(OH.ORDER_ID,2)=0 AND AD.PINCODE NOT IN 
											(SELECT
												AD.PINCODE
                                                FROM ADDRESS AD
                                                WHERE AD.PINCODE LIKE "5%");