


------**claims database **-------------------------

--Create database

create database patient_provider_claims
use patient_provider_claims

--Create a patients table
CREATE TABLE Patient_s (
  PatientID INT PRIMARY KEY NOT NULL,
  FirstName VARCHAR(40) NOT NULL,
  LastName VARCHAR(40) NOT NULL,
  DOB DATE NOT NULL,
  Address VARCHAR(100) NOT NULL,
  PhoneNumber VARCHAR(25) NOT NULL
);
--create a providers table

CREATE TABLE Provider_s (
  ProviderID INT PRIMARY KEY NOT NULL,
  ProviderName VARCHAR(100) NOT NULL,
  Address VARCHAR(100) NOT NULL,
  PhoneNumber VARCHAR(25) NOT NULL,
  Specialty VARCHAR(60) NOT NULL
);

--create a claims table

CREATE TABLE Claim_s (
  ClaimID INT PRIMARY KEY NOT NULL,
  PatientID INT NOT NULL,
  ProviderID INT NOT NULL,
  ServiceDate DATE NOT NULL,
  ServiceType VARCHAR(40) NOT NULL,
  Amount DECIMAL(15, 3) NOT NULL,
  FOREIGN KEY (PatientID) REFERENCES Patient_s(PatientID),
  FOREIGN KEY (ProviderID) REFERENCES Provider_s(ProviderID)
);


---Insert the patients records
INSERT INTO Patient_s (PatientID, FirstName, LastName, DOB, Address, PhoneNumber)
VALUES
  (1, 'William', 'Michael', '1983-11-01', '1025 benoi Main St, Some State USA', '545-2344'),
  (2, 'Emma', 'Noah', '1980-06-15', '2056 glen st, Some State USA', '505-5078'),
  (3, 'Daniel', 'Elizabeth', '1985-11-25', '3092 harb St, Some State USA', '055-9001'),
  (4, 'Andrew', 'Mia', '2001-05-06', '2099 Lech Rd, Some State USA', '505-1212'),
  (5, 'Amelia', 'Patricia', '1992-10-11', '2033 Lev Rd, Some State State USA', '855-1013');
-----Insert the providers records

INSERT INTO Provider_s (ProviderID, ProviderName, Address, PhoneNumber, Specialty)
VALUES
  (1, 'Some Physical Therapy', '8550 Reigh Dr, Some State USA', '655-0468', 'Physical Therapy'),
  (2, 'Some Mental Health', '2770 Benon St, Some State USA', '985-0960', 'Mental Health'),
  (3, 'Some Vision center', '3880 Cycl Rd, Some State USA', '945-2832', 'OPtometry'),
  (4, 'Some Chiropractic', '4880 Sunny Ave, Some State USA', '954-5945', 'Chiropractic'),
  (5, 'Some Physical Therapy', '5230 eive Blvd, State USA', '659-7191', 'Physical Therapy');
---Insert the claims records


INSERT INTO Claim_s (ClaimID, PatientID, ProviderID, ServiceDate, ServiceType, Amount)
VALUES
  (1, 1, 1, '2023-01-11', 'Office Visit', 90.00),
  (2, 2, 2, '2023-01-25', 'Lab Work', 80.00),
  (3, 3, 3, '2023-02-11', 'Spinal Therapy', 45.00),
  (4, 4, 4, '2023-02-25', 'Eye Exam', 40.00),
  (5, 5, 5, '2023-03-09', 'Contact Lenses', 100.00),
  (6, 1, 2, '2023-03-15', 'Dental Fillings', 250.00),
  (7, 2, 3, '2023-04-08', 'Massage Therapy', 120.00),
  (8, 3, 4, '2023-04-19', 'Phyical Therapy', 120.00),
  (9, 4, 5, '2023-05-04', 'Occupational Therapy', 205.00),
  (10, 5, 1, '2023-05-25', 'Teeth cleaning', 75.00);





  --Retrieving the claims,provider,patient data:

--. Retrieve the total amount of claims for a specific providerid is 2
SELECT SUM(Amount) AS TotalAmount FROM Claim_s WHERE ProviderID = 2;

--. Get all claims with a service date between two dates
SELECT * FROM Claim_s WHERE ServiceDate BETWEEN '2023-01-01' AND '2023-12-31';

--. Get all patients and their corresponding claims
SELECT Patient_s.*, Claim_s.* FROM Patient_s
JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID;


 --. Display the total amount of claims submitted by providers in each specialty, sorted in descending order
SELECT Provider_s.Specialty, SUM(Claim_s.Amount) AS Total_Claims_Amount
FROM Provider_s
INNER JOIN Claim_s ON Provider_s.ProviderID = Claim_s.ProviderID
GROUP BY Provider_s.Specialty
ORDER BY Total_Claims_Amount DESC; 

--. Display the patients who have submitted claims for a specific service type
SELECT Patient_s.FirstName, Patient_s.LastName, Claim_s.ServiceType
FROM Patient_s
INNER JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID
WHERE Claim_s.ServiceType = 'Optmetry';

--.**** Display the total amount of claims submitted by patients in each state, sorted in descending order
SELECT SUBSTRING(1,5,'Address') AS Address, SUM(Claim_s.Amount) AS Total_Claims_Amount
FROM Patient_s
INNER JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID
GROUP BY Address
ORDER BY Total_Claims_Amount DESC;
  
--. Get all patient information
SELECT * FROM Patients;
-- . Get all claim information for a specific patient id 4
SELECT * FROM Claim_s WHERE PatientID = 4;

--. Get all providers in a specific specialty as physical therapy
SELECT * FROM Provider_s WHERE Specialty = 'Physical Therapy';


--. ***Retrieve the total amount of claims for each patient
SELECT Patient_s.FirstName, Patient_s.LastName, SUM(Claim_s.Amount) AS TotalAmount FROM Patient_s
JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID

-- . Retrieve the number of claims for each service type
SELECT ServiceType, COUNT(*) AS totalclaims FROM Claim_s
GROUP BY ServiceType;

--. Retrieve all patients with no claims, since each patient has a claim this wll return nothing
SELECT Patient_s.* FROM Patient_s
LEFT JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID
WHERE Claim_s.ClaimID IS NULL;

--. Retrieve the top 5 providers with the highest total claim amount""
SELECT Provider_s.ProviderID, SUM(Claim_s.Amount) AS TotalAmount FROM Provider_s
JOIN Claim_s ON Provider_s.ProviderID = Claim_s.ProviderID
GROUP BY Provider_s.ProviderID
ORDER BY TotalAmount DESC

--  Display the total amount of claims submitted by each patient, sorted in descending order
SELECT Patient_s.LastName, SUM(Claim_s.Amount) AS Total_Claims_Amount
FROM Patient_s
INNER JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID
GROUP BY Patient_s.LastName
ORDER BY Total_Claims_Amount DESC;

-- Display the total amount of claims submitted by each provider, sorted in descending order
SELECT Provider_s.ProviderName, SUM(Claim_s.Amount) AS Total_Claims_Amount
FROM Provider_s
INNER JOIN Claim_s ON Provider_s.ProviderID = Claim_s.ProviderID
GROUP BY Provider_s.ProviderName
ORDER BY Total_Claims_Amount DESC;

-- Display the total amount of claims submitted by each specialty, sorted in descending order
SELECT Provider_s.Specialty, SUM(Claim_s.Amount) AS Total_Claims_Amount
FROM Provider_s
INNER JOIN Claim_s ON Provider_s.ProviderID = Claim_s.ProviderID
GROUP BY Provider_s.Specialty
ORDER BY Total_Claims_Amount DESC;

-- Display the patients who have submitted more than greater than or equal to 1 claim
SELECT Patient_s.FirstName, Patient_s.LastName, COUNT(Claim_s.ClaimID) AS Total_Claims_Submitted
FROM Patient_s
INNER JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID
GROUP BY Patient_s.FirstName,Patient_s.LastName
HAVING COUNT(Claim_s.ClaimID) > 5;

--Display the patients who have submitted claims with more than $100 in total amount
SELECT Patient_s.FirstName, Patient_s.LastName, SUM(Claim_s.Amount) AS Total_Claims_Amount
FROM Patient_s
INNER JOIN Claim_s ON Patient_s.PatientID = Claim_s.PatientID
GROUP BY Patient_s.FirstName, Patient_s.LastName
HAVING SUM(Claim_s.Amount) > 100;

-- Display the providers who have submitted claims with more than $1,000 in total amount, since im kind and I kept the costs low, this will return nothing
SELECT Provider_s.ProviderID, SUM(Claim_s.Amount) AS Total_Claims_Amount
FROM Provider_s
INNER JOIN Claim_s ON Provider_s.ProviderID = Claim_s.ProviderID
GROUP BY Provider_s.ProviderID
HAVING SUM(Claim_s.Amount) > 50;




































-- This query retrieves information about patients who have medical claims for services rendered by providers in "some state". 
--It returns each patient's name, address, the total amount they have paid for medical claims, and the number of unique Mental Health
---and Physical Therapy providers they have seen. The query also filters the results to only include patients who have paid at least
---$100 in total medical claims, and sorts the results in descending order of the number of Mental Health providers seen and ascending
---order of the number of Physical Therapy providers seen."""
/*SELECT
  p.FirstName,
  p.LastName,
  p.Address,
  SUM(c.Amount) AS TotalAmountPaid,
  (
    SELECT COUNT(DISTINCT p2.ProviderID)
    FROM Claim_s c2
    INNER JOIN Provider_s p2 ON c2.ProviderID = p2.ProviderID
    WHERE c2.PatientID = p.PatientID
    AND p2.Specialty = 'Mental Health'
  ) AS NumCardiologyProviders,
  (
    SELECT COUNT(DISTINCT p3.ProviderID)
    FROM Claim_s c3
    INNER JOIN Provider_s p3 ON c3.ProviderID = p3.ProviderID
    WHERE c3.PatientID = p.PatientID
    AND p3.Specialty = 'Physical Therapy'
  ) AS NumRadiologyProviders
FROM
  Patient_s p
  INNER JOIN Claim_s c ON p.PatientID = c.PatientID
  INNER JOIN Provider_s pr ON c.ProviderID = pr.ProviderID
WHERE
  p.Address LIKE '%Some State%'
GROUP BY
    p.FirstName,p.LastName
HAVING
   SUM(c.amount) >= 100
ORDER BY
  NumCardiologyProviders DESC,
  NumRadiologyProviders ASC;/*