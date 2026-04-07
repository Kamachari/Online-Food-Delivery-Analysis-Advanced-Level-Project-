# 🍔 Online Food Delivery Advanced Analytics — SQL Project 2

> An intermediate-to-advanced SQL analytics project applying window functions, CTEs, views, customer segmentation, and revenue leaderboards to an online food delivery platform dataset.

**Level:** 🟡 Advanced | **Status:** ✅ Complete | **Part:** 2 of 3

---

## 🔗 Demo Link

> _Data visualisations and dashboards built from this project are available via Power BI / Google Sheets / Excel. Screenshots are in the `/Screenshots` folder._

---

## 📑 Table of Contents

- [Business Understanding](#business-understanding)
- [Data Understanding](#data-understanding)
- [Screenshots](#screenshots)
- [Technologies](#technologies)
- [Setup](#setup)
- [Approach](#approach)
- [Status](#status)
- [Credits](#credits)

---

## 💼 Business Understanding

Having established foundational metrics in Project 1, this project goes deeper — answering strategic business questions that require advanced SQL techniques. Businesses need more than just counts and sums; they need to understand customer loyalty, restaurant rankings, menu dead weight, and time-based behavioural patterns.

**Goal:** Apply advanced SQL analytics to the online food delivery dataset to produce actionable business intelligence — including customer classification, restaurant revenue rankings, trend analysis, and reusable database objects for reporting.

**Why this project?**
This is the second project in a 3-part SQL portfolio series, bridging beginner SQL and a full enterprise analytics system. It demonstrates proficiency in:
- Window functions (`RANK()`, `ROW_NUMBER()`, `SUM OVER`)
- Conditional logic with `CASE WHEN` for business segmentation
- Reusable database objects: **temporary tables** and **views**
- Connecting SQL outputs to visualisation tools (Power BI / Excel / Google Sheets)

**Challenges faced:**
- Designing CASE WHEN logic that accurately reflects real business classification rules
- Using window functions correctly to rank restaurants without losing other columns
- Identifying "never ordered" menu items requires understanding LEFT JOIN and NULL filtering
- Building views and temp tables that are efficient enough for repeated use in reporting

---

## 📊 Data Understanding

### Datasets Used
This project uses the same **5 relational tables** as Project 1:

| Table | Description |
|---|---|
| `Customers` | Customer details including signup dates and city |
| `Orders` | Transaction records with order date and customer ID |
| `Menu_Items` | List of food items offered by restaurants with pricing |
| `Order_Details` | Line-item breakdown of items ordered per transaction |
| `Restaurants` | Restaurant information including city and menu offerings |

### Dataset Relationships
```
Customers ──< Orders ──< Order_Details >── Menu_Items
                │
            Restaurants
```

### Advanced Analysis Enabled By This Dataset
- **Customer signup year** → Early Bird / Regular / New classification
- **Order frequency per customer** → Loyal vs one-time customer detection
- **Menu item order counts** → Dead stock identification (never ordered items)
- **Restaurant menu size** → Small / Medium / Large categorisation
- **Revenue per restaurant** → Leaderboard with window functions

**Future enhancements:**
- Automate customer reclassification as new orders come in *(trigger logic in Project 3)*
- Add delivery performance metrics *(covered in Project 3)*
- Expand the revenue leaderboard into a live Power BI dashboard

---

## 📸 Screenshots

> Visualisation outputs (Power BI / Excel / Google Sheets) and query result screenshots are in the `/Screenshots` folder.

---

## 🛠️ Technologies

| Tool | Purpose |
|---|---|
| **MySQL 8.x** | Relational database engine — window functions, CTEs, views |
| **VS Code** | Primary development IDE |
| **SQLTools Extension** | MySQL connection and query execution within VS Code |
| **SQLTools MySQL/MariaDB Driver** | VS Code driver to connect to MySQL server |
| **MySQL Workbench** | Backend MySQL server (connected via SQLTools) |
| **Power BI / Google Sheets / Excel** | Data visualisation of query outputs |
| **Git & GitHub** | Version control and project showcase |

---

## ⚙️ Setup

### Prerequisites
- MySQL Server installed and running (port 3306)
- VS Code with SQLTools + MySQL Driver installed
- *(Optional)* Power BI Desktop or Google Sheets for visualisations

### Step 1 — Clone the Repository
```bash
git clone https://github.com/BuragapalliKamachari/online-food-delivery-sql-project-2.git
cd online-food-delivery-sql-project-2
```

### Step 2 — Configure SQLTools in VS Code
1. Open VS Code → Click the **SQLTools icon** in the Activity Bar
2. Select **Add New Connection** → Choose **MySQL**
3. Enter connection details:
   - Host: `localhost`
   - Port: `3306`
   - Username: `root`
   - Password: _(your MySQL root password)_
4. Click **Test Connection** → **Save**

### Step 3 — Run SQL Scripts in Order
```
1. Database_Creation.sql        ← Use existing DB from Project 1 or recreate
2. Table_Creation.sql           ← Ensure all 5 tables exist with data
3. Advanced_Analysis.sql        ← Run all 10 advanced problem statements
4. Views_TempTables.sql         ← Create views and temporary tables
5. Revenue_Leaderboard.sql      ← Window function leaderboard queries
```

### Step 4 — Visualise Results *(Optional)*
- Export query results as CSV from SQLTools
- Import into Power BI / Google Sheets / Excel
- Build charts for monthly trends, revenue rankings, and customer segments

---

## 🔍 Approach

This project follows the **Data Analysis Lifecycle**: Define → Collect → Analyse → Model → Visualise → Report.

### Phase 1 — Customer Intelligence

| # | Problem Statement | SQL Technique |
|---|---|---|
| 1 | Classify customers by signup year (Early Bird / Regular / New) | `CASE WHEN`, `YEAR()` |
| 2 | Identify customers with maximum orders | `COUNT`, `ORDER BY`, `LIMIT` |
| 6 | Detect one-time customers | `HAVING COUNT(*) = 1` |

**Customer Classification Logic:**
```sql
CASE
  WHEN YEAR(signup_date) <= 2020 THEN 'Early Bird'
  WHEN YEAR(signup_date) BETWEEN 2021 AND 2022 THEN 'Regular'
  ELSE 'New'
END AS customer_category
```

### Phase 2 — Restaurant Intelligence

| # | Problem Statement | SQL Technique |
|---|---|---|
| 3 | Rank restaurants by revenue performance | `RANK()`, Window Functions |
| 7 | Categorise restaurants by menu size (Small/Medium/Large) | `CASE WHEN`, `COUNT` |
| 9 | Build revenue leaderboard | `SUM() OVER`, `RANK() OVER` |

**Restaurant Size Classification Logic:**
```sql
CASE
  WHEN menu_item_count < 10 THEN 'Small'
  WHEN menu_item_count BETWEEN 10 AND 20 THEN 'Medium'
  ELSE 'Large'
END AS restaurant_size
```

### Phase 3 — Menu & Order Analysis

| # | Problem Statement | SQL Technique |
|---|---|---|
| 4 | Find menu items never ordered | `LEFT JOIN`, `WHERE IS NULL` |
| 5 | Monthly and weekly order trends | `MONTH()`, `WEEK()`, `GROUP BY` |

### Phase 4 — Database Objects

| # | Object | Purpose |
|---|---|---|
| 8 | Temporary Tables | Store intermediate results for complex multi-step analysis |
| 8 | Views | Create reusable virtual tables for reporting and dashboards |
| 10 | Visualisation Export | Connect SQL outputs to Power BI / Google Sheets / Excel |

### Phase 5 — Visualisation
- Monthly trend charts (line chart — orders over time)
- Revenue leaderboard (bar chart — top restaurants)
- Customer segment distribution (pie chart — Early Bird / Regular / New)

---

## 📌 Status

```
✅ Complete — Jan 2026
```
This is **Part 2 of 3** in the Online Food Delivery SQL Portfolio Series:
- ✅ Project 1 — Beginner Analysis
- ✅ Project 2 — Advanced Analytics ← You are here
- 🔄 Project 3 — Business Analytics System (In Progress)

---

## 🙏 Credits

| Contributor | Role |
|---|---|
| **Buragapalli Kamachari** | Project Author — Advanced SQL Development & Analytics |
| **MySQL Documentation** | Reference for window functions, CTEs, and views |
| **SQLTools by Matheus Teixeira** | VS Code MySQL integration extension |
| **Power BI / Google / Microsoft** | Visualisation platforms used for reporting |
| **GitHub** | Repository hosting and portfolio showcase |

---

*Online Food Delivery SQL Project 2 of 3 | Buragapalli Kamachari | Jan 2026*
