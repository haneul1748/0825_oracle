/*

 	함수 < FUNCTION >
 	
 	자바로 따지면 메소드
 	전달된 값을 가지고 계산된 결과를 반환해준다

	-단일행 함수 : N개의 값을 읽어서 N개의 결과를 반환( 매 행마다 함수 결과 반환)
	-그룹 함수★☆★ : N개의 값을 일겅서 1개의 결과를 반환( 그룹별로 함수 결과 반환 )


*/
------------------< 단일행 함수 >-----------------------------------
SELECT
	   SALARY
	 , LENGTH(SALARY)
	 , SUM(SALARY) 
  FROM
   	   EMPLOYEE;
-- 단일행 함수와 그룹함수는 함께 사용 불가능 : 결과 행의 개수가 다르기 때문에


/*
  < 문자열과 관련된 함수 >
  LENGTH / LENGTHB

  STR : '문자열' / 문자열이 들어가있는 컬럼
  
  "equals".length(); <-- 얘랑 똑같음
  - LENGTH(STR) : 전달된 문자열의 글자 수 반환
  - LENGTHB(STR) : 전달된 문자열의 바이트 수 반환
  
  결과는 NUMBER타입

  한글 : 'ㄱ', 'ㅏ', '강' => 한 글자당 3Byte
  숫자, 영어, 특수문자 => 한 글자당 1Byte
*/

SELECT 
	   LENGTH('오라클!')
	 , LENGTHB('오라클!')
  FROM 
	  --EMPLOYEE;
	   DUAL; -- 가상테이블(DUMMY TABLE)
	  
SELECT
	   EMAIL
	 , LENGTH(EMAIL)
  FROM 
  	   EMPLOYEE;

/*
 * INSTR
 *  
 * - INSTR(STR) : 문자열로부터 특정 문자의 위치값 반환
 * 
 * INSTR(STR, '특정 문자', 찾을위치의 시작값, 순번)
 * 
 * 결과값은 NUMBER타입으로 반환
 * 찾을 위치의 시작값과 순번은 생략이 가능
 * 
 * 찾을 위치의 시작값
 * 1 : 앞에서부터 찾겠다.(기본값)
 * -1 : 뒤에서부터 찾겠다.
*/

SELECT 
	   INSTR('AABAACAABBAA', 'B')
  FROM 
  	   DUAL;

SELECT 
	   INSTR('AABAACAABBAA', 'B', -1)
  FROM
  	   DUAL; -- 뒤에서부터 첫 번째 'B'가 앞에서부터 몇 번째인지
  	   
SELECT
	   INSTR('AABAACAABBAA', 'B', 1, 3) -- 앞에서부터 찾을건데 세번째 'B'가 몇번째인지 
  FROM
  	   DUAL;

SELECT
	   INSTR(EMAIL, '@') "@의 위치"
  FROM
  	   EMPLOYEE;
-----------------------------------------------------------------------------
/*
 * SUBSTR
 * 
 * - SUBSTR(STR, POSITION, LENGTH) : 문자열로부터 특전 문자열을 추출해서 반환
 * 
 * -STR : '문자열'또는 문자타입 컬럼 값
 * -POSITION : 문자열 추출 시작위치값(POSITION번째 문자부터 추출) -> 음수도 가능
 * -LENGTH : 추출할 문자 개수(생략 시 끝까지라는 의미)
 */

SELECT 
	   SUBSTR('KH정보교육원', 3)
  FROM
  	   DUAL;

SELECT
	   SUBSTR('KH정보교육원', -3, 2)
  FROM
  	   DUAL;  --POSITION이 음수일 경우 뒤에서 N번째 부터 추출하겠다 라는 의미
-- EMPLOYEE 테이블로부터 사원명과 이메일컬럼과 EMAIL컬럼값 중 아이디값만 추출해서 조회
SELECT 
	   EMP_NAME 
	 , EMAIL
	 , SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1) "아이디"
  FROM
  	   EMPLOYEE;

SELECT
	   EMP_NAME
	 , SUBSTR(EMP_NO, 8, 1)
  FROM
  	   EMPLOYEE;

-- 남성 사원들만 이름을 조회
SELECT
	   EMP_NAME
  FROM
  	   EMPLOYEE
 WHERE
  	   SUBSTR(EMP_NO, 8, 1) = 1;
--------------------------------------------------------------
/*
 * LPAD / RPAD (L, R PADDING) (LEFT , RIGHT)
 * 
 * - LPAD  / RPAD (STR, 최종적으로 반환할 문자의 길이(바이트), 패딜할문자)
 * : 인자로 전달한 문자열에 임의의 문자를 왼쪽 또는 오른쪾에 덧붙여서 N길이만큼의 문자열 반환
 * 
 * 결과값은 CHARACTER타입으로 반환
 * 덧붙이고자 하는 문자는 생략이 가능
 */

SELECT
	   LPAD(EMAIL, 25)
  FROM
  	   EMPLOYEE;

SELECT
	   LPAD(EMAIL, 25, '!')
  FROM
  	   EMPLOYEE;

SELECT
	   EMP_NAME
	 , EMP_NO
  FROM
  	   EMPLOYEE;

 -- EMPLOYEE 테이블에서 모든 직원의 사원명과 주민등록번호 뒤 6자리를 마스킹 처리해서 조회하기


SELECT
	   SUBSTR(EMP_NAME, 1, 1)
	 , SUBSTR(EMP_NO, 1, 8)
  FROM
  	   EMPLOYEE;

SELECT
	   RPAD(SUBSTR(EMP_NAME, 1, 1), 4, '*')
	 , RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
  FROM
   	   EMPLOYEE;
 
----------------------------------------------------------------
/*
 * LTRIM / RTRIM
 * 
 * - LTRIM / RTRIM(STR, 제거하고자하는 문자)
 *  : 문자열의 왼쪽 또는 오른쪽에서 제거하고자 하는 문자들을 찾아서 제거한 나머지 문자열을 반환
 * 
 * 결과값은 CHARACTER타입으로 반환
 */

SELECT
	   LTRIM('          K  H')
  FROM
  	   DUAL;

SELECT
	   LTRIM('123123KH123', '123')
  FROM
  	   DUAL;
 ------------------------------------------------------
/*
 * TRIM
 * 
 * - TRIM(BOTH / LEADING / TRAILRING '제거하고자하는문자' FROM STR)
 * : 문자열의 앞 / 뒤 / 양쪽에 있는 문자를 제거한 나머지 문자열을 반환
 * 
 * 결과값은 CHARACTER
 * BOTH / LEADING / TRAILING은 생략 가능 참고로 생략 시 기본값은 BOTH
 */
 
SELECT
	   TRIM('    K   H    ')
  FROM
  	   DUAL; --BOTH

 SELECT
 	    TRIM(LEADING 'Z' FROM 'ZZZKHZZZ')
   FROM
   		DUAL;
 
 SELECT
 	    TRIM(TRAILING 'Z' FROM 'ZZZKHZZZ')
   FROM
   	    DUAL;
 
 -----------------------------------------------------------------
/*
 * LOWER / UPPER /INITCAP
 * 	
 * - LOWER(STR)
 *  : 다 대문자로 변경
 * 
 * - UPPER(STR)
 *  : 다 대문자로 변경
 * 
 * - INITCAP(STR)
 *  : 각 단어마다 앞 글자만 대문자로 변경
 * 
 * 결과 값은 모두 CHARACTER타입으로 반환
 */
 
SELECT 
	   LOWER('HELLO WORLD')
  FROM 
  	   DUAL;

SELECT
	   UPPER('hello world')
  FROM
  	   DUAL;

SELECT
	   INITCAP('hello world')
  FROM
  	   DUAl;
 
-----------------------------------------------------------
/*
 * CONCAT
 * 
 * - CONCAT(STR1, STR2)
 * : 전달된 두 개의 인자를 하나로 합친 결과를 반환
 * 
 * 반환타입은 CHARACTER
 */

SELECT CONCAT('경실련 하이텔', '정보교육원') FROM DUAL;

------------------------------------------------------------
/*
 * REPLACE
 * 
 * - REPLACE(STR, 찾을문자, 바꿀문자)
 *  : STR로부터 찾을문자를 찾아서 바꿀문자로 바꾼 문자열을 반환
 * 결과값은 CHARACTER타입
 */
 
SELECT
	   REPLACE('서울시 중구 남대문로 120 대일빌딩', '대일빌딩', '그레이츠 청계')
  FROM
  	   DUAL;
 
SELECT 
	   EMAIL
	 , REPLACE(EMAIL, 'kh.or.kr', 'iei.co.kr')
  FROM
  	   EMPLOYEE;
 
 ---------------------------------------------------------
/*
 * MOD
 * 
 * - MOD(NUBMER1, NUMBER2) 나머지구할 때 쓰는거 실수,정수 둘다가능
 */
 
 SELECT
 	    MOD(10, 3)
 	  , MOD(-10, 3)
 	  , MOD(10.8, 3)
  FROM
  	   DUAL;
 
 ---------------------------------------------------------
 /*
  * ROUND
  * 
  * - ROUND(NUMBER, 위치) : 반올림 처리해주는 함수
  * 
  * 위치 : 소수점 아래 N번째 위치를 저장할 수 있음
  * 생략도 가능, 생략시 기본값은 0
  */
 
 SELECT
 	    ROUND(123.456)
 	  , ROUND(123.456, 1)
 	  , ROUND(123.456, 2)
 	  , ROUND(123.456, -1)
 	  , ROUND(123.456, -2)
   FROM
   	 	DUAL;
 	
 --------------------------------------------
 /*
 * FLOOR
 * 
 * -FLOOR(NUMBER) 소수점 아래의 수를 무조건 버림처리해주는 함수
 *  
 * CEIL
 * 
 * - CEIL(NUMBER) 소수점 아래의 수를 무조건 올림처리해주는 함수
 */
 
 SELECT 
 	    FLOOR(123.45 * 10) / 10
   FROM
   	    DUAL;
 
SELECT
	   CEIL(123.456)
  FROM
  	   DUAL;
 
 ---------------------------------------------------------

-- 각 직원별로 고용일로부터 오늘까지의 근무 일수 조회 + 이름 조회

SELECT
	   EMP_NAME
	 , CONCAT(FLOOR(SYSDATE - HIRE_DATE), '일') "근무일자"
  FROM
  	   EMPLOYEE
 WHERE 
	   FLOOR(SYSDATE - HIRE_DATE) > 365 * 17;
 
 ------------------------------------------------------
/*
 * TRUNC
 * - TRUNC(NUMBER, 위치) : 위치지정이 가능한 절삭처리 함수
 * 그냥 버리는거라 속도가 빠르다
 */
 
 SELECT
 	    TRUNC(123.456, 2)
   FROM 
  	    DUAL;
 --------------------------------------------------------
 /*
  * < 날짜 관련 함수 >
  * 
  * DATE 타입 : 년, 월, 일, 시, 분 초를 모두 포함한 자료형
  * TIMPSTAMP <- 얘는 나중에
  * 
  */ 
  
  SELECT
  	     SYSDATE
  	   , SYSTIMESTAMP
    FROM
    	 DUAL;
  
-- MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜사이의 개월 수 반환(NUMBER)
-- DATE2에 너무먼수를 넣을시 음수가 나올수 있음
-- EMPLOYEE테이블로부터 각 사원 사원명, 고용일로부터 근무일수, 근무 개월수
  
SELECT 
	   EMP_NAME
	 , FLOOR(SYSDATE - HIRE_DATE) || '일' AS "근무일수"
	 , FLOOR(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월' AS "개월수"
  FROM
  	   EMPLOYEE;
  
-- ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼의 개월 수를 더한 날짜(DATE로 반환)
SELECT
	   ADD_MONTHS(SYSDATE, 4)
  FROM
  	   DUAL;

-- NEXT_DAY(DATE, 요일) : 특정날짜에서 가장 가까운 요일을 찾아 그 날짜를 반환

SELECT
	   NEXT_DAY(SYSDATE, '금요일')
     , NEXT_DAY(SYSDATE, '금')
     , NEXT_DAY(SYSDATE, 6) --1 : 일요일, 2 : 월요일, 3: 화요일 ... 7 : 토요일
  FROM
  	   DUAL;

-- 언어변경 ALTER SESSION SET NLS_LANGUAGE = AMERICAN; // KOREAN

-- LAST_DAY(DATE) 날짜를 받아서 해당 날짜가 있는 달의 마지막날짜를 반환
SELECT
	   LAST_DAY(SYSDATE)
  FROM
  	   DUAL;


------------------------------------------------------------
/*
* ★EXTRACT : 년도 또는 월 또는 일정보를 추출해서 반환(NUMBER타입)
* 활용도 높음
* - EXTRACT(YEAR FROM DATE) : 년도만 추출
* - EXTRACT(MONTH FROM DATE) : 월만 추출
* - EXTRACT(DAY FROM DATE) : 일만 추출
*/
-- EMPLOYEE테이블에서 사원명 입사년도 입사월 입사일
SELECT
	   EMP_NAME
	 , EXTRACT(YEAR FROM HIRE_DATE) AS "년도"
	 , ExTRACT(MONTH FROM HIRE_DATE) AS "월"
	 , EXTRACT(DAY FROM HIRE_DATE) AS "일"
	 , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
  FROM
  	   EMPLOYEE
 ORDER
 	BY
 	   "년도", "월", "일";
-------------------------------------------------------------------
/*
 * < 형변환 함수 >
 * 
 * NUMBER / DATE => CHARACTER
 * 
 * - TO_CHAR(NUMBER/DATE, 포맷) : 숫자 또는 날짜 데이터를 문자데이터타입으로 반환
 */

SELECT 
	   1234
	 , TO_CHAR(1234)
	 , TO_CHAR(1234, '00000') -- 자리수보다 큰 공간을 0으로 채움
	 , TO_CHAR(1234, '99999') -- 자리수보다 큰 공간을 공백문자로 채움
	 , TO_CHAR(1234, 'L00000') -- 설정된 나라(LOCAL)의 화폐 단위
	 , TO_CHAR(1234, '$99999')
	 , TO_CHAR(12341234, 'L999,999,999')
	 FROM
  	   DUAL;
--------------------------------------------------------------
--DATE(년월일시분초) => CHARACTER

SELECT
	   SYSDATE
	 , TO_CHAR(SYSDATE, 'YYYY-MM-DD')
	 , TO_CHAR(SYSDATE, 'PM HH:MI:SS') --PM 오전 / 오후출력
	 , TO_CHAR(SYSDATE, 'HH24:MI:SS') -- 24시간 표기형식
	 , TO_CHAR(SYSDATE, 'MON DY, YYYY')
  FROM
  	   DUAL;
-------------------------------------------------------------
-- 년도로 쓸 수 있는 포맷 Y2K문제
SELECT
 	   TO_CHAR(SYSDATE, 'YYYY')
 	 , TO_CHAR(SYSDATE, 'RRRR')
 	 , TO_CHAR(TO_DATE('26-95', 'DD-YY'), 'YYYY')
 	 , TO_CHAR(TO_DATE('26-95', 'DD-RR'), 'YYYY')
 	 , TO_CHAR(SYSDATE, 'YEAR')
  FROM
  	   DUAL;

-- 월에 쓸 수 있는 포맷
SELECT
 	   TO_CHAR(SYSDATE, 'MM')
 	 , TO_CHAR(SYSDATE, 'MON')
 	 , TO_CHAR(SYSDATE, 'MONTH')
 	 , TO_CHAR(SYSDATE, 'RM')
 FROM
  	   DUAL;

-- 일에 쓸 수 있는 포맷

SELECT
	   TO_CHAR(SYSDATE, 'DD') -- DD : 한달 기준
	 , TO_CHAR(SYSDATE, 'D') -- D : 일주일 기준(일요일부터)
	 , TO_CHAR(SYSDATE, 'DDD') -- DDD : 일년 기준 1월 1일로부터 몇일이 지났는지
  FROM
  	   DUAL;

SELECT
	   TO_CHAR(SYSDATE, 'DAY')
	 , TO_CHAR(SYSDATE, 'DY')
  FROM
  	   DUAL;

SELECT
	   EMP_NAME
	 , TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" DY"요일"') AS "하이어데이트"
  FROM
  	   EMPLOYEE;
-- 한글이 쓰고싶으면 ""로 묶어줘야함
-------------------------------------------------------------------
/*
 * NUMBER / CHARACTER => DATE
 * 
 * - TO_DATE(NUMBER, CHARACTER, 포맷) : 숫자/문자를 날짜로 변환(DATE로 변환)
 */
SELECT 
	   TO_DATE(20250826)
	 , TO_DATE('001212')
	 , TO_DATE('980607', 'YYMMDD') -- 형식을 지정해줘야 2000년도인지 1900년도인지 확인가능 2000년도 기준 형식 지정
  FROM
  	   DUAL;
-----------------------------------------------------------------------------------------------------
/*
 *  CHARACTER => NUMBER
 * 
 *  - TO_NUMBER(CHARACTER, 포맷) : 문자를 숫자형으로 변환(NUMBER로 반환)
 */

SELECT 
	   TO_NUMBER('01234')
  FROM
  	   DUAL;

SELECT
	   '123' + '456'
  FROM
  	   DUAL;

SELECT
	   '11,000' + '20,000'
  FROM
  	   DUAL; --이건 불가능
  	   
SELECT
	   TO_NUMBER('44,000', '99,999') + TO_NUMBER('20,000', '99,999')
  FROM
  	   DUAL;

------------------------------------------------------------------
/*
 *  < NULL 처리 함수 >
 * 
 * 
 * NVL(컬럼명, 해당 컬럼값이 NULL값인 경우 반환할 결과값)
 */

-- EMPLOYEE테이블로부터 사원명, 보너스
SELECT
	   EMP_NAME
	 , BONUS
	 , NVL(BONUS, 0)
  FROM
  	   EMPLOYEE;

-- 보너스 포함 연봉조회
SELECT
	   EMP_NAME
	 , (SALARY + SALARY * NVL(BONUS, 0)) * 12
	 , NVL(DEPT_CODE, '부서 없음')
  FROM
  	   EMPLOYEE;

-- NVL2(컬럼명, 결과값1, 결과값2)
-- 해당 컬럼에 값이 존재할 경우 결과값1 을 반환
-- 해당 컬럼에 값이 NULL값인 경우 결과값2를 반환
SELECT
	   EMP_NAME
	 , DEPT_CODE
	 , NVL2(DEPT_CODE, '부서 배치 완료', '부서 없음')
  FROM
  	   EMPLOYEE;

--NULLIF(비교대상1, 비교대상2)
-- 두개의 값이 동일한 경우 NULL을 반환
-- 두개의 값이 동일하지 않을 경우 비교대상1을 반환

SELECT
	   NULLIF('1', '1')
	 , NULLIF('1', '2')
  FROM
  	   DUAL;

--------------------------------------------------------
/*
 * < 선택 함수 >
 * 
 * DECODE(비교대상(컬럼명/산술연산/함수식), 조건값1, 결과값1, 조건값2, 결과값3.... 결과값)\
 *
 *	- 자바에서의 switch문과 유사
 *	switch(비교대상) {
 *	case 조건값1 : 결과값1;
 *  case 조건값2 : 결과값2;
 *  default : 결과값
 * }
 */

-- EMPLOYEE테이블 사원명, 성별
SELECT
	   EMP_NAME
	 , DECODE(SUBSTR(EMP_NO, 8, 1),
	 		  1, '남성',
	 		  2, '여성',
	 		  	 '성별 선택안함') AS "성별"
  FROM
  	   EMPLOYEE;

-- 직원들의 급여를 인상시켜서 조회
-- 직급코드(JOB_CODE)가 'J7'인 사원들의 급여는 15%인상해서 조회
-- 직급코드가 'J6'인 사원들의 급여는 20%인상해서 조회
-- 직급코드가 'J5'인 사원들의 급여는 30%인상해서 조회
-- 나머지 직급인 사원들의 급여는 5% 인상해서 조회
SELECT
	   EMP_NAME
	 , SALARY
	 , JOB_CODE
	 , DECODE(JOB_CODE, 'J7', (SALARY + SALARY * 0.15)
	 				  ,	'J6', (SALARY + SALARY * 0.2)
	 				  ,	'J5', (SALARY + SALARY * 0.3)
	 				  , (SALARY + SALARY * 0.05)) "인상 후 급여"
  FROM
  	   EMPLOYEE;
---------------------------------------------------------------------------------
/*
 * CASE WHEN THEN 구문
 * 
 * -DECODE랑 비교했을 때 DECODE는 동등비교만 수행
 *  CASE WHEN THEN 다양한 조건식을 기술 가능
 * 
 * [ 표현법 ]
 * CASE
 * 	   	WHEN 조건식1 THEN 결과값1
 * 	    WHEN 조건식2 THEN 결과값2
 * 		....
 * 		ELSE 결과값
 * END
 */

SELECT 
	   EMP_NAME
	 , CASE 
	 	WHEN SUBSTR(EMP_NO, 8, 1) = '1' THEN '남성'	
	 	WHEN SUBSTR(EMP_NO, 8, 1) = '2' THEN '여성'
	 	ELSE '성별선택안함'
	   END AS "성별"
  FROM 
  	   EMPLOYEE;

-------------------------------------------------------------

---------------------< ★ 그 룹 함 수 ☆ >-----------------------
/*
 * N개의 값을 읽어서 1개의 결과를 반환(하나의 그룹별로 함수 실행결과를 반환)
 */
SELECT
	   SALARY
  FROM
  	   EMPLOYEE;
-- 1. SUM(숫자타입) : 해당 컬럼값들의 총 합계를 반환해주는 함수
-- 전체 사원의 총 급여합계
SELECT
	   SUM(SALARY)
  FROM
  	   EMPLOYEE;

SELECT
	   EMP_NAME
	 , EMAIL
  FROM
  	   EMPLOYEE;

-- 이메일에 0이 들어가는 사원들의 총 급여합
-- 부서코드가 D5인 친구들만
SELECT
	   SUM(SALARY)
  FROM
  	   EMPLOYEE
 WHERE
 	   EMAIL LIKE '%0%'
   AND
	   DEPT_CODE ='D5';

--------------------------------------------------------------------
-- 2. AVG(숫자타입) : 해당 컬럼들의 평균값을 구해서 반환
-- 전체사원들의 급여 평균구하기
SELECT
	   ROUND(AVG(SALARY))
  FROM
  	   EMPLOYEE;

-- 3.MIN(ANY) : 해당 컬럼값들 중 작은 값 반환
SELECT
	   MIN(SALARY) "제일 작은 급여"
	 , MIN(EMP_NAME) "제일 이름이 빠른사람"
	 , MIN(HIRE_DATE) "제일 빠른 입사일"
  FROM
  	   EMPLOYEE;
--4. MAX(ANY) : 해당 컬럼값들 중 가장 큰 값 반환

SELECT
	   MAX(SALARY) "가장 높은 급여"
	 , MAX(EMP_NAME) "가장 느린 이름"
	 , MAX(HIRE_DATE) "가장 늦은 입사일"
  FROM
	   EMPLOYEE;

--5. COUNT(*/컬럼명 / DISTINCT 컬럼명) : 행 개수 세서 반환

SELECT * FROM EMPLOYEE;
-- COUNT(*) : 조회 결과에 해당하는 모든 행 개수를 다 세서 반환
SELECT 
	   COUNT(*) 
  FROM 
   	   EMPLOYEE;
























  
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 




