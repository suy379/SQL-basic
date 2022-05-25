USE EDU

SELECT * FROM MEMBER 

--------------------- 1. SELECT ------------------

-- WHERE : ONLY MAN
SELECT *
FROM MEMBER
WHERE gender = 'man'

-- GROUP BY
--ONLY MAN & addr�� �׷�����Ͽ� ȸ���� ���� 
SELECT addr, COUNT(mem_no) AS mem_cnt
FROM MEMBER
WHERE gender= 'man'
GROUP BY addr 


-- ONLY MAN & addr, gender �׷�����Ͽ� ȸ���� ����
SELECT addr, gender, count(mem_no) AS mem_cnt
FROM MEMBER
GROUP BY addr, gender 


--ONLY MAN & addr�� �׷�����Ͽ� ȸ���� ����(��, ȸ���� 50 �̻� ������)
SELECT addr, count(mem_no) AS mem_cnt
FROM MEMBER
WHERE gender = 'man'
GROUP BY addr
HAVING count(mem_no) >= 50 


--ORDER BY 
--ONLY MAN & addr�� �׷�����Ͽ� ȸ���� ����(��, ȸ���� 50 �̻� ������) & ȸ���� ���� ������ ����
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
-- [MEMBER] �������� LEFT JOIN
SELECT *
FROM [MEMBER] A
LEFT JOIN [ORDER] B
ON A.mem_no = B.mem_no

-- [ORDER] �������� RIGHT JOIN 
SELECT *
FROM [MEMBER] A
RIGHT JOIN [ORDER] B
ON A.mem_no = B.mem_no

-- [MEMBER] & [ORDER] FULL JOIN : ������(UNION)
SELECT *
FROM [MEMBER] A
FULL JOIN [ORDER] B
ON A.mem_no = B.mem_no



-- 3. OTHER JOIN : CROSS / SELF JOIN 

-- [MEMBER] �������� [ORDER]�� CROSS JOIN 
-- [MEMBER] �� 1���� [ORDER]�� ��� ��� JOIN -> �ʹ� �����Ƿ� mem_no = '1000001' �� �͸�!
SELECT *
FROM [MEMBER] A
CROSS JOIN [ORDER] B
WHERE A.mem_no = '1000001'


-- [MEMBER] X [MEMBER] SELF JOIN 
-- [MEMBER] �� 1���� [MEMBER]�� ��� ��� JOIN -> ���� �ʹ� �����Ƿ� mem_no = '1000001' �� �͸�!
SELECT *
FROM [MEMBER] A, [MEMBER] B 
WHERE A.mem_no = '1000001'



---------- 3. Sub Query -------------

-- 1. SELECT�� ��������
-- [MEMBER], [ORDER] �� ���밪�� ��Ī�ϵ�, [ORDER]�� ���� & [MEMBER]�� gender ���� ������ �ϱ�
SELECT *, (SELECT gender 
			FROM [MEMBER] B 
			WHERE B.mem_no = A.mem_no) AS gender
FROM [ORDER] A

SELECT A.*, B.gender
FROM [ORDER] A
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no


-- 2. FROM�� ��������
-- mem_no�� �ֹ��ݾ� ���� 
SELECT mem_no, SUM(sales_amt) AS tot_amt
FROM [ORDER]
GROUP BY mem_no

-- ���� ���� ���� FROM���� �־� �̾ƺ���..
SELECT *
FROM (SELECT mem_no, SUM(sales_amt) AS tot_amt
		FROM [ORDER]
	GROUP BY mem_no) A 


-- ���� A �� ��������, [MEMBER] ���̺��� ����: ȸ���� �ֹ��ݾװ� �� ȸ�� ������ �˰�;�!
SELECT *
FROM (SELECT mem_no, SUM(sales_amt) AS tot_amt
		FROM [ORDER]
	GROUP BY mem_no) A 
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no


-- 3. WHERE�� ��������(�Ϲ� ��������)

-- ���� ��������
-- [MEMBER] ���̺��� mem_no = '1000005'�� �ֹ������� [ORDER] ���̺��� �̱�
SELECT *
FROM [ORDER]
WHERE mem_no IN (SELECT mem_no FROM [MEMBER] WHERE mem_no = '1000005')

--Ȯ�� 
SELECT *
FROM [ORDER]
WHERE mem_no = '1000005'


-- ���� ��������
-- [MEMBER] ���̺��� gender = 'man'�� �ֹ������� [ORDER] ���̺��� �̱�
SELECT *
FROM [ORDER]
WHERE mem_no IN (SELECT mem_no FROM [MEMBER] WHERE gender = 'man')





------------- 4. FIANL QUIZ ---------- (�� ������� �Ұ�!!)

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
-- 1. [ORDER] �������� [MEMBER] ���̺� LEFT JOIN 
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

-- 2. 1���� FROM�� ��������(����)�� �Ͽ�, [MEMBER] ���̺�� LEFT JOIN 
SELECT *
FROM (SELECT mem_no, sum(sales_amt) tot_amt
		FROM [ORDER]
	GROUP BY mem_no ) A 
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 

-- 3. CALCUATE SUM OF [tot_amt] PER [gender, addr]

SELECT B.gender, B.addr, SUM(tot_amt) AS �հ�
FROM (SELECT mem_no, sum(sales_amt) tot_amt
		FROM [ORDER]
	GROUP BY mem_no ) A 
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 
GROUP BY B.gender, B.addr 