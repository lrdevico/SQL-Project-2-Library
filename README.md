# Library Management System – SQL Project

This is my second SQL project using PostgreSQL, where I designed and implemented a complete library management system. The project includes schema creation, data import, complex queries, and stored procedures to simulate real-world operations in a library environment.

## Features

- Creation of normalized relational tables:
  - `books`, `members`, `employees`, `branches`, `issued_status`, `return_status`
- Enforcement of referential integrity using foreign key constraints
- Import and transformation of data from `.csv` files
- Conversion of textual status values to Boolean for optimized queries
- Data manipulation (INSERT, UPDATE, DELETE) and analytical SQL queries:
  - Identify overdue books and calculate fines
  - Branch-level performance reports
  - List of active members
  - Track damaged book returns
- Summary tables using `CREATE TABLE AS`
- Stored procedures in PL/pgSQL:
  - `issue_book`: issues a book only if available
  - `add_return_records`: registers returned books and updates their status
- Use of aggregate functions, joins, and subqueries to create management-level insights

## File Structure

| File                          | Description                                 |
|-------------------------------|---------------------------------------------|
| `project_2_lib.sql`           | Main SQL script with table creation, inserts, queries, and procedures |
| `books.csv`, `members.csv`, etc. | CSV datasets used to populate the database |
| `README.md`                   | Project documentation                       |
| `.gitignore`                  | Ignore unnecessary or temporary files       |

## Technologies

- PostgreSQL
- SQL (DDL, DML, PL/pgSQL)
- pgAdmin 4 (used for development)

## How to Run

1. Clone this repository:

