# [SQL-PBI-Dashboard] Maven Market chain store business performance data analysis 

## About the project
Maven Market, a hypothetical multinational supermarket chain operating in Canada, Mexico, and the United States, offers a wide range of essential products, including food, beverages, household items, fashion, home goods, and electronics.

***Let’s say the leadership team at Maven Market has set key goals for analytics, focusing on the following:***

- Enable management to track key performance indicators (KPIs) such as sales, revenue, profit, and profit margin by audience
- Compare performance across different regions.
- Track revenue progress to achieve a 5% increase over the previous month’s revenue.

Additionally, additional insights can be gleaned through self-developed analytics on the topics of revenue, costs, profit, and profit margin for audiences, customer spending habits analysis, product and customer analysis

***This project follows a structured process, with each step contributing to a comprehensive data analysis:***

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

Here is my dashboard:
![Hình ảnh từ Google Drive](https://drive.google.com/uc?id=1g4u5FljBNho6XfrIzwi0wEbWcplNFaKB)

![Hình ảnh từ Google Drive](https://drive.google.com/uc?id=17PQjcP3YCswF6sAobrNwbwM9e4N7p_hx)

![Hình ảnh từ Google Drive](https://drive.google.com/uc?id=1CLCmKeAIk4i42hUNWia_kMaOBeft6kbb)

### VI. Insights And Recomendations

### Insight 01:

#### I. Overview of Sales (1997-1998):
- **Total Sales:** $1.76M, **Profit:** $1.05M, **Transactions:** 270K.
- **Sales Distribution by Country:**
  - **USA:** Dominates with 66-67% of total sales across age groups 31-50, 51-70, and above 70.
  - **Canada:** Lowest sales, around 6%.
- **Top-Selling Products (1997-1998):**
  - **Canada:** Thai Rice, AAA-Size Batteries.
  - **Mexico:** Rye Bread, Thai Rice, Apple Fruit Roll.
  - **USA:** Frying Pan, Thai Rice, Frozen Chicken Wings.
- **Monthly Sales Trends:**
  - **Canada:** Relatively stable, between $7K-$10K.
  - **Mexico:** Slight fluctuations, with significant growth in the last three months (from $37K to $49K).
  - **USA:** Strong surge in November and December (from $88K to $119K).
- **Customer Occupation Trends:** The highest sales came from customers with occupations like Manual, Skilled Manual, and Professional, especially Professionals.

#### II. Market Insights:
- **Top Products by Store Type:**
  - **Deluxe Supermarket:** Sugar Cookies, Thai Rice, AAA-Size Batteries.
  - **Gourmet Supermarket:** Sugar Cookies, Chicken Soup, Apple Fruit Roll.
  - **Mid-Size Grocery:** Raspberry Fruit Roll, Spaghetti, Plastic Knives.
  - **Small Grocery:** Chicken Soup, Low Fat Popcorn, Havarti Cheese.
  - **Supermarket:** Frying Pan, Popsicles, Thai Rice.
- **Sales Trends by Month:** Sales see a significant rise in the last three months (October to December), increasing from $118K to $177K, driven by end-of-year shopping events and increased consumer demand.
- **Profit Margin:** Slight decrease from 59.7% to 59.66% over two years, though relatively stable over the long term.

#### III. Business Recommendations:

1. **Enhance Year-End Marketing Campaigns:**
   - Focus on aggressive marketing during the last three months of the year when sales peak. Implement promotional campaigns aligned with major year-end events to boost sales further.

2. **Expand in Mexico and Canada:**
   - **Mexico** shows strong sales growth in the second half of the year. Increase distribution of top-selling products like Thai Rice and Apple Fruit Roll in large stores during this period.
   - **Canada** has lower sales, but still has growth potential. Develop localized strategies to better penetrate the market and cater to local preferences.

3. **Diversify Product Portfolio by Store Type:**
   - Focus on expanding key products for each store type, such as Thai Rice and AAA-size Batteries for Deluxe Supermarkets, and Chicken Soup and Havarti Cheese for Small Grocery stores. This will optimize the product offering and target the right customer base for each store category.

4. **Target Professional and Skilled Manual Customers:**
   - Leverage marketing strategies targeting these customer segments, as they contribute the highest sales. Further analyze their buying patterns to tailor products and services that cater to their needs.

5. **Optimize Profit Margins:**
   - Closely monitor profit margins to prevent further declines, particularly in high-sales periods. Focus on reducing production and operational costs without compromising product quality.

6. **Expand Loyalty Programs:**
   - Develop loyalty programs to retain customers, particularly in high-performing stores like Supermarkets and Gourmet Supermarkets, which generate significant sales volume. This will help boost customer retention and long-term growth.


### Insight 02:

#### I. Scatter Plot Insights: Relationship Between Revenue, Costs, and Profit Margins of Brands

1. **Size represents Revenue:**
- Products with larger sizes indicate higher revenue. It is evident that products with total costs ranging from $5,000 to $10,000 generally have larger sizes, meaning these products generate more revenue.
- Products with very high costs (above $15,000), despite their large size (high revenue), show profit margins ranging from 0.55 to 0.60. This suggests that high costs are affecting profit optimization, even though revenue remains high.

2. **Products with High Profit Margins (Above 0.60):**
- Some products have a profit margin above 0.60 but are smaller in size (lower revenue). This indicates that while these products have good profit margins, they are not major revenue drivers. You might need to focus on increasing marketing efforts for these products to exploit their profit potential.

3. ***Revenue Distribution Across Cost Groups:***
- High revenue is concentrated in the mid-cost range ($5,000 to $10,000). Products with lower costs (below $5,000) tend to be smaller in size, meaning they generate less revenue despite having relatively good profit margins.
- Products with high costs (above $15,000) are concentrated within specific brands and do not have outstanding profit margins, even though they generate significant revenue.
- Brands with mid-range costs ($5K-$15K) and relatively good profit margins (between 0.55 and 0.65) tend to generate medium to large revenues. These brands are the most stable revenue generators when compared to others, which show inconsistent revenues and profit margins.

4. ***Notable Brands:***
- **Hermanos**, **Tell Tale**, **Tri State**, **Ebony**, and products with costs above $15K appear as large data points (high revenue) and are focused on high-cost products. These brands might be employing a high-cost, high-revenue strategy but with relatively stable profit margins (around 0.55 to 0.65).
- **Dual City**, **Quick**, and **ADJ** have smaller points but with high profit margins (above 0.65), though their revenues are not as prominent. This may point to an opportunity to optimize marketing strategies to boost revenue for these products with good profit margins.

#### II. Business Recommendations:


1. ***Increase Investment in Mid-Cost Products with Medium to High Revenue:***
- Products with total costs ranging from $5,000 to $10,000 have larger sizes (generating medium to high revenue) and stable profit margins between 0.55 and 0.60. This group of products shows potential for sustainable value. Therefore, increasing investment in production, marketing, and distribution for these products could help expand revenue.

2. ***Optimize Profit Margins for High-Cost Products:***
- Products with costs above $15,000 generate high revenue but with lower profit margins. Consider optimizing production costs or revisiting product pricing to improve profit margins. Strategies like enhancing perceived customer value or reducing input costs could increase profitability without negatively impacting revenue.

3. ***Focus on Developing High-Profit Margin Products:***
- Products with high profit margins (above 0.60) but smaller sizes (lower revenue) need to be emphasized through marketing and distribution. Explore new markets or potential customer segments to increase sales for these products, better leveraging their profit potential.


### Insight 03:

#### I. Key insights

1. ***Majority of Customers are from the USA:***
- All but one customer are from the USA, with just one customer from Mexico. This indicates that the USA is the primary market with the highest number of transactions and total revenue.

2. ***High Transaction Volume Linked to Higher Profit:***
- Customers with a high number of transactions generally bring higher profit (e.g., customer #4676 has 301 transactions and a profit margin of 60.10%).

3. ***Top Customers Have Consistent Profit Margins:***
- All top customers have profit margins ranging from 59.28% to 60.19%, showing no significant variation in profit margins among the top customers.

4. ***Mexican Customer Shows Slightly Lower Profit Margin:***
- The single customer from Mexico has a profit margin of 59.32%, slightly lower compared to customers from the USA.

#### II. Business Recommendations:

1. ***Focus on Retaining Top USA Customers:***
- Since top customers in the USA have a high number of transactions and revenue, consider creating loyalty programs or offering special incentives to retain and increase their loyalty.

2. ***Boost Engagement with Mexican Customers:***
- With fewer transactions from Mexico, this market may be underutilized. The recommendation is to enhance marketing efforts or offer special promotions to stimulate growth in this market.

3. ***Further Analyze Profit Margins:***
- While profit margins are consistent, optimizing margins across specific customer segments could be beneficial. Further analysis of the products or services that customers are purchasing could help optimize profitability.

4. ***VIP Customer Program:***
- Introduce special rewards programs for customers with high transaction volumes and total revenue. You could offer discounts, gifts, or personalized services to maintain their loyalty and increase spending.

5. ***Leverage Customer Data for Personalized Experiences:***
- Use data on transaction volumes, total revenue, and country to offer personalized product recommendations for each customer. This could help increase repeat purchases and raise average order value.

### Insight 04:
#### 1. Key Insights:

1. ***Brands with the Highest Profit Margins:***
- Brands such as **ADJ**, **Quick**, and **Dual City** have the highest profit margins at 68.84%, 68.48%, and 67.54%, respectively. These brands generate significant profits without needing exceptionally high total revenue.

2. ***Transaction Volume Does Not Always Correlate with Profit Margins:***
- For example, **Plato** and **BBB Best** have the highest number of transactions and total revenue ($29,114.13), but their profit margin (63.55%) is still lower than brands with fewer transactions like **ADJ** and **Quick**. This suggests that while **Plato** and **BBB Best** have strong sales, their profitability is not as optimized as other brands.

3. ***Low Return Rates:***
- Most brands on the list have very low return rates, ranging from 0.96% to 1.31%. This indicates that these brands' products are of high quality, or customers are less likely to return the products.

#### II. Business Recommendations:

1. ***Focus on High-Profit Margin Brands:***
- Brands like **ADJ**, **Quick**, and **Dual City** should be prioritized in marketing and advertising efforts because they provide high profit margins without requiring high total revenue. Focusing on promoting products from these brands can help optimize overall profitability.

2. ***Reassess Pricing and Cost Strategies for High Revenue Brands:***
- For brands like **Plato** and **BBB Best**, while they generate substantial revenue, their profit margins are not as high as other brands. This suggests that re-evaluating their pricing strategies or optimizing production and operational costs could increase profit margins while maintaining high sales.

3. ***Continue Supporting Products with Low Return Rates:***
- With an average return rate of 0.96% to 1.31%, most products from these brands demonstrate stability in quality and customer satisfaction. This can help reduce operational and post-sale management costs.

4. ***Strengthen Loyalty Programs for Popular Brands:***
- Implement customer loyalty programs like offering reward points or discounts to repeat customers purchasing from these brands. This can help retain customer loyalty and drive further sales growth.

5. ***Explore New Markets for Lower Margin Brands:***
- For brands with slightly lower profit margins but high revenue, such as **Hermanos**, **Tell Tale**, and **Ebony**, focus on expanding into new markets to offset lower margins. Selling these products in markets with higher demand could improve profit margins.
















