-- 02. 효율화 & 자동화에 필요한 SQL 문법
-- VIEW : 자주 사용하는 SQL 명령어를 저장 -> 즉, 새로 만든 테이블을 저장한다고 생각.
-- PROCEDURE : 자주 사용하는 SQL 명령어를 저장하되, '매개변수'를 활용해 자동화


-- VIEW
USE EDU

-- 생성: CREATE VIEW AS / 조회: 일반 테이블 조회랑 같음 / 수정: ALTER VIEW AS / 삭제: DROP VIEW

--이런 결과를 만들었다고 하자
SELECT A.*,
	B.gender,
	B.ageband,
	B.join_date
FROM [ORDER] A
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 


-- VIEW 생성
CREATE VIEW [SY_TABLE]
AS
SELECT A.*,
	B.gender,
	B.ageband,
	B.join_date
FROM [ORDER] A
LEFT JOIN [MEMBER] B 
ON A.mem_no = B.mem_no 


-- VIEW 조회
SELECT *
FROM [SY_TABLE]

-- VIEW 수정
-- 너무 데이터가 많은거 같아서, 채널코드가 1인 것만 저장

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

--다시확인
SELECT * FROM [SY_TABLE] 


-- VIEW 삭제
DROP VIEW [SY_TABLE] 




----- PROCEDURE
-- 생성: CREATE PROCEDURE () AS / 실행: EXEC / 수정: ALTER PROCEDURE () AS / 삭제: DROP PROCEDURE

-- 앞서 만들었던 JOIN 코드를 그대로 사용하되, 특정 AGEBAND 입력 시 그 값만 뽑히도록 해보자.

-- 생성
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


-- 조회 
EXEC [SY_PRO] 40 

-- 수정 : ageband뿐 아니라, gender와 order_date의 MONTH도 골라서 뽑을 수 있도록 해보자.
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

-- 다시 조회
EXEC [SY_PRO] 30, 'man', 1


-- 삭제
DROP PROCEDURE [SY_PRO] 