/*Chapter 6*/
-- #1
SELECT vendor_id, SUM(invoice_total) AS Total_invoice
FROM invoices
GROUP BY vendor_id;

-- #2
SELECT vendor_name, SUM(payment_total) AS Total_Payment
FROM vendors JOIN invoices
ON vendors.vendor_id = invoices.vendor_id
GROUP BY vendor_name
ORDER BY payment_total DESC;

-- #3
SELECT vendor_name, COUNT(invoice_id) AS invoice_count, SUM(invoice_total) AS invoice_total
FROM vendors JOIN invoices
ON vendors.vendor_id = invoices.vendor_id
GROUP By vendor_name
ORDER BY invoice_count DESC;

-- #4
SELECT 
    account_description, 
	COUNT(line_item_amount) AS item_count,
    SUM(line_item_amount) as total_amount
FROM general_ledger_accounts gla JOIN invoice_line_items ili
	ON gla.account_number = ili.account_number
GROUP by account_description
HAVING item_count > 1
ORDER BY total_amount DESC;

-- #5
SELECT 
    account_description,
    COUNT(line_item_amount) AS item_count,
    SUM(line_item_amount) AS total_amount
FROM general_ledger_accounts gla 
JOIN invoice_line_items ili
    ON gla.account_number = ili.account_number
JOIN invoices i
    ON ili.invoice_id = i.invoice_id 
WHERE invoice_date BETWEEN "2018-04-01" AND "2018-06-30"
GROUP BY account_description
HAVING item_count > 1
ORDER BY total_amount DESC;

-- #6
SELECT account_number, SUM(line_item_amount) AS line_totals
FROM invoice_line_items
GROUP BY account_number WITH ROLLUP;

-- #7
SELECT vendor_name, COUNT( DISTINCT ILI.account_number) AS Accounts
FROM vendors 
JOIN invoices USING (vendor_id)
JOIN invoice_line_items ILI USING (invoice_id)
GROUP BY vendor_name
HAVING Accounts > 1;

/*Chapter 7*/

-- #1
SELECT DISTINCT vendor_name
FROM vendors
WHERE vendor_id IN
(
	SELECT vendor_id
	FROM invoices
)
ORDER BY vendor_name;

-- #2
SELECT invoice_number, invoice_total
FROM invoices
WHERE payment_total >
(
	SELECT AVG(payment_total) AS average_payment
	FROM invoices
	WHERE payment_total > 0
    -- 1733.729515
)
 ORDER BY invoice_total DESC;

-- #3
SELECT account_number, account_description
FROM general_ledger_accounts GLA
WHERE NOT EXISTS 
(
	SELECT *
    FROM invoice_line_items
    WHERE account_number = GLA.account_number
)
ORDER BY account_number;

-- #4
SELECT vendor_name, invoice_id, invoice_sequence, line_item_amount
FROM vendors 
JOIN invoices USING (vendor_id)
JOIN invoice_line_items USING (invoice_id)
WHERE invoice_id IN
(
	SELECT invoice_id
    FROM invoice_line_items
    WHERE invoice_sequence > 1
)
ORDER BY vendor_name, invoice_id, invoice_sequence;

-- #5a

SELECT vendor_id, MAX(invoice_total - payment_total - credit_total) AS unpaid
FROM invoices
WHERE (invoice_total - payment_total - credit_total) > 0
GROUP BY vendor_id;

-- #5b

SELECT SUM(unpaid) AS unpaid_sum
FROM
(
SELECT vendor_id, MAX(invoice_total - payment_total - credit_total) AS unpaid
FROM invoices
WHERE (invoice_total - payment_total - credit_total) > 0
GROUP BY vendor_id
) t;

-- #6

SELECT vendor_name, vendor_city, vendor_state
FROM 
	(SELECT *
	FROM vendors
	GROUP BY vendor_city, vendor_state
	HAVING COUNT(vendor_city) <= 1 
	)t 
ORDER BY vendor_state, vendor_city;

-- subquery test
SELECT vendor_name, vendor_city, vendor_state
FROM vendors
GROUP BY vendor_city, vendor_state
HAVING COUNT(vendor_city) <= 1 ;

-- #7
SELECT vendor_name, invoice_number, invoice_date, invoice_total
FROM vendors JOIN invoices i USING (vendor_id)
WHERE invoice_date = 
(
	-- returns the oldest invoice date
    SELECT MIN(invoice_date) 
	FROM invoices
	WHERE vendor_id = vendors.vendor_id
)
ORDER BY vendor_name;

-- #8

SELECT vendor_name, invoice_number, invoice_date, invoice_total
FROM vendors JOIN 
(
	SELECT vendor_id, invoice_number, MIN(invoice_date) AS "invoice_date", invoice_total
    FROM invoices
    GROUP BY vendor_id
)t USING (vendor_id)
ORDER BY vendor_name;
