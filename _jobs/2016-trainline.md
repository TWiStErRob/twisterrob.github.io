---
title: Trainline
type: Company
role: senior – principal software engineer
maintech: Android, Gradle, TeamCity
sector: travel
location: London
dates:
  from: 2016-12-12
  to: 2022-10-14
employer: {}
---

Trainline is the UK's leading rail ticket distributor. I was working on the Android mobile team (12–40 Android engineers) to make the flagship Android app better. We worked closely together with the iOS mobile team and our Backend for Frontend team.

Here are some aspects of my work that highlights what I'm capable of:
 * **Re-platforming**: I started working on a project to Trainline's coverage to EU using a single codebase. This involved rewriting a live application from beginning to end onto a new backend, architecture, while maintaining compatibility in the same app. I was involved in the project from the very beginning, so I worked on building many screens from the ground up: Search Criteria, Search Results, My Tickets, Login, Refunds, PDF tickets, Crowd Alerts, My Bookings, Global Live Tracker, Seat Maps, Incremental Search; and these are just my main contributions, I was also involved in many others.
 * **Hard Projects**: I was one of the people who could jump on any project and execute it, for this reason I was involved in many integration projects:
   * Auth0 login
   * Session tracking
   * Localization
   * Google Pay
   * 3DS integration
   * Google Analytics schema based code generation
   * PayPal Braintree integration
   * Station database search: On-device, fast, and flexible; Improved first startup time 80%.
   * Major BFF service migration
   * Self-hosted GitHub Enterprise to GitHub Cloud migration.
   * AppCenter re-integration

 * **Hands-on**:
   * I contributed 500 pull requests myself, amounting to 4 million lines changed. I also reviewed ~1700 of them (commenter: 1641, reviewer: 1463). This means I was involved in 25% of all the code changes that went into the app.
   * I was actively reviewing code, and helping others improve their code quality, teaching them frameworks and libraries, and how to write better code.
 * **Technical Debt**: I was working hard to reduce technical debt and help maintain/improve the code quality.
   * When I joined we had `PMD: 2875; CPD: 399; Checkstyle: 5493; Lint: 4433`,  
     1 year later, it was `PMD: 0; Checkstyle: 0; Lint: 0` due to my continued efforts.
   * I was also actively pushing for removal of dead code, so we don't need to maintain it.
   * I was also one of the main drivers of keeping our tools up to date, for example: AGP, Android targetSdk, AndroidX migration, GCM to FCM, Appboy to Braze, Leanplum, NewRelic, and many more.
   * I introduced custom Lint and Detekt checks to the project to fill the needs of the team.
   * Helped migration between frameworks, e.g. Butterknife to Synthetics to ViewBindings; or Dagger to Dagger Android.
 * **Localization**: I helped make the app available in 14 languages (including complex ones: JP, CN, RU, PL). I worked on Smartling integration, and processes/tooling to make it easier to localize the app.
 * **Releases**: v12.0 to v225.0, aside from executing many releases, I was also deeply invested in documenting, improving and automating the release process.
 * **Recruitment**: I was involved in growing the team from 12 to 40+, conducting interviews, onboarding, mentoring, improving the process. I've worked together with 100 other Android engineers during my tenure.
 * **Documentation**: I was actively working on improving our documentation, so that frequently asked questions have a record somewhere. This meant that our onboarding experience was getting better over time, and developers could find answers to their questions faster.
 * **Processes**:
   * Apart from maintaining the Release process, I was also highly involved in agile activities, such as Refinement and Retrospectives, and creating and ensuring our Definition of Ready and Definition of Done.
   * I actively maintained our technical backlog in Jira, triaging and prioritizing issues.
   * We developed an initiatives frameworks for developers to take ownership of technological innovations and lead them to completion.
   * I helped totally re-wamp our pull request merging process with the introduction of an automated merging tool.
   * I actively maintained our TeamCity CI/CD pipelines, and helped others gain understanding of them too.
 * **Community**:
   * I was the go-to person for technical questions, I am able to help people with anything project related, be it coding, libraries, tools, general or obscure.
   * I was helping it out in our `#android` Slack channel answering many questions trying to unblock people as fast as possible.
   * I organized internal events, such as our weekly Technical Meeting, Ask Me Anything Android, Release Therapy, some tech talks, hack evenings.
   * I also represented Trainline at external events, such as Droidcon, Android Makers, Londroid, Codebar.io, HackTrain.  
     Talk: [Leveraging Kotlin to write maintainable UI tests](https://www.youtube.com/watch?v=wlb3lg5JocA)
   * I actively report any issues found in our tools and libraries.
 * **Architecture**:
   * I have a deep understanding of our architecture, why things the way they are. I was involved in decisions to shape the architecture. I was advising on architectural decisions, such as where code belongs in our complex module system.
   * From week 2 I was involved in improving our dependency injection approaches in a huge multi-module project.
   * I helped lay the groundwork for Java to Kotlin migration.
   * I helped lay the groundwork for our design system integration.
 * **Modularization**:
     * I was involved in splitting up a huge monolith into 200+ feature modules over the years. From definition of how to approach modularization, to execution, and maintenance.
     * I became proficient in Gradle and started migrating our build system to more idiomatic build scripts.
     * I helped move huge pieces of code around to make the app more modular, and our builds faster.
 * **Tests**:
     * I was deeply involved in creating a Kotlin DSL framework for UI tests to abstract away the complexity of Espresso and make the tests easy to follow.
     * After introducing "Lean left", I helped migrate from Appium to Espresso for integration tests, so developers can help maintain them.
     * I was actively involved in advising and fixing flaky UI tests.

**Technologies**: Android, Kotlin, Java, Gradle, MVP, Dagger, Coroutines, RxJava, Retrofit, OkHttp, Gson, DBFlow, Espresso, JUnit, Mockito, JFixture, Crashlytics, NewRelic, Leanplum, Smartling

**Tools**: Android Studio, Git, GitHub, TeamCity, Slack, Jira, Trello, Outlook
