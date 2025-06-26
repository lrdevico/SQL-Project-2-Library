# Library Management System – SQL Project

This is my second SQL project using PostgreSQL, where I designed and implemented a complete library management system. The project includes schema creation, data import from files, complex SQL queries, and stored procedures to simulate core operations in a library.

## Features

- Normalized relational database schema:
  - Tables: `books`, `members`, `employees`, `branch`, `issued_status`, `return_status`
- Foreign key constraints for referential integrity
- Two-phase data population:
  - `insert_proj2.sql` contains full INSERT statements for realistic sample data
  - `.csv` files can also be used for loading data via bulk import
- Conversion of string-based status fields to Boolean
- Data manipulation operations: `INSERT`, `UPDATE`, `DELETE`
- Analytical queries:
  - Find overdue books and compute fines
  - Branch performance summaries
  - Damaged book tracking
  - Active member identification
- Summary tables using `CREATE TABLE AS`
- Two stored procedures:
  - `issue_book` — checks availability and processes book issuing
  - `add_return_records` — logs returns and updates book availability
- Queries demonstrating joins, aggregations, filtering, and logic branching with `CASE`

## File Structure

| File                  | Description                                             |
|-----------------------|---------------------------------------------------------|
| `project_2_lib.sql`   | Main SQL logic: schema creation, procedures, queries    |
| `insert_proj2.sql`    | Data population: INSERT statements for all tables       |
| `*.csv` files         | Optional data sources for bulk import (via pgAdmin)     |
| `README.md`           | Project documentation                                   |
| `.gitignore`          | Prevents tracking of temporary/system files             |

## Technologies

- PostgreSQL
- SQL (DDL, DML, PL/pgSQL)
- pgAdmin 4 (for development and testing)

## How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
