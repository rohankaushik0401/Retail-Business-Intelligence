
# Retail-Business-Intelligence
# Retail Intelligence & Decision Support System

An end-to-end retail analytics project combining **Python, SQL, statistical analysis, demand forecasting, inventory analytics, machine learning, and Power BI** to transform raw e-commerce data into actionable business intelligence.

> **Note:** This project is based on the Olist e-commerce dataset and is intended for analytics and portfolio purposes. Business thresholds and assumptions used in the analysis are project-specific unless explicitly stated otherwise.

---

## 📌 Project Overview

Retail businesses generate large volumes of transactional, customer, product, seller, logistics, and review data. However, raw transaction data alone does not directly answer questions such as:

* Which products and categories drive revenue?
* Which customers generate the most value?
* Where are retention risks concentrated?
* Which sellers have delivery or service-quality issues?
* Which products require inventory attention?
* How predictable is product demand?
* Can customer behavior be used for personalization?
* Can operational risks be predicted?
* How can all these insights be presented to management?

This project builds an **end-to-end retail intelligence system** that addresses these questions using multiple layers of analytics.

---

# 🎯 Objectives

The project was designed to:

* Build a structured analytical dataset from multiple raw e-commerce sources.
* Perform extensive data cleaning and feature engineering.
* Develop reusable analytical marts.
* Perform business-oriented SQL analysis.
* Analyze customer, product, seller, geographic and logistics behavior.
* Build demand forecasting capabilities.
* Develop inventory risk and replenishment analytics.
* Implement ABC–XYZ product classification.
* Apply machine learning to customer and operational problems.
* Build an interactive Power BI decision-support environment.
* Convert analytical outputs into actionable management insights.

---

# 🏗️ End-to-End Architecture

```text
Raw Olist Data
      │
      ▼
Data Cleaning & Integration
      │
      ▼
Feature Engineering
      │
      ▼
Analytical Data Marts
      │
      ├──────────────► SQL Analytics
      │
      ├──────────────► Statistical Analysis
      │
      ├──────────────► Demand Forecasting
      │
      ├──────────────► Inventory & ABC–XYZ
      │
      └──────────────► Machine Learning
                              │
                              ▼
                    Prediction / Segmentation
                              │
                              ▼
                     Power BI Semantic Model
                              │
                              ▼
                  Interactive Decision Dashboards
                              │
                              ▼
                    Business Recommendations
```

---

# 🗂️ Data Sources

The project uses the Olist e-commerce dataset and integrates information from multiple business entities, including:

* Customers
* Orders
* Order items
* Payments
* Products
* Sellers
* Reviews
* Geographic information
* Product-category translation

The integrated data was transformed into analytical structures used for customer, product, seller, geographic, inventory, demand and operational analysis.

---

# 🛠️ Technology Stack

| Technology         | Purpose                                                      |
| ------------------ | ------------------------------------------------------------ |
| **Python**         | Data preparation, analysis, forecasting and machine learning |
| **Pandas / NumPy** | Data manipulation and feature engineering                    |
| **Scikit-learn**   | Machine learning and clustering                              |
| **SQL / MySQL**    | Business analytics and analytical querying                   |
| **Power BI**       | Interactive BI and decision support                          |
| **DAX**            | Measures and analytical calculations                         |
| **Power Query**    | Data transformation and modelling                            |

---

# 🔄 Data Preparation & Feature Engineering

Multiple raw datasets were integrated into a consolidated analytical structure.

Key preparation activities included:

* Data type standardization
* Timestamp processing
* Missing-value handling
* Dataset joins
* Aggregation
* Transaction-level feature creation
* Customer-level features
* Seller-level features
* Product-level features
* Delivery metrics
* Revenue and freight metrics
* Geographic features
* Demand features
* Inventory-related features

Analytical marts were created to separate business domains and make downstream analysis more manageable.

---

# 📊 Business Analytics

The project includes analytical investigations across several business areas.

### Customer Analytics

* Customer purchasing behavior
* Repeat purchasing
* Customer value
* Revenue concentration
* Customer segmentation
* Retention risk

### Product & Category Analytics

* Revenue contribution
* Category performance
* Product demand
* Revenue concentration
* Product opportunity analysis

### Seller Analytics

* Seller revenue
* Order volume
* Delivery performance
* Customer satisfaction
* Seller performance comparison
* Seller risk identification

### Logistics Analytics

* Delivery-time distribution
* Geographic delivery performance
* Delivery vs customer satisfaction
* Operational risk identification

---

# 🧮 SQL Analytics

SQL was used to answer business-oriented analytical questions rather than simply demonstrate basic querying.

The analysis includes techniques such as:

* Aggregation
* Conditional logic
* CTEs
* Window functions
* Ranking
* Rolling metrics
* Comparative analysis
* Segmentation
* Performance benchmarking
* Operational analysis

The SQL layer was used to investigate customer, product, seller, demand and operational behavior.

---

# 📈 Statistical Analysis

Statistical methods were applied where they provided additional evidence beyond descriptive analysis.

The project includes statistical investigation of relationships between business variables and uses statistical results to distinguish measurable relationships from assumptions.

Where appropriate, statistical significance and practical business interpretation were considered separately.

---

# 🔮 Demand Forecasting

A demand forecasting workflow was developed to estimate future product demand.

The forecasting pipeline connects:

```text
Historical Demand
       ↓
Demand Preparation
       ↓
Eligible Product Selection
       ↓
Forecasting
       ↓
Forecast Evaluation
       ↓
Inventory Planning
```

Forecast outputs were subsequently used as inputs to inventory and demand-planning analysis.

---

# 📦 Inventory Intelligence

The project extends beyond simple stock reporting by connecting demand, inventory and replenishment risk.

Key concepts include:

* Current inventory
* Demand velocity
* Days of inventory cover
* Reorder requirements
* Inventory gaps
* Stock-risk classification
* Forecast demand
* Replenishment prioritization

The objective is to answer:

> **Which products require inventory attention, and why?**

---

# 🏷️ ABC–XYZ Analysis

Products were analyzed using two complementary dimensions:

### ABC — Business Importance

Classifies products according to their contribution to the selected business-value metric.

### XYZ — Demand Predictability

Classifies products according to demand variability.

The combined matrix produces categories such as:

```text
AX   AY   AZ
BX   BY   BZ
CX   CY   CZ
```

This allows inventory decisions to consider both:

**how important a product is** and **how predictable its demand is**.

---

# 🤖 Machine Learning

Machine learning was used to extend the project from descriptive/diagnostic analytics toward predictive decision support.

## 1. Recommendation System

A customer-product interaction framework was developed to identify products that could be recommended based on purchasing similarity.

The workflow includes:

```text
Customer Transactions
        ↓
Customer–Product Matrix
        ↓
Similarity Calculation
        ↓
Similar Products
        ↓
Recommendations
```

---

## 2. Delivery Delay Prediction

A classification model was developed to identify orders with elevated delivery-delay risk.

The objective is to support proactive logistics intervention rather than relying exclusively on post-delivery analysis.

---

## 3. Low Review Prediction

A machine-learning model was developed to identify situations associated with low customer review outcomes.

This provides a potential early-warning mechanism for customer-experience problems.

---

## 4. Seller Performance Prediction

Seller-level characteristics were used to investigate predictive classification of seller performance.

The project also identifies the methodological limitation of using features closely related to the target definition and highlights the need for temporal/historical feature construction in a production implementation.

---

## 5. Customer Segmentation

Customers were segmented using **RFM analysis + K-Means clustering**.

The framework considers:

* Recency
* Frequency
* Monetary value

Resulting customer groups include segments such as:

* Champions
* Loyal Customers
* Potential Loyalists
* At Risk
* Lost Customers

These segments provide a foundation for targeted retention and customer-value strategies.

---

# 📊 Power BI Decision Support

The final Power BI environment consists of **7 analytical pages**.

### 1. Executive Overview

Provides a high-level view of:

* Revenue
* Orders
* Customers
* AOV
* Reviews
* Delivery performance
* Business trends

### 2. Product & Category Intelligence

Focuses on:

* Category contribution
* Product economics
* Revenue concentration
* Category opportunities
* Product performance

### 3. Customer Intelligence & Retention

Analyzes:

* Customer value
* Repeat behavior
* RFM segments
* Retention risk
* Customer revenue contribution

### 4. Seller & Logistics Intelligence

Combines:

* Seller performance
* Delivery efficiency
* Geographic performance
* Customer satisfaction
* Operational risk

### 5. Inventory Control & Demand Planning

Connects:

```text
Demand → Forecast → Inventory → Coverage → Risk → Replenishment
```

### 6. ML Decision Support

Brings predictive outputs into the BI layer, including:

* Customer segmentation
* Recommendations
* Delivery risk
* Seller risk
* Customer-experience risk

### 7. Management Decision Dashboard

The final synthesis layer converts the project's analytical outputs into:

* Key business risks
* Opportunities
* Strategic KPIs
* Management actions
* Priority areas

---

# 🧠 Analytical Progression

The project follows a progression from understanding the business to supporting decisions:

```text
Descriptive
    ↓
What is happening?

Diagnostic
    ↓
Why is it happening?

Predictive
    ↓
What could happen?

Prescriptive / Decision Support
    ↓
What should be investigated or acted upon?
```

This progression is reflected in the movement from raw transactional analysis to forecasting, machine learning, inventory decisions and the final management dashboard.

---

# 💡 Key Business Questions Addressed

The project investigates questions such as:

* Which categories and products drive business value?
* How concentrated is revenue?
* Which customers contribute the greatest value?
* Where is customer retention risk concentrated?
* Which sellers create operational risk?
* Where are delivery problems geographically concentrated?
* Which products require replenishment?
* How predictable is product demand?
* Which products combine high business importance with unpredictable demand?
* Can customer behavior support personalized recommendations?
* Which operational outcomes can be predicted?
* How can analytical results be converted into management actions?

---

# ⚠️ Limitations

The project is based on a public e-commerce dataset and therefore has limitations compared with a production retail environment.

Important considerations include:

* Some inventory variables require project-specific assumptions because actual warehouse inventory history is not available in the source data.
* Forecasting quality depends on the available historical demand.
* Some business thresholds are analytical/project benchmarks rather than official company SLAs.
* Actual COGS is not available, so product price/payment values should not automatically be interpreted as profit.
* Certain predictive models require stronger temporal validation before production deployment.
* Seller-performance modeling requires particular attention to target leakage when performance labels are constructed from the same variables used as model predictors.

These limitations are treated as part of the analytical evaluation rather than being hidden.

---

# 🎯 Business Value

The project demonstrates how fragmented transactional data can be transformed into a connected analytical system covering:

**Customer → Product → Seller → Logistics → Demand → Inventory → Prediction → Management Decision**

Instead of stopping at dashboard visualization, the project combines:

* Data preparation
* SQL analytics
* Statistical reasoning
* Forecasting
* Inventory analytics
* Machine learning
* Business intelligence

to create a broader decision-support framework.

---

# 📁 Suggested Repository Structure

```text
retail-intelligence/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── python/
│   ├── data_preparation/
│   ├── feature_engineering/
│   ├── eda/
│   ├── forecasting/
│   └── machine_learning/
│
├── sql/
│   └── analytical_queries.sql
│
├── powerbi/
│   └── retail_intelligence.pbix
│
├── reports/
│   └── project_report.pdf
│
├── screenshots/
│
└── README.md
```
# Retail Intelligence & Decision Support System

An end-to-end retail analytics project combining **Python, SQL, statistical analysis, demand forecasting, inventory analytics, machine learning, and Power BI** to transform raw e-commerce data into actionable business intelligence.

> **Note:** This project is based on the Olist e-commerce dataset and is intended for analytics and portfolio purposes. Business thresholds and assumptions used in the analysis are project-specific unless explicitly stated otherwise.

---

## 📌 Project Overview

Retail businesses generate large volumes of transactional, customer, product, seller, logistics, and review data. However, raw transaction data alone does not directly answer questions such as:

* Which products and categories drive revenue?
* Which customers generate the most value?
* Where are retention risks concentrated?
* Which sellers have delivery or service-quality issues?
* Which products require inventory attention?
* How predictable is product demand?
* Can customer behavior be used for personalization?
* Can operational risks be predicted?
* How can all these insights be presented to management?

This project builds an **end-to-end retail intelligence system** that addresses these questions using multiple layers of analytics.

---

# 🎯 Objectives

The project was designed to:

* Build a structured analytical dataset from multiple raw e-commerce sources.
* Perform extensive data cleaning and feature engineering.
* Develop reusable analytical marts.
* Perform business-oriented SQL analysis.
* Analyze customer, product, seller, geographic and logistics behavior.
* Build demand forecasting capabilities.
* Develop inventory risk and replenishment analytics.
* Implement ABC–XYZ product classification.
* Apply machine learning to customer and operational problems.
* Build an interactive Power BI decision-support environment.
* Convert analytical outputs into actionable management insights.

---

# 🏗️ End-to-End Architecture

```text
Raw Olist Data
      │
      ▼
Data Cleaning & Integration
      │
      ▼
Feature Engineering
      │
      ▼
Analytical Data Marts
      │
      ├──────────────► SQL Analytics
      │
      ├──────────────► Statistical Analysis
      │
      ├──────────────► Demand Forecasting
      │
      ├──────────────► Inventory & ABC–XYZ
      │
      └──────────────► Machine Learning
                              │
                              ▼
                    Prediction / Segmentation
                              │
                              ▼
                     Power BI Semantic Model
                              │
                              ▼
                  Interactive Decision Dashboards
                              │
                              ▼
                    Business Recommendations
```

---

# 🗂️ Data Sources

The project uses the Olist e-commerce dataset and integrates information from multiple business entities, including:

* Customers
* Orders
* Order items
* Payments
* Products
* Sellers
* Reviews
* Geographic information
* Product-category translation

The integrated data was transformed into analytical structures used for customer, product, seller, geographic, inventory, demand and operational analysis.

---

# 🛠️ Technology Stack

| Technology         | Purpose                                                      |
| ------------------ | ------------------------------------------------------------ |
| **Python**         | Data preparation, analysis, forecasting and machine learning |
| **Pandas / NumPy** | Data manipulation and feature engineering                    |
| **Scikit-learn**   | Machine learning and clustering                              |
| **SQL / MySQL**    | Business analytics and analytical querying                   |
| **Power BI**       | Interactive BI and decision support                          |
| **DAX**            | Measures and analytical calculations                         |
| **Power Query**    | Data transformation and modelling                            |

---

# 🔄 Data Preparation & Feature Engineering

Multiple raw datasets were integrated into a consolidated analytical structure.

Key preparation activities included:

* Data type standardization
* Timestamp processing
* Missing-value handling
* Dataset joins
* Aggregation
* Transaction-level feature creation
* Customer-level features
* Seller-level features
* Product-level features
* Delivery metrics
* Revenue and freight metrics
* Geographic features
* Demand features
* Inventory-related features

Analytical marts were created to separate business domains and make downstream analysis more manageable.

---

# 📊 Business Analytics

The project includes analytical investigations across several business areas.

### Customer Analytics

* Customer purchasing behavior
* Repeat purchasing
* Customer value
* Revenue concentration
* Customer segmentation
* Retention risk

### Product & Category Analytics

* Revenue contribution
* Category performance
* Product demand
* Revenue concentration
* Product opportunity analysis

### Seller Analytics

* Seller revenue
* Order volume
* Delivery performance
* Customer satisfaction
* Seller performance comparison
* Seller risk identification

### Logistics Analytics

* Delivery-time distribution
* Geographic delivery performance
* Delivery vs customer satisfaction
* Operational risk identification

---

# 🧮 SQL Analytics

SQL was used to answer business-oriented analytical questions rather than simply demonstrate basic querying.

The analysis includes techniques such as:

* Aggregation
* Conditional logic
* CTEs
* Window functions
* Ranking
* Rolling metrics
* Comparative analysis
* Segmentation
* Performance benchmarking
* Operational analysis

The SQL layer was used to investigate customer, product, seller, demand and operational behavior.

---

# 📈 Statistical Analysis

Statistical methods were applied where they provided additional evidence beyond descriptive analysis.

The project includes statistical investigation of relationships between business variables and uses statistical results to distinguish measurable relationships from assumptions.

Where appropriate, statistical significance and practical business interpretation were considered separately.

---

# 🔮 Demand Forecasting

A demand forecasting workflow was developed to estimate future product demand.

The forecasting pipeline connects:

```text
Historical Demand
       ↓
Demand Preparation
       ↓
Eligible Product Selection
       ↓
Forecasting
       ↓
Forecast Evaluation
       ↓
Inventory Planning
```

Forecast outputs were subsequently used as inputs to inventory and demand-planning analysis.

---

# 📦 Inventory Intelligence

The project extends beyond simple stock reporting by connecting demand, inventory and replenishment risk.

Key concepts include:

* Current inventory
* Demand velocity
* Days of inventory cover
* Reorder requirements
* Inventory gaps
* Stock-risk classification
* Forecast demand
* Replenishment prioritization

The objective is to answer:

> **Which products require inventory attention, and why?**

---

# 🏷️ ABC–XYZ Analysis

Products were analyzed using two complementary dimensions:

### ABC — Business Importance

Classifies products according to their contribution to the selected business-value metric.

### XYZ — Demand Predictability

Classifies products according to demand variability.

The combined matrix produces categories such as:

```text
AX   AY   AZ
BX   BY   BZ
CX   CY   CZ
```

This allows inventory decisions to consider both:

**how important a product is** and **how predictable its demand is**.

---

# 🤖 Machine Learning

Machine learning was used to extend the project from descriptive/diagnostic analytics toward predictive decision support.

## 1. Recommendation System

A customer-product interaction framework was developed to identify products that could be recommended based on purchasing similarity.

The workflow includes:

```text
Customer Transactions
        ↓
Customer–Product Matrix
        ↓
Similarity Calculation
        ↓
Similar Products
        ↓
Recommendations
```

---

## 2. Delivery Delay Prediction

A classification model was developed to identify orders with elevated delivery-delay risk.

The objective is to support proactive logistics intervention rather than relying exclusively on post-delivery analysis.

---

## 3. Low Review Prediction

A machine-learning model was developed to identify situations associated with low customer review outcomes.

This provides a potential early-warning mechanism for customer-experience problems.

---

## 4. Seller Performance Prediction

Seller-level characteristics were used to investigate predictive classification of seller performance.

The project also identifies the methodological limitation of using features closely related to the target definition and highlights the need for temporal/historical feature construction in a production implementation.

---

## 5. Customer Segmentation

Customers were segmented using **RFM analysis + K-Means clustering**.

The framework considers:

* Recency
* Frequency
* Monetary value

Resulting customer groups include segments such as:

* Champions
* Loyal Customers
* Potential Loyalists
* At Risk
* Lost Customers

These segments provide a foundation for targeted retention and customer-value strategies.

---

# 📊 Power BI Decision Support

The final Power BI environment consists of **7 analytical pages**.

### 1. Executive Overview

Provides a high-level view of:

* Revenue
* Orders
* Customers
* AOV
* Reviews
* Delivery performance
* Business trends

### 2. Product & Category Intelligence

Focuses on:

* Category contribution
* Product economics
* Revenue concentration
* Category opportunities
* Product performance

### 3. Customer Intelligence & Retention

Analyzes:

* Customer value
* Repeat behavior
* RFM segments
* Retention risk
* Customer revenue contribution

### 4. Seller & Logistics Intelligence

Combines:

* Seller performance
* Delivery efficiency
* Geographic performance
* Customer satisfaction
* Operational risk

### 5. Inventory Control & Demand Planning

Connects:

```text
Demand → Forecast → Inventory → Coverage → Risk → Replenishment
```

### 6. ML Decision Support

Brings predictive outputs into the BI layer, including:

* Customer segmentation
* Recommendations
* Delivery risk
* Seller risk
* Customer-experience risk

### 7. Management Decision Dashboard

The final synthesis layer converts the project's analytical outputs into:

* Key business risks
* Opportunities
* Strategic KPIs
* Management actions
* Priority areas

---

# 🧠 Analytical Progression

The project follows a progression from understanding the business to supporting decisions:

```text
Descriptive
    ↓
What is happening?

Diagnostic
    ↓
Why is it happening?

Predictive
    ↓
What could happen?

Prescriptive / Decision Support
    ↓
What should be investigated or acted upon?
```

This progression is reflected in the movement from raw transactional analysis to forecasting, machine learning, inventory decisions and the final management dashboard.

---

# 💡 Key Business Questions Addressed

The project investigates questions such as:

* Which categories and products drive business value?
* How concentrated is revenue?
* Which customers contribute the greatest value?
* Where is customer retention risk concentrated?
* Which sellers create operational risk?
* Where are delivery problems geographically concentrated?
* Which products require replenishment?
* How predictable is product demand?
* Which products combine high business importance with unpredictable demand?
* Can customer behavior support personalized recommendations?
* Which operational outcomes can be predicted?
* How can analytical results be converted into management actions?

---

# ⚠️ Limitations

The project is based on a public e-commerce dataset and therefore has limitations compared with a production retail environment.

Important considerations include:

* Some inventory variables require project-specific assumptions because actual warehouse inventory history is not available in the source data.
* Forecasting quality depends on the available historical demand.
* Some business thresholds are analytical/project benchmarks rather than official company SLAs.
* Actual COGS is not available, so product price/payment values should not automatically be interpreted as profit.
* Certain predictive models require stronger temporal validation before production deployment.
* Seller-performance modeling requires particular attention to target leakage when performance labels are constructed from the same variables used as model predictors.

These limitations are treated as part of the analytical evaluation rather than being hidden.

---

# 🎯 Business Value

The project demonstrates how fragmented transactional data can be transformed into a connected analytical system covering:

**Customer → Product → Seller → Logistics → Demand → Inventory → Prediction → Management Decision**

Instead of stopping at dashboard visualization, the project combines:

* Data preparation
* SQL analytics
* Statistical reasoning
* Forecasting
* Inventory analytics
* Machine learning
* Business intelligence

to create a broader decision-support framework.

---

# 📁 Suggested Repository Structure

```text
retail-intelligence/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── python/
│   ├── data_preparation/
│   ├── feature_engineering/
│   ├── eda/
│   ├── forecasting/
│   └── machine_learning/
│
├── sql/
│   └── analytical_queries.sql
│
├── powerbi/
│   └── retail_intelligence.pbix
│
├── reports/
│   └── project_report.pdf
│
├── screenshots/
│
└── README.md
```
# Retail Intelligence & Decision Support System

An end-to-end retail analytics project combining **Python, SQL, statistical analysis, demand forecasting, inventory analytics, machine learning, and Power BI** to transform raw e-commerce data into actionable business intelligence.

> **Note:** This project is based on the Olist e-commerce dataset and is intended for analytics and portfolio purposes. Business thresholds and assumptions used in the analysis are project-specific unless explicitly stated otherwise.

---

## 📌 Project Overview

Retail businesses generate large volumes of transactional, customer, product, seller, logistics, and review data. However, raw transaction data alone does not directly answer questions such as:

* Which products and categories drive revenue?
* Which customers generate the most value?
* Where are retention risks concentrated?
* Which sellers have delivery or service-quality issues?
* Which products require inventory attention?
* How predictable is product demand?
* Can customer behavior be used for personalization?
* Can operational risks be predicted?
* How can all these insights be presented to management?

This project builds an **end-to-end retail intelligence system** that addresses these questions using multiple layers of analytics.

---

# 🎯 Objectives

The project was designed to:

* Build a structured analytical dataset from multiple raw e-commerce sources.
* Perform extensive data cleaning and feature engineering.
* Develop reusable analytical marts.
* Perform business-oriented SQL analysis.
* Analyze customer, product, seller, geographic and logistics behavior.
* Build demand forecasting capabilities.
* Develop inventory risk and replenishment analytics.
* Implement ABC–XYZ product classification.
* Apply machine learning to customer and operational problems.
* Build an interactive Power BI decision-support environment.
* Convert analytical outputs into actionable management insights.

---

# 🏗️ End-to-End Architecture

```text
Raw Olist Data
      │
      ▼
Data Cleaning & Integration
      │
      ▼
Feature Engineering
      │
      ▼
Analytical Data Marts
      │
      ├──────────────► SQL Analytics
      │
      ├──────────────► Statistical Analysis
      │
      ├──────────────► Demand Forecasting
      │
      ├──────────────► Inventory & ABC–XYZ
      │
      └──────────────► Machine Learning
                              │
                              ▼
                    Prediction / Segmentation
                              │
                              ▼
                     Power BI Semantic Model
                              │
                              ▼
                  Interactive Decision Dashboards
                              │
                              ▼
                    Business Recommendations
```

---

# 🗂️ Data Sources

The project uses the Olist e-commerce dataset and integrates information from multiple business entities, including:

* Customers
* Orders
* Order items
* Payments
* Products
* Sellers
* Reviews
* Geographic information
* Product-category translation

The integrated data was transformed into analytical structures used for customer, product, seller, geographic, inventory, demand and operational analysis.

---

# 🛠️ Technology Stack

| Technology         | Purpose                                                      |
| ------------------ | ------------------------------------------------------------ |
| **Python**         | Data preparation, analysis, forecasting and machine learning |
| **Pandas / NumPy** | Data manipulation and feature engineering                    |
| **Scikit-learn**   | Machine learning and clustering                              |
| **SQL / MySQL**    | Business analytics and analytical querying                   |
| **Power BI**       | Interactive BI and decision support                          |
| **DAX**            | Measures and analytical calculations                         |
| **Power Query**    | Data transformation and modelling                            |

---

# 🔄 Data Preparation & Feature Engineering

Multiple raw datasets were integrated into a consolidated analytical structure.

Key preparation activities included:

* Data type standardization
* Timestamp processing
* Missing-value handling
* Dataset joins
* Aggregation
* Transaction-level feature creation
* Customer-level features
* Seller-level features
* Product-level features
* Delivery metrics
* Revenue and freight metrics
* Geographic features
* Demand features
* Inventory-related features

Analytical marts were created to separate business domains and make downstream analysis more manageable.

---

# 📊 Business Analytics

The project includes analytical investigations across several business areas.

### Customer Analytics

* Customer purchasing behavior
* Repeat purchasing
* Customer value
* Revenue concentration
* Customer segmentation
* Retention risk

### Product & Category Analytics

* Revenue contribution
* Category performance
* Product demand
* Revenue concentration
* Product opportunity analysis

### Seller Analytics

* Seller revenue
* Order volume
* Delivery performance
* Customer satisfaction
* Seller performance comparison
* Seller risk identification

### Logistics Analytics

* Delivery-time distribution
* Geographic delivery performance
* Delivery vs customer satisfaction
* Operational risk identification

---

# 🧮 SQL Analytics

SQL was used to answer business-oriented analytical questions rather than simply demonstrate basic querying.

The analysis includes techniques such as:

* Aggregation
* Conditional logic
* CTEs
* Window functions
* Ranking
* Rolling metrics
* Comparative analysis
* Segmentation
* Performance benchmarking
* Operational analysis

The SQL layer was used to investigate customer, product, seller, demand and operational behavior.

---

# 📈 Statistical Analysis

Statistical methods were applied where they provided additional evidence beyond descriptive analysis.

The project includes statistical investigation of relationships between business variables and uses statistical results to distinguish measurable relationships from assumptions.

Where appropriate, statistical significance and practical business interpretation were considered separately.

---

# 🔮 Demand Forecasting

A demand forecasting workflow was developed to estimate future product demand.

The forecasting pipeline connects:

```text
Historical Demand
       ↓
Demand Preparation
       ↓
Eligible Product Selection
       ↓
Forecasting
       ↓
Forecast Evaluation
       ↓
Inventory Planning
```

Forecast outputs were subsequently used as inputs to inventory and demand-planning analysis.

---

# 📦 Inventory Intelligence

The project extends beyond simple stock reporting by connecting demand, inventory and replenishment risk.

Key concepts include:

* Current inventory
* Demand velocity
* Days of inventory cover
* Reorder requirements
* Inventory gaps
* Stock-risk classification
* Forecast demand
* Replenishment prioritization

The objective is to answer:

> **Which products require inventory attention, and why?**

---

# 🏷️ ABC–XYZ Analysis

Products were analyzed using two complementary dimensions:

### ABC — Business Importance

Classifies products according to their contribution to the selected business-value metric.

### XYZ — Demand Predictability

Classifies products according to demand variability.

The combined matrix produces categories such as:

```text
AX   AY   AZ
BX   BY   BZ
CX   CY   CZ
```

This allows inventory decisions to consider both:

**how important a product is** and **how predictable its demand is**.

---

# 🤖 Machine Learning

Machine learning was used to extend the project from descriptive/diagnostic analytics toward predictive decision support.

## 1. Recommendation System

A customer-product interaction framework was developed to identify products that could be recommended based on purchasing similarity.

The workflow includes:

```text
Customer Transactions
        ↓
Customer–Product Matrix
        ↓
Similarity Calculation
        ↓
Similar Products
        ↓
Recommendations
```

---

## 2. Delivery Delay Prediction

A classification model was developed to identify orders with elevated delivery-delay risk.

The objective is to support proactive logistics intervention rather than relying exclusively on post-delivery analysis.

---

## 3. Low Review Prediction

A machine-learning model was developed to identify situations associated with low customer review outcomes.

This provides a potential early-warning mechanism for customer-experience problems.

---

## 4. Seller Performance Prediction

Seller-level characteristics were used to investigate predictive classification of seller performance.

The project also identifies the methodological limitation of using features closely related to the target definition and highlights the need for temporal/historical feature construction in a production implementation.

---

## 5. Customer Segmentation

Customers were segmented using **RFM analysis + K-Means clustering**.

The framework considers:

* Recency
* Frequency
* Monetary value

Resulting customer groups include segments such as:

* Champions
* Loyal Customers
* Potential Loyalists
* At Risk
* Lost Customers

These segments provide a foundation for targeted retention and customer-value strategies.

---

# 📊 Power BI Decision Support

The final Power BI environment consists of **7 analytical pages**.

### 1. Executive Overview

Provides a high-level view of:

* Revenue
* Orders
* Customers
* AOV
* Reviews
* Delivery performance
* Business trends

### 2. Product & Category Intelligence

Focuses on:

* Category contribution
* Product economics
* Revenue concentration
* Category opportunities
* Product performance

### 3. Customer Intelligence & Retention

Analyzes:

* Customer value
* Repeat behavior
* RFM segments
* Retention risk
* Customer revenue contribution

### 4. Seller & Logistics Intelligence

Combines:

* Seller performance
* Delivery efficiency
* Geographic performance
* Customer satisfaction
* Operational risk

### 5. Inventory Control & Demand Planning

Connects:

```text
Demand → Forecast → Inventory → Coverage → Risk → Replenishment
```

### 6. ML Decision Support

Brings predictive outputs into the BI layer, including:

* Customer segmentation
* Recommendations
* Delivery risk
* Seller risk
* Customer-experience risk

### 7. Management Decision Dashboard

The final synthesis layer converts the project's analytical outputs into:

* Key business risks
* Opportunities
* Strategic KPIs
* Management actions
* Priority areas

---

# 🧠 Analytical Progression

The project follows a progression from understanding the business to supporting decisions:

```text
Descriptive
    ↓
What is happening?

Diagnostic
    ↓
Why is it happening?

Predictive
    ↓
What could happen?

Prescriptive / Decision Support
    ↓
What should be investigated or acted upon?
```

This progression is reflected in the movement from raw transactional analysis to forecasting, machine learning, inventory decisions and the final management dashboard.

---

# 💡 Key Business Questions Addressed

The project investigates questions such as:

* Which categories and products drive business value?
* How concentrated is revenue?
* Which customers contribute the greatest value?
* Where is customer retention risk concentrated?
* Which sellers create operational risk?
* Where are delivery problems geographically concentrated?
* Which products require replenishment?
* How predictable is product demand?
* Which products combine high business importance with unpredictable demand?
* Can customer behavior support personalized recommendations?
* Which operational outcomes can be predicted?
* How can analytical results be converted into management actions?

---

# ⚠️ Limitations

The project is based on a public e-commerce dataset and therefore has limitations compared with a production retail environment.

Important considerations include:

* Some inventory variables require project-specific assumptions because actual warehouse inventory history is not available in the source data.
* Forecasting quality depends on the available historical demand.
* Some business thresholds are analytical/project benchmarks rather than official company SLAs.
* Actual COGS is not available, so product price/payment values should not automatically be interpreted as profit.
* Certain predictive models require stronger temporal validation before production deployment.
* Seller-performance modeling requires particular attention to target leakage when performance labels are constructed from the same variables used as model predictors.

These limitations are treated as part of the analytical evaluation rather than being hidden.

---

# 🎯 Business Value

The project demonstrates how fragmented transactional data can be transformed into a connected analytical system covering:

**Customer → Product → Seller → Logistics → Demand → Inventory → Prediction → Management Decision**

Instead of stopping at dashboard visualization, the project combines:

* Data preparation
* SQL analytics
* Statistical reasoning
* Forecasting
* Inventory analytics
* Machine learning
* Business intelligence

to create a broader decision-support framework.

---

# 📁 Suggested Repository Structure

```text
retail-intelligence/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── python/
│   ├── data_preparation/
│   ├── feature_engineering/
│   ├── eda/
│   ├── forecasting/
│   └── machine_learning/
│
├── sql/
│   └── analytical_queries.sql
│
├── powerbi/
│   └── retail_intelligence.pbix
│
├── reports/
│   └── project_report.pdf
│
├── screenshots/
│
└── README.md

"C:\Users\RohanS\OneDrive\Desktop\Projects\retail project\PBI retail\Screenshot 2026-09-15 164349.png"
"C:\Users\RohanS\OneDrive\Desktop\Projects\retail project\PBI retail\Screenshot 2026-09-15 164423.png"
"C:\Users\RohanS\OneDrive\Desktop\Projects\retail project\PBI retail\Screenshot 2026-09-15 164437.png"
"C:\Users\RohanS\OneDrive\Desktop\Projects\retail project\PBI retail\Screenshot 2026-09-15 164437.png"
"C:\Users\RohanS\OneDrive\Desktop\Projects\retail project\PBI retail\Screenshot 2026-09-15 164519.png"
"C:\Users\RohanS\OneDrive\Desktop\Projects\retail project\PBI retail\Screenshot 2026-09-15 164542.png"
---

# 🚀 Project Outcome

The completed project provides an end-to-end analytical workflow capable of moving from raw retail transactions to business intelligence and decision support.

The key outcome is not a single model or dashboard, but the integration of multiple analytical layers into one system:

> **Data → Analytics → Prediction → Decision Support**

---

## 👤 Author

**Rohan Kaushik**

Data Analytics / Business Intelligence Portfolio Project

---

# 🚀 Project Outcome

The completed project provides an end-to-end analytical workflow capable of moving from raw retail transactions to business intelligence and decision support.

The key outcome is not a single model or dashboard, but the integration of multiple analytical layers into one system:

> **Data → Analytics → Prediction → Decision Support**

---

## 👤 Author

**Rohan Kaushik**

Data Analytics / Business Intelligence Portfolio Project

---

# 🚀 Project Outcome

The completed project provides an end-to-end analytical workflow capable of moving from raw retail transactions to business intelligence and decision support.

The key outcome is not a single model or dashboard, but the integration of multiple analytical layers into one system:

> **Data → Analytics → Prediction → Decision Support**

---

## 👤 Author

**Rohan Kaushik**

Data Analytics / Business Intelligence Portfolio Project
