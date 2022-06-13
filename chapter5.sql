USE EDU

-- Q1. 데이터 마트를 구성하시오.
-- 1) [CAR_ORDER] 테이블을 왼쪽으로 모든 테이블 LEFT JOIN
SELECT A.*,
	B.prod_cd, B.quantity,
	C.gender, C.age, C.addr, C.join_date,
	D.store_addr,
	E.brand, E.type, E.model, E.price
FROM [CAR_ORDER] A
LEFT JOIN [CAR_ORDERDETAIL] B
ON A.order_no = B.order_no 
LEFT JOIN [CAR_MEMBER] C
ON A.mem_no = C.mem_no
LEFT JOIN [CAR_STORE] D
ON A.store_cd = D.store_cd
LEFT JOIN [CAR_PRODUCT] E
ON B.prod_cd = E.prod_cd


-- 2) [CAR_ORDERDETAIL]의 quantity와, [CAR_PRODUCT]의 price를 곱해 sales_amt(주문금액) 열을 생성해라.
SELECT A.*,
	B.prod_cd, B.quantity,
	C.gender, C.age, C.addr, C.join_date,
	D.store_addr,
	E.brand, E.type, E.model, E.price,
	B.quantity*E.price AS sales_amt
FROM [CAR_ORDER] A
LEFT JOIN [CAR_ORDERDETAIL] B
ON A.order_no = B.order_no 
LEFT JOIN [CAR_MEMBER] C
ON A.mem_no = C.mem_no
LEFT JOIN [CAR_STORE] D
ON A.store_cd = D.store_cd
LEFT JOIN [CAR_PRODUCT] E
ON B.prod_cd = E.prod_cd

-- 3) [CAR_MART] 테이블을 생성하시오.
SELECT A.*,
	B.prod_cd, B.quantity,
	C.gender, C.age, C.addr, C.join_date,
	D.store_addr,
	E.brand, E.type, E.model, E.price,
	B.quantity*E.price AS sales_amt
INTO [CAR_MART] 
FROM [CAR_ORDER] A
LEFT JOIN [CAR_ORDERDETAIL] B
ON A.order_no = B.order_no 
LEFT JOIN [CAR_MEMBER] C
ON A.mem_no = C.mem_no
LEFT JOIN [CAR_STORE] D
ON A.store_cd = D.store_cd
LEFT JOIN [CAR_PRODUCT] E
ON B.prod_cd = E.prod_cd


-- 잘 생성되었나 확인
SELECT * FROM [CAR_MART]


--
-- Q2. 구매 고객 프로파일 분석: 고객의 성별/연령/지역 등을 활용해 구매자의 특징 및 특성을 파악한다.
-- 1) [CAR_MART]에 연령대 열을 추가한 세션 임시 테이블을 생성하라.
-- 조건: 연령구간 10세, 열이름 ageband, 임시테이블명 #PROFILE_BASE 
SELECT MIN(age), MAX(age)
FROM [CAR_MART]

SELECT *,
	CASE WHEN age BETWEEN 20 AND 29 THEN '20대'
		WHEN age BETWEEN 30 AND 39 THEN '30대'
		WHEN age BETWEEN 40 AND 49 THEN '40대'
		WHEN age BETWEEN 50 AND 59 THEN '50대'
		ELSE '60대' END AS ageband
INTO #PROFILE_BASE
FROM [CAR_MART]

-- 임시테이블 조회
-- 임시테이블이란 : 해당 쿼리창에서만 잠시 저장되는 테이블. 말 그대로 "임시"로 사용.
SELECT * FROM #PROFILE_BASE


-- 2) 위에서 만든 세션 임시 테이블을 활용해, 성별 및 연령대별 구매자 분포를 알아보아라.
-- 2-1)성별 구매자 분포
SELECT gender, COUNT(DISTINCT mem_no) AS mem_cnt 
FROM #PROFILE_BASE
GROUP BY gender 
WITH ROLLUP

-- 2-2)연령대별 구매자 분포
SELECT ageband, COUNT(DISTINCT mem_no) AS mem_cnt
FROM #PROFILE_BASE
GROUP BY ageband
WITH ROLLUP

-- 2-3) 성별&연령대별 구매자 분포
SELECT gender, ageband, COUNT(DISTINCT mem_no) AS mem_cnt
FROM #PROFILE_BASE
GROUP BY gender, ageband 
ORDER BY 1

-- 2-4) CASE WHEN의 또다른 활용
-- 성별&연령대별 구매자를 연도별로 카운트해라.
SELECT gender, ageband, 
		COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2020 THEN mem_no END) AS mem_cnt_20,
		COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2021 THEN mem_no END) AS mem_cnt_21
FROM #PROFILE_BASE
GROUP BY gender, ageband 
ORDER BY 1

-- 단, 주의!!
-- 원래 COUNT는 NULL값을 포함해 개수를 세지만, CASE WHEN과 함께 사용할 경우 NULL은 제외하고 집계함
-- 또한 CASE WHEN문에서 조건으로 설정한 것 외는 ELSE로 지정하지 않으면 모두 NULL로 집계됨.

SELECT COUNT(DISTINCT CASE WHEN YEAR(order_date) = 2020 THEN mem_no END) AS mem_cnt_20
FROM #PROFILE_BASE



--
-- Q3. RFM 고객세분화 분석
-- 고객의 구매지표(Recency, Frequency, Money)를 활용해 고객을 세분화한다.

-- 1) [CAR_MART] 테이블에서 고객별 RFM 세션 임시 테이블을 생성하라.
-- 조건: 2020~2021 주문건만 고려, 임시 테이블명은 #RFM_BASE 
-- 열은 mem_no별 총구매건수 & 총구매액
SELECT * FROM [CAR_MART]

SELECT mem_no, SUM(sales_amt) AS tot_amt, COUNT(order_no) AS ord_cnt
INTO #RFM_BASE 
FROM [CAR_MART] 
WHERE YEAR(order_date) BETWEEN 2020 AND 2021 
GROUP BY mem_no -- 어차피 mem_no는 그룹바이 할거니까 DISTINCT 안해도 됨 

-- 조회
SELECT *
FROM #RFM_BASE


-- 2) [CAR_MEMBER] 왼쪽 테이블을 기준으로 #RFM_BASE를 LEFT JOIN하고, 고객세분화 그룹 열을 추가해 세션 임시 테이블을 만들어라.
SELECT * FROM [CAR_MEMBER] 

SELECT A.*, 
	B.tot_amt, B.ord_cnt ,
	CASE WHEN B.tot_amt >= 1000000000 AND B.ord_cnt >= 3 THEN '1_VVIP'
	WHEN B.tot_amt >= 500000000 AND B.ord_cnt >= 2 THEN '2_VIP'
	WHEN B.tot_amt >= 300000000 THEN '3_GOLD'
	WHEN B.tot_amt >= 100000000 THEN '4_SILVER'
	WHEN B.ord_cnt >= 1 THEN '5_BRONZE' 
	ELSE '6_POTENTIAL' END AS seg
INTO [RFM_BASE_SEG2]
FROM [CAR_MEMBER] A 
LEFT JOIN #RFM_BASE B
ON A.mem_no = B.mem_no 

--조회
SELECT * FROM [RFM_BASE_SEG2]


--3) #RFM_BASE_SEG를 통해, seg별 고객 수 및 매출 비중을 파악하라.
SELECT seg, COUNT(mem_no) AS seg_cnt, SUM(tot_amt) AS seg_amt 
FROM [RFM_BASE_SEG2]
GROUP BY seg
ORDER BY 1


-- 응용: seg별 고객 수 비율을 뽑아보자. : COUNT는 비율을 못구하기 때문에 꼭 SUM으로 해주자...(빅쿼리에선 되는데 여기선 안됨..)
SELECT ROUND(SUM(CASE WHEN seg = '1_VVIP' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100,2)AS SEG1,
		ROUND(SUM(CASE WHEN seg = '2_VIP' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG2,
		ROUND(SUM(CASE WHEN seg = '3_GOLD' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG3,
		ROUND(SUM(CASE WHEN seg = '4_SILVER' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG4,
		ROUND(SUM(CASE WHEN seg = '5_BRONZE' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG5,
		ROUND(SUM(CASE WHEN seg = '6_POTENTIAL' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100, 2) AS SEG6
FROM [RFM_BASE_SEG2] 


-- %를 굳이 붙인다면....
SELECT CONCAT(CAST(ROUND(SUM(CASE WHEN seg = '1_VVIP' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT)*100,2) AS VARCHAR), '%')
FROM [RFM_BASE_SEG2] 


-- 응용2: seg별 매출 비율을 뽑아보자.
SELECT seg, SUM(tot_amt) AS seg_amt,
	ROUND((SUM(tot_amt) / (SELECT SUM(tot_amt) FROM [RFM_BASE_SEG2]))*100, 2) AS seg_rate
FROM [RFM_BASE_SEG2]
GROUP BY seg 
ORDER BY 1


--
-- Q4. 구매전환율 및 구매주기 분석
-- 고객들의 구매패턴을 파악할 때 사용한다.

-- 1) [CAR_MART]를 활용해 구매전환율 세션 임시 테이블을 생성하라. 
-- 2020년에 구매를 한 고객이 21년에도 구매한 경우 Y, 아니면 N을 표시하는 'retention' 열 생성 
-- 임시테이블명은 #RETENTION_BASE 

SELECT * FROM [CAR_MART] 

-- 20년도 구매고객 -중복이 있어서 꼭 제거해주기 
SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020
-- 21년도 구매고객 
SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021 

-- 먼저 20년 구매고객을 밑바탕으로 깔아 테이블을 만든다.
SELECT *
FROM (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020) A 
LEFT JOIN (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no 

-- 만일 NULL로 나온거면 전환이 안된거고, 값이 있음 재구매를 한 거겠지? 
SELECT A.mem_no AS mem_20, B.mem_no AS mem_21,
		CASE WHEN B.mem_no IS NOT NULL THEN 'Y'
		ELSE 'N' END AS retention
INTO #RETENTION_BASE 
FROM (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2020) A 
LEFT JOIN (SELECT DISTINCT mem_no FROM [CAR_MART] WHERE YEAR(order_date) = 2021) B
ON A.mem_no = B.mem_no 

-- 조회
SELECT * FROM #RETENTION_BASE

SELECT COUNT(mem_21), COUNT(DISTINCT mem_21) FROM #RETENTION_BASE

--DROP TABLE #RETENTION_BASE 


-- 2)#RETENTION_BASE 테이블을 활용해 구매전환율을 계산해라.
SELECT retention, COUNT(retention) AS re_cnt
FROM #RETENTION_BASE
GROUP BY retention
WITH ROLLUP 
ORDER BY 1 DESC 


SELECT CASE WHEN GROUPING(retention) = 1 THEN 'total' ELSE retention END AS 현황,
	   COUNT(retention) AS re_cnt
FROM #RETENTION_BASE
GROUP BY retention
WITH ROLLUP 

-- 또는 CASE WHEN을 사용하면
SELECT COUNT(*) AS total,
	COUNT(CASE WHEN retention = 'Y' THEN retention END) AS re_y
FROM #RETENTION_BASE 

SELECT COUNT(*) AS total,
	SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END) AS re_y
FROM #RETENTION_BASE 


-- (번외) 전환된 비율까지 구할 수 있을까?
SELECT * FROM #RETENTION_BASE


-- COUNT가 안먹기 때문에 SUM으로 바꿔서 써줘야 한다
SELECT	ROUND((SUM(CASE WHEN retention = 'Y' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT))*100,2) AS RE_Y,
		ROUND((SUM(CASE WHEN retention = 'N' THEN 1 ELSE 0 END) / CAST(COUNT(*) AS FLOAT))*100,2) AS RE_N
FROM #RETENTION_BASE 

-- 요렇게 하면 COUNT라서 안나온다는거..! 
SELECT retention,
	CONCAT(CAST(ROUND((COUNT(retention) / (SELECT COUNT(retention) FINAL_RE FROM #RETENTION_BASE))*100, 2) AS VARCHAR), '%') re_rate
FROM #RETENTION_BASE
GROUP BY retention 


-- 3) [CAR_MART]를 활용해 매장코드(store_cd)별로 구매주기를 구하고, 세션 임시 테이블 #CYCLE_BASE를 생성하라.
SELECT * FROM [CAR_MART]
-- 주의: 구매주기라는 것은 2번 이상 샀다는 뜻.
-- 구매주기(cycle) 공식: (최근구매일 - 최초구매일)/(구매횟수-1)


SELECT sub.store_cd, sub.order_lately, sub.first_order, sub.ord_cnt,
		DATEDIFF(DAY, sub.first_order, sub.order_lately)/(sub.ord_cnt -1) AS cycle,
		DATEDIFF(DAY, sub.first_order, sub.order_lately)*1.0/(sub.ord_cnt -1) AS cycle2 --소수점까지 
INTO #CYCLE_BASE 
FROM (SELECT store_cd, MAX(order_date) order_lately, MIN(order_date) first_order,
				COUNT(DISTINCT order_no) AS ord_cnt
		FROM [CAR_MART]
		GROUP BY store_cd
		HAVING COUNT(DISTINCT order_no) >= 2) sub
ORDER BY 6 DESC

SELECT * FROM #CYCLE_BASE 


-- 
-- Q5. 제품 및 성장률 분석: 상품의 경쟁력 파악 용도

-- 1) [CAR_MART] 테이블을 활용해 brand 및 model별 2020, 2021년 구매금액 세션 임시 테이블 #PRODUCT_GROWTH_BASE을 만들어라.
SELECT * FROM [CAR_MART] 

SELECT brand, model, 
	SUM(CASE WHEN YEAR(order_date) = 2020 THEN sales_amt END) AS amt_20,
	SUM(CASE WHEN YEAR(order_date) = 2021 THEN sales_amt END) AS amt_21
INTO #PRODUCT_GROWTH_BASE 
FROM [CAR_MART]
GROUP BY brand, model

SELECT * FROM #PRODUCT_GROWTH_BASE 


-- 2) #PRODUCT_GROWTH_BASE 테이블을 활용한 브랜드별 성장률을 파악해라. (전년도 대비 매출 성장률)
SELECT brand, SUM(amt_21)/SUM(amt_20)-1 AS growth 
FROM #PRODUCT_GROWTH_BASE 
GROUP BY brand 
ORDER BY 2 DESC 



-- 3) #PRODUCT_GROWTH_BASE 테이블에서 브랜드 및 모델별 성장률을 파악하라.
--단, 각 브랜드별 성장률 TOP2 모델만 필터링할 것
SELECT sub2.*
FROM (SELECT sub.*, 
				RANK() OVER (PARTITION BY sub.brand ORDER BY sub.growth desc) AS rnk
		FROM (SELECT brand, model, SUM(amt_21)/SUM(amt_20)-1 AS growth
				FROM #PRODUCT_GROWTH_BASE 
				GROUP BY brand , model ) sub ) sub2
WHERE sub2.rnk <= 2 