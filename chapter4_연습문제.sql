-- 4-3 연습문제 : 데이터 마트 구축하기
-- 목적: 2020년 주문금액 및 건수 회원 프로파일 만들기 

-- Q1. [ORDER] 테이블의 mem_no별 sales_amt 합계(열이름: tot_amt) 및 order_no의 개수(열이름: tot_tr)를 구해라.
--(조건: order_date가 2020년)
SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
FROM [ORDER] 
WHERE YEAR(order_date) = 2020 
GROUP BY mem_no

-- Q2. [MEMBER] 테이블을 왼쪽으로 하여 Q1에서 만든 테이블을 LEFT JOIN 하여라.
SELECT A.*, B.tot_amt, B.tot_tr -- 여기서 모든 열을 결합하지 않도록 주의! B.mem_no까지 같이 하면 고유한 컬럼이 안된다.
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-- Q3. Q2 결과를 활용해 구매여부 열을 추가하여라.(구매한 적 있는 회원이면 1, 아니면 0)
SELECT A.*, B.tot_amt, B.tot_tr, 
	CASE WHEN B.mem_no IS NULL THEN 0
	ELSE 1 END AS 구매여부 
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-- Q4-1. Q3에서 만든 테이블을 가상 테이블(VIEW)로 만들어라.
CREATE VIEW [Q3_RESULT]
AS
SELECT A.*, B.tot_amt, B.tot_tr, 
	CASE WHEN B.mem_no IS NULL THEN 0
	ELSE 1 END AS 구매여부 
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-- Q4-2. Q3에서 만든 테이블을 데이터베이스 내 테이블로 만들어라.
SELECT A.*, B.tot_amt, B.tot_tr, 
	CASE WHEN B.mem_no IS NULL THEN 0
	ELSE 1 END AS 구매여부 
INTO [Q3_RESULT2] -- VIEW 테이블과 이름 다르게 할 것
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-------------------------
-- 데이터 정합성 
-- 위에서 만든 [Q3_RESULT2] 테이블이 잘 만들어졌는지 데이터 정합성을 확인해보자.
-- 확인: [Q3_RESULT2]의 회원 및 주문 수가 정확한 데이터인가?

-- Q1. [Q3_RESULT2] 데이터 마트의 회원 수 중복이 있는지 체크하시오.
SELECT * FROM [Q3_RESULT2]

SELECT COUNT(mem_no), COUNT(DISTINCT mem_no)
FROM [Q3_RESULT2]

-- Q2. [MEMBER] 테이블과 [Q3_RESULT2] 간 회원 수 차이는 없는가? (주문연도를 2020으로 맞출 필요 X. [MEMBER]를 왼쪽으로 전부 붙였으므로)
SELECT COUNT(mem_no), COUNT(DISTINCT mem_no) FROM [MEMBER]
SELECT COUNT(mem_no) FROM [Q3_RESULT2]

-- Q3. [ORDER] 테이블과 [Q3_RESULT2] 간 주문 수 차이는 없는가?(주문연도를 2020년으로 모두 통일) 
SELECT * FROM [ORDER]

SELECT COUNT(order_no), COUNT(DISTINCT order_no) FROM [ORDER] WHERE YEAR(order_date) = 2020 
SELECT SUM(tot_tr) FROM [Q3_RESULT2] 

---------------------- 사실 Q2, Q3에서 [MEMBER]의 mem_no, [ORDER]의 order_no는 DISTINCT 할 필요는 없다.
-- 어차피 두 컬럼 모두 PRIMARY KEY이기 때문에 절대 중복으로 들어갈 수가 없기 때문.. 
-- 하지만 안전하게 하기 위해서 해봄.

-- Q4. [Q3_RESULT2] 테이블의 미구매자는 [ORDER] 테이블에서 2020년에 구매가 없는가? 
SELECT mem_no, order_no, order_date
FROM [ORDER] 
WHERE mem_no IN (SELECT mem_no FROM [Q3_RESULT2] WHERE 구매여부 = 0)
AND YEAR(order_date) = 2020

