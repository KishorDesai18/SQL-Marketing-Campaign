-- Creating a base universe for marketing campaign reach analysis
DROP TABLE IF EXISTS marketing_analytics.campaign_engagement_base;

CREATE TABLE marketing_analytics.campaign_engagement_base AS (
    SELECT DISTINCT user_id
    FROM (
        SELECT DISTINCT e.user_id
        FROM (
            SELECT 
                CASE WHEN mdm_id IS NOT NULL THEN mdm_id ELSE customer_id END AS user_id
            FROM (
                SELECT * FROM (
                    SELECT DISTINCT customer_id
                    FROM marketing_analytics.customer_interaction_log
                    WHERE campaign_name = 'AdMarketX_Holiday_Campaign'
                    AND channel IN ('Email', 'Social Media', 'Website')
                    AND engagement_score > 50
                ) a
                LEFT JOIN marketing_analytics.master_customer_merge b
                ON a.customer_id = b.legacy_customer_id
            ) c
        ) e
        INNER JOIN (
            SELECT DISTINCT customer_id AS user_id
            FROM (
                SELECT DISTINCT customer_id
                FROM marketing_analytics.transaction_data
                WHERE transaction_date >= '2023-01-01' AND transaction_date < '2023-12-31'
                AND product_category IN ('Electronics', 'Apparel')
                UNION ALL
                SELECT DISTINCT customer_id
                FROM marketing_analytics.subscription_data
                WHERE subscription_start_date >= '2023-01-01' AND subscription_type = 'Premium'
            ) A
        ) b
        ON e.user_id = b.user_id
    ) d
);

-- Mapping customer location details for personalized marketing campaigns
DROP TABLE IF EXISTS marketing_analytics.campaign_engagement_location;

CREATE TABLE marketing_analytics.campaign_engagement_location AS (
    SELECT e.user_id, f.customer_name, e.address, e.city, e.state, e.zip, 
           CASE WHEN f.customer_segment IS NULL THEN 'New' ELSE 'Returning' END AS customer_type,
           f.preferred_channel, f.customer_segment
    FROM (
        SELECT c.user_id, d.address, d.city, d.state,
               LPAD(TRIM(d.zip), 5, '0') AS zip
        FROM (
            SELECT a.user_id, b.address_id
            FROM marketing_analytics.campaign_engagement_base a
            LEFT JOIN (
                SELECT * FROM marketing_analytics.customer_address_mapping
                WHERE is_primary_address = 'Y'
            ) b
            ON a.user_id = b.customer_id
            WHERE b.address_id IS NOT NULL
        ) c
        LEFT JOIN marketing_analytics.address_master d
        ON c.address_id = d.address_id
    ) e
    LEFT JOIN marketing_analytics.customer_profiles f
    ON e.user_id = f.customer_id
);

-- Mapping territory and segment information for targeted marketing
DROP TABLE IF EXISTS marketing_analytics.campaign_engagement_territory;

CREATE TABLE marketing_analytics.campaign_engagement_territory AS (
    SELECT e.user_id, e.customer_name, e.address, e.city, e.state, e.zip, e.customer_type,
           e.territory_id, e.territory_name, e.region_id, e.region_name, e.customer_segment,
           f.preferred_marketing_channel,
           CASE WHEN f.preferred_marketing_channel = 'Digital' THEN 'Online' 
                WHEN f.preferred_marketing_channel = 'Retail' THEN 'In-Store' 
                ELSE 'Unclassified' END AS marketing_channel
    FROM (
        SELECT c.user_id, c.customer_name, c.address, c.city, c.state, c.zip, c.customer_type,
               c.customer_segment, d.territory_id, d.territory_name, d.region_id, d.region_name
        FROM (
            SELECT a.*, b.territory_id, b.territory_name, b.region_id, b.region_name
            FROM marketing_analytics.campaign_engagement_location a
            LEFT JOIN marketing_analytics.territory_mapping b
            ON a.zip = b.zip
        ) c
        LEFT JOIN marketing_analytics.campaign_target_segments d
        ON c.user_id = d.customer_id
    ) e
    LEFT JOIN marketing_analytics.customer_preferences f
    ON e.user_id = f.customer_id;
);

-- Aggregating marketing campaign performance metrics
DROP TABLE IF EXISTS marketing_analytics.campaign_performance_summary;

CREATE TABLE marketing_analytics.campaign_performance_summary AS (
    SELECT campaign_name, week_date,
           COUNT(DISTINCT user_id) AS engaged_users,
           SUM(click_throughs) AS total_clicks,
           SUM(conversions) AS total_conversions,
           ROUND((SUM(conversions) * 100.0 / NULLIF(SUM(click_throughs), 0)), 2) AS conversion_rate
    FROM marketing_analytics.campaign_interactions
    WHERE campaign_name LIKE 'AdMarketX%'
    GROUP BY 1, 2
);

-- Extracting highly engaged customers for personalized follow-up
DROP TABLE IF EXISTS marketing_analytics.highly_engaged_customers;

CREATE TABLE marketing_analytics.highly_engaged_customers AS (
    SELECT user_id, customer_name, email, city, state,
           AVG(engagement_score) AS avg_engagement_score,
           COUNT(*) AS total_interactions
    FROM marketing_analytics.campaign_interactions
    WHERE engagement_score > 80
    GROUP BY 1, 2, 3, 4, 5
    HAVING COUNT(*) > 5
);

-- Marketing campaign reach and territory effectiveness analysis
DROP TABLE IF EXISTS marketing_analytics.campaign_reach_territory;

CREATE TABLE marketing_analytics.campaign_reach_territory AS (
    SELECT e.region_name, COUNT(DISTINCT e.user_id) AS engaged_users,
           SUM(f.click_throughs) AS total_clicks, SUM(f.conversions) AS total_conversions
    FROM marketing_analytics.campaign_engagement_territory e
    LEFT JOIN marketing_analytics.campaign_interactions f
    ON e.user_id = f.user_id
    GROUP BY 1
);
