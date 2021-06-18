set serveroutput on size 32000

-- Question 1: CarRentalSiteDetail detail
create or replace procedure CarRentalSiteDetail (id IN CarRentalSite.CarRentalSiteId%TYPE) as
rental_site_name CarRentalSite.CarRentalSiteName%TYPE;
rental_site_city CarRentalSite.City%TYPE;
rental_site_total NUMBER;
rental_site_pop Car.CarName%TYPE;
total_rent_time NUMBER;
CURSOR car_cur is SELECT stats_mode(CarName) from Rentals, Car WHERE Rentals.CarRentalSiteId = id AND Rentals.CarId = Car.Carid AND Category LIKE 'compact';
BEGIN
        SELECT CarRentalSiteName into rental_site_name from CarRentalSite where CarRentalSiteId = id;
        SELECT City into rental_site_city from CarRentalSite where CarRentalSiteId = id;
        SELECT COUNT(RentalId) into rental_site_total from Rentals where CarRentalSiteID = id;
        OPEN car_cur;
        FETCH car_cur INTO rental_site_pop;
        SELECT SUM(Rentals.numOfDays) INTO total_rent_time from Rentals, Car where Rentals.ca
rId = Car.Carid AND Car.CarName = rental_site_pop;
        dbms_output.put_line('CarRentalSite Name: ' || rental_site_name);
        dbms_output.put_line('CarRentalSite City: ' || rental_site_city);
        dbms_output.put_line('CarRentalSite Total Rentals: ' || rental_site_total);
        dbms_output.put_line('Most Popular Compact Car: ' || rental_site_pop);
        dbms_output.put_line('Total Days Rented: ' || total_rent_time);
END CarRentalSiteDetail;
/
BEGIN
        CarRentalSiteDetail(1);
END;
/


-- Question 2:

create or replace procedure MonthlyBusinessRentalsReport as
BEGIN
        dbms_output.put_line('placeholder');
END MonthlyBusinessRentalsReport;
/
BEGIN
        MonthlyBusinessRentalsReport;
End;
/

-- Question 3:

create or replace procedure MostandLeastProfitCarIndiana as
least_prof_compact_rate Rentals.RentalRate%TYPE;
most_prof_compact_rate Rentals.RentalRate%TYPE;
current_compact_rate Rentals.RentalRate%TYPE;
least_prof_compact_name Car.CarName%TYPE;
most_prof_compact_name Car.CarName%TYPE;
CURSOR least_prof_compact_cur is SELECT Car.CarName, AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) from Rentals, Car, CarDealers WHERE Rentals.CarId = Car.Carid AND Car.DealerId = CarDealers.DealerId AND CarDealers.State LIKE 'IN'  AND  Category LIKE 'compact' GROUP BY Car.CarName ORDER BY AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) ASC, Car.CarName ASC;
CURSOR most_prof_compact_cur is SELECT Car.CarName, AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) from Rentals, Car, CarDealers WHERE Rentals.CarId = Car.Carid AND Car.DealerId = CarDealers.DealerId AND CarDealers.State LIKE 'IN'  AND  Category LIKE 'compact' GROUP BY Car.CarName ORDER BY AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) DESC, Car.CarName ASC;
least_prof_luxury_rate Rentals.RentalRate%TYPE;
most_prof_luxury_rate Rentals.RentalRate%TYPE;
current_luxury_rate Rentals.RentalRate%TYPE;
least_prof_luxury_name Car.CarName%TYPE;
most_prof_luxury_name Car.CarName%TYPE;
CURSOR least_prof_luxury_cur is SELECT Car.CarName, AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) from Rentals, Car, CarDealers WHERE Rentals.CarId = Car.Carid AND Car.DealerId = CarDealers.DealerId AND CarDealers.State LIKE 'IN'  AND  Category LIKE 'luxury' GROUP BY Car.CarName ORDER BY AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) ASC, Car.CarName ASC;
CURSOR most_prof_luxury_cur is SELECT Car.CarName, AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) from Rentals, Car, CarDealers WHERE Rentals.CarId = Car.Carid AND Car.DealerId = CarDealers.DealerId AND CarDealers.State LIKE 'IN'  AND  Category LIKE 'luxury' GROUP BY Car.CarName ORDER BY AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) DESC, Car.CarName ASC;
least_prof_van_rate Rentals.RentalRate%TYPE;
most_prof_van_rate Rentals.RentalRate%TYPE;
current_van_rate Rentals.RentalRate%TYPE;
least_prof_van_name Car.CarName%TYPE;
most_prof_van_name Car.CarName%TYPE;
CURSOR least_prof_van_cur is SELECT Car.CarName, AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) from Rentals, Car, CarDealers WHERE Rentals.CarId = Car.Carid AND Car.DealerId = CarDealers.DealerId AND CarDealers.State LIKE 'IN'  AND  Category LIKE 'van' GROUP BY Car.CarName ORDER BY AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) ASC, Car.CarName ASC;
CURSOR most_prof_van_cur is SELECT Car.CarName, AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) from Rentals, Car, CarDealers WHERE Rentals.CarId = Car.Carid AND Car.DealerId = CarDealers.DealerId AND CarDealers.State LIKE 'IN'  AND  Category LIKE 'van' GROUP BY Car.CarName ORDER BY AVG(Rentals.RentalRate - Car.SuggestedDealerRentalPrice) DESC, Car.CarName ASC;
BEGIN
        dbms_output.put_line('Least Profit in compact');
        OPEN least_prof_compact_cur;
        FETCH least_prof_compact_cur INTO least_prof_compact_name, least_prof_compact_rate;
        current_compact_rate := least_prof_compact_rate;
        LOOP
                dbms_output.put_line('- ' || least_prof_compact_name || ': ' || current_compact_rate);
                FETCH least_prof_compact_cur INTO least_prof_compact_name, current_compact_rate;
                EXIT WHEN(current_compact_rate > least_prof_compact_rate) OR(least_prof_compact_cur%NOTFOUND);
        END LOOP;
        dbms_output.put_line('Least Profit in luxury');
        OPEN least_prof_luxury_cur;
        FETCH least_prof_luxury_cur INTO least_prof_luxury_name, least_prof_luxury_rate;
        current_luxury_rate := least_prof_luxury_rate;
        LOOP
                dbms_output.put_line('- ' || least_prof_luxury_name || ': ' || current_luxury_rate);
                FETCH least_prof_luxury_cur INTO least_prof_luxury_name, current_luxury_rate;
                EXIT WHEN(current_luxury_rate > least_prof_luxury_rate) OR(least_prof_luxury_cur%NOTFOUND);
        END LOOP;
        dbms_output.put_line('Least Profit in van');
        OPEN least_prof_van_cur;
        FETCH least_prof_van_cur INTO least_prof_van_name, least_prof_van_rate;
        current_van_rate := least_prof_van_rate;
        LOOP
                dbms_output.put_line('- ' || least_prof_van_name || ': ' || current_van_rate);
                FETCH least_prof_van_cur INTO least_prof_van_name, current_van_rate;
                EXIT WHEN(current_van_rate > least_prof_van_rate) OR(least_prof_van_cur%NOTFOUND);
        END LOOP;
        dbms_output.put_line('Most Profit in compact');
        OPEN most_prof_compact_cur;
        FETCH most_prof_compact_cur INTO most_prof_compact_name, most_prof_compact_rate;
        current_compact_rate := most_prof_compact_rate;
        LOOP
                dbms_output.put_line('- ' || most_prof_compact_name || ': ' || current_compact_rate);
                FETCH most_prof_compact_cur INTO most_prof_compact_name, current_compact_rate;
                EXIT WHEN(current_compact_rate < most_prof_compact_rate) OR(most_prof_compact_cur%NOTFOUND);
        END LOOP;
        dbms_output.put_line('Most Profit in luxury');
        OPEN most_prof_luxury_cur;
        FETCH most_prof_luxury_cur INTO most_prof_luxury_name, most_prof_luxury_rate;
        current_luxury_rate := most_prof_luxury_rate;
        LOOP
                dbms_output.put_line('- ' || most_prof_luxury_name || ': ' || current_luxury_rate);
                FETCH most_prof_luxury_cur INTO most_prof_luxury_name, current_luxury_rate;
                EXIT WHEN(current_luxury_rate < most_prof_luxury_rate) OR(most_prof_luxury_cur%NOTFOUND);
        END LOOP;
        dbms_output.put_line('Most Profit in van');
        OPEN most_prof_van_cur;
        FETCH most_prof_van_cur INTO most_prof_van_name, most_prof_van_rate;
        current_van_rate := most_prof_van_rate;
        LOOP
                dbms_output.put_line('- ' || most_prof_van_name || ': ' || current_van_rate);
                FETCH most_prof_van_cur INTO most_prof_van_name, current_van_rate;
                EXIT WHEN(current_van_rate < most_prof_van_rate) OR(most_prof_van_cur%NOTFOUND);
        END LOOP;
END MostandLeastProfitCarIndiana;
/

BEGIN
        MostandLeastProfitCarIndiana;
END;
/

-- Question 4:

create table BusinessRentalCategoryTable(CarRentalSiteId integer, Compact integer, Luxury integer, SUV integer, primary key(CarRentalSiteId));
create or replace procedure BusinessRentalCategory as
rental_site_id RentalInventories.CarRentalSiteId%TYPE;
rental_site_compact NUMBER;
rental_site_luxury NUMBER;
rental_site_van NUMBER;
CURSOR business_rental_cur is SELECT Rentals.CarRentalSiteId, COUNT(case when (Car.Category LIKE 'compact') then 1 else null end), COUNT(case when (Car.Category LIKE 'luxury') then 1 else null end), COUNT(case when (Car.Category LIKE 'SUV') then 1 else null end) from Rentals, Car  WHERE Rentals.CarId = Car.CarId AND Rentals.Status LIKE 'BUSINESS' GROUP BY Rentals.CarRentalSiteID ORDER BY Rentals.CarRentalSiteID ASC;
BEGIN
        OPEN business_rental_cur;
        LOOP
                FETCH business_rental_cur INTO rental_site_id, rental_site_compact, rental_site_luxury, rental_site_van;
                EXIT WHEN(business_rental_cur%NOTFOUND);
                INSERT INTO BusinessRentalCategoryTable VALUES (rental_site_id,rental_site_compact,rental_site_luxury,rental_site_van);
        END LOOP;
END BusinessRentalCategory;
/

BEGIN
BusinessRentalCategory;
END;
/
select * from BusinessRentalCategoryTable;

drop table BusinessRentalCategoryTable;


-- Question 5:

create or replace procedure CarCategoryInventoryInfo(crsid IN CarRentalSite.CarRentalSiteId%TYPE) as
rental_site_name CarRentalSite.CarRentalSiteName%TYPE;
car_name Car.CarName%TYPE;
car_quantity RentalInventories.TotalCars%TYPE;
CURSOR rentals_cur is SELECT Car.CarName, RentalInventories.TotalCars  from RentalInventories, Car WHERE RentalInventories.CarRentalSiteId = crsid AND RentalInventories.CarId = Car.Carid ORDER BY Car.CarName;
BEGIN
        dbms_output.put_line('CarRentalSiteId: ' || crsid);
        SELECT CarRentalSite.CarRentalSiteName into rental_site_name from CarRentalSite where CarRentalSite.CarRentalSiteId = crsid;
        dbms_output.put_line('CarRentalSiteName: ' || rental_site_name);
        OPEN rentals_cur;
        LOOP
                FETCH rentals_cur INTO car_name, car_quantity;
                EXIT WHEN(rentals_cur%NOTFOUND);
                dbms_output.put_line('CarName: ' || car_name || ': ' || car_quantity);
        END LOOP;
EXCEPTION
        WHEN OTHERS THEN
                dbms_output.put_line('Invalid CarRentalSiteId!');
END CarCategoryInventoryInfo;
/

BEGIN
CarCategoryInventoryInfo(1);
END;
/

BEGIN
CarCategoryInventoryInfo(111);
END;
/



