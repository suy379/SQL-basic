USE EDU

SELECT * FROM MEMBER 

--------------------- 1. SELECT ------------------

-- WHERE : ONLY MAN
SELECT *
FROM MEMBER
WHERE gender = 'man'

-- GROUP BY
--ONLY MAN & addr로 그룹바이하여 회원수 집계 
SELECT addr, COUNT(mem_no) AS mem_cnt
FROM MEMBER
WHERE gender= 'man'
GROUP BY addr 


-- ONLY MAN & addr, gender 그룹바이하여 회원수 집계
SELECT addr, gender, count(mem_no) AS mem_cnt
FROM MEMBER
GROUP BY addr, gender 


--ONLY MAN & addr로 그룹바이하여 회원수 집계(단, 회원수 50 이상만 나오게)
SELECT addr, count(mem_no) AS mem_cnt
FROM MEMBER
WHERE gender = 'man'
GROUP BY addr
HAVING count(mem_no) >= 50 


--ORDER BY 
--ONLY MAN & addr로 그룹바이하여 회원수 집계(단, 회원수 50 이상만 나오게) & 회원수 높은 순으로 정렬
SELECT addr, count(mem_no) AS mem_cnt 
FROM MEMBER
WHERE gender = 'man'
GROUP BY addr 
HAVING count(mem_no) >= 50
ORDER BY 2 DESC 




------------------- 2. JOIN ----------------
USE EDU 
SELECT * FROM [MEMBER]
SELECT * FROM [ORDER]

-- JOIN TWO TABLES (KEY: mem_no)

--1. INNER JOIN
SELECT *
FROM [MEMBER] A 
INNER JOIN [ORDER] B 
ON A.mem_no = B.mem_no

--2. OUTER JOIN : LEFT / RIGHT / FULL JOIN 
-- [MEMBER] 기준으로 LEFT JOIN
SELECT *
FROM [MEMBER] A
LEFT JOIN [ORDER] B
ON A.mem_no = B.mem_no

-- [ORDER] 기준으로 RIGHT JOIN 
SELECT *
FROM [MEMBER] A
RIGHT JOIN [ORDER] B
ON A.mem_no = B.mem_no

-- [MEMBER] & [ORDER] FULL JOIN : 합집합(UNION)
SELECT *
FROM [MEMBER] A
FULL JOIN [ORDER] B
ON A.mem_no = B.mem_no



-- 3. OTHER JOIN : CROSS / SELF JOIN 

-- [MEMBER] 기준으로 [ORDER]와 CROSS JOIN 
-- [MEMBER] 행 1개당 [ORDER]의 모든 행과 JOIN -> 너무 많으므로 mem_no = '1000001' 인 것만!
SELECT *
FROM [MEMBER] A
CROSS JOIN [ORDER] B
WHERE A.mem_no = '1000001'


-- [MEMBER] X [MEMBER] SELF JOIN 
-- [MEMBER] 행 1개당 [MEMBER]의 모든 행과 JOIN -> 역시 너무 많으므로 mem_no = '1000001' 인 것만!
SELECT *
FROM [MEMBER] A, [MEMBER] B 
WHERE A.mem_no = '1000001'



---------- 3. Sub Query -------------

-- 1. SELECT절 서브쿼리
-- [MEMBER], [ORDER] 간 공통값만 매칭하되, [ORDER]는 전부 & [MEMBER]는 gender 열만 나오게 하기
SELECT *, (SELECT gender 
			FROM [MEMBER] B 
			WHERE B.mem_no = A.mem_no) AS gender
FROM [ORDER] A

SELECT A.*, B.gender
FROM [ORDER] A
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no


-- 2. FROM절 서브쿼리
-- mem_no별 주문금액 집계 
SELECT mem_no, SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY mem_no

-- 굳이 위의 식을 FROM절에 넣어 뽑아보면..
SELECT *
FROM (SELECT mem_no, SUM(sales_amt) AS tot_amt
		FROM [ORDER]
	GROUP BY mem_no) A 


-- 위의 A 를 기준으로, [MEMBER] 테이블을 결합: 회원별 주문금액과 그 회원 정보가 알고싶어!
SELECT *
FROM (SELECT mem_no, SUM(sales_amt) AS tot_amt
		FROM [ORDER]
	GROUP BY mem_no) A 
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no


-- 3. WHERE절 서브쿼리(일반 서브쿼리)

-- 단일 서브쿼리
-- [MEMBER] 테이블의 mem_no = '1000005'인 주문내역을 [ORDER] 테이블에서 뽑기
SELECT *
FROM [ORDER]
WHERE mem_no IN (SELECT mem_no FROM [MEMBER] WHERE mem_no = '1000005')

--확인 
SELECT *
FROM [ORDER]
WHERE mem_no = '1000005'


-- 다중 서브쿼리
-- [MEMBER] 테이블의 gender = 'man'인 주문내역을 [ORDER] 테이블에서 뽑기
SELECT *
FROM [ORDER]
WHERE mem_no IN (SELECT mem_no FROM [MEMBER] WHERE gender = 'man')





------------- 4. FIANL QUIZ ---------- (꼭 순서대로 할것!!)

-- Q1. 
-- 1. SELECT ALL DATA FROM [ORDER]
SELECT *
FROM [ORDER] 

-- 2. FILTER [shop_code] column OVER 30 
SELECT *
FROM [ORDER]
WHERE shop_code >= 30 

-- 3. CALCULATE SUM OF [sales_amt] PER [mem_no]
SELECT mem_no, SUM(sales_amt) AS tot_amt
FROM [ORDER]
WHERE shop_code >= 30 
GROUP BY mem_no

-- 4. FILTER SUM OF [sales_amt] OVER 100000
SELECT mem_no, SUM(sales_amt) AS tot_amt
FROM [ORDER]
WHERE shop_code >= 30 
GROUP BY mem_no 
HAVING SUM(sales_amt) >= 100000

-- 5. SORTING SUM OF [sales_amt] DESC
SELECT mem_no, SUM(sales_amt) AS tot_amt
FROM [ORDER]
WHERE shop_code >= 30 
GROUP BY mem_no 
HAVING SUM(sales_amt) >= 100000
ORDER BY 2 DESC 



-- Q2.
-- 1. [ORDER] 기준으로 [MEMBER] 테이블 LEFT JOIN 
SELECT *
FROM [ORDER] A
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no

-- 2. CALCULATE SUM OF [sales_amt] PER [gender]
SELECT B.gender AS gender, SUM(A.sales_amt) AS tot_amt
FROM [ORDER] A
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no
GROUP BY B.gender

-- 3. CALCULATE SUM OF [sales_amt] PER [gender, addr]
SELECT B.gender AS gender, B.addr AS addr, SUM(sales_amt) AS tot_amt
FROM [ORDER] A
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no
GROUP BY B.gender, B.addr 




-- Q3.
-- 1. CALCULATE SUM OF [sales_amt] PER [mem_no] IN [ORDER] TABLE 
SELECT * FROM [ORDER] 

SELECT mem_no, sum(sales_amt) tot_amt
FROM [ORDER]
GROUP BY mem_no 

-- 2. 1번을 FROM절 서브쿼리(기준)로 하여, [MEMBER] 테이블과 LEFT JOIN 
SELECT *
FROM (SELECT mem_no, sum(sales_amt) tot_amt
		FROM [ORDER]
	GROUP BY mem_no ) A 
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 

-- 3. CALCUATE SUM OF [tot_amt] PER [gender, addr]

SELECT B.gender, B.addr, SUM(tot_amt) AS 합계
FROM (SELECT mem_no, sum(sales_amt) tot_amt
		FROM [ORDER]
	GROUP BY mem_no ) A 
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 
GROUP BY B.gender, B.addr 