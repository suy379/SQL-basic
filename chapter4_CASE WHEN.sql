-- CASE WHEN ����

------------------- ���� 1 ----------------------
-- 1. AGEBAND�� Ȱ���� 'AGEBAND_SEG' �÷��� ����ÿ�.
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




-- 2. ���� �� ���ɴ뺰 �����ڸ� ī��Ʈ�Ͻÿ�.
SELECT gender, ageband, COUNT(mem_no) AS mem_cnt 
FROM [MEMBER] 
GROUP BY gender, ageband 
ORDER BY 1

-- ���� �� ���ɴ뺰�� ī��Ʈ�ϵ�, join_date�� �������� ������ �����ڸ� ī��Ʈ�Ͻÿ�.
SELECT MIN(join_date), MAX(join_date)
FROM [MEMBER]

SELECT gender, ageband,	
	COUNT(CASE WHEN YEAR(join_date) = 2018 THEN mem_no END) AS join_18,
	COUNT(CASE WHEN YEAR(join_date) = 2019 THEN mem_no END) AS join_19
FROM [MEMBER]
GROUP BY gender, ageband
ORDER BY 1



-------------------- ���� 2----------------
-- 1. [CAR_MART]�� Ȱ���� ������ȯ���� ���ϱ� ����,
-- 2020�⿡ ���Ÿ� �� ���� 21�⿡�� ������ ��� Y, �ƴϸ� N�� ǥ���ϴ� 'retention' ���� �����϶�.

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

SELECT * FROM #RETENTION_BASE 

-- 2)#RETENTION_BASE ���̺��� Ȱ���� ������ȯ���� ����ض�.
SELECT retention, COUNT(retention) AS re_cnt
FROM #RETENTION_BASE
GROUP BY retention
WITH ROLLUP 
ORDER BY 1 DESC 



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
SELECT ROUND((SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END)/ CAST(COUNT(*) AS FLOAT))*100, 2)
FROM #RETENTION_BASE 


SELECT CONCAT(CAST(ROUND((SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END)/ CAST(COUNT(*) AS FLOAT))*100, 2) AS VARCHAR), '%')
FROM #RETENTION_BASE 