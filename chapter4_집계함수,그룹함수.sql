-- 1-3 ���� �� �Լ�(GROUPING FUNCTION)

-- �����Լ�
-- COUNT, SUM, AVG, MAX, MIN, STDEV, VAR 

USE EDU
SELECT * FROM [ORDER]

-- USING ALL DATA = describe data
SELECT COUNT(order_no) AS ���ֹ���,
		SUM(sales_amt) AS ���ֹ��ݾ�,
		AVG(sales_amt) AS ����ֹ��ݾ�,
		MAX(order_date) AS �ֱٱ�������,
		MIN(order_date) AS ���ʱ�������,
		STDEV(sales_amt) AS �ֹ��ݾ�_ǥ��,
		VAR(sales_amt) AS �ֹ��ݾ�_�л�
FROM [ORDER] 


-- USING WITH GROUP BY
-- describe data per mem_no
SELECT mem_no,
		COUNT(order_no) AS ���ֹ���,
		SUM(sales_amt) AS ���ֹ��ݾ�,
		AVG(sales_amt) AS ����ֹ��ݾ�,
		MAX(order_date) AS �ֱٱ�������,
		MIN(order_date) AS ���ʱ�������,
		STDEV(sales_amt) AS �ֹ��ݾ�_ǥ��,
		VAR(sales_amt) AS �ֹ��ݾ�_�л�
FROM [ORDER] 
GROUP BY mem_no




-- �׷��Լ�
-- WITH ROLLUP, WITH CUBE, GROUPING SETS, GROUPING
-- GROUP BY �׸���� �׷����� ���� �Լ��̸�, ��ü������ GROUP BY �׸��� 2�� �̻��� ��쿡�� ���!

USE EDU

-- ������ �׷���� 
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
ORDER BY 1 DESC, 2 ASC 


-- 1) WITH ROLLUP �Բ� ���: ������ -> ���� ������ �׷� ���� / �Ѱ�, �Ұ� ���� �� Ȱ�� 
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC 

--������ �ٲ۴ٸ�? ���� ��з��� �������� ������ ���� ���ϴ�..
SELECT channel_code AS ch_code,
		YEAR(order_date) AS year1,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY channel_code, YEAR(order_date)
WITH ROLLUP
ORDER BY 1 ASC, 2 DESC 



-- 2) WITH CUBE �Բ� ���: ��� GROUPBY ����� ���� �׷����� ���� 
-- �ռ� ���̽����� ������ �Ұ�� �ƴµ�, ä���ڵ庰 �Ұ�� ������. WITH CUBE�� �̰� �˼�����! / �Ѱ�, �Ұ� ���Ҷ� Ȱ�� 
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH CUBE 
ORDER BY 1 DESC, 2 ASC 


-- 3) GROUPING SETS: GROUP BY �׸���� ���� �׷����� ����.
-- �� GROUP BY�� ������ �׸���� "�Ұ�"�� ����(ä���ڵ庰 �Ұ�, ������ �Ұ�)
SELECT YEAR(order_date) AS year1,
		channel_code AS ch_code,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY GROUPING SETS(YEAR(order_date), channel_code)


-- 4) GROUPING: WITH ROLLUP, WITH CUBE�� �Բ� ���Ǹ�
-- ��׿� ���� �׷�ȭ�� ��� 0, �ƴϸ� 1�� ��ȯ / NULL�� ������ �κи� 1
SELECT YEAR(order_date) AS year1,
		GROUPING(YEAR(order_date)) AS year1_group,
		channel_code AS ch_code,
		GROUPING(channel_code) AS chcode_group,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH ROLLUP
ORDER BY 1 DESC, 2 ASC 

-- CUBE��?
SELECT YEAR(order_date) AS year1,
		GROUPING(YEAR(order_date)) AS year1_group,
		channel_code AS ch_code,
		GROUPING(channel_code) AS chcode_group,
		SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY YEAR(order_date), channel_code
WITH CUBE 
ORDER BY 1 DESC, 2 ASC 

-- GROUPING�� ����: CASE WHEN�� �Բ� NULL �̸��� ������ �� �ִ�.
-- ����, ä���ڵ�, sales_amt�� FROM�� ���������� ������!! 

-- (�� �ڵ� ����� ����) year1�� ch_code�� ���� ������(VARCHAR)���� �ٲ���� ��. �Ѱ�, �Ұ��� ���ڸ� �־��ַ���!!
SELECT CASE WHEN GROUPING(year1) = 1 THEN '�Ѱ�'
		ELSE year1 END AS ����_�Ѱ�,
		CASE WHEN GROUPING(ch_code) = 1 THEN '�Ұ�'
		ELSE ch_code END AS ä���ڵ�_�Ѱ�,
		SUM(sales_amt) AS tot_amt
FROM (SELECT YEAR(order_date) AS year1,
				channel_code AS ch_code,
				sales_amt 
		FROM [ORDER]) A
GROUP BY year1, ch_code
WITH ROLLUP 


--CAST ����Ͽ� ���������� �ٲ��� ���
SELECT CASE WHEN GROUPING(year1) = 1 THEN '�Ѱ�'
		ELSE year1 END AS ����_�Ѱ�,
		CASE WHEN GROUPING(ch_code) = 1 THEN '�Ұ�'
		ELSE ch_code END AS ä���ڵ�_�Ѱ�,
		SUM(sales_amt) AS tot_amt
FROM (SELECT CAST(YEAR(order_date) AS VARCHAR) AS year1,
				CAST(channel_code AS VARCHAR) AS ch_code,
				sales_amt 
		FROM [ORDER]) A
GROUP BY year1, ch_code
WITH ROLLUP 


-- ������ ����. ä���ڵ�_�Ѱ��� �� ������ ���� '�Ѱ�'�� ���;� �Ѵ�
SELECT CASE WHEN GROUPING(year1) = 1 THEN '�Ѱ�'
		ELSE year1 END AS ����_�Ѱ�,
		CASE WHEN GROUPING(year1) = 1 THEN '�Ѱ�' -- �̰� �� ū�����̹Ƿ� ���� ���ش�
		WHEN GROUPING(ch_code) = 1 THEN '�Ұ�'
		ELSE ch_code END AS ä���ڵ�_�Ѱ�,
		SUM(sales_amt) AS tot_amt
FROM (SELECT CAST(YEAR(order_date) AS VARCHAR) AS year1,
				CAST(channel_code AS VARCHAR) AS ch_code,
				sales_amt 
		FROM [ORDER]) A
GROUP BY year1, ch_code
WITH ROLLUP 