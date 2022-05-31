-- 1-3 복수 행 함수(GROUPING FUNCTION)

-- 집계함수
-- COUNT, SUM, AVG, MAX, MIN, STDEV, VAR 

USE EDU
SELECT * FROM [ORDER]

-- USING ALL DATA = describe data
SELECT COUNT(order_no) AS 총주문수,
		SUM(sales_amt) AS 총주문금액,
		AVG(sales_amt) AS 평균주문금액,
		MAX(order_date) AS 최근구매일자,
		MIN(order_date) AS 최초구매일자,
		STDEV(sales_amt) AS 주문금액_표편,
		VAR(sales_amt) AS 주문금액_분산
FROM [ORDER] 


-- USING WITH GROUP BY
-- describe data per mem_no
SELECT mem_no,
		COUNT(order_no) AS 총주문수,
		SUM(sales_amt) AS 총주문금액,
		AVG(sales_amt) AS 평균주문금액,
		MAX(order_date) AS 최근구매일자,
		MIN(order_date) AS 최초구매일자,
		STDEV(sales_amt) AS 주문금액_표편,
		VAR(sales_amt) AS 주문금액_분산
FROM [ORDER] 
GROUP BY mem_no




-- 그룹함수
-- WITH ROLLUP, WITH CUBE, GROUPING SETS, GROUPING
-- GROUP BY 항목들을 그룹으로 묶는 함수이며, 구체적으론 GROUP BY 항목이 2개 이상인 경우에만 사용!

USE EDU

-- 원래의 그룹바이 
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
ORDER BY 1 DESC, 2 ASC 


-- 1) WITH ROLLUP 함께 사용: 오른쪽 -> 왼쪽 순으로 그룹 묶음 / 총계, 소계 구할 때 활용 
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC 

--순서를 바꾼다면? 역시 대분류는 가짓수가 적은게 보기 편하다..
SELECT channel_code AS ch_code,
		YEAR(order_date) AS year1,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY channel_code, YEAR(order_date)
WITH ROLLUP
ORDER BY 1 ASC, 2 DESC 



-- 2) WITH CUBE 함께 사용: 모든 GROUPBY 경우의 수를 그룹으로 묶음 
-- 앞선 케이스에선 연도의 소계는 아는데, 채널코드별 소계는 몰랐다. WITH CUBE로 이걸 알수있음! / 총계, 소계 구할때 활용 
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH CUBE 
ORDER BY 1 DESC, 2 ASC 


-- 3) GROUPING SETS: GROUP BY 항목들을 개별 그룹으로 묶음.
-- 즉 GROUP BY로 지정한 항목들의 "소계"만 뽑음(채널코드별 소계, 연도별 소계)
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY GROUPING SETS(YEAR(order_date), channel_code)


-- 4) GROUPING: WITH ROLLUP, WITH CUBE와 함께 사용되며
-- 얘네에 의해 그룹화된 경우 0, 아니면 1을 반환 / NULL로 나오는 부분만 1
SELECT YEAR(order_date) AS year1,
		GROUPING(YEAR(order_date)) AS year1_group,
		channel_code AS ch_code,
		GROUPING(channel_code) AS chcode_group,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC 

-- CUBE는?
SELECT YEAR(order_date) AS year1,
		GROUPING(YEAR(order_date)) AS year1_group,
		channel_code AS ch_code,
		GROUPING(channel_code) AS chcode_group,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH CUBE 
ORDER BY 1 DESC, 2 ASC 

-- GROUPING의 쓰임: CASE WHEN과 함께 NULL 이름을 변경할 수 있다.
-- 연도, 채널코드, sales_amt를 FROM절 서브쿼리로 만들자!! 

-- (밑 코드 실행시 에러) year1과 ch_code의 값을 문자형(VARCHAR)으로 바꿔줘야 함. 총계, 소계라는 문자를 넣어주려면!!
SELECT CASE WHEN GROUPING(year1) = 1 THEN '총계'
		ELSE year1 END AS 연도_총계,
		CASE WHEN GROUPING(ch_code) = 1 THEN '소계'
		ELSE ch_code END AS 채널코드_총계,
		SUM(sales_amt) AS tot_amt
FROM (SELECT YEAR(order_date) AS year1,
				channel_code AS ch_code,
				sales_amt 
		FROM [ORDER]) A
GROUP BY year1, ch_code
WITH ROLLUP 


--CAST 사용하여 문자형으로 바꿔준 경우
SELECT CASE WHEN GROUPING(year1) = 1 THEN '총계'
		ELSE year1 END AS 연도_총계,
		CASE WHEN GROUPING(ch_code) = 1 THEN '소계'
		ELSE ch_code END AS 채널코드_총계,
		SUM(sales_amt) AS tot_amt
FROM (SELECT CAST(YEAR(order_date) AS VARCHAR) AS year1,
				CAST(channel_code AS VARCHAR) AS ch_code,
				sales_amt 
		FROM [ORDER]) A
GROUP BY year1, ch_code
WITH ROLLUP 


-- 하지만 문제. 채널코드_총계의 맨 마지막 행은 '총계'로 나와야 한다
SELECT CASE WHEN GROUPING(year1) = 1 THEN '총계'
		ELSE year1 END AS 연도_총계,
		CASE WHEN GROUPING(year1) = 1 THEN '총계' -- 이게 더 큰단위이므로 먼저 써준다
		WHEN GROUPING(ch_code) = 1 THEN '소계'
		ELSE ch_code END AS 채널코드_총계,
		SUM(sales_amt) AS tot_amt
FROM (SELECT CAST(YEAR(order_date) AS VARCHAR) AS year1,
				CAST(channel_code AS VARCHAR) AS ch_code,
				sales_amt 
		FROM [ORDER]) A
GROUP BY year1, ch_code
WITH ROLLUP 