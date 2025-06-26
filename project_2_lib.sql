DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS temp_books;
CREATE TABLE temp_books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(3),
            author VARCHAR(30),
            publisher VARCHAR(30)
);

DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status BOOLEAN,
            author VARCHAR(30),
            publisher VARCHAR(30)
);

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
SELECT 
    isbn,
    book_title,
    category,
    rental_price,
    CASE 
        WHEN LOWER(status) = 'yes' THEN TRUE
        WHEN LOWER(status) = 'no' THEN FALSE
        ELSE NULL
    END, -- In case this was a larger dataset, having the status values set as boolean instead of a string would optimize the code.
    author,
    publisher
FROM temp_books;

DROP TABLE temp_books;

-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10)
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50)
);

ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;

-- Q1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

-- Q2. Update an Existing Member's Address
UPDATE members
SET members_address = 'Av. Nicodemos, 538'
WHERE member_id = 'C107'

-- Q3. Delete a Record from the Issued Status Table
DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- Q4. Retrieve All Books Issued by a Specific Employee
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

-- Q5.  List Members Who Have Issued More Than One Book 
SELECT issued_emp_id, COUNT(*)
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Q6. Create Summary Tables
CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_issued_cnt
ORDER BY issue_count DESC;

-- Q7. Retrieve All Books in a Specific Category
SELECT category, COUNT(*) AS total_books
FROM books
GROUP BY category; -- query to make sure that the amount of books are correct to the amount shown by the next query

SELECT * FROM books
WHERE category = 'Horror';

-- Q8. Find Total Rental Income by Category
SELECT category, SUM(rental_price), COUNT(*)
FROM books
GROUP BY category;

-- Q9. List Members Who Registered in the Last 180 Days
SELECT * FROM members;

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'; -- since the dataset goes only up to the year 2024, I'll set the first date to July 2022

SELECT * FROM members
WHERE reg_date >= DATE '2022-07-20' - INTERVAL '180 days';

-- Q10. List Employees with Their Branch Manager's Name and their branch details
SELECT e1.emp_id, e1.emp_name, e1.position, e1.salary, b.*, e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;

-- Q11. Create a Table of Books with Rental Price Above a Certain Threshold
CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books;

-- Q12. Retrieve the List of Books Not Yet Returned
SELECT DISTINCT ist.issued_book_name FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;


INSERT INTO issued_status(issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
VALUES
('IS151', 'C118', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '24 days',  '978-0-553-29698-2', 'E108'),
('IS152', 'C119', 'The Catcher in the Rye', CURRENT_DATE - INTERVAL '13 days',  '978-0-553-29698-2', 'E109'),
('IS153', 'C106', 'Pride and Prejudice', CURRENT_DATE - INTERVAL '7 days',  '978-0-14-143951-8', 'E107'),
('IS154', 'C105', 'The Road', CURRENT_DATE - INTERVAL '32 days',  '978-0-375-50167-0', 'E101');


ALTER TABLE return_status
ADD Column book_quality VARCHAR(15) DEFAULT('Good');

UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id 
    IN ('IS112', 'IS117', 'IS118');
SELECT * FROM return_status;

/* Q13. Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period).
Display the member's_id, member's name, book title, issue date, and days overdue. */
-- get members with issued status + books
-- check is the book hasnt been returned but only if it has passed more than 30 days

SELECT
m.member_id,
m.member_name,
ist.issued_date,
bk.book_title,
rs.return_date,
CURRENT_DATE - ist.issued_date AS overdue_days
FROM members AS m
JOIN issued_status AS ist
	ON m.member_id = ist.issued_member_id
JOIN books AS bk
	ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
	ON rs.issued_id = ist.issued_id
	WHERE rs.return_date IS NULL 
	AND (CURRENT_DATE - ist.issued_date) > 30
ORDER BY issued_date;

/* Q14. Write a query to update the status of 
books in the books table to "Yes" when they are returned (based on entries in the return_status table). 
*/


SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1'

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1'

SELECT * FROM return_status
WHERE issued_id = 'IS135'  -- doesnt show anything

-- testing 
UPDATE books
SET status = 'no' -- or 'yes' depending on the isbn being tested 
WHERE isbn = '978-0-307-58837-1'


CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$

CALL add_return_records('RS138', 'IS135', 'Good');

/* Q15.Create a query that generates a performance
report for each branch, showing the number of books issued,
the number of books returned, and the total revenue generated from book rentals.

I need to know which manager is in charge of each other employees 
(issued_status doesnt give me that, so ill probably use a JOIN for employees somewhere)


*/
SELECT * FROM branch;
CREATE TABLE branch_reports
AS
SELECT 
b.branch_id,
b.manager_id,
m.emp_name AS manager_name,
COUNT(ist.issued_id) AS number_of_book_issued,
COUNT(rs.return_id) AS number_of_book_return,
SUM(bk.rental_price) AS total_revenue,
ROUND(COUNT(rs.return_id)::decimal / COUNT(ist.issued_id), 2) AS return_rate
FROM issued_status AS ist
JOIN 
employees AS e
ON e.emp_id = ist.issued_emp_id
JOIN
branch AS b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status AS rs
ON rs.issued_id = ist.issued_id
JOIN 
books AS bk
ON ist.issued_book_isbn = bk.isbn
JOIN employees AS m
ON m.emp_id = b.manager_id
GROUP BY b.branch_id, b.manager_id, m.emp_name;

SELECT * FROM branch_reports;

/*
Q16. Use the CREATE TABLE AS (CTAS) statement to create a new table active_members 
containing members who have issued at least one book in the last 2 months. 
*/
SELECT * FROM issued_status

CREATE TABLE active_members
AS SELECT * FROM members
WHERE member_id IN (SELECT issued_member_id FROM issued_status
WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month')

SELECT * FROM active_members -- since the dataset is "old" it wont show any active_members

-- Q17. Find Employees with the Most Book Issues Processed
SELECT * FROM branch

SELECT
e.emp_id,
e.emp_name,
COUNT(issued_id) AS number_of_books_issued
FROM issued_status AS ist
JOIN employees AS e
ON e.emp_id = ist.issued_emp_id
GROUP BY e.emp_id, e.emp_name
ORDER BY number_of_books_issued DESC

/* Q18. Write a query to identify members who have issued books more than twice with the status 
"damaged" in the books table. Display the member name, book title, and the number of times they've
issued damaged books.
*/
SELECT
m.member_name,
ist.issued_member_id,
b.book_title,
COUNT(*) AS damaged_issues
FROM issued_status AS ist
JOIN members AS m
ON ist.issued_member_id = m.member_id
JOIN return_status AS rt
ON rt.issued_id = ist.issued_id
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
WHERE rt.book_quality = 'Damaged'
GROUP BY m.member_name, b.book_title, ist.issued_member_id
HAVING COUNT(*) > 2

-- some basic search to see if things make sense
SELECT * FROM members
SELECT * FROM return_status
SELECT * FROM issued_status
WHERE issued_id IN ('IS112', 'IS117', 'IS118')
SELECT * FROM books

/* Q.19 Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on 
its issuance. The procedure should function as follows: 
The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). If the book is available, 
it should be issued, and the status in the books table should be updated to 'no'. If the book is not 
available (status = 'no'),
the procedure should return an error message indicating that the book is currently not available.
*/

CREATE OR REPLACE PROCEDURE issue_book (p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10)) 
LANGUAGE plpgsql
AS $$
DECLARE v_status BOOLEAN;
BEGIN
SELECT status
INTO v_status
FROM books
WHERE isbn = p_issued_book_isbn;
IF v_status = TRUE THEN 
	INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
	VALUES (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);
	UPDATE books
	SET status = FALSE
	WHERE isbn = p_issued_book_isbn;
	RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;
ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

SELECT proname, proargtypes, proargnames
FROM pg_proc
WHERE proname ILIKE 'issue_book';

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-553-29698-2'

/* Q.20 Write a CTAS query to create a new table that lists each member and the books they have 
issued but not returned within 30 days. The table should include: The number of overdue books. The total
fines, with each day's fine calculated at $0.50. The number of books 
issued by each member. The resulting table 
should show: Member ID Number of overdue books Total fines
*/ 
CREATE TABLE overdue_search AS
SELECT
issued_member_id,
COUNT(CASE WHEN CURRENT_DATE - ist.issued_date > 30 AND b.status = FALSE
		THEN 1
	END) AS overdue_books,
COALESCE(
    SUM(
        CASE WHEN CURRENT_DATE - ist.issued_date > 30 AND b.status = FALSE
            THEN (CURRENT_DATE - ist.issued_date - 30) * 0.50
            ELSE 0
        END), 0) AS total_fines,
COUNT(ist.issued_id) AS total_books_issued
FROM issued_status AS ist
JOIN books AS b
ON b.isbn = ist.issued_book_isbn

GROUP BY ist.issued_member_id;


SELECT * FROM books
SELECT * FROM issued_status
