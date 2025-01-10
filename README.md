<div align=left>
  <h1>✨ 덕메랑 ✨</h1>
  <strong>UMC 7th iOS Project</strong>
  <br/>
  <strong>개발기간: 2025.01 ~</strong>
</div>

<br/><br/>

<div align=left>
  <h2>📚 Tech Stacks 📚</h2>
  <strong>Environment</strong>
  <br/>
  <img src="https://img.shields.io/badge/xcode-%231575F9.svg?&style=for-the-badge&logo=xcode&logoColor=white" />  <img src="https://img.shields.io/badge/git-%23F05032.svg?&style=for-the-badge&logo=git&logoColor=white" />  <img src="https://img.shields.io/badge/github-%23181717.svg?&style=for-the-badge&logo=github&logoColor=white" />
  <br/><br/>
  <strong>Development</strong>
  <br/>
  <img src="https://img.shields.io/badge/swift-%23FA7343.svg?&style=for-the-badge&logo=swift&logoColor=white" />  <img src="https://img.shields.io/badge/uikit-%232396F3.svg?&style=for-the-badge&logo=uikit&logoColor=white" />
</div>

<br/><br/>

<div align=left>
  <h2>🪵 Git Branch Strategy 🪵</h2>
  브랜치 전략은 Git Flow를 기반으로 한다.
</div>

<br/><br/>

<div align=left>
  <h2>💻 Coding Convention 💻</h2>
  
  <h4>네이밍</h4>
    
  - 클래스와 구조체, 열거형, 프로토콜의 이름에는 UpperCamelCase를 사용합니다.
  - 함수, 변수, 상수 이름, 열거형의 각 case에는 lowerCamelCase를 사용합니다.
  
  <h4>줄바꿈</h4>
  
  - 함수를 호출하는 코드가 최대 길이를 초과하는 경우에는 파라미터 이름을 기준으로 줄바꿈합니다.
  
  ```swift
  let actionSheet = UIActionSheet(
    title: "정말 계정을 삭제하실 건가요?",
    delegate: self,
    cancelButtonTitle: "취소",
    destructiveButtonTitle: "삭제해주세요"
  )
  ```

  - if let 구문이 길 경우에는 줄바꿈하고 한 칸 들여씁니다.
  ```swift
  if let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
     let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
    user.gender == .female {
    // ...
  }
  ```

  - guard let 구문이 길 경우에는 줄바꿈하고 한 칸 들여씁니다. else는 guard와 같은 들여쓰기를 적용합니다.
  ```swift
  guard let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
        let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
        user.gender == .female
  else {
    return
  }
  ```

  <h4>약어</h4>
  
  - 약어로 시작하는 경우 소문자로 표기하고, 그 외의 경우에는 항상 대문자로 표기합니다.
  
  좋은 예:
  ```swift
    let userID: Int?
    let html: String?
    let websiteURL: URL?
    let urlString: String?
  ```
  나쁜 예:
  ```swift
    let userId: Int?
    let HTML: String?
    let websiteUrl: NSURL?
    let URLString: String?
  ```
</div>

<br/><br/>

<div align=left>
  <h2>📓 Commit Convention 📓</h2>
  <h3>기본 구조 : 제목, 본문, 꼬리말 3가지 파트로 나눈다.</h3>
  
  ```
  태그: 제목

  본문(무엇을, 왜 했는지 간략하게 작성)
  
  이슈 유형: #이슈 번호
  ```

  <h3>태그 종류</h3>
  
  ```
  Feat: 새로운 기능 추가
  Fix: 버그 수정
  Docs: 문서 수정
  Style: 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우
  Refactor: 코드 리펙토링
  Test: 테스트 코드, 리펙토링 테스트 코드 추가
  Chore: 빌드 업무 수정, 패키지 매니저 수정
  ```
</div>
