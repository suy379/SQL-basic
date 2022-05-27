--------------- Chapter 4. �ǹ��� �ʿ��� SQL -----------

------ 01 ���� ���̴� SQL ����
-- 1-1 ������
-- �� �˾Ƶα�
-- LIKE, BETWEEN, IN / = �� ���� 
-- NOT, AND, OR 


USE EDU

-- Q1. [MEMBER] ���̺��� [addr]�� 'SEOUL'�� �ƴ� ���� ��ȸ
SELECT *
FROM [MEMBER]
WHERE addr <> 'seoul'

-- Q2. [MEMBER] ���̺��� [gender]�� 'man'�̰� [ageband]�� 20�� ���� ��ȸ
SELECT *
FROM [MEMBER]
WHERE gender = 'man' AND ageband = 20 

-- [MEMBER] ���̺��� [gender]�� 'man'�̰� [ageband]�� 20�� ���� �Ǵ� [addr]�� 'seoul'�� ���� ��ȸ
SELECT *
FROM [MEMBER]
WHERE (gender = 'man' AND ageband = 20) OR addr = 'seoul'


-- Q3. [MEMBER] ���̺��� [ageband]�� 20~40�� ���� ��ȸ
SELECT *
FROM [MEMBER] 
WHERE ageband BETWEEN 20 AND 40 

-- [MEMBER] ���̺��� [addr]�� 'ae'�� �����ϴ� ���� ��ȸ
SELECT *
FROM [MEMBER]
WHERE addr LIKE '%ae%'


-- Q4. [ORDER] ���̺��� [sales_amt]�� 0.1�� ���� �� 'fees'�� ������.
SELECT *, (sales_amt*0.1) AS fees
FROM [ORDER]

-- [ORDER] ���̺��� [sales_amt]�� [sales_amt]�� 0.1�� ������ ���� �E���� �� 'Excluding_fees'�� ������.
SELECT *, (sales_amt - sales_amt*0.1) AS Excluding_fees
FROM [ORDER] 



--- 1-2 ���� �� �Լ�
-- 1)������ �Լ�

--Q1. 3.1419�� 2�� �ڸ����� �ݿø��Ͽ���.
SELECT ROUND(3.1419, 2)
-- 3.1419�� �ø��Ͽ� ������ ǥ���ض�.
SELECT CEILING(3.1419)
-- 3.1419�� �����Ͽ� ������ ǥ���ض�.
SELECT FLOOR(3.1419)

SELECT SQRT(100)
SELECT POWER(6,2)

-- 2) ������ �Լ�: ����ǥ �ʼ� 

-- Q1. 'eVERly'�� ��� �빮�ڷ�, 'EverLY'�� ��� �ҹ��ڷ� ��Ÿ����.
SELECT UPPER('eVERly')
SELECT LOWER('EverLY')

-- Q2. 'I LOVE HER.' �� ���� ���̴�?
SELECT LEN('I LOVE HER.')

-- Q3. 'I WISH YOU WERE HERE' ���忡�� ������ E�� �����϶�.
SELECT STUFF('I WISH YOU WERE HERE', 20, 1, ' ')
SELECT LEN('I WISH YOU WERE HERE')
-- �׸��� ��� �ҹ��ڷ� �ٲ��.
SELECT LOWER(STUFF('I WISH YOU WERE HERE', 20, 1, ' '))

-- Q4. '���� �������� ��ƿ�' ������ '���� ���ʱ��� ��ƿ�'�� �ٲپ��.
SELECT REPLACE('���� �������� ��ƿ�', '����', '����')

-- Q5. '����', '�α�', '����'�� �ٿ� '���ѹα�����'�� ������.
SELECT CONCAT('����', '�α�', '����')
-- ���⵵ ���� �ؼ� '���ѹα� ����'�� ������.
SELECT CONCAT('����', '', '�α�', ' ', '����')

-- Q6. '  �����ں����� ���Ͽ�   ' ��� ������� ������ ���� ������ �ִ�. �� ������ �����϶�.
SELECT TRIM('  �����ں����� ���Ͽ�   ')
SELECT RTRIM('  �����ں����� ���Ͽ�   ')
SELECT LTRIM('  �����ں����� ���Ͽ�   ')

-- Q7. '����� ���۱� �漮�� 184' ���� '����'�� �̾ƶ�.
SELECT SUBSTRING('����� ���۱� �漮�� 184', 5, 2)

-- Q8. '����� ���۱� �漮�� 184'���� '����'�� �̾ƶ�
SELECT LEFT('����� ���۱� �漮�� 184', 2)
-- �̹��� '184'�� �̾ƶ�
SELECT RIGHT('����� ���۱� �漮�� 184', 3)

-- Q9. '����� ���۱� �漮�� 184'���� '�漮' �̶�� �ܾ �� ��°�� �ִ°�?
SELECT CHARINDEX('�漮','����� ���۱� �漮�� 184')

--Q10. '����', '���ڹ�' �ܾ �����ϵ�, �߰��� ���� 5���ڸ� �߰��϶�. --�̷��� + �����ڷ� �ܾ� ������ �Ǵ±���~
SELECT '����' + SPACE(5) + '���ڹ�'

--�ݴ��
SELECT '����', SPACE(5),  '���ڹ�' -- ','�� ����� ���� �ٸ� ������ ����.



-- 3) ��¥�� �Լ� : ����ǥ �ʼ�!! / '����'�� ���� ���� ����.

-- Q1. ���� ��¥�� ����϶�.
SELECT GETDATE()

-- Q2. 2022-05-26 19:00:07 ��¥�� YEAR, MONTH, DAY, H, M, S, ������ �̾ƶ�.
SELECT YEAR('2022-05-26 19:00:07')
SELECT MONTH('2022-05-26 19:00:07')
SELECT DAY('2022-05-26 19:00:07')

SELECT DATEPART(YEAR, '2022-05-26 19:00:07')
SELECT DATEPART(MONTH, '2022-05-26 19:00:07')
SELECT DATEPART(DAY, '2022-05-26 19:00:07')
SELECT DATEPART(HH, '2022-05-26 19:00:07')
SELECT DATEPART(MI, '2022-05-26 19:00:07')
SELECT DATEPART(SS, '2022-05-26 19:00:07')

SELECT DATEPART(DW, '2022-05-26 19:00:07')

-- Q3. Ư�� ��¥ 2�� '2022-04-19 05:22:11' �� '2022-05-26 19:00:07' ��¥ ������ ������ �˰��� �Ѵ�.
SELECT DATEDIFF(YEAR, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(MONTH, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(DAY, '2022-04-19 05:22:11', '2022-05-26 19:00:07')

SELECT DATEDIFF(HH, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(MI, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(SS, '2022-04-19 05:22:11', '2022-05-26 19:00:07')

-- Q4. '2022-05-26'�� ������ ��;���. 100�� �� ��¥��?
SELECT DATEADD(DAY, 100, '2022-05-26')

-- �׷� 8���� ���� ��¥��?
SELECT DATEADD(MONTH, -8, '2022-05-26')




-- 4) ���� ��ȯ �Լ�
-- Q1. Ư�� �÷��� ���ڷ� �Ǿ��ִ�. �̸� 'INT'�� �����ϰ� �ʹٸ�?
SELECT CAST('0' AS INT)
-- ��¥�� DATETIME���� �Ǿ��ִµ� DATE�� �ٲٰ� �ʹٸ�?
SELECT CAST('2022-05-26 14:59:38' AS DATE)

-- Q2. NULL�� ������ ��� 0���� ��ȯ�Ͻÿ�.(����ġ ��ȯ)
SELECT ISNULL(NULL, 0)
-- Ư������ NULL�� �ƴϸ� �״�� ��ȯ�ض�.
SELECT ISNULL(99, 0)

-- Q3. �ΰ��� ������ ������ NULL�� ��ȯ�ض�.
SELECT NULLIF('A', 'A')
-- �� ������ �ٸ��� ù���� ������ ��ȯ
SELECT NULLIF(' A', 'A')
