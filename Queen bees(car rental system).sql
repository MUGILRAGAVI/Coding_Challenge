use Marchdb

create table Vehicle
(
vehicleID int identity primary key not null,
make varchar(50) not null,
model varchar(50) not null,
year int not null,
dailyRate decimal(10,2),
status VARCHAR(20) CHECK (status IN ('available', 'notAvailable')) DEFAULT 'available',
passengerCapacity int not null,
engineCapacity int not null
);

create table Customer 
(
customerID int identity primary key not null,
firstName varchar(50) not null,
lastName varchar(50)not null,
email varchar(50) unique not null,
phoneNumber varchar(15) unique not null
);

create table Lease
(
leaseID int identity primary key not null,
vehicleID int,
customerID int,
startDate date not null,
endDate date not null,
type varchar(10) check(type in ('daily','Monthly')),
foreign key (vehicleID) references Vehicle (vehicleID) on delete cascade,
foreign key (customerID) references Customer(CustomerID) on delete cascade
);

create table Payment
(
paymentID int identity primary key not null,
leaseID int ,
paymentDate date not null,
amount decimal(10,2),
foreign key (leaseID) references Lease(leaseID) on delete cascade
);

insert into Vehicle (make, model, year, dailyRate, status, passengerCapacity, engineCapacity) VALUES
('Toyota', 'Camry', 2022, 50.00, 'available', 4, 1450),
('Honda', 'Civic', 2023, 45.00, 'available', 7, 1500),
('Ford', 'Focus', 2022, 48.00, 'notAvailable', 4, 1400),
('Nissan', 'Altima', 2023, 52.00, 'available', 7, 1200),
('Chevrolet', 'Malibu', 2022, 47.00, 'available', 4, 1800),
('Hyundai', 'Sonata', 2023, 49.00, 'notAvailable', 7, 1400),
('BMW', '3 Series', 2023, 60.00, 'available', 7, 2499),
('Mercedes', 'C-Class', 2022, 58.00, 'available', 8, 2599),
('Audi', 'A4', 2022, 55.00, 'notAvailable', 4, 2500),
('Lexus', 'ES', 2023, 54.00, 'available', 4, 2500);

select*from Vehicle

insert into Customer (firstName, lastName, email, phoneNumber) VALUES
('John', 'Doe', 'johndoe@example.com', '555-555-5555'),
('Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
('Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
('Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
('David', 'Lee', 'david@example.com', '555-987-6543'),
('Laura', 'Hall', 'laura@example.com', '555-234-5678'),
('Michael', 'Davis', 'michael@example.com', '555-876-5432'),
('Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
('William', 'Taylor', 'william@example.com', '555-321-6547'),
('Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

select * from Customer

insert into Lease (vehicleID, customerID,startDate, endDate, type) VALUES
(1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, '2023-10-10', '2023-10-31', 'Monthly');

select * from Lease

insert into Payment (leaseID, paymentDate, amount) VALUES
(1, '2023-01-03', 200.00),
(2, '2023-02-20', 1000.00),
(3, '2023-03-12', 75.00),
(4, '2023-04-25', 900.00),
(5, '2023-05-07', 60.00),
(6, '2023-06-18', 1200.00),
(7,'2023-07-03', 40.00),
(8, '2023-08-14', 1100.00),
(9, '2023-09-09', 80.00),
(10, '2023-10-25', 1500.00);

select * from Payment

-- Update the daily rate for a Mercedes car to 68.
 
 update Vehicle 
 set dailyRate = 68
 where make ='Mercedes';

 select * from Vehicle

 --Delete a specific customer and all associated leases and payments.

 declare @customerID int=1;
 delete from Payment
 where leaseID in (select leaseID from Lease where customerID = @customerID);
 
 delete from Lease
 where customerID = @customerID;

 delete from Customer
 where customerID=@customerID;

 select *from Customer
 select * from Lease
 select * from Payment

 --Rename the "paymentDate" column in the Payment table to "transactionDate"

exec sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN';

select * from Payment

--Find a specific customer by email.

select * from Customer
where email ='robert@example.com';

--Get active leases for a specific customer.

select * from Lease
where customerID = 6 and endDate >  getdate();

--Find all payments made by a customer with a specific phone number.

select p.* from Payment p
join Lease l on p.leaseID = l.leaseID
join Customer c on l.customerID = c.customerID
where c.phoneNumber = '555-765-4321'

--Calculate the average daily rate of all available cars

select AVG(dailyRate) AS average_daily_rate
from Vehicle
where status = 'available';

--Find the car with the highest daily rate.

select top 1 * from Vehicle
order by dailyRate desc ;

--Retrieve all cars leased by a specific customer.

select v.* from Vehicle v
join Lease l on v.vehicleID = l.vehicleID
where l.customerID = 4

--Find the details of the most recent lease.

select top 1* from Lease
order by startDate desc ;

--List all payments made in the year 2023.

select * from Payment
where year(transactionDate) =2023;

--Retrieve customers who have not made any payments.

select c.* from Customer c
left join Lease l on c.customerID = l.customerID
left join Payment p on l.LeaseID=p.leaseID
where p.paymentID is null;

--Retrieve Car Details and Their Total Payments.

SELECT v.*, SUM(p.amount) AS totalPayments
FROM Vehicle v
LEFT JOIN Lease l ON v.vehicleID = l.vehicleID
LEFT JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY v.vehicleID, v.make, v.model, v.year, v.dailyRate, v.status, v.passengerCapacity, v.engineCapacity;

--Calculate Total Payments for Each Customer.

SELECT c.customerID, c.firstName, c.lastName, SUM(p.amount) AS totalPayments
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName;

--List Car Details for Each Lease.

SELECT v.*, l.* FROM Vehicle v
JOIN Lease l ON v.vehicleID = l.vehicleID;

--Retrieve Details of Active Leases with Customer and Car Information.

SELECT l.*, c.*, v.*
FROM Lease l
JOIN Customer c ON l.customerID = c.customerID
JOIN Vehicle v ON l.vehicleID = v.vehicleID
WHERE l.endDate > GETDATE(); 
 
 select * from Lease

--Find the Customer Who Has Spent the Most on Leases

SELECT top 1 c.customerID, c.firstName, c.lastName, SUM(p.amount) AS totalSpent
FROM Customer c
JOIN Lease l ON c.customerID = l.customerID
JOIN Payment p ON l.leaseID = p.leaseID
GROUP BY c.customerID, c.firstName, c.lastName
ORDER BY totalSpent DESC; 

--List All Cars with Their Current Lease Information.

select v.*, l.*, c.firstName, c.lastName
from Vehicle v
join Lease l ON v.vehicleID = l.vehicleID 
join Customer c ON l.customerID = c.customerID;

