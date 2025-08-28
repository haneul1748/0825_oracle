/*
 * < SUB QUERY 서브쿼리 >
 * 
 * 하나의 메인 SQL(SELECT, INSERT, DELETE, CREATE, ....)안에 포함된
 * 또 하나의 SELECT문
 * 
 * MAIN SQL문의 보조역할을 하는 쿼리문
 */

-- 간단 서브쿼리 예시
SELECT * FROM EMPLOYEE;
-- 박세혁 사원과 부서가 같은 사원들의 사원명 조회

-- 1) 먼저 박세혁 사원의 부서코드 조회
SELECT
	   DEPT_CODE
  FROM
	   EMPLOYEE
 WHERE
       EMP_NAME = '박세혁'; 

-- 2) 부서코드가 D5인 사원들의 사원명 조회
SELECT
	   EMP_NAME
  FROM
  	   EMPLOYEE
 WHERE
  	   DEPT_CODE = 'D5';

-- 위 두 단계를 하나의 쿼리문으로 합치기
SELECT
	   EMP_NAME
FROM
	   EMPLOYEE
WHERE
	   DEPT_CODE = (
	SELECT
						   DEPT_CODE
	FROM
		EMPLOYEE
	WHERE
		EMP_NAME = '박세혁');

---------------------------------------------------------
-- 간단한 서브쿼리 예시 두 번째
-- 전체 사원의 평균 급여보다 더 많은 급여를 받고 있는 사원들의 사번, 사원명을 조회

-- 1) 전체 사원의 평균 급여 구하기
SELECT
	   AVG(SALARY)
  FROM
  	   EMPLOYEE;  -- 대략 3,131,140원

-- 2) 급여가 3131140원 이상인 사원들의 사번, 사원명
SELECT
	   EMP_ID
	 , EMP_NAME
  FROM
  	   EMPLOYEE
 WHERE
 	   SALARY  >= (3131140);

-- 3) 합치기
SELECT
	   EMP_ID
	 , EMP_NAME
  FROM
  	   EMPLOYEE
 WHERE
 	   SALARY >= (SELECT
	   				     AVG(SALARY)
 				    FROM
  	  					 EMPLOYEE);
-------------------------------------------------------
/*
 * 서브쿼리의 분류
 * 
 * 서브쿼리를 수행한 결과가 몇 행 몇 열이냐에 따라서 분류됨
 * 
 * - 단일행 [단일열] 서브쿼리 : 서브쿼리 수행 결과가 딱 1개일 경우
 * - 다중행 [단일열] 서브쿼리 : 서브쿼리 수행결과가 여러 행일 때
 * - [단일열] 다중열 서브쿼리 : 서브쿼리 수행 결과가 여러 열일 때
 * - 다중행 다중열 서브쿼리 : 서브쿼리 수행 결과가 여러 행, 여러 줄일 때
 * 
 * => 수행결과가 몇 행 몇 열이냐에 따라서 사용할 수 있는 연산자가 다름
 * 
 */

/*
 * 1. 단일 행 서브쿼리(SINGLE ROW SUBQUERY)
 * 
 * 서브쿼리의 조합 결과값이 오로지 1개 일 때
 * 
 * 일반 연산자 사용 (=, !=, >, <....)
 */
-- 전 직원의 평균 급여보다 적게 받는 사원들의 사원명, 전화번호 조회
-- 1. 평균급여 구하기
SELECT
	   AVG(SALARY)
  FROM
  	   EMPLOYEE; -- 3,131,140 --> 결과값 : 오로지 1개의 값
  	   
SELECT
	   EMP_NAME
	 , PHONE
  FROM
  	   EMPLOYEE
 WHERE 
 	   SALARY < (SELECT
	   				    AVG(SALARY)
                   FROM
  	                    EMPLOYEE);

-- 최저급여를 받는 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회

-- 1. 최저급여
SELECT
	   MIN(SALARY)
  FROM
  	   EMPLOYEE;
-- 2. 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회
SELECT 
	   EMP_ID
	 , EMP_NAME
	 , JOB_CODE
	 , SALARY
	 , HIRE_DATE
  FROM
   	   EMPLOYEE
 WHERE
	   SALARY = (SELECT
	   	   			    MIN(SALARY)
  				   FROM
  	   					EMPLOYEE);

-- 안준영 사원의 급여보다 더 많은 급여를 받는 사원들의 사원명, 급여 조회
SELECT
	   SALARY
  FROM
  	   EMPLOYEE
 WHERE
  	   EMP_NAME = '안준영'; -- 1,380,000

SELECT
	   EMP_NAME
	 , SALARY
  FROM
  	   EMPLOYEE
 WHERE
 	   SALARY > (SELECT
					    SALARY
  				   FROM
  	 				    EMPLOYEE
				  WHERE
  					    EMP_NAME = '안준영');

-- JOIN도 써먹어야죵
-- 박수현 사원과 같은 부서인 사원들의 사원명, 전화번호, 직급명을 조회하는데 박수현 사원을 제외
SELECT * FROM EMPLOYEE;
SELECT * FROM JOB;

SELECT
	   DEPT_CODE
  FROM
  	   EMPLOYEE
 WHERE
 	   EMP_NAME = '박수현'; --D5(박수현사원과 같은 부서 찾기)

SELECT
	   EMP_NAME
	 , PHONE
	 , JOB_NAME
  FROM
  	   EMPLOYEE 
  	 , JOB
WHERE
	  EMPLOYEE.JOB_CODE = JOB.JOB_CODE 
  AND
  	  DEPT_CODE = (SELECT
	  					  DEPT_CODE
 				     FROM
  	                      EMPLOYEE
                    WHERE
 	                      EMP_NAME = '박수현') -- (사원명, 전화번호, 직급 조회)
  AND
	  EMP_NAME != '박수현'; -- (박수현 제외)

--ANSI
SELECT
	   EMP_NAME
	 , PHONE
	 , JOB_NAME
  FROM 
  	   EMPLOYEE
  JOIN 
  	   JOB USING(JOB_CODE)
 WHERE
 	   DEPT_CODE = (SELECT
	  					  DEPT_CODE
 				     FROM
  	                      EMPLOYEE
                    WHERE
 	                      EMP_NAME = '박수현')
   AND
  	   EMP_NAME != '박수현';
-----------------------------------------------------------
-- 부서별 급여 합계가 가장 큰 부서의 부서명, 부서코드, 급여합계 조회
--1. 각 부서별 급여 합계
SELECT
	   SUM(SALARY)
  FROM
  	   EMPLOYEE
 GROUP
	BY
	   DEPT_CODE; 

--1_2. 부서별 급여합계 중 가장 큰 급여합
SELECT
	   MAX(SUM(SALARY))
  FROM
  	   EMPLOYEE
 GROUP
	BY
	   DEPT_CODE;

SELECT
	   SUM(SALARY)
	 , DEPT_CODE
	 , DEPT_TITLE
  FROM
  	   EMPLOYEE
  JOIN
  	   DEPARTMENT ON (DEPT_ID = DEPT_CODE)
 GROUP
	BY
	   DEPT_CODE,
	   DEPT_TITLE;

---------------------------------------------------------------------
/*
 * 2. 다중 행 서브쿼리
 * 서브쿼리의 조회 결과값이 여러 행일때
 * 
 * - IN(10, 20, 30) : 여러 개의 결과값 중 한 개라도 일치하는 값이 있다면
 */
-- 각 부서별 최고급여를 받는 사원의 이름, 급여 조회

SELECT
	   MAX(SALARY)
  FROM
       EMPLOYEE 
 GROUP
    BY 
       DEPT_CODE; -- 830, 390, 366, 255, 289, 376, 750
       
SELECT * FROM EMPLOYEE;

SELECT 
       EMP_NAME
     , SALARY
  FROM
       EMPLOYEE
 WHERE
       SALARY IN(SELECT
	                    MAX(SALARY)
                   FROM
                        EMPLOYEE 
                  GROUP
                     BY 
                        DEPT_CODE);

-- 이승철 사원 또는 선승제 사원과 같은 부서인 사원들의 사원명, 핸드폰 번호 조회
SELECT 
	   DEPT_CODE
  FROM
       EMPLOYEE 
 WHERE
       EMP_NAME IN ('이승철','선승제');


SELECT 
       EMP_NAME
     , PHONE
  FROM
       EMPLOYEE
 WHERE
       DEPT_CODE IN (SELECT 
	   	                    DEPT_CODE
                       FROM
                            EMPLOYEE 
                      WHERE
                            EMP_NAME IN ('이승철','선승제'));

SELECT * FROM JOB;
-- 인턴(수습사원) < 사원 < 주임 < 대리 < 과장 < 차장 < 부장

SELECT * FROM EMPLOYEE;
-- 대리직급에도 불구하고 과장보다 급여를 많이받는 대리가 존재한다...!

-- 1) 과장들은 얼마를 받고 있는가

-- '과장'
SELECT
	   SALARY
  FROM
       EMPLOYEE E
     , JOB J
 WHERE
       J.JOB_CODE = E.JOB_CODE
   AND
       JOB_NAME = '과장';  -- 220, 250, 232, 376, 750
       
-- 2) 위의 급여보다 높은 급여를 받고 있는 대리의 사원명, 직급명, 급여
SELECT
       EMP_NAME
     , JOB_NAME
     , SALARY
  FROM
       EMPLOYEE E
     , JOB J
 WHERE
       E.JOB_CODE=J.JOB_CODE
   AND
       --SALARY > ANY(2000000, 2500000, 2300000)
       --SALARY >2000000 OR SALARY> 2500000 OR SALARY > 2300000....
       SALARY > ANY(SELECT
	                       SALARY
                      FROM
                           EMPLOYEE E
                         , JOB J
                     WHERE
                           J.JOB_CODE = E.JOB_CODE
                       AND
                           JOB_NAME = '과장')
                       AND
                           JOB_NAME ='대리';
      
/*
 * X(컬럼) > ANY(값, 값, 값)
 * X의 값이 ANY괄호안의 값 중 하나라도 크면 참
 * 
 * >ANY(값,값,값) : 여러 개의 결과값 중 하나라도 "클"경우 참을 반환
 * 
 * < ANY(값, 값, 값) : 여러 개의 결과값 중 하나라도 "작을 경우 참을 반환
 */
    
 -- 과장직급인데 모든 차장직급의 급여ㄷ보다 더 많이 받는 직원
 
SELECT 
       SALARY
  FROM
       EMPLOYEE
  JOIN
       JOB USING(JOB_CODE)
 WHERE 
       JOB_NAME = '차장';

SELECT
       EMP_NAME
  FROM
       EMPLOYEE
  JOIN
       JOB USING(JOB_CODE)
 WHERE
       SALARY > ALL(SELECT 
                           SALARY
                      FROM
                           EMPLOYEE
                      JOIN
                           JOB USING(JOB_CODE)
                     WHERE 
                           JOB_NAME = '차장')
   AND 
       JOB_NAME = '과장';
------------------------------------------------------
/*
 * 3. 다중 열 서브쿼리
 * 
 * 조회결과는한 행이지만 나열된 컬럼의 수가 다수개일 때
 */
SELECT * FROM EMPLOYEE;
--박채형 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드조회
SELECT 
       DEPT_CODE
     , JOB_CODE
  FROM
       EMPLOYEE
 WHERE 
       EMP_NAME = '박채형'; --D5 / J5

-- 사원며으 부서코드, 직급코드 부서코드 == D5+ 직급코드 ==J5
SELECT
       EMP_NAME
     , DEPT_CODE
     , JOB_CODE
  FROM 
       EMPLOYEE 
 WHERE
       DEPT_CODE = (SELECT 
       				       DEPT_CODE
                         , JOB_CODE
                      FROM
                           EMPLOYEE
                     WHERE 
                           EMP_NAME = '박채형')
   AND 
       JOB_CODE = (SELECT 
                          DEPT_CODE
                        , JOB_CODE
                     FROM
                          EMPLOYEE
                    WHERE 
                          EMP_NAME = '박채형');



SELECT
       EMP_NAME
     , DEPT_CODE
     , JOB_CODE
  FROM 
       EMPLOYEE 
 WHERE
       (DEPT_CODE, JOB_CODE) = (SELECT 
                                       DEPT_CODE
                                     , JOB_CODE
                                  FROM
                                       EMPLOYEE
                                 WHERE 
                                       EMP_NAME = '박채형');

-------------------------------------------------------------
/*
 * 4. 다중 행 다중 열 서브쿼리
 * 서브쿼리 수행 결과가 행도많고 열도많음
 */
-- 각 직급별로 최고 급여를 받는 사원들 조회(이름, 직급코드, 급여)
SELECT 
       JOB_CODE
     , MAX(SALARY)
  FROM
       EMPLOYEE
 GROUP
    BY
       JOB_CODE ;

SELECT 
       EMP_NAME
     , JOB_CODE
     , SALARY
 FROM
      EMPLOYEE
WHERE
      (JOB_CODE, SALARY) IN(SELECT 
       							   JOB_CODE
                                 , MAX(SALARY)
                              FROM
                                   EMPLOYEE
                             GROUP
                                BY
                                   JOB_CODE);
-------------------------------------------------------
/*
 * 5. 인랑니 뷰(INLINE VIEW)
 * FROM절에 서브쿼리를 작성
 * SELECT
 * 
 * 6. 스칼라 서브쿼리(SCALAR SUBQUERY)
 * 주로 SELECT 절에 사용하는 쿼리를 의미(WHERE나 FROM이나 다 쓸 순 있음)
 * 메인쿼리 실행마다 서브쿼리가 실행될 수 있으므로 성능문제가 생길 수 있음
 * 그렇기 때문에 JOIN으로 대체하는 것이 일반적으로는 성능상 유리함
 * 단, 캐싱이 되기 때문에 동일한 결과에 대해선 성능상JOIN보다 뛰어날 수도 있음
 * 스칼라쿼리는 반드시 단 한개의 값만을 반환해야함
 */
--스칼라 예시
--사원의 사원명과 부서명을 조회
SELECT 
       EMP_NAME
     , DEPT_TITLE
  FROM
       EMPLOYEE
  JOIN
       DEPARTMENT ON (DEPT_CODE = DEPT_ID);

SELECT 
       EMP_NAME
     , (SELECT DEPT_TITLE FROM DEPARTMENT WHERE E. DEPT_CODE = DEPT_ID)
 FROM EMPLOYEE E;

--간단하고 시원하게 인라뷰 한 번 그냥 써보기만하기
--사원들의 이름, 보너스 포함 연봉 조회하고 싶음
-- 단, 보너스포함 연봉이 4000만원 이상인 사원ㅁ나 조회
/*
SELECT 
       EMP_NAME AS "사원이름"
     , (SALARY + SALARY * NVL(BONUS, 0))  * 12 AS "보너스포함연봉"
  FROM 
       EMPLOYEE
 WHERE 
       "보너스 포함 연봉" > 40000000;
*/
-- 셀렉에서 별칭 "보너스 포함 연봉"이 정의 됨, WHERE절이 SELECT절보다 먼저이기에 오류가 나옴

SELECT 
       "사원이름"
       "보너스포함연봉"
  FROM
       (SELECT 
               EMP_NAME AS "사원이름"
             , (SALARY + SALARY * NVL(BONUS, 0))  * 12 AS "보너스포함연봉"
          FROM 
               EMPLOYEE)
 WHERE      
       "보너스포함연봉" > 40000000;
 



--------------------
/*
 * 여기는 자바
 * final method => 오버라이딩이 안됨
 * final class => 상속이 안됨
 * String integer -> 이 클래스에는 final이 달려있음
 */
--------------------

--> 인라인 뷰를 주로 사용하는 예(클래식)
-->TOP-N 분석 : DB상에 있는 값들 중 최상위 N개의 데이터를 보기위해서 사용

SELECT * FROM EMPLOYEE;
-- 전 직원들 중 급여가 가장 높은 상위 5명 줄 세우기해서 조회
-- * ROWNUM : 오라클에서 자체적으로 제공해주는 컬럼, 조회된 순서대로 순번을 붙여줌

SELECT 
       EMP_NAME
     , SALARY
     , ROWNUM
  FROM  
       EMPlOYEE;

SELECT          		-- 3
	   ROWNUM
	 , EMP_NAME
	 , SALARY
  FROM					-- 1
	   EMPLOYEE
 WHERE					-- 2
  	   ROWNUM <=5
 ORDER					-- 4
    BY
       SALARY DESC;


-- ORDER BY절을 이용해서 줄세우기 먼저 수행

SELECT
	   EMP_NAME
	 , SALARY
  FROM
       (SELECT
               EMP_NAME
             , SALARY
          FROM
               EMPLOYEE
         ORDER
            BY
               SALARY DESC)
 WHERE 
       ROWNUM <= 5;
              
----------------------------------------------------

-- 아 모던한 방법 쓰고 싶다.
SELECT
       EMP_NAME
     , SALARY
  FROM 
       EMPLOYEE
 ORDER
    BY
       SALARY DESC 
OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY;
-- 0개를 건너뛰고 그 다음 5행을 반환받겠다.
    











