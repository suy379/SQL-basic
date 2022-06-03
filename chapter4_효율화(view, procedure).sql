-- 02. ȿ��ȭ & �ڵ�ȭ�� �ʿ��� SQL ����
-- VIEW : ���� ����ϴ� SQL ��ɾ ���� -> ��, ���� ���� ���̺��� �����Ѵٰ� ����.
-- PROCEDURE : ���� ����ϴ� SQL ��ɾ �����ϵ�, '�Ű�����'�� Ȱ���� �ڵ�ȭ


-- VIEW
USE EDU

-- ����: CREATE VIEW AS / ��ȸ: �Ϲ� ���̺� ��ȸ�� ���� / ����: ALTER VIEW AS / ����: DROP VIEW

--�̷� ����� ������ٰ� ����
SELECT A.*,
	B.gender,
	B.ageband,
	B.join_date
FROM [ORDER] A
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 


-- VIEW ����
CREATE VIEW [SY_TABLE]
AS
SELECT A.*,
	B.gender,
	B.ageband,
	B.join_date
FROM [ORDER] A
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 


-- VIEW ��ȸ
SELECT *
FROM [SY_TABLE]

-- VIEW ����
-- �ʹ� �����Ͱ� ������ ���Ƽ�, ä���ڵ尡 1�� �͸� ����

ALTER VIEW [SY_TABLE]
AS
SELECT A.*,
	B.gender,
	B.ageband,
	B.join_date
FROM [ORDER] A
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no
WHERE A.channel_code = 1 

--�ٽ�Ȯ��
SELECT * FROM [SY_TABLE] 


-- VIEW ����
DROP VIEW [SY_TABLE] 




----- PROCEDURE
-- ����: CREATE PROCEDURE () AS / ����: EXEC / ����: ALTER PROCEDURE () AS / ����: DROP PROCEDURE

-- �ռ� ������� JOIN �ڵ带 �״�� ����ϵ�, Ư�� AGEBAND �Է� �� �� ���� �������� �غ���.

-- ����
CREATE PROCEDURE [SY_PRO] 
(@ageband AS INT)
AS 
SELECT A.*,
	B.gender,
	B.ageband,
	B.join_date
FROM [ORDER] A
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no
WHERE B.ageband = @ageband 


-- ��ȸ 
EXEC [SY_PRO] 40 

-- ���� : ageband�� �ƴ϶�, gender�� order_date�� MONTH�� ��� ���� �� �ֵ��� �غ���.
ALTER PROCEDURE [SY_PRO]
(@ageband AS INT,
@gender AS VARCHAR(20),
@month_date AS INT)
AS
SELECT A.*,
	B.gender,
	B.ageband,
	B.join_date
FROM [ORDER] A
LEFT JOIN [MEMBER] B
ON A.mem_no = B.mem_no
WHERE B.ageband = @ageband 
AND B.gender = @gender
AND MONTH(order_date) = @month_date

-- �ٽ� ��ȸ
EXEC [SY_PRO] 30, 'man', 1


-- ����
DROP PROCEDURE [SY_PRO] 