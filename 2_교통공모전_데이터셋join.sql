CREATE DATABASE transportation_contest;
USE transportation_contest;

#테이블 생성
CREATE TABLE HW_time
	(town_code VARCHAR(10) PRIMARY KEY,
    time_sum float,
    population_sum float,
    avg_hw float);
SELECT * FROM HW_time;

CREATE TABLE WH_time
	(town_code VARCHAR(10) PRIMARY KEY,
    avg_wh float);
SELECT * FROM WH_time;

CREATE TABLE town_name
	(metropolitan_code char(5),
    city_code char(5),
    town_code VARCHAR(10) PRIMARY KEY,
    town_name_kor VARCHAR(20),
    town_full_name_kor VARCHAR(50));
SELECT * FROM town_name;

#데이터 튜플 입력
LOAD DATA LOCAL INFILE 'C:/Users/user/OneDrive/Desktop/Traffic_Contest/avg_hw_time.csv'
INTO TABLE HW_time
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/OneDrive/Desktop/Traffic_Contest/avg_wh_time.csv'
INTO TABLE WH_time
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/user/OneDrive/Desktop/Traffic_Contest/town_name_code.csv'
INTO TABLE town_name
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#검색
SELECT hw.town_code as '행정동별 코드', town_full_name_kor as '행정동명', avg_hw as '평균 출근시간', avg_wh as '평균 퇴근시간'
FROM HW_time hw, town_name tname, WH_time wh
WHERE hw.town_code = tname.town_code AND wh.town_code = tname.town_code;

#누락된 동네까지 다 저장
(SELECT 
	'행정동별 코드' as '행정동별 코드', 
	'행정동명' as '행정동명', 
	'평균 출근시간' as '평균 출근시간', 
	'평균 퇴근시간' as '평균 퇴근시간'
)
UNION ALL
(SELECT 
	hw.town_code, 
	tname.town_full_name_kor, 
	hw.avg_hw, 
	wh.avg_wh
FROM HW_time hw
JOIN town_name tname ON hw.town_code = tname.town_code
JOIN WH_time wh ON hw.town_code = wh.town_code
)
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/commute_all_result.csv'
CHARACTER SET euckr 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

SHOW VARIABLES LIKE 'secure_file_priv';