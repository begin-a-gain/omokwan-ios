# 오목완

오목완, 오늘의 목표 완료  
하루에 한 수, 오목을 두며 만드는 생활 루틴  

## Tech Stack

```  
## Tech Stack

Language
- Swift

UI
- SwiftUI

Architecture
- MVI
- TCA (The Composable Architecture)
- Clean Architecture
- Modular Architecture

Dependency Injection
- Swinject
- TCA Dependencies

Build / Project
- Tuist
- Swift Package Manager
- Makefile

Network / Persistence
- URLSession
- Keychain
- UserDefaults

Third-Party / SDK
- TCA (The Composable Architecture)
- Firebase Analytics
- Firebase Remote Config
- Firebase Crashlytics
- Kakao iOS SDK
- Lottie

CI/CD
- Xcode Cloud
- Discord Webhook

```  

## Why TCA

- 상태 변경을 `Action -> Reducer -> State` 흐름으로 일관되게 관리 가능  
- 화면 로직을 Reducer 중심으로 모을 수 있어 복잡한 분기 추적 용이  
- `@Dependency` 기반으로 외부 의존성을 분리해 테스트와 유지보수에 유리
- Feature 단위 분리가 자연스러워 모듈화된 구조와 잘 맞습니다.

## Project Structure

```bash
Projects
├── Omokwan
├── Presentation
│   ├── Base
│   ├── Splash
│   ├── Root
│   ├── SignIn
│   ├── SignUp
│   ├── Main
│   ├── MyGame
│   ├── MyGameAdd
│   ├── MyGameParticipate
│   ├── GameDetail
│   ├── Notification
│   └── MyPage
├── Domain
├── Data
├── DI
├── DesignSystem
└── Utils
```

### Layer Description

- `Presentation`
  - SwiftUI View와 TCA Reducer를 포함한 화면 계층
  - 화면 상태, 액션, 프레젠테이션 흐름을 담당

- `Domain`
  - UseCase, Entity Model, RepositoryProtocol을 정의하는 계층
  - Presentaion과 Data 사이의 기준 인터페이스 역할을 함

- `Data`
  - API, Firebase, Keychain, Local 저장소, Repository 구현체를 담당
  - 외부 시스템과의 실제 연결은 이 계층에서 처리

- `DI`
  - Swinject 기반 의존성 조립 계층

- `DesignSystem`
  - 공통 컴포넌트, 색상, 이미지, Lottie, ViewModifier를 관리하는 UI 계층

- `Omokwan`
  - 실제 앱 엔트리 포인트
  - AppDelegate, 외부 SDK 초기화, DI 등록과 같은 앱 조립 역할을 담당

이 구조는 Clean Architecture를 기반으로 계층을 분리하고, 인터페이스와 구현을 나누어 변경에 유연한 구조를 지향했다.  
그래서 외부 구현이 바뀌더라도 해당 레이어 중심으로 수정 범위를 제한할 수 있어 유지보수에 유리하다.  

## Environment

오목완은 환경별 설정을 분리해 운영하고 있음.  

- DEV (개발용)
- PROD (운영)

`XCConfig`와 Tuist 설정을 통해 환경값을 분리했고, 빌드 및 배포 과정에서도 이를 기준으로 구성  

## Remote Control

운영 단계에서 앱 동작을 유연하게 제어하기 위해 Firebase Remote Config를 사용  

- 강제 업데이트 여부 제어
- 공지 팝업 노출
- Feature Flag 기반 UI 노출/비노출

즉, 앱을 다시 배포하지 않아도 일부 기능의 노출 정책을 원격에서 제어할 수 있도록 구성  

## CI/CD

배포 파이프라인은 Xcode Cloud 기반으로 구성  

- post-clone 단계
  - 환경 설정 파일 생성 (DEV, PROD 대응)
  - Tuist 기반 프로젝트 생성
- archive 수행
- post-xcodebuild
  - Discord 알림 전송
- archive 성공 시 TestFlight 업로드  

## Getting Started

### Requirements
- Xcode
- Tuist

### Generate Project

```bash
make generate
```

### Clean & Regenerate

```bash
make clean
make generate
```

프로젝트를 새로 생성해야 하거나 캐시를 정리하고 다시 시작할 때 위 순서를 사용  