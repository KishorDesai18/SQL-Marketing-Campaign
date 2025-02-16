# SQL-Marketing-Campaign

This project analyzes the performance of marketing campaigns for AdMarketX, a digital marketing company focused on customer engagement. The SQL-based analysis tracks campaign reach, customer engagement, and territory-wise performance to optimize marketing strategies.  

**Objectives**  

•	Identify highly engaged customers based on marketing interactions.  
•	Analyze weekly and monthly campaign performance metrics (click-throughs, conversions, engagement rates).  
•	Map customer interactions to geographic territories for targeted marketing.  
•	Aggregate multi-channel marketing effectiveness (email, social media, website).  
•	Track conversion trends and high-performing regions.  

**Dataset Description**

•	customer_interaction_log: Records user engagements (clicks, conversions, visits).  
•	transaction_data: Contains purchase and subscription details.  
•	subscription_data: Tracks premium customer sign-ups.  
•	territory_mapping: Maps customers to sales territories and regions.  
•	campaign_interactions: Logs campaign performance across multiple channels.  
•	customer_profiles: Stores demographic and preference-based segmentation.  

**Key SQL Queries and Their Purpose**  

1. Campaign Engagement Base  
•	Extracts customers who interacted with the AdMarketX Holiday Campaign. 
•	Filters users based on their engagement score and channel preference.

2. Customer Location Mapping  
•	Maps customer IDs to addresses for personalized targeting.  
•	Segments customers as new or returning based on interaction history.

3. Territory-Based Analysis  
•	Assigns customers to sales regions and determines their marketing segment.  
•	Categorizes users into Digital, Retail, and Unclassified based on their marketing channel preference.
 
4. Campaign Performance Summary  
•	Aggregates campaign-level engagement, click-throughs, and conversion rates.    
•	Helps in identifying high-impact marketing efforts.

5. Highly Engaged Customer Extraction   
•	Identifies customers with engagement scores above 80.  
•	Extracts repeat interactions to target loyal customers.

6. Marketing Campaign Reach and Territory Effectiveness  
•	Compares regional campaign effectiveness by counting engaged users.  
•	Analyzes the total clicks and conversions per region.
   
**Expected Outcomes**   

•	Customer Insights: Identify high-value users for personalized marketing.  
•	Region-Based Performance: Optimize marketing efforts in high-converting regions.  
•	Channel Performance Tracking: Improve ROI by adjusting marketing strategies.  
•	Campaign Efficiency: Enhance campaign effectiveness based on real-time data.  
