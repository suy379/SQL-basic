-- 1-4 ������ �Լ�
-- ������ ���� �Լ� / ������ ���� �Լ�(����)
-- ������ �Լ� + OVER (ORDER BY �� ASC or DESC)
-- ������ �Լ� + OVER (PARTITION BY �� ORDER BY ��)

USE EDU 
SELECT * FROM [ORDER] 

-- �����Լ� 
-- Q. order_date�� ����, �����ֹ����ں��� ������ �ο��϶�.(� �Լ��� �������� ���� ������ �޶���)
SELECT order_date,
	ROW_NUMBER() OVER (ORDER BY order_date ASC) AS rownumber,
	RANK() OVER (ORDER BY order_date ASC) AS rnk,
	DENSE_RANK() OVER (ORDER BY order_date ASC) AS densernk
FROM [ORDER]

-- Q. mem_no�� ���� �������� order_date�� ������ �ο��϶�.
SELECT mem_no, order_date,
	ROW_NUMBER() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS rownumber,
	RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS rnk,
	DENSE_RANK() OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS densernk
FROM [ORDER]



-- ���� �����Լ�

-- Q1. order_date�� ����, sales_amt�� ���� ����Ƚ��/���� ���űݾ�/���� ��ձ��űݾ�/���� �ְ��űݾ�/���� �������űݾ��� ���Ͽ���.
-- ����� ���� ���� order_date�� ���ؼ� ���������� ��� �Ȱ���! 
SELECT --order_date, sales_amt,
		COUNT(sales_amt) OVER (ORDER BY order_date ASC),
		SUM(sales_amt) OVER (ORDER BY order_date ASC)
FROM [ORDER] 


SELECT order_date, sales_amt,
		COUNT(sales_amt) OVER (ORDER BY order_date ASC) AS ��������Ƚ��,
		SUM(sales_amt) OVER (ORDER BY order_date ASC) AS �������űݾ�,
		AVG(sales_amt) OVER (ORDER BY order_date ASC) AS ������ձ��űݾ�,
		MAX(sales_amt) OVER (ORDER BY order_date ASC) AS �����ְ��űݾ�,
		MIN(sales_amt) OVER (ORDER BY order_date ASC) AS �����������űݾ�
FROM [ORDER] 


-- ���� �̷��� �ϸ�? (�׷��� ���� �����. �ֳĸ� order_date���� �������� ���ϴ� �Ŵϱ�!)
SELECT order_date, sales_amt,
		COUNT(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS ��������Ƚ��,
		SUM(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS �������űݾ�,
		AVG(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS ������ձ��űݾ�,
		MAX(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS �����ְ��űݾ�,
		MIN(sales_amt) OVER (PARTITION BY order_date ORDER BY order_date ASC) AS �����������űݾ�
FROM [ORDER] 


-- Q2. mem_no �� order_date��(��������) ���� �����Լ��� ����Ͻÿ�.
SELECT mem_no, order_date, sales_amt,
		COUNT(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ��������Ƚ��,
		SUM(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS �������űݾ�,
		AVG(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS ������ձ��űݾ�,
		MAX(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS �����ְ��űݾ�,
		MIN(sales_amt) OVER (PARTITION BY mem_no ORDER BY order_date ASC) AS �����������űݾ�
FROM [ORDER] 