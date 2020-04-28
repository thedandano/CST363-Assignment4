-- *************************************************************
-- ap database queries
-- *************************************************************
USE AP; 

SELECT invoice_number, invoice_date, invoice_total,
    payment_total, credit_total,
    invoice_total - payment_total - credit_total  AS balance_due
FROM invoices 
WHERE invoice_total - payment_total - credit_total > 0
ORDER BY invoice_date;

SELECT vendor_name, invoice_number, invoice_date,
       invoice_total
FROM vendors INNER JOIN invoices
    ON vendors.vendor_id = invoices.vendor_id
WHERE invoice_total >= 500
ORDER BY vendor_name, invoice_total DESC;


-- *************************************************************
-- petdb queries
-- *************************************************************

use petdb;
-- select all columns and rows
SELECT * 
FROM owner;

-- select subset of columns (projection)
select id, name, address 
from owner;

-- select subset of rows (predicates)
select * 
from pet
where type='cat';

-- specify sort order of result
select id, name, address 
from owner 
order by name;

-- what if we want to order by last name?  
-- use SQL functions to get last name (see chapter 9 "How to work with string data"
-- or design should separate firstname and lastname
select id, 
       substring_index(name,' ',1) as firstname, 
       substring_index(name, ' ', -1) as lastname , 
       address 
from owner 
order by lastname;

-- cartesian product.   
select * 
from pet, owner;

-- only want pets that go with their owners.  
-- ownerid column in pet should equal id column in owner
select * 
from pet join owner on ownerid=id;

-- name column is ambiguous because there is a 
-- name column in pet and a name column in owner
select * 
from pet join owner on ownerid=id 
where pet.name='Socks';


-- another way to do it
select * 
from pet p join owner o on p.ownerid=o.id 
where p.name='Socks';

-- when we get a report of pets and their owners, 
-- an owner with no pets will not appear.
-- outer join to the rescue.

select * 
from owner o left outer join pet p on(p.ownerid=o.id); 

-- union of two results.  Must have same number of columns.
select id,  name, 'owner' from owner
union 
select petid,  name, type from pet
order by name;