-- 1-5. ���� ������
-- �ΰ� �̻��� SELECT�� ����� �ϳ��� ������. 
-- UNION / UNION ALL / INTERSECT, EXCEPT

USE EDU
SELECT * FROM [MEMBER_1]
SELECT * FROM [MEMBER_2]

-- ������ row-bind ���� 
-- UNION (�ߺ�X) , UNION ALL(�ߺ� O) 
SELECT * FROM [MEMBER_1]
UNION 
SELECT * FROM [MEMBER_2]

SELECT * FROM [MEMBER_1]
UNION ALL 
SELECT * FROM [MEMBER_2]



-- ������ row-bind ���� 
-- INTERSECT (�ߺ�X)
SELECT * FROM [MEMBER_1]
INTERSECT
SELECT * FROM [MEMBER_2] 


-- ������ row-bind ����
-- EXCEPT (�ߺ�X)
SELECT * FROM [MEMBER_1]
EXCEPT 
SELECT * FROM [MEMBER_2] 

SELECT * FROM [MEMBER_2]
EXCEPT 
SELECT * FROM [MEMBER_1] 