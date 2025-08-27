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












