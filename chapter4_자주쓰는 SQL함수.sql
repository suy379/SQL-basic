--------------- Chapter 4. 실무에 필요한 SQL -----------

------ 01 자주 쓰이는 SQL 문법
-- 1-1 연산자
-- 꼭 알아두기
-- LIKE, BETWEEN, IN / = 의 차이 
-- NOT, AND, OR 


USE EDU

-- Q1. [MEMBER] 테이블의 [addr]이 'SEOUL'이 아닌 값만 조회
SELECT *
FROM [MEMBER]
WHERE addr <> 'seoul'

-- Q2. [MEMBER] 테이블의 [gender]가 'man'이고 [ageband]가 20인 값만 조회
SELECT *
FROM [MEMBER]
WHERE gender = 'man' AND ageband = 20 

-- [MEMBER] 테이블의 [gender]가 'man'이고 [ageband]가 20인 값과 또는 [addr]이 'seoul'인 값만 조회
SELECT *
FROM [MEMBER]
WHERE (gender = 'man' AND ageband = 20) OR addr = 'seoul'


-- Q3. [MEMBER] 테이블에서 [ageband]가 20~40인 값만 조회
SELECT *
FROM [MEMBER] 
WHERE ageband BETWEEN 20 AND 40 

-- [MEMBER] 테이블에서 [addr]이 'ae'를 포함하는 값만 조회
SELECT *
FROM [MEMBER]
WHERE addr LIKE '%ae%'


-- Q4. [ORDER] 테이블에서 [sales_amt]를 0.1로 곱한 열 'fees'를 만들어라.
SELECT *, (sales_amt*0.1) AS fees
FROM [ORDER]

-- [ORDER] 테이블에서 [sales_amt]에 [sales_amt]를 0.1로 곱셈한 값을 뺼셈한 열 'Excluding_fees'를 만들어라.
SELECT *, (sales_amt - sales_amt*0.1) AS Excluding_fees
FROM [ORDER] 



--- 1-2 단일 행 함수
-- 1)숫자형 함수

--Q1. 3.1419를 2의 자리에서 반올림하여라.
SELECT ROUND(3.1419, 2)
-- 3.1419를 올림하여 정수로 표현해라.
SELECT CEILING(3.1419)
-- 3.1419를 버림하여 정수로 표현해라.
SELECT FLOOR(3.1419)

SELECT SQRT(100)
SELECT POWER(6,2)

-- 2) 문자형 함수: 따옴표 필수 

-- Q1. 'eVERly'를 모두 대문자로, 'EverLY'를 모두 소문자로 나타내라.
SELECT UPPER('eVERly')
SELECT LOWER('EverLY')

-- Q2. 'I LOVE HER.' 의 문자 길이는?
SELECT LEN('I LOVE HER.')

-- Q3. 'I WISH YOU WERE HERE' 문장에서 마지막 E를 제거하라.
SELECT STUFF('I WISH YOU WERE HERE', 20, 1, ' ')
SELECT LEN('I WISH YOU WERE HERE')
-- 그리고 모두 소문자로 바꿔라.
SELECT LOWER(STUFF('I WISH YOU WERE HERE', 20, 1, ' '))

-- Q4. '저는 강남구에 살아요' 문장을 '저는 서초구에 살아요'로 바꾸어라.
SELECT REPLACE('저는 강남구에 살아요', '강남', '서초')

-- Q5. '대한', '민국', '만세'를 붙여 '대한민국만세'로 만들어라.
SELECT CONCAT('대한', '민국', '만세')
-- 띄어쓰기도 같이 해서 '대한민국 만세'로 만들어라.
SELECT CONCAT('대한', '', '민국', ' ', '만세')

-- Q6. '  엘리자베스를 위하여   ' 라는 쓸모없는 공백이 많은 문장이 있다. 이 공백을 제거하라.
SELECT TRIM('  엘리자베스를 위하여   ')
SELECT RTRIM('  엘리자베스를 위하여   ')
SELECT LTRIM('  엘리자베스를 위하여   ')

-- Q7. '서울시 동작구 흑석로 184' 에서 '동작'만 뽑아라.
SELECT SUBSTRING('서울시 동작구 흑석로 184', 5, 2)

-- Q8. '서울시 동작구 흑석로 184'에서 '서울'만 뽑아라
SELECT LEFT('서울시 동작구 흑석로 184', 2)
-- 이번엔 '184'만 뽑아라
SELECT RIGHT('서울시 동작구 흑석로 184', 3)

-- Q9. '서울시 동작구 흑석로 184'에서 '흑석' 이라는 단어가 몇 번째에 있는가?
SELECT CHARINDEX('흑석','서울시 동작구 흑석로 184')

--Q10. '딸기', '수박바' 단어를 연결하되, 중간에 공백 5글자를 추가하라. --이렇게 + 연산자로 단어 연결이 되는구나~
SELECT '딸기' + SPACE(5) + '수박바'

--반대로
SELECT '딸기', SPACE(5),  '수박바' -- ','로 연결시 서로 다른 변수로 본다.



-- 3) 날짜형 함수 : 따옴표 필수!! / '기준'을 가장 먼저 쓴다.

-- Q1. 현재 날짜를 출력하라.
SELECT GETDATE()

-- Q2. 2022-05-26 19:00:07 날짜의 YEAR, MONTH, DAY, H, M, S, 요일을 뽑아라.
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

-- Q3. 특정 날짜 2개 '2022-04-19 05:22:11' 과 '2022-05-26 19:00:07' 날짜 사이의 간격을 알고자 한다.
SELECT DATEDIFF(YEAR, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(MONTH, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(DAY, '2022-04-19 05:22:11', '2022-05-26 19:00:07')

SELECT DATEDIFF(HH, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(MI, '2022-04-19 05:22:11', '2022-05-26 19:00:07')
SELECT DATEDIFF(SS, '2022-04-19 05:22:11', '2022-05-26 19:00:07')

-- Q4. '2022-05-26'에 연인을 사귀었다. 100일 뒤 날짜는?
SELECT DATEADD(DAY, 100, '2022-05-26')

-- 그럼 8개월 전의 날짜는?
SELECT DATEADD(MONTH, -8, '2022-05-26')




-- 4) 형식 변환 함수
-- Q1. 특정 컬럼이 문자로 되어있다. 이를 'INT'로 변경하고 싶다면?
SELECT CAST('0' AS INT)
-- 날짜가 DATETIME으로 되어있는데 DATE로 바꾸고 싶다면?
SELECT CAST('2022-05-26 14:59:38' AS DATE)

-- Q2. NULL이 있으면 모두 0으로 변환하시오.(결측치 변환)
SELECT ISNULL(NULL, 0)
-- 특정열이 NULL이 아니면 그대로 반환해라.
SELECT ISNULL(99, 0)

-- Q3. 두가지 변수가 같으면 NULL을 반환해라.
SELECT NULLIF('A', 'A')
-- 두 변수가 다르면 첫번쨰 변수를 반환
SELECT NULLIF(' A', 'A')
