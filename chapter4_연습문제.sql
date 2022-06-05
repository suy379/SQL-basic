-- 4-3 �������� : ������ ��Ʈ �����ϱ�
-- ����: 2020�� �ֹ��ݾ� �� �Ǽ� ȸ�� �������� ����� 

-- Q1. [ORDER] ���̺��� mem_no�� sales_amt �հ�(���̸�: tot_amt) �� order_no�� ����(���̸�: tot_tr)�� ���ض�.
--(����: order_date�� 2020��)
SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
FROM [ORDER] 
WHERE YEAR(order_date) = 2020 
GROUP BY mem_no

-- Q2. [MEMBER] ���̺��� �������� �Ͽ� Q1���� ���� ���̺��� LEFT JOIN �Ͽ���.
SELECT A.*, B.tot_amt, B.tot_tr -- ���⼭ ��� ���� �������� �ʵ��� ����! B.mem_no���� ���� �ϸ� ������ �÷��� �ȵȴ�.
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-- Q3. Q2 ����� Ȱ���� ���ſ��� ���� �߰��Ͽ���.(������ �� �ִ� ȸ���̸� 1, �ƴϸ� 0)
SELECT A.*, B.tot_amt, B.tot_tr, 
	CASE WHEN B.mem_no IS NULL THEN 0
	ELSE 1 END AS ���ſ��� 
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-- Q4-1. Q3���� ���� ���̺��� ���� ���̺�(VIEW)�� ������.
CREATE VIEW [Q3_RESULT]
AS
SELECT A.*, B.tot_amt, B.tot_tr, 
	CASE WHEN B.mem_no IS NULL THEN 0
	ELSE 1 END AS ���ſ��� 
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-- Q4-2. Q3���� ���� ���̺��� �����ͺ��̽� �� ���̺�� ������.
SELECT A.*, B.tot_amt, B.tot_tr, 
	CASE WHEN B.mem_no IS NULL THEN 0
	ELSE 1 END AS ���ſ��� 
INTO [Q3_RESULT2] -- VIEW ���̺�� �̸� �ٸ��� �� ��
FROM [MEMBER] A 
LEFT JOIN (SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS tot_tr
			FROM [ORDER] 
			WHERE YEAR(order_date) = 2020 
			GROUP BY mem_no) B
ON A.mem_no = B.mem_no 


-------------------------
-- ������ ���ռ� 
-- ������ ���� [Q3_RESULT2] ���̺��� �� ����������� ������ ���ռ��� Ȯ���غ���.
-- Ȯ��: [Q3_RESULT2]�� ȸ�� �� �ֹ� ���� ��Ȯ�� �������ΰ�?

-- Q1. [Q3_RESULT2] ������ ��Ʈ�� ȸ�� �� �ߺ��� �ִ��� üũ�Ͻÿ�.
SELECT * FROM [Q3_RESULT2]

SELECT COUNT(mem_no), COUNT(DISTINCT mem_no)
FROM [Q3_RESULT2]

-- Q2. [MEMBER] ���̺�� [Q3_RESULT2] �� ȸ�� �� ���̴� ���°�? (�ֹ������� 2020���� ���� �ʿ� X. [MEMBER]�� �������� ���� �ٿ����Ƿ�)
SELECT COUNT(mem_no), COUNT(DISTINCT mem_no) FROM [MEMBER]
SELECT COUNT(mem_no) FROM [Q3_RESULT2]

-- Q3. [ORDER] ���̺�� [Q3_RESULT2] �� �ֹ� �� ���̴� ���°�?(�ֹ������� 2020������ ��� ����) 
SELECT * FROM [ORDER]

SELECT COUNT(order_no), COUNT(DISTINCT order_no) FROM [ORDER] WHERE YEAR(order_date) = 2020 
SELECT SUM(tot_tr) FROM [Q3_RESULT2] 

---------------------- ��� Q2, Q3���� [MEMBER]�� mem_no, [ORDER]�� order_no�� DISTINCT �� �ʿ�� ����.
-- ������ �� �÷� ��� PRIMARY KEY�̱� ������ ���� �ߺ����� �� ���� ���� ����.. 
-- ������ �����ϰ� �ϱ� ���ؼ� �غ�.

-- Q4. [Q3_RESULT2] ���̺��� �̱����ڴ� [ORDER] ���̺��� 2020�⿡ ���Ű� ���°�? 
SELECT mem_no, order_no, order_date
FROM [ORDER] 
WHERE mem_no IN (SELECT mem_no FROM [Q3_RESULT2] WHERE ���ſ��� = 0)
AND YEAR(order_date) = 2020

