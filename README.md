# Advanced Database Implementation for Simpang Pasar Coffee Shop (SQL-Based System)

## Project Overview

This project implements a relational database system designed to manage operational data for Simpang Pasar Coffee Shop. The system was developed to support business processes such as transaction recording, inventory management, and customer data organization.

The database structure is designed using normalization principles and relational modeling to ensure data consistency, scalability, and efficient query performance.

This project demonstrates practical implementation of SQL for business data management and structured database system development.

---

## Objectives

The primary objectives of this project include:

- Designing a structured relational database for a small business
- Implementing SQL queries for managing operational data
- Ensuring data integrity through normalization and relational constraints
- Supporting daily business activities such as sales recording and inventory tracking

---

## Database System Design

The database system consists of several core entities that represent the coffee shop's operational data.

### Main Tables

- Customers  
Stores customer information including identification and contact data.

- Products  
Contains product details such as coffee menu items, prices, and categories.

- Orders  
Stores transaction records for each customer purchase.

- Order Details  
Contains detailed information for each product included in a transaction.

- Inventory  
Tracks stock levels for coffee ingredients and products.

- Employees  
Stores employee information related to store operations.

---

## Database Schema Example

- Customers

customer_id,
customer_name,
phone_number

- Products

product_id,
product_name,
category,
price

- Orders

order_id,
customer_id,
order_date,
total_price

- Order_Details

order_detail_id,
order_id,
product_id,
quantity,
subtotal

---

## Key SQL Features Implemented

The project demonstrates several advanced SQL concepts including:

- Table Creation using Relational Schema
- Primary Keys and Foreign Key Relationships
- Data Normalization
- Complex SQL Queries
- Data Aggregation and Reporting Queries
- Transaction Data Analysis

Example SQL operations implemented:

- SELECT queries for business reporting
- JOIN operations across multiple tables
- GROUP BY aggregation queries
- Filtering and sorting transaction data

---

## Example Analytical Query

Example query to calculate the most popular products:

```sql
SELECT product_name, SUM(quantity) AS total_sold
FROM Order_Details
JOIN Products ON Order_Details.product_id = Products.product_id
GROUP BY product_name
ORDER BY total_sold DESC;
```
---

## Technologies Used

- Database System → MySQL / PostgreSQL
- Development Tools → MySQL Workbench / DBMS tools
- Development Tools → MySQL Workbench / DBMS tools
- Version Control → Git & GitHubatabase Language

---

## Skills Demonstrated

This project demonstrates several technical competencies including:

- Relational Database Design
- SQL Query Development
- Database Normalization
- Data Modeling
- Business Data Analysis
- Database Documentation

---

## Learning Outcomes

Through this project, the following concepts were applied:

- Designing Relational Database Structures For Business Systems
- Implementing SQL Queries for Operational And Analytical Purposes
- Maintaining Data Integrity using Relational Constraints
- Translating Business Requirements into Structured Data Systems

---

## Future Improvements

Potential improvements for the system include:

- Integrating the database with a Web-Based Ordering Interface
- Implementing Stored Procedures and Triggers
- Building a Dashboard for Sales Analytics
- Developing an API Layer for Application Integration

---

## Author

Hans Alexander  
Informatics Engineering Student  
Interests: Data Science, SQL, and Intelligent Data Systems
