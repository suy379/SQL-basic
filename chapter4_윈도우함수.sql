-- 1-4 윈도우 함수
-- 윈도우 순위 함수 / 윈도우 집계 함수(누적)
-- 윈도우 함수 + OVER (ORDER BY 열 ASC or DESC)
-- 윈도우 함수 + OVER (PARTITION BY 열 ORDER BY 열)

USE EDU 
SELECT * FROM [ORDER] 

-- 순위함수 
-- Q. order_date에 대해, 최초주문일자부터 순위를 부여하라.(어떤 함수를 쓰는지에 따라 순위가 달라짐)
SELECT order_date,
	ROW_NUMBER() OVER (ORDER BY order_date ASC) AS rownumber,
	RANK() OVER (ORDER BY order_date ASC) AS rnk,
	DENSE_RANK() OVER (ORDER BY order_date ASC) AS densernk
FROM [ORDER]

-- Q. mem_no에 따라 구분지어 order_date에 순위를 부여하라.
SELECT mem_no, order_date,
	ROW_NUMBER() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS rownumber,
	RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS rnk,
	DENSE_RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS densernk
FROM [ORDER]



-- 누적 집계함수

-- Q1. order_date에 따라, sales_amt의 누적 구매횟수/누적 구매금액/누적 평균구매금액/누적 최고구매금액/누적 최저구매금액을 구하여라.
-- 결과를 보면 같은 order_date에 대해선 누적값들이 모두 똑같다! 
SELECT --order_date, sales_amt,
		COUNT(sales_amt) OVER (ORDER BY order_date ASC),
		SUM(sales_amt) OVER (ORDER BY order_date ASC)
FROM [ORDER] 


SELECT order_date, sales_amt,
		COUNT(sales_amt) OVER (ORDER BY order_date ASC) AS 누적구매횟수,
		SUM(sales_amt) OVER (ORDER BY order_date ASC) AS 누적구매금액,
		AVG(sales_amt) OVER (ORDER BY order_date ASC) AS 누적평균구매금액,
		MAX(sales_amt) OVER (ORDER BY order_date ASC) AS 누적최고구매금액,
		MIN(sales_amt) OVER (ORDER BY order_date ASC) AS 누적최저구매금액
FROM [ORDER] 


-- 만일 이렇게 하면? (그래도 같은 결과다. 왜냐면 order_date별로 누적값을 구하는 거니까!)
SELECT order_date, sales_amt,
		COUNT(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS 누적구매횟수,
		SUM(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS 누적구매금액,
		AVG(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS 누적평균구매금액,
		MAX(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS 누적최고구매금액,
		MIN(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS 누적최저구매금액
FROM [ORDER] 


-- Q2. mem_no 및 order_date별(오름차순) 누적 집계함수를 사용하시오.
SELECT mem_no, order_date, sales_amt,
		COUNT(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적구매횟수,
		SUM(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적구매금액,
		AVG(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적평균구매금액,
		MAX(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적최고구매금액,
		MIN(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS 누적최저구매금액
FROM [ORDER] 