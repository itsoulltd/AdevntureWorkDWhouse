
USE AdventureWorksDW2022;

Select * from DimCustomer;

Select Gender, COUNT(Gender) as 'Total Male', COUNT(Gender) as 'Total Female'
from DimCustomer
where Gender IN ('M', 'F')
group by Gender;

select
    Gender
     ,	TotalCount = count(1)
from DimCustomer c
group by Gender;

-- --
Select
    BirthdayMonth = MONTH(BirthDate)
     , TotalCount = count(1)
from DimCustomer c
group by MONTH(BirthDate)
order by MONTH(BirthDate);

-- -- ---
select
    MONTH(BirthDate)
     ,	COUNT(MONTH(BirthDate))
from DimCustomer
group by MONTH(BirthDate)
ORDER BY MONTH(BirthDate);