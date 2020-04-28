/*Chapter 4*/
-- #1
SELECT *
FROM vendors
	JOIN invoices USING (vendor_id);

-- #2
SELECT vendor_name, invoice_number, invoice_date,
	invoice_total - payment_total - credit_total AS balance_due
FROM vendors v
	JOIN invoices i USING (vendor_id)
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY vendor_name;

-- #3
SELECT vendor_name, default_account_number AS default_account,
	account_description AS "description"
FROM vendors v
	JOIN general_ledger_accounts gla
		ON v.default_account_number = gla.account_number
ORDER BY account_description, vendor_name;

-- #4
SELECT vendor_name, invoice_date, invoice_number,
	invoice_sequence AS li_sequence, 
    line_item_amount AS li_amount
FROM vendors v
	JOIN invoices i 
		ON v.vendor_id = i.vendor_id
    JOIN invoice_line_items li 
		ON i.invoice_id = li.invoice_id
ORDER BY vendor_name, invoice_date, invoice_number, li_sequence;

-- #5
SELECT DISTINCT v.vendor_id, v.vendor_name,
	CONCAT(v.vendor_contact_first_name," ",v.vendor_contact_last_name) AS contact_name
FROM vendors v JOIN vendors v2
		ON v.vendor_contact_last_name = v2.vendor_contact_last_name AND
           v.vendor_id <> v2.vendor_id
ORDER BY v.vendor_contact_last_name;

-- #6
SELECT gla.account_number, account_description
FROM general_ledger_accounts gla
	LEFT JOIN invoice_line_items li
		ON gla.account_number = li.account_number
WHERE isnull(invoice_id)
ORDER BY account_number;

-- #7
	SELECT vendor_name, "CA" AS vendor_state
	FROM vendors
	WHERE vendor_state = "CA"
UNION
	SELECT vendor_name, "Outside CA" AS vendor_state
	FROM vendors
	WHERE vendor_state <> "CA"
ORDER BY vendor_name;

/*Chapter 5*/

-- #1
INSERT terms
(terms_id, terms_description, terms_due_days)
VALUES
(6, "Net due 120 days", 120);

-- #2
UPDATE terms
SET terms_description = "Net due 125 days"
WHERE terms_id = 6;

-- #3
DELETE FROM terms
WHERE terms_id = 6;

-- #4
INSERT invoices
VALUES
(DEFAULT, 32, "AX-014-027", "2018-08-01", 434.58, DEFAULT, DEFAULT, 2, "2018-08-31", NULL);

-- #5
INSERT invoice_line_items
VALUES
(115, 1, 160, 180.23, "Hard drive"),
(115, 2, 527, 254.35, "Exchange Server Update");

-- #6
UPDATE invoices
SET credit_total = invoice_total * .10,
	payment_total = invoice_total - credit_total
WHERE invoice_id = 115;

-- #7 
UPDATE vendors
SET default_account_number = 403
WHERE vendor_id = 44;

-- #8 
UPDATE invoices
SET terms_id = 2
WHERE vendor_id IN
	(SELECT vendor_id
	 FROM vendors
     WHERE default_terms_id = 2); 
     
-- number 8 test    
SELECT v.vendor_id, i.vendor_id, i.terms_id
FROM vendors v NATURAL JOIN invoices i
WHERE v.default_terms_id =2;

-- #9



