# [SQL-PBI-Dashboard] Maven Market chain store business performance data analysis 

## About the project
Maven Market, a hypothetical multinational supermarket chain operating in Canada, Mexico, and the United States, offers a wide range of essential products, including food, beverages, household items, fashion, home goods, and electronics.

Assume the leadership team at Maven Market has set key objectives for the analysis, focusing on the following areas:

- Enabling management to track key performance indicators (KPIs) such as sales, revenue, profit, and profit margin.
- Comparing operational performance across different regions.
- Analyzing weekly transaction trends.
- Monitoring revenue progress to achieve a 5% increase compared to the previous month's revenue.

This project follows a structured process, with each step contributing to a comprehensive data analysis:

1. **Dataset Exploration:** Identifying the scope, relevant information, and actual data details through data profiling.
2. **Data Connection and Processing (ETL):** Using SQL to check for errors, inconsistencies, and data type mismatches to facilitate analysis. The transformation phase standardizes and cleanses the data to ensure accuracy (Data transformation and cleaning).
3. **Building a Relational Model:** Once cleaned, the data is organized into tables based on their unique relationships (Data modeling).
4. **Creating Calculated Fields:** Leveraging analytical methods (DAX) in Power BI to address business analysis needs by adding calculations and measures.
5. **Designing Visual Reports:** Visualizing the data, along with calculated measures, to uncover insights through comprehensive reporting (Visualization).

## Data Analysis Process

### I. Dataset Exploration

The initial dataset consists of eight tables stored in CSV format:

- MavenMarket_Calendar
- MavenMarket_Customers
- MavenMarket_Products
- MavenMarket_Regions
- MavenMarket_Returns_1997-1998
- MavenMarket_Stores
- MavenMarket_Transactions_1997
- MavenMarket_Transactions_1998

### II. Data Connection and Processing (ETL)

Data will be imported into SQL Server after creating a suitable database for storage. Azure Data Studio will be used to execute queries.

The process involves combining query syntax to handle invalid strings, correcting data types for various columns, and consolidating tables to calculate additional metrics. New columns will be created based on the original dataset. Detailed processing steps can be found in the file titled **“Profiling_Cleaning_Quality_Transform_Raw_Data.”**


### III. Building a Relational Model (Data Modeling)

#### 1. **Cardinality of Relationships**
All relationships adhered to a one-to-many cardinality, where primary keys resided on the lookup (Dimension) side, and foreign keys were located on the data (Fact) side.

#### 2. **Schema Design**
Both star and snowflake schemas were implemented to organize the data effectively.

#### 3. **Filter Context Flow**
The filter context flows "downstream" from the lookup tables to the data tables, ensuring that filters applied to dimension tables affect the corresponding fact tables.

#### 4. **Connection of Data Tables**
Data tables are connected through shared lookup tables rather than directly linking to one another, which maintains clarity in the data structure.

#### 5. **Visibility of Foreign Keys**
All foreign keys were made invisible to streamline the user experience and enhance the simplicity of the data model.

![Hình ảnh từ Google Drive](https://drive.google.com/uc?id=1Ph-eoMxyHaKT7exRl3DzHELRDZs1BLST)



### IV. Creating Measures and Calculations Using DAX

| Measure                | Description                                                                         | DAX Formula                                           |
|------------------------|-------------------------------------------------------------------------------------|-------------------------------------------------------|
| **Quantity Sold**      | Calculates the total quantity sold by summing the quantity from the Transactions table. | ```DAX Quantity_Sold = SUM(Transactions[Quantity])``` |
| **Quantity Returned**  | Computes the total quantity returned by summing the quantity from the Returns table.   | ```DAX Quantity_Returned = SUM(Returns[Quantity])```   |
| **Total Transactions** | Counts the number of rows in the Transactions table.                                  | ```DAX Total_Transactions = COUNTROWS(Transactions)```|
| **Total Returns**      | Counts the number of rows in the Returns table.                                       | ```DAX Total_Returns = COUNTROWS(Returns)```           |
| **Return Rate**        | Calculates the return rate based on the total number of transactions.                 | ```DAX Return_Rate = DIVIDE([Total_Returns], [Total_Transactions], 0)```|
| **All Transactions**   | Calculates the grand total of transactions, ignoring filters using the ALL function.  | ```DAX All_Transactions = CALCULATE([Total_Transactions], ALL(Transactions))```|
| **All Returns**        | Calculates the grand total of returns, ignoring filters using the ALL function.       | ```DAX All_Returns = CALCULATE([Total_Returns], ALL(Returns))```|
| **Total Revenue**      | Computes total revenue using the SUMX iterator and RELATED lookup function.           | ```DAX Total_Revenue = SUMX(Transactions, Transactions[Quantity] * RELATED(Products[Price]))```|
| **Total Cost**         | Computes total cost using the SUMX iterator and RELATED lookup function.              | ```DAX Total_Cost = SUMX(Transactions, Transactions[Quantity] * RELATED(Products[Cost]))```|
| **Total Profit**       | Calculates total profit as the difference between total revenue and total cost.       | ```DAX Total_Profit = [Total_Revenue] - [Total_Cost]```|
| **Profit Margin**      | Computes the profit margin by dividing total profit by total revenue.                 | ```DAX Profit_Margin = DIVIDE([Total_Profit], [Total_Revenue], 0)```|
| **YTD Revenue**        | Calculates year-to-date total revenue using the DATESYTD function.                    | ```DAX YTD_Revenue = CALCULATE([Total_Revenue], DATESYTD(Calendar[Date]))```|
| **Last Month Transactions** | Calculates transactions for the last month using CALCULATE and DATEADD functions.   | ```DAX Last_Month_Transactions = CALCULATE([Total_Transactions], DATEADD(Calendar[Date], -1, MONTH))```|
| **Last Month Revenue** | Calculates revenue for the last month using CALCULATE and DATEADD functions.          | ```DAX Last_Month_Revenue = CALCULATE([Total_Revenue], DATEADD(Calendar[Date], -1, MONTH))```|
| **Last Month Profit**  | Calculates profit for the last month using CALCULATE and DATEADD functions.           | ```DAX Last_Month_Profit = CALCULATE([Total_Profit], DATEADD(Calendar[Date], -1, MONTH))```|
| **Last Month Returns** | Calculates returns for the last month using CALCULATE and DATEADD functions.          | ```DAX Last_Month_Returns = CALCULATE([Total_Returns], DATEADD(Calendar[Date], -1, MONTH))```|
| **Revenue Target**     | Sets a target for revenue as a 5% increase over the previous month's revenue.         | ```DAX Revenue_Target = [Last_Month_Revenue] * 1.05```|


### V. Visualization

The visualization of data requires maximum attention as data can only communicate effectively when presented in a simple and meaningful way. For example, accessibility ethics are ensured by using gradient color schemes. Several charting tools are used, including:

- Gauge
- Slicer
- Card
- Donut chart
- 100% Stacked bar chart
- Stacked bar chart
- Matrix
- Map
- Stacked column chart

### VI. Insights

1. **Top performing brand in sales:** Hermanos
2. **Top 5 profit-generating brands:** ADJ, Quick, Dual City, Akron, Plato, with profit margins ranging from 64% to 69%
3. **Brand facing the highest return rate:** King with 2%
4. Female customers aged 31-70 contribute the highest sales, accounting for more than 50% of total revenue.
5. Customers aged 18-30 generate the lowest sales.
6. The country with the highest sales is the USA, while Canada has the lowest sales.
7. The city with the highest sales is Spokane, while the lowest sales are found in Mill Valley, San Francisco, Oakland, and Redwood City in the USA.
8. The city with the highest sales in Canada is Langley, and the lowest is Royal Oak.
9. The top 3 customer occupations influencing sales the most are **Professional**, **Skilled Manual**, and **Manual**.
10. The customer occupation with the least impact on sales is **Clerical**.
11. It was observed that early-week days during the winter months (end of the year) generate the highest sales.

### VII. Recommendations

#### 1. **Optimize product lines based on performance**

- **Insight**: The "Hermanos" brand is the best-selling brand, and the brands "ADJ," "Quick," "Dual City," "Akron," and "Plato" have the highest profit margins (64%-69%).
- **Strategy**: Increase promotion and distribution for brands that generate **high revenue and large profits**, such as Hermanos, ADJ, and Quick. In particular, **focus on promotional programs** for these brands in areas with low sales to improve sales performance.
  - **Idea**: Design **promotional campaigns tied to top brands** like Hermanos and ADJ, combined with **increased online sales** to attract potential customer groups while encouraging the purchase of high-profit margin products.

#### 2. **Reduce product return rates**

- **Insight**: The "King" brand has the highest product return rate (2%).
- **Strategy**: Conduct a **quality assessment of King products** to identify specific issues. Also, consider adjusting or **restructuring this product line** to reduce return rates and improve brand image.
  - **Idea**: Implement a **hassle-free return program** for King products and offer **special incentives** for customers to continue purchasing other products, minimizing the negative impact of return rates.

#### 3. **Focus on female customers aged 31-70**

- **Insight**: Female customers aged 31-70 contribute over 50% of total sales.
- **Strategy**: Develop **personalized marketing and promotional programs** targeting this customer group, enhancing the shopping experience, and building a loyalty program specifically for women in this age group.
  - **Idea**: Create **special product packages** and **prioritize customer service** for women in this age range, along with developing a **personalized mobile app** to provide product recommendations based on previous shopping preferences and behavior.

#### 4. **Develop a strategy to engage younger customers (18-30)**

- **Insight**: Customers aged 18-30 generate the lowest sales.
- **Strategy**: Launch **marketing campaigns targeting younger customers**, with suitable products and pricing strategies that match their spending capabilities. Social media platforms can be used to **boost brand awareness** among this audience.
  - **Idea**: Create **flash sale promotions** on online channels and social media, while collaborating with **influencers** and digital marketing campaigns to attract the attention of this younger age group.

#### 5. **Enhance presence in Canada**

- **Insight**: Canada has the lowest sales among the three countries, especially in Royal Oak.
- **Strategy**: Analyze the factors leading to low sales in Canada and focus on cities with potential, such as Langley. Build a **market development strategy** aimed at increasing brand awareness and improving customer experience in Canada.
  - **Idea**: **Host community events** and major discount programs in areas with low sales. Simultaneously, boost **brand promotion through exclusive promotions** and **offers specifically for Canadian customers**.

#### 6. **Enhance services in the USA, especially in Spokane**

- **Insight**: Spokane has the highest sales in the USA, while cities such as Mill Valley, San Francisco, Oakland, and Redwood City have low sales.
- **Strategy**: **Expand services** and increase the **loyalty program** in Spokane to capitalize on the strong market, while also **boosting promotions and advertisements** in cities with lower sales.
  - **Idea**: **Open new branches** or **online sales points** in Spokane, along with local **advertising events** in lower-performing areas to increase awareness and attract new customers.

#### 7. **Focus on occupations that drive high sales**

- **Insight**: Occupations such as Professional, Skilled Manual, and Manual have the greatest impact on sales.
- **Strategy**: Develop **specialized programs** for these professions, such as exclusive offers for professionals and skilled workers, and enhance advertising in areas where these occupations are concentrated.
  - **Idea**: **Develop a career-specific discount program** tailored to these professions, including periodic discounts or special gifts for high-sales customer groups.

#### 8. **Capitalize on opportunities during the winter months**

- **Insight**: Early-week days during the winter months (end of the year) generate the highest sales.
- **Strategy**: Focus on **winter advertising and promotional campaigns**, particularly on early-week days, to increase revenue, while **optimizing the supply chain** and preparing for the peak season.
  - **Idea**: Develop **special winter campaigns** with offers exclusive to early-week days, combined with **free shipping** or **incentives for online transactions** during this period.






