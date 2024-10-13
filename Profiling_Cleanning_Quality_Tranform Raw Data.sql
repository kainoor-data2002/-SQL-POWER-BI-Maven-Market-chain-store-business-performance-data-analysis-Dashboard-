/*
-- ALL DATA 1998
SELECT*
FROM DOIT.MavenMarket_Customers AS MC
INNER JOIN DOIT.MavenMarket_Transactions_1998 AS MT98 ON MC.customer_id = MT98.customer_id
INNER JOIN DOIT.MavenMarket_Products AS MP ON MT98.product_id = MP.product_id
INNER JOIN DOIT.[MavenMarket_Returns_1997-1998] AS MR  ON MP.product_id = MR.product_id
INNER JOIN DOIT.MavenMarket_Stores AS MS ON MR.store_id = MS.store_id
INNER JOIN DOIT.MavenMarket_Regions AS MRE ON MS.region_id = MRE.region_id
-- ALL DATA 1997
SELECT*
FROM DOIT.MavenMarket_Customers AS MC
INNER JOIN DOIT.MavenMarket_Transactions_1997 AS MT97 ON MC.customer_id = MT97.customer_id
INNER JOIN DOIT.MavenMarket_Products AS MP ON MT97.product_id = MP.product_id
INNER JOIN DOIT.[MavenMarket_Returns_1997-1998] AS MR  ON MP.product_id = MR.product_id
INNER JOIN DOIT.MavenMarket_Stores AS MS ON MR.store_id = MS.store_id
INNER JOIN DOIT.MavenMarket_Regions AS MRE ON MS.region_id = MRE.region_id
*/


-------------------------------------------------------------------------------------------------------- DATA EXPLORING & CLEANING THAN ANALYTICS

----------------------------------------- DOIT.MavenMarket_Customers
SELECT *
FROM DOIT.MavenMarket_Customers 
-- I. EXPLORING

---- customer_country : Có 3 quốc gia chính: mexico, canada, usa
---- marital_status : Có 2 loại tình trạng hôn nhân: Single và Married
---- total_children: số lượng con cái trong gia đình
---- num_children_at_home: số lượng con cái còn ở nhà (chưa đi học, đi làm, có thể hiểu là còn quá nhỏ tuổi)
---- education: Bachelors degree - Cử nhân đại học; Partial high school - Chưa hoàn thành chương trình trung học phổ thông; Partial college - Chưa hoàn thành chương trình đại học; Graduate - degree: Bằng sau đại học; High school degree - bằng cấp 3

-- II. CLEANING
---- Kiểu tra kiểu dữ liệu từng cột (ổn)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'MavenMarket_Customers'
    AND TABLE_SCHEMA = 'DOIT';

---- Tạo 1 cột fullname = lastname + firstname
SELECT 
customer_id,	
customer_acct_num,	
first_name,	
last_name, 
first_name + ' ' + last_name as full_name,	-- tạo thêm full name
customer_address,	
customer_city,	
customer_state_province	,
customer_postal_code,	
customer_country,	
birthdate,
YEAR(birthdate)	as birth_year,
marital_status,	
yearly_income,	
gender,	
total_children,	
CASE 
    WHEN total_children <> 0 THEN 'Y'
    ELSE 'N'
END AS has_children,
num_children_at_home,	
education,	
acct_open_date,	
member_card,	
occupation,	
homeowner

FROM DOIT.Customers as MC 

---- Đổi tên bảng 
EXEC sp_rename 'DOIT.MavenMarket_Customers', 'Customers';


----------------------------------------- DOIT.MavenMarket_Products
SELECT *
FROM DOIT.MavenMarket_Products
-- I. EXPLORING
---- Kiểm tra kiểu dữ liệu các cột trong bảng (ổn)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'MavenMarket_Products'
    AND TABLE_SCHEMA = 'DOIT';


-- II. CLEANING
---- Product_name dang chứa các tên thương hiệu lẫn tên sản phẩm, vì vậy chúng ta phải tách chúng ra 
SELECT 
product_id,	
product_brand,	
product_name,	
LTRIM(REPLACE(product_name, product_brand, '')) AS Name_of_pro,
product_sku,
product_retail_price,	
product_cost,	
product_weight,	
recyclable,	
low_fat

FROM DOIT.MavenMarket_Products

---- Đếm số product_brand: 111 thương hiệu và name_of_pro: 1560 sản phẩm
with cte1 AS
(
SELECT 
product_id,	
product_brand,	
product_name,	
LTRIM(REPLACE(product_name, product_brand, '')) AS Name_of_pro,
product_sku,
product_retail_price,	
product_cost,
ROUND(product_retail_price*0.9, 2) as discount_price,	
product_weight,	
recyclable,	
low_fat

FROM DOIT.MavenMarket_Products
)

SELECT *
FROM cte1

--- Tính giá bán lẻ trung bình theo thương hiệu (AVG product_retail_price by product_brand) as Avg Retail Price
WITH cte1 AS
(
    SELECT 
        product_id,	
        product_brand,	
        product_name,	
        LTRIM(REPLACE(product_name, product_brand, '')) AS Name_of_pro,
        product_sku,
        product_retail_price,	
        product_cost,
        ROUND(product_retail_price * 0.9, 2) AS discount_price,	
        product_weight,	
        recyclable,	
        low_fat
    FROM DOIT.MavenMarket_Products
)

SELECT 
    cte1.product_id,
    cte1.product_brand,
    cte1.product_name,
    cte1.Name_of_pro,
    cte1.product_sku,
    cte1.product_retail_price,
    cte1.product_cost,
    cte1.discount_price,
    cte1.product_weight,
    cte1.recyclable,
    COALESCE(cte1.recyclable, 0) AS recyclable_new,
    cte1.low_fat,
    COALESCE(cte1.low_fat, 0) AS low_fat_new,
    ROUND(AVG(cte1.product_retail_price) OVER (PARTITION BY cte1.product_brand),2) AS Avg_Retail_Price
FROM cte1

---- Đổi tên bảng 
EXEC sp_rename 'DOIT.MavenMarket_Products', 'Products';



----------------------------------------- DOIT.MavenMarket_Stores
SELECT *
FROM DOIT.MavenMarket_Stores
-- I. EXPLORING
---- Kiểm tra kiểu dữ liệu các cột trong bảng (ổn)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'MavenMarket_Stores'
    AND TABLE_SCHEMA = 'DOIT';

-- II. CLEANING
SELECT
    store_id,	
    region_id,	
    store_type,	
    store_name,	
    store_street_address,	
    store_city,	
    store_state,	
    store_country,	
    CONCAT(store_city, ', ', store_state, ', ', store_country) AS full_address, -- FULL ADDRESS
    store_phone,
    CASE -- GET AREA_PHONE
        WHEN CHARINDEX('-', store_phone) > 0 
        THEN SUBSTRING(store_phone, 1, CHARINDEX('-', store_phone) - 1)
        ELSE store_phone
    END AS area_code,	
    first_opened_date,	
    last_remodel_date,	
    total_sqft,	
    grocery_sqft
FROM DOIT.MavenMarket_Stores


---- Đổi tên bảng 
EXEC sp_rename 'DOIT.MavenMarket_Stores', 'Stores';



----------------------------------------- DOIT.MavenMarket_Regions
SELECT *
FROM DOIT.MavenMarket_Regions
-- I. EXPLORING
---- Kiểm tra kiểu dữ liệu các cột trong bảng (ổn)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'MavenMarket_Regions'
    AND TABLE_SCHEMA = 'DOIT';



----------------------------------------- DOIT.MavenMarket_Calendar
SELECT *
FROM DOIT.MavenMarket_Calendar
-- I. EXPLORING
---- Kiểm tra kiểu dữ liệu các cột trong bảng (ổn)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'MavenMarket_Regions'
    AND TABLE_SCHEMA = 'DOIT';

-- II. CLEANING

---- Transform data ngày tháng năm theo dạng: Start of Week (starting Sunday), Name of Day, Start of Month, Name of Month, Quarter of Year, Year 
WITH
TIMER AS 
(
SELECT 
column1 AS month_t,
column2 AS day_d, 
column3 as year_y
FROM DOIT.MavenMarket_Calendar
)

SELECT
    T.*,
-- Create a date from the renamed columns
    CAST(CONCAT(year_y, '-', month_t, '-', day_d) AS DATE) AS full_date,

    -- Start of Week (Sunday)
    DATEADD(DAY, -(DATEPART(WEEKDAY, CAST(CONCAT(year_y, '-', month_t, '-', day_d) AS DATE)) - 1), CAST(CONCAT(year_y, '-', month_t, '-', day_d) AS DATE)) AS start_of_week,

    -- Name of Day
    DATENAME(WEEKDAY, CAST(CONCAT(year_y, '-', month_t, '-', day_d) AS DATE)) AS day_name,

    -- Start of Month
    DATEFROMPARTS(year_y, month_t, 1) AS start_of_month,

    -- Name of Month
    DATENAME(MONTH, CAST(CONCAT(year_y, '-', month_t, '-', day_d) AS DATE)) AS month_name,

    -- Quarter of Year
    DATEPART(QUARTER, CAST(CONCAT(year_y, '-', month_t, '-', day_d) AS DATE)) AS quarter_of_year



FROM TIMER AS T




----------------------------------------- DOIT.MavenMarket_Transactions_1997 and DOIT.MavenMarket_Transactions_1998
SELECT *
FROM DOIT.MavenMarket_Transactions_1997

SELECT *
FROM DOIT.MavenMarket_Transactions_1998


-- I. EXPLORING
---- Kiểm tra kiểu dữ liệu các cột trong bảng (ổn)
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'MavenMarket_Transactions_1997'
    AND TABLE_SCHEMA = 'DOIT';

----
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_NAME = 'MavenMarket_Transactions_1998'
    AND TABLE_SCHEMA = 'DOIT';

-- II. TRANSFORM
---- UNION ALL
SELECT *
FROM DOIT.MavenMarket_Transactions_1997

UNION ALL

SELECT *
FROM DOIT.MavenMarket_Transactions_1998;




---------------------
----------- Cleaning & Tranform data part 2
---- Thêm một cột có tên là "Weekend", trả về giá trị "Y" cho ngày thứ Bảy và Chủ Nhật, ngược lại là "N".
SELECT*
FROM MARKET.Calender_v2

ALTER TABLE MARKET.Calender_v2
ADD Weekend AS (
  CASE 
    WHEN DATENAME(WEEKDAY, full_date) IN ('Saturday', 'Sunday') THEN 'Y'
    ELSE 'N'
  END
);

---- Thêm một cột có tên là "End of Month", trả về ngày cuối cùng của tháng hiện tại cho mỗi hàng.
ALTER TABLE MARKET.Calender_v2
ADD End_of_Month AS (
  EOMONTH(full_date)
);


---- Thêm một cột có tên là "Current Age", tính toán tuổi hiện tại của khách hàng dựa trên cột "birthdate" và hàm TODAY() hoặc đến 1998.
SELECT *
FROM MARKET.Customers_v2

ALTER TABLE market.customers_v2
ADD Current_Age_1998 AS (
    DATEDIFF(YEAR, Birthdate, '1998-01-01')
);

---- Thêm một cột có tên là "Priority", trả về "High" cho những khách hàng sở hữu nhà và có thẻ thành viên "Golden", ngược lại là "Standard".
ALTER TABLE market.customers_v2
ADD Priority AS (
  CASE 
    WHEN homeowner = 'Y' AND member_card = 'Golden' THEN 'High'
    ELSE 'Standard'
  END
);


---- Thêm một cột có tên là "Short_Country", trả về ba ký tự đầu của quốc gia khách hàng, và chuyển tất cả thành chữ hoa.
ALTER TABLE market.customers_v2
ADD Short_Country AS (
  UPPER(LEFT(customer_Country, 3))
);

---- Thêm một cột có tên là "House Number", trích xuất tất cả các ký tự/số trước khoảng trắng đầu tiên trong cột "customer_address".
ALTER TABLE market.customers_v2
ADD House_Number AS (
  LEFT(customer_address, CHARINDEX(' ', customer_address) - 1)
);


---- Thêm một cột có tên là "Price_Tier", trả về "High" nếu giá bán lẻ > 3$, "Mid" nếu giá > 1$, và "Low" nếu ngược lại.
SELECT*
FROM MARKET.Products_v2

ALTER TABLE MARKET.Products_v2
ADD Price_Tier AS (
  CASE
    WHEN product_retail_price > 3 THEN 'High'
    WHEN product_retail_price > 1 THEN 'Mid'
    ELSE 'Low'
  END
);



---- Thêm một cột có tên là "Years_Since_Remodel", tính số năm giữa ngày hiện tại (TODAY()) và ngày lần cuối sửa chữa.
SELECT*
FROM MARKET.Stores_v2

ALTER TABLE MARKET.Stores_v2
ADD Years_Since_Remodel AS (
    DATEDIFF(YEAR, last_remodel_date, '1998-01-01')
);
