-- Quiz --

-- '한국'에서 근무하는 사원들의 사번, 이름, 부서명, 직급명, 근무국가명을 조회해주세요!
-- 사번 : EMP_NO, 
-- 이름 : EMP_NAME,
-- 부서명 : DEPT_TITLE, EMPLOYEE(DEPT_CODE) = DEPARTMENT(DEPT_ID)
-- 직급명 : JOB_NAME , EMPLOYEE(JOB_CODE) = JOB(JOB_CODE)

-- 근무 국가명 : NATIONAL_NAME , LOCATION(NATIONAL_CODE) = NATIONAL(NATIONAL_CODE)
-- 지역 : DEPARTMENT(LOCATION_CODE) = LOCATION(LOCAL_CODE)

-- ORACLE(?)
SELECT 
	   EMP_ID
	 , EMP_NAME
	 , DEPT_TITLE
	 , JOB_NAME
	 , NATIONAL_NAME
 FROM
  	   EMPLOYEE E
	 , DEPARTMENT D
	 , JOB J
	 , NATIONAL N
	 , LOCATION L
 WHERE 
 	   DEPT_CODE =  D.DEPT_ID
   AND 
 	   E.JOB_CODE = J.JOB_CODE
   AND 
 	   L.NATIONAL_CODE = N.NATIONAL_CODE
   AND 
 	   LOCATION_ID = LOCAL_CODE
   AND 
	   NATIONAL_NAME = '한국';

-- 선생님 풀이 ANSI
SELECT
	   EMP_ID
	 , EMP_NAME
	 , DEPT_TITLE
	 , JOB_NAME
	 , NATIONAL_NAME
  FROM
  	   EMPLOYEE
  JOIN
  	   DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN
  	   JOB USING(JOB_CODE)
  JOIN
	   LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN 
	   NATIONAL USING(NATIONAL_CODE)
WHERE
	  NATIONAL_NAME = '한국';
-----------------------------------------------------------------------
/*
 * < VIEW 뷰 > --> 논리적인 가상테이블
 * 
 * SELECT문 저장하는 객체
 * 
 * 1. VIEW 생성
 * 
 * [ 표현법 ]
 * CREATE VIEW 뷰이름
 * 	 AS 서브쿼리;
 */

CREATE OR REPLACE VIEW VW_EMPLOYEE
	AS SELECT 
	 		  EMP_ID
	 	    , EMP_NAME
		    , DEPT_TITLE
	 	    , JOB_NAME
		    , NATIONAL_NAME
  		FROM
  	 		 EMPLOYEE
  		JOIN
  	 	     DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  		JOIN
  	  	     JOB USING(JOB_CODE)
		JOIN
	 	     LOCATION ON (LOCATION_ID = LOCAL_CODE)
 		JOIN 
	 	     NATIONAL USING(NATIONAL_CODE);
SELECT * FROM VW_EMPLOYEE;

-- 한국에서 근무하는 사원
SELECT
	   *
  FROM
  	   VW_EMPLOYEE
 WHERE
 	   NATIONAL_NAME = '한국';

-- 일본에서 근무하는 사원
SELECT
	   *
  FROM
  	   VW_EMPLOYEE
 WHERE
 	   NATIONAL_NAME = '일본';

--뷰의 장점 : 쿼리문이 엄청 긴게 필요할 때 그때그때 작성하면 힘들다....
-- 			딱 한번 뷰로 만들어주면 그때부터는 뷰를 사용해서 간단하게 조회할 수 있음

-- 해당 계정이 가지고있는 VIEW에 대한 정보를 조회할 수 있는 데이터 딕셔너리
SELECT * FROM USER_VIEWS;
-- 뷰는 논리적인 가상테이블 => 실질적으로 데이터를 저장하고 있지 않음
--						 (쿼리문을 TXT 형태로 저장해놓음)
---------------------------------------------------------------------
/*
 * CREATE OR REPLACE VIEW 뷰이름
 *    AS 서브쿼리;
 * 
 * 뷰 생성 시 기존에 중복된 이름의 뷰가 존재한다면 갱신(변경)GOWNRH
 * 없다면 새로운 뷰를 생성해줌
 */
-- 사원의 사원명, 연봉, 근무년스를 조회할 수 있는 SELECT문 정의
SELECT
	   EMP_NAME
	 , SALARY * 12
	 , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
  FROM
       EMPLOYEE;

CREATE OR REPLACE VIEW VW_EMP
    AS (SELECT 
	  		   EMP_NAME
	 	     , SALARY * 12 AS "연봉"
	 	     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
  		  FROM 
       		   EMPLOYEE);
/*
 * 뷰 생성 시 SELECT절에 함수 또는 산술연산식이 기술되어있는 경우 뷰 생성이 불가능하니깐
 * 반드시 별칭을 지정해주어야함
 */

SELECT * FROM VW_EMP;

-- 별칭 부여 방법 두 번째!(모든 컬럼에다가 별칭을 지어주어야함)
CREATE OR REPLACE VIEW VW_EMP(사원명, 연봉, 근무년수)
    AS SELECT 
	  		   EMP_NAME
	 	     , SALARY * 12 
	 	     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
  		  FROM 
       		   EMPLOYEE;
----------------------------------------------------------------------------
















