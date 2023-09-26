-- March 16, 2020
-- Gina Krynski

-- Returns each property owned by am owner.
-- Returns the owner’s name, phone number, and the property’s address. 
-- Sorts the list by address and then the owner’s name.

SELECT  name, o.phoneNumber, address
FROM Owner o
    JOIN PropertyOwners po ON o.ownerId = po.ownerId
    JOIN Property p ON po.propertyId = p.propertyId

ORDER BY p.address, o.name

-- Returns each renter that still owes a deposit. 
-- Returns the renter’s name, property’s address, the amount of deposit the renter has paid,
--  what the required deposit should be for the property, and the amount of deposit the renter
--  still owes (user defined field called “depositOwed”). 
-- Sorts the list by the renter’s name

SELECT DISTINCT r.renterName, p.address, pr.deposit, rd.depositReq,
                rd.depositReq - pr.deposit AS depositOwed
FROM Renter r
    JOIN PropertyRental pr ON r.renterId = pr.renterId
    JOIN RentalData rd ON pr.rentalDataId = rd.rentalDataId
    JOIN Property p ON rd.propertyId = p.propertyId
    JOIN RentalPayment rp ON pr.propertyRentalId = rp.propertyRentalId
WHERE pr.deposit < rd.depositReq
ORDER BY r.renterName

-- Returns each renter that still owes a deposit as well as the renters that paid too much deposit. 
-- Returns the renter’s name, property’s address, the amount of deposit the renter has paid, what the 
--  required deposit should be for the property, and the amount of deposit the renter still owes 
--  owes (user defined field called “depositOwed”). 
-- Sorts the list by the renter’s name. 

SELECT DISTINCT r.renterName, p.address, pr.deposit, rd.depositReq,
                rd.depositReq - pr.deposit AS depositOwed
FROM Renter r
    JOIN PropertyRental pr ON r.renterId = pr.renterId
    JOIN RentalData rd ON pr.rentalDataId = rd.rentalDataId
    JOIN Property p ON rd.propertyId = p.propertyId
    --JOIN RentalPayment rp ON pr.propertyRentalId = rp.propertyRentalId
WHERE pr.deposit < rd.depositReq OR pr.deposit > rd.depositReq
ORDER BY r.renterName

-- Returns each renter that still owes a deposit, renters that paid too much deposit, and 
--  renters that paid the correct amount of deposit. 
-- Returns the renter’s name, property’s address, the amount of deposit the renter 
--  has paid, what the required deposit should be for the property, the amount of deposit the 
--  renter still owes owes (user defined field called “depositOwed”), and a field called “status” 
--  that displays the appropriate text: “OK”, “Outstanding Account” or “Refund Needed” . 
-- Sorts the list by the renter’s name.

SELECT DISTINCT r.renterName, 
                p.address, 
                pr.deposit, 
                rd.depositReq,
                rd.depositReq - pr.deposit AS depositOwed,
                [status] =
                    CASE
                        WHEN rd.depositReq = pr.deposit THEN 'OK'
                        WHEN rd.depositReq > pr.deposit THEN 'Outstanding Account'
                        ELSE 'Refund Needed'
                    END
FROM Renter r
    JOIN PropertyRental pr ON r.renterId = pr.renterId
    JOIN RentalData rd ON pr.rentalDataId = rd.rentalDataId
    JOIN Property p ON rd.propertyId = p.propertyId
    JOIN RentalPayment rp ON pr.propertyRentalId = rp.propertyRentalId
ORDER BY r.renterName

-- Implicit query that returns the first 5 property address and
--  owner’s name where the owner owns 100% of the property. 
-- Sorts the list by the address and then the owner

SELECT o.name, p.address
FROM Owner o, PropertyOwners po, Property p 
WHERE o.ownerId = po.ownerId AND po.propertyId = p.propertyId AND po.percentOwner = 100
ORDER BY p.address, o.name
    OFFSET 0 ROWS
    FETCH FIRST 5 ROWS ONLY


-- 6.	(5 records) Assuming you have seen the first 5 rows listed in the previous question
--  display the next 5 rows


SELECT o.name, p.address
FROM Owner o, PropertyOwners po, Property p 
WHERE o.ownerId = po.ownerId AND po.propertyId = p.propertyId AND po.percentOwner = 100
ORDER BY p.address, o.name
    OFFSET 5 ROWS
    FETCH FIRST 5 ROWS ONLY

-- Returns all property addresses and renter’s name
--  that are renting but not paid rent. 
-- Includes a user defined column called “status” 
--  and assign it “No Rent Paid”

SELECT r.renterName, p.address, [status] = 'No Rent Paid'
FROM Renter r
    JOIN PropertyRental pr ON r.renterId = pr.renterId
    LEFT JOIN RentalPayment rp ON pr.propertyRentalId = rp.propertyRentalId
    JOIN RentalData rd ON pr.rentalDataId = rd.rentalDataId
    JOIN Property p ON rd.propertyId = p.propertyId
WHERE pr.deposit > 0 AND rp.paymentAmount IS NULL
Order BY p.address, r.renterName


