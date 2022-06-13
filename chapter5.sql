USE EDU

-- Q1. ������ ��Ʈ�� �����Ͻÿ�.
-- 1) [CAR_ORDER] ���̺��� �������� ��� ���̺� LEFT JOIN
SELECT A.*,
	B.prod_cd, B.quantity,
	C.gender, C.age, C.addr, C.join_date,
	D.store_addr,
	E.brand, E.type, E.model, E.price
FROM [CAR_ORDER] A
LEFT JOIN [CAR_ORDERDETAIL] B
ON A.order_no = B.order_no 
LEFT JOIN [CAR_MEMBER] C
ON A.mem_no = C.mem_no
LEFT JOIN [CAR_STORE] D
ON A.store_cd = D.store_cd
LEFT JOIN [CAR_PRODUCT] E
ON B.prod_cd = E.prod_cd


-- 2) [CAR_ORDERDETAIL]�� quantity��, [CAR_PRODUCT]�� price�� ���� sales_amt(�ֹ��ݾ�) ���� �����ض�.
SELECT A.*,
	B.prod_cd, B.quantity,
	C.gender, C.age, C.addr, C.join_date,
	D.store_addr,
	E.brand, E.type, E.model, E.price,
	B.quantity*E.price AS sales_amt
FROM [CAR_ORDER] A
LEFT JOIN [CAR_ORDERDETAIL] B
ON A.order_no = B.order_no 
LEFT JOIN [CAR_MEMBER] C
ON A.mem_no = C.mem_no
LEFT JOIN [CAR_STORE] D
ON A.store_cd = D.store_cd
LEFT JOIN [CAR_PRODUCT] E
ON B.prod_cd = E.prod_cd

-- 3) [CAR_MART] ���̺��� �����Ͻÿ�.
SELECT A.*,
	B.prod_cd, B.quantity,
	C.gender, C.age, C.addr, C.join_date,
	D.store_addr,
	E.brand, E.type, E.model, E.price,
	B.quantity*E.price AS sales_amt
INTO [CAR_MART] 
FROM [CAR_ORDER] A
LEFT JOIN [CAR_ORDERDETAIL] B
ON A.order_no = B.order_no 
LEFT JOIN [CAR_MEMBER] C
ON A.mem_no = C.mem_no
LEFT JOIN [CAR_STORE] D
ON A.store_cd = D.store_cd
LEFT JOIN [CAR_PRODUCT] E
ON B.prod_cd = E.prod_cd


-- �� �����Ǿ��� Ȯ��
SELECT * FROM [CAR_MART]


--
-- Q2. ���� �� �������� �м�: ���� ����/����/���� ���� Ȱ���� �������� Ư¡ �� Ư���� �ľ��Ѵ�.
-- 1) [CAR_MART]�� ���ɴ� ���� �߰��� ���� �ӽ� ���̺��� �����϶�.
-- ����: ���ɱ��� 10��, ���̸� ageband, �ӽ����̺�� #PROFILE_BASE 
SELECT MIN(age), MAX(age)
FROM [CAR_MART]

SELECT *,
	CASE WHEN age BETWEEN 20 AND 29 THEN '20��'
		WHEN age BETWEEN 30 AND 39 THEN '30��'
		WHEN age BETWEEN 40 AND 49 THEN '40��'
		WHEN age BETWEEN 50 AND 59 THEN '50��'
		ELSE '60��' END AS ageband
INTO #PROFILE_BASE
FROM [CAR_MART]

-- �ӽ����̺� ��ȸ
-- �ӽ����̺��̶� : �ش� ����â������ ��� ����Ǵ� ���̺�. �� �״�� "�ӽ�"�� ���.
SELECT * FROM #PROFILE_BASE


-- 2) ������ ���� ���� �ӽ� ���̺��� Ȱ����, ���� �� ���ɴ뺰 ������ ������ �˾ƺ��ƶ�.
-- 2-1)���� ������ ����
SELECT gender, COUNT(DISTINCT mem_no) AS mem_cnt 
FROM #PROFILE_BASE
GROUP BY gender 
WITH ROLLUP

-- 2-2)���ɴ뺰 ������ ����
SELECT ageband, COUNT(DISTINCT mem_no) AS mem_cnt
FROM #PROFILE_BASE
GROUP BY ageband
WITH ROLLUP

-- 2-3) ����&���ɴ뺰 ������ ����
SELECT gender, ageband, COUNT(DISTINCT mem_no) AS mem_cnt
FROM #PROFILE_BASE
GROUP BY gender, ageband 
ORDER BY 1

-- 2-4) CASE WHEN�� �Ǵٸ� Ȱ��
-- ����&���ɴ뺰 �����ڸ� �������� ī��Ʈ�ض�.
SELECT gender, ageband, 
		COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2020 THEN mem_no END) AS mem_cnt_20,
		COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2021 THEN mem_no END) AS mem_cnt_21
FROM #PROFILE_BASE
GROUP BY gender, ageband 
ORDER BY 1

-- ��, ����!!
-- ���� COUNT�� NULL���� ������ ������ ������, CASE WHEN�� �Բ� ����� ��� NULL�� �����ϰ� ������
-- ���� CASE WHEN������ �������� ������ �� �ܴ� ELSE�� �������� ������ ��� NULL�� �����.

SELECT COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2020 THEN mem_no END) AS mem_cnt_20
FROM #PROFILE_BASE



--
-- Q3. RFM ������ȭ �м�
-- ���� ������ǥ(Recency, Frequency, Money)�� Ȱ���� ���� ����ȭ�Ѵ�.

-- 1) [CAR_MART] ���̺��� ���� RFM ���� �ӽ� ���̺��� �����϶�.
-- ����: 2020~2021 �ֹ��Ǹ� ���, �ӽ� ���̺���� #RFM_BASE 
-- ���� mem_no�� �ѱ��ŰǼ� & �ѱ��ž�
SELECT * FROM [CAR_MART]

SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS ord_cnt
INTO #RFM_BASE 
FROM [CAR_MART] 
WHERE YEAR(order_date) BETWEEN 2020 AND 2021 
GROUP BY mem_no -- ������ mem_no�� �׷���� �ҰŴϱ� DISTINCT ���ص� �� 

-- ��ȸ
SELECT *
FROM #RFM_BASE


-- 2) [CAR_MEMBER] ���� ���̺��� �������� #RFM_BASE�� LEFT JOIN�ϰ�, ������ȭ �׷� ���� �߰��� ���� �ӽ� ���̺��� ������.
SELECT * FROM [CAR_MEMBER] 

SELECT A.*, 
	B.tot_amt, B.ord_cnt ,
	CASE WHEN B.tot_amt >= 1000000000 AND B.ord_cnt >= 3 THEN '1_VVIP'
	WHEN B.tot_amt >= 500000000 AND B.ord_cnt >= 2 THEN '2_VIP'
	WHEN B.tot_amt >= 300000000 THEN '3_GOLD'
	WHEN B.tot_amt >= 100000000 THEN '4_SILVER'
	WHEN B.ord_cnt >= 1 THEN '5_BRONZE' 
	ELSE '6_POTENTIAL' END AS seg
INTO [RFM_BASE_SEG2]
FROM [CAR_MEMBER] A 
LEFT JOIN #RFM_BASE B
ON A.mem_no = B.mem_no 

--��ȸ
SELECT * FROM [RFM_BASE_SEG2]


--3) #RFM_BASE_SEG�� ����, seg�� �� �� �� ���� ������ �ľ��϶�.
SELECT seg, COUNT(mem_no) AS seg_cnt, SUM(tot_amt) AS seg_amt 
FROM [RFM_BASE_SEG2]
GROUP BY seg
ORDER BY 1


-- ����: seg�� �� �� ������ �̾ƺ���. : COUNT�� ������ �����ϱ� ������ �� SUM���� ������...(���������� �Ǵµ� ���⼱ �ȵ�..)
SELECT ROUND(SUM(CASE WHEN seg = '1_VVIP' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100,2)AS SEG1,
		ROUND(SUM(CASE WHEN seg = '2_VIP' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG2,
		ROUND(SUM(CASE WHEN seg = '3_GOLD' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG3,
		ROUND(SUM(CASE WHEN seg = '4_SILVER' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG4,
		ROUND(SUM(CASE WHEN seg = '5_BRONZE' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG5,
		ROUND(SUM(CASE WHEN seg = '6_POTENTIAL' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG6
FROM [RFM_BASE_SEG2] 


-- %�� ���� ���δٸ�....
SELECT CONCAT(CAST(ROUND(SUM(CASE WHEN seg = '1_VVIP' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100,2) AS VARCHAR), '%')
FROM [RFM_BASE_SEG2] 


-- ����2: seg�� ���� ������ �̾ƺ���.
SELECT seg, SUM(tot_amt) AS seg_amt,
	ROUND((SUM(tot_amt) / (SELECT SUM(tot_amt) FROM [RFM_BASE_SEG2]))*100, 2) AS seg_rate
FROM [RFM_BASE_SEG2]
GROUP BY seg 
ORDER BY 1


--
-- Q4. ������ȯ�� �� �����ֱ� �м�
-- ������ ���������� �ľ��� �� ����Ѵ�.

-- 1) [CAR_MART]�� Ȱ���� ������ȯ�� ���� �ӽ� ���̺��� �����϶�. 
-- 2020�⿡ ���Ÿ� �� ���� 21�⿡�� ������ ��� Y, �ƴϸ� N�� ǥ���ϴ� 'retention' �� ���� 
-- �ӽ����̺���� #RETENTION_BASE 

SELECT * FROM [CAR_MART] 

-- 20�⵵ ���Ű� -�ߺ��� �־ �� �������ֱ� 
SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020
-- 21�⵵ ���Ű� 
SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021 

-- ���� 20�� ���Ű��� �ع������� ��� ���̺��� �����.
SELECT *
FROM (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020) A 
LEFT JOIN (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no 

-- ���� NULL�� ���°Ÿ� ��ȯ�� �ȵȰŰ�, ���� ���� �籸�Ÿ� �� �Ű���? 
SELECT A.mem_no AS mem_20, B.mem_no AS mem_21,
		CASE WHEN B.mem_no IS NOT NULL THEN 'Y'
		ELSE 'N' END AS retention
INTO #RETENTION_BASE 
FROM (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020) A 
LEFT JOIN (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no 

-- ��ȸ
SELECT * FROM #RETENTION_BASE

SELECT COUNT(mem_21), COUNT(DISTINCT mem_21) FROM #RETENTION_BASE

--DROP TABLE #RETENTION_BASE 


-- 2)#RETENTION_BASE ���̺��� Ȱ���� ������ȯ���� ����ض�.
SELECT retention, COUNT(retention) AS re_cnt
FROM #RETENTION_BASE
GROUP BY retention
WITH ROLLUP 
ORDER BY 1 DESC 


SELECT CASE WHEN GROUPING(retention) = 1 THEN 'total' ELSE retention END AS ��Ȳ,
	   COUNT(retention) AS re_cnt
FROM #RETENTION_BASE
GROUP BY retention
WITH ROLLUP 

-- �Ǵ� CASE WHEN�� ����ϸ�
SELECT COUNT(*) AS total,
	COUNT(CASE WHEN retention = 'Y' THEN retention END) AS re_y
FROM #RETENTION_BASE 

SELECT COUNT(*) AS total,
	SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END) AS re_y
FROM #RETENTION_BASE 


-- (����) ��ȯ�� �������� ���� �� ������?
SELECT * FROM #RETENTION_BASE


-- COUNT�� �ȸԱ� ������ SUM���� �ٲ㼭 ����� �Ѵ�
SELECT	ROUND((SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT))*100,2) AS RE_Y,
		ROUND((SUM(CASE WHEN retention = 'N' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT))*100,2) AS RE_N
FROM #RETENTION_BASE 

-- �䷸�� �ϸ� COUNT�� �ȳ��´ٴ°�..! 
SELECT retention,
	CONCAT(CAST(ROUND((COUNT(retention) / (SELECT COUNT(retention) FINAL_RE FROM #RETENTION_BASE))*100, 2) AS VARCHAR), '%') re_rate
FROM #RETENTION_BASE
GROUP BY retention 


-- 3) [CAR_MART]�� Ȱ���� �����ڵ�(store_cd)���� �����ֱ⸦ ���ϰ�, ���� �ӽ� ���̺� #CYCLE_BASE�� �����϶�.
SELECT * FROM [CAR_MART]
-- ����: �����ֱ��� ���� 2�� �̻� ��ٴ� ��.
-- �����ֱ�(cycle) ����: (�ֱٱ����� - ���ʱ�����)/(����Ƚ��-1)


SELECT sub.store_cd, sub.order_lately, sub.first_order, sub.ord_cnt,
		DATEDIFF(DAY, sub.first_order, sub.order_lately)/(sub.ord_cnt -1) AS cycle,
		DATEDIFF(DAY, sub.first_order, sub.order_lately)*1.0/(sub.ord_cnt -1) AS cycle2 --�Ҽ������� 
INTO #CYCLE_BASE 
FROM (SELECT store_cd, MAX(order_date) order_lately, MIN(order_date) first_order,
				COUNT(DISTINCT order_no) AS ord_cnt
		FROM [CAR_MART]
		GROUP BY store_cd
		HAVING COUNT(DISTINCT order_no) >= 2) sub
ORDER BY 6 DESC

SELECT * FROM #CYCLE_BASE 


-- 
-- Q5. ��ǰ �� ����� �м�: ��ǰ�� ����� �ľ� �뵵

-- 1) [CAR_MART] ���̺��� Ȱ���� brand �� model�� 2020, 2021�� ���űݾ� ���� �ӽ� ���̺� #PRODUCT_GROWTH_BASE�� ������.
SELECT * FROM [CAR_MART] 

SELECT brand, model, 
	SUM(CASE WHEN YEAR(order_date) = 2020 THEN sales_amt END) AS amt_20,
	SUM(CASE WHEN YEAR(order_date) = 2021 THEN sales_amt END) AS amt_21
INTO #PRODUCT_GROWTH_BASE 
FROM [CAR_MART]
GROUP BY brand, model

SELECT * FROM #PRODUCT_GROWTH_BASE 


-- 2) #PRODUCT_GROWTH_BASE ���̺��� Ȱ���� �귣�庰 ������� �ľ��ض�. (���⵵ ��� ���� �����)
SELECT brand, SUM(amt_21)/SUM(amt_20)-1 AS growth 
FROM #PRODUCT_GROWTH_BASE 
GROUP BY brand 
ORDER BY 2 DESC 



-- 3) #PRODUCT_GROWTH_BASE ���̺��� �귣�� �� �𵨺� ������� �ľ��϶�.
--��, �� �귣�庰 ����� TOP2 �𵨸� ���͸��� ��
SELECT sub2.*
FROM (SELECT sub.*, 
				RANK() OVER (PARTITION BY sub.brand ORDER BY sub.growth desc) AS rnk
		FROM (SELECT brand, model, SUM(amt_21)/SUM(amt_20)-1 AS growth
				FROM #PRODUCT_GROWTH_BASE 
				GROUP BY brand , model ) sub ) sub2
WHERE sub2.rnk <= 2 