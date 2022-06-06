-- CASE WHEN 구문

------------------- 예시 1 ----------------------
-- 1. AGEBAND를 활용해 'AGEBAND_SEG' 컬럼을 만드시오.
USE EDU

SELECT *
FROM [MEMBER]

--
SELECT *, 
	CASE WHEN ageband BETWEEN 20 AND 30 THEN '2030'
	WHEN ageband BETWEEN 40 AND 50 THEN '4050'
	ELSE 'other' END AS ageband_seg
FROM [MEMBER] 


-- NOT USING "ELSE" -> it becomes 'NULL'
SELECT *, 
	CASE WHEN ageband BETWEEN 20 AND 30 THEN '2030'
	WHEN ageband BETWEEN 40 AND 50 THEN '4050'
	END AS ageband_seg
FROM [MEMBER] 




-- 2. 성별 및 연령대별 구매자를 카운트하시오.
SELECT gender, ageband, COUNT(mem_no) AS mem_cnt 
FROM [MEMBER] 
GROUP BY gender, ageband 
ORDER BY 1

-- 성별 및 연령대별로 카운트하되, join_date의 연도별로 나누어 구매자를 카운트하시오.
SELECT MIN(join_date), MAX(join_date)
FROM [MEMBER]

SELECT gender, ageband,	
	COUNT(CASE WHEN YEAR(join_date) = 2018 THEN mem_no END) AS join_18,
	COUNT(CASE WHEN YEAR(join_date) = 2019 THEN mem_no END) AS join_19
FROM [MEMBER]
GROUP BY gender, ageband
ORDER BY 1



-------------------- 예시 2----------------
-- 1. [CAR_MART]를 활용해 구매전환율을 구하기 위해,
-- 2020년에 구매를 한 고객이 21년에도 구매한 경우 Y, 아니면 N을 표시하는 'retention' 열을 생성하라.

SELECT * FROM [CAR_MART] 

-- 20년도 구매고객 -중복이 있어서 꼭 제거해주기 
SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020
-- 21년도 구매고객 
SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021 

-- 먼저 20년 구매고객을 밑바탕으로 깔아 테이블을 만든다.
SELECT *
FROM (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020) A 
LEFT JOIN (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no 

-- 만일 NULL로 나온거면 전환이 안된거고, 값이 있음 재구매를 한 거겠지? 
SELECT A.mem_no AS mem_20, B.mem_no AS mem_21,
		CASE WHEN B.mem_no IS NOT NULL THEN 'Y'
		ELSE 'N' END AS retention
INTO #RETENTION_BASE 
FROM (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020) A 
LEFT JOIN (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no 

SELECT * FROM #RETENTION_BASE 

-- 2)#RETENTION_BASE 테이블을 활용해 구매전환율을 계산해라.
SELECT retention, COUNT(retention) AS re_cnt
FROM #RETENTION_BASE
GROUP BY retention
WITH ROLLUP 
ORDER BY 1 DESC 



-- 또는 CASE WHEN을 사용하면
SELECT COUNT(*) AS total,
	COUNT(CASE WHEN retention = 'Y' THEN retention END) AS re_y
FROM #RETENTION_BASE 

SELECT COUNT(*) AS total,
	SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END) AS re_y
FROM #RETENTION_BASE 


-- (번외) 전환된 비율까지 구할 수 있을까?
SELECT * FROM #RETENTION_BASE

-- COUNT가 안먹기 때문에 SUM으로 바꿔서 써줘야 한다
SELECT ROUND((SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END)/ CAST(COUNT(*) AS FLOAT))*100, 2)
FROM #RETENTION_BASE 


SELECT CONCAT(CAST(ROUND((SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END)/ CAST(COUNT(*) AS FLOAT))*100, 2) AS VARCHAR), '%')
FROM #RETENTION_BASE 