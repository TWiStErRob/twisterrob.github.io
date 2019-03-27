---
title: "Practical JFixture"
subheadline: "How to use it to help you write clean, focused tests"
teaser: "Magic one-liner with powerful behaviour"
category: dev
tags:
- test
- tutorial
- efficiency
---

Tests need data, let's see how can we create them using [JFixture](https://github.com/FlexTradeUKLtd/jfixture).<!--more--> 
In this article we'll go through some practical usage patterns of JFixture, and compare those to some other alternatives.

## Introduction

> JFixture is a Java library to assist in the writing of Unit Tests, particularly when following Test Driven Development. It generates types based on the concept of 'constrained non-determinism', which is an implementation of the [Generated Value](http://xunitpatterns.com/Generated%20Value.html) xUnit test pattern.
<cite>[JFixture README.md](https://github.com/FlexTradeUKLtd/jfixture)</cite>

In practice this means, is that JFixture can create any data object with very little developer effort, here's an example:
```java
private val fixture = JFixture()

@Test fun test() {
    val fixtJourney: Journey = fixture();

    val result = sut.process(fixtJourney);

    assertNotNull(result);
}
```
Compare this to the classic approach where we would need to create each object individually, filling in the properties with dummy values, and potentially creating constants for these values. No matter how deep or complicated it gets, JFixture usually finds a way to create an instance with all the data filled in.
```kotlin
val journey = Journey(
    "",
    listOf(
        Leg(
            Stop("", ""),
            LocalDateTime.now(),
            TransportMode.TRAIN,
            Stop("", ""),
            LocalDataTime.now()
        ),
        Leg(
            Stop("", ""),
            LocalDateTime.now(),
            TransportMode.TRAIN,
            Stop("", ""),
            LocalDataTime.now()
        )
    )
)
```

{% include toc.md %}

{% include alert info='
Note: In this article I use JUnit&nbsp;Jupiter and Mockito + Mockito&nbsp;Kotlin as the testing frameworks; and Kotlin as the language, because of its conciseness.
While JFixture was written for the JVM with Java in mind it works for Kotlin too due to Kotlin\'s awesome interoperability.
Everything you see here applies to Java as well (unless it\'s about using some Kotlin language feature).
' %}

## The need for JFixture
In this section, we'll go through developing and testing a fictitious component.
Starting simply, and getting more complicated, we'll finding solutions to problems that come up on the way.

### From the ground up
Let's imagine we're writing a user interface for displaying some info based on a journey. Journey data is coming from a data source, and we transform it to display it on the UI.

Let's start with a simple data structure:
```kotlin
data class Journey(
    val id: String,
    val origin: String,
    val destination: String
)

data class Model(/*...*/)
```
{: title="data models"}
Additionally, let's say this is the class that orchestrates the loading and displaying:
```kotlin
class JourneyPresenter(
    private val view: JourneyView,
    private val dataSource: DataSource<Journey>,
    private val mapper: (Journey) -> Model
) {
    fun load(journeyId: String) {
        dataSource
            .getById(journeyId)
            .map(mapper)
            .subscribe { model -> view.show(model) }
    }
}
```
Here are the collaborator interfaces for completeness (using RxJava's `Single`):
```kotlin
interface JourneyView {
    fun show(model: Model)
}
interface DataSource<T> {
    fun getById(id: String): Single<T>
}
```
{: title="collabolators"}

To test this, we will need to mock the collaborators and stub their inputs and return values.
Mind you, we're testing the data flow here: `dataSource` &rarr; `mapper` &rarr; `view`.
At this point, we don't really care what the data is, as long as it's of the right type:
```kotlin
private val mockView: JourneyView = mock()
private val mockDataSource: DataSource<Journey> = mock()
private val mockMapper: (Journey) -> Model = mock()

private val sut = JourneyPresenter(mockView, mockDataSource, mockMapper)

@Test fun `loads journey and presents it to view`() {
    whenever(mockDataSource.getById(fixtJourneyId)).thenReturn(fixtJourney)
    whenever(mockMapper.invoke(fixtJourney)).thenReturn(fixtModel)

    sut.load(fixtJourneyId)

    verify(mockView).show(fixtModel)
}
```
{: title="JourneyPresenterTest"}
You might notice, some of the declarations are missing, namely `fixtJourneyId`, `fixtJourney` and `fixtModel`. These are left out, as they will be the focus of the next sections.

### Classic approach
Usually when we're faced with a problem of creating an instance of a class, we use instantiation (the good old `new` in Java).
The simplest way to fill in the missing pieces above is this:
```kotlin
private val fixtJourneyId = ""
private val fixtJourney = Journey("", "", "")
private val fixtModel = Model("", 0, 0)
```
{: title="Classic data setup for test"}
Here, we filled in the values, so that it compiles. At the same time, we don't really care about what the values are, so we mostly use default values such as use empty strings, `false`, or `0`s.

### More complex model
Let's expand our extremely simple model to a more realistic example:
```kotlin
data class Journey(
    val id: String,
    val legs: List<Leg>
)

data class Leg(
    val origin: Stop,
    val departure: LocalDateTime,
    val mode: TransportMode,
    val destination: Stop,
    val arrival: LocalDateTime
)

enum class TransportMode { WALK, TRAIN, TAXI }

data class Stop(
    val id: String,
    val name: String
)
```
{: title="Realistic data structure"}

Now let's update our classic approach:
```kotlin
private val fixtJourney = Journey("", emptyList())
```
OK... I took a shortcut here, but what will happen if we can't assume to have an empty list there?
Say, the production code needs to loop through the list and we need to check the outcome based on that.
Let's go with the assumption that we need at least 2 legs:
```kotlin
private val fixtJourney = Journey(
    "",
    listOf(
        Leg(
            Stop("", ""),
            LocalDateTime.now(),
            TransportMode.WALK,
            Stop("", ""),
            LocalDataTime.now()
        ),
        Leg(
            Stop("", ""),
            LocalDateTime.now(),
            TransportMode.WALK,
            Stop("", ""),
            LocalDataTime.now()
        )
    )
)
```
{: title="Complex instantiation of realistic data structure"}

What can we observe so far? Instantiate one `Leg`, instantiate multiple `Stop`s, pick an `TransportMode` to use; and then instantiate another leg, and so forth. It's simply too much to write, read, and maintain; and when we scale it, there's repetition.

### Enter factories
What do we do when we see repeated code? we extract methods/classes. So we go on and refactor our code to introduce a _factory method_ for leg creation:
```kotlin
private val fixtJourney = Journey("", listOf(createLeg(), createLeg()))

private fun createLeg() = Leg(
    Stop("", ""),
    LocalDateTime.now(),
    TransportMode.WALK,
    Stop("", ""),
    LocalDataTime.now()
)
```
{: title="Re-using code with factory method"}
Cool, it works! Using code looks clean, but is that scalable? How many factory methods should we create to cover all the model types. Is it easily maintainable? How many variations of the same factory method should we have to satisfy all the test scenarios? Okay, we could parameterise each factory method by passing in the parameters that we are interested in; we could even leverage Kotlin's default parameters for functions. But..., what happens if it's a complex model? How many parameters and/or overloads should we have?

### Enter builders
So then, let's move on to the next solution... _builders_! The perfect tool to solve all our issues in terms of maintainability, is it not?
It alleviates the repetition and allows dynamism for creating objects; for example something like this would help with `Journey`s:
```kotlin
class JourneyBuilder(
    private var id: String = "",
    private val legs: MutableList<Leg> = mutableListOf()
) {
    fun build() = Journey(id, legs)

    fun setId(id: String): JourneyBuilder = this.apply { this.id = id }
    fun addLeg(leg: Leg): JourneyBuilder = this.apply { legs.add(leg) }
}

class LegBuilder(
    private var origin: Stop = Stop("", ""),
    private var departure: LocalDateTime = LocalDateTime.now(),
    private var mode: TransportMode = TransportMode.WALK,
    private var destination: Stop = Stop("", ""),
    private var arrival: LocalDateTime = LocalDateTime.now()
) {
    fun build() = Leg(origin, departure, mode, destination, arrival)

    fun setOrigin(origin: Stop): LegBuilder = this.apply { this.origin = origin }
    fun setMode(mode: TransportMode): LegBuilder = this.apply { this.mode = mode }
    // ...
}
```
{: title="Re-using code by implementing complex builder classes"}

Phew, that was a lot of code to type --- and I didn't even write out all the properties (e.g. `destination`), and sub-builders (e.g. `Stop`), nor did I use Kotlin DSL and lambdas.

Anyway, let's use this builder to replace the factory:
```kotlin
private val fixtJourney = JourneyBuilder()
    .addLeg(LegBuilder().build())
    .addLeg(LegBuilder().build())
    .build()
```
{: title="Simple, yet dynamic builder usage"}

Nice! Easy to read, we can create our own domain specific language. But I think it's easy to see how the builder approach might get complicated really fast as the system grows and more data types, properties are added and combined together in various ways.

### JFixture to the rescue

Remember `JourneyBuilder` we created just now? Turns out a very similar effect can be achieved by using the `JFixture` library:
```kotlin
private val fixtJourney: Journey = fixture.create(Journey::class.java)
```
... but what does this do? and what are the benefits? That's what we'll explore next.

#### How does JFixture create an object?
When we call `fixture.create(Class)`, JFixture tries numerous ways to create our objects:
 * built-in types (
   see [Default Supported Types](https://github.com/FlexTradeUKLtd/jfixture/wiki/Default-Behaviour#default-supported-types)
   and [`DefaultEngineParts`](https://github.com/FlexTradeUKLtd/jfixture/blob/master/jfixture/src/main/java/com/flextrade/jfixture/builders/DefaultEngineParts.java)
 )
 * `customise()` (if any)
   * `lazyInstance`
   * `sameInstance`
   * `useSubType`
 * public constructor with the least number of arguments
 * public factory method with the least number of arguments
 * package visible constructor with the least number of arguments

{% include alert tip='Pro tip:
<q>public constructor with the least number of arguments</q> can be changed to <q>most</q> when a class has overloaded constructors:
```kotlin
fixture.customise(GreedyConstructorCustomisation(SomeType::class.java))
```
' %}

When it succeeds, after creation it'll also use:
 * `customise()`
   * `propertyOf`
   * `intercept`
 * setters for mutable properties  
 * write visible mutable fields

Notice that while this may seems like a lot to digest at first, we're usually only using 1 or 2 of these.

#### Benefits: No builder required
JFixture is a builder by itself, except it adapts to the shape of your code automatically.

less code to write  
: ^
   We can save a lot of code that would just create our objects by using the library.

less code to maintain  
: ^
   Every time a new property is added all the usages of the class have to be revised and the constructor calls/builders adjusted.
   Most of the time these are unrelated places and the new field doesn't affect behaviour of the tests, yet we still have to modify them.
   With builders the situation is much better than the classic or factory approach, but maintenance is still needed.

customisation of objects is still possible
: ^
   The flexibility of the builder is that we can pick which parts to be set and how.
   For example a `TRAIN`-only journey with multiple legs; this is still easily possible.

#### Benefits: Data is randomised
Don't worry, it's the [good type of random](https://github.com/FlexTradeUKLtd/jfixture#overview).

no conflicts from random data  
: ^
   Consider this simple thing:
   ```kotlin
   val journeys = setOf(
       JourneyBuilder().addLeg(LegBuilder().build()).build(),
       JourneyBuilder().addLeg(LegBuilder().build()).build()
   )
   assertThat(journeys, hasSize(2))
   ```
   With the hand-built builders we would have to write random code ourselves to get this to pass.
   What's even worse: it could sometimes pass and sometimes wouldn't pass, depending on what time it is now and how fast our computer is.

more confidence in verification  
: ^
   Let's imagine we have a bug, and the production code is using the wrong leg to calculate the origin station's name. With the current builder implementation each leg's station names are all the same. This means that we could easily end up with a false positive verification. JFixture puts different data everywhere, so it would catch the problem:
   With the current builder implementation
   ```kotlin
   // same as   fixtJourney.legs[i].origin.name
   assertEquals(fixtJourney.legs[0].origin.name, model.origin)
   ```

#### A note on Kotlin
Writing `fixture.create(Journey::class.java)` over and over again gets old really fast. In Kotlin we can do better:
```kotlin
inline fun <reified T> JFixture.build(): T = create(T::class.java)
inline operator fun <reified T> JFixture.invoke(): T = create(T::class.java)
```
The first one gives us `val fixtString: String = fixture.build()` with inferred type arguments.
The second one enables `val fixtString: String = fixture()` similar to `mock()` (given `val fixture: JFixture` in scope of course).
It's up to you which way you go, based on how much Kotlin magic is acceptable.
I recommend writing extension methods for most of the `customise()` methods using `KClass`, or `inline` + `reified` so they feel more idiomatic.

_I'll use `operator invoke` in the rest of the article._

## Data-oriented testing
{% include alert info='
Most of the examples in this section demonstrate features that are also listed on the [JFixture&nbsp;cheat&nbsp;sheet](https://github.com/FlexTradeUKLtd/jfixture/wiki/Usage-Cheat-Sheet).
' %}

Until now the focus was on the presenter, and data flow; let's move on to the `JourneyMapper`'s tests to demonstrate how JFixture can help.

### Controlling collections
Let's say the model has a field which represents how many changes passengers have to make on a journey:
```kotlin
data class Model(
    // ...,
    val changeCount: Int
)
```
this is of course calculated as follows:
```kotlin
override fun invoke(journey: Journey) = Model(
    // ...,
    changeCount = journey.legs.size - 1
)
```
{: title="JourneyMapper"}
If we were to use the classic approach, tests for this would get unwieldy. Builders are a bit better, but testing for multiple counts in a parameterised test still requires some form of looping, or a custom factory just to create a certain amount of legs. With JFixture this is supported out of the box for any type:
```kotlin
@CsvSource("1, 0", "2, 1", "3, 2", "4, 3")
@ParameterizedTest
fun `changeCount is mapped correctly`(legCount: Int, expectedChanges: Int) {
    fixture.customise().repeatCount(legCount)
    val fixtJourney: Journey = fixture()

    val result = sut.invoke(fixtJourney)

    assertThat(result.changeCount, equalTo(expectedChanges))
}
```
{% include alert info='
`repeatCount` is a built-in method that changes how many elements each fixtured collection will contain;
the default is&nbsp;[<var>3</var>](https://github.com/FlexTradeUKLtd/jfixture/blob/master/jfixture/src/main/java/com/flextrade/jfixture/MultipleCount.java).
' %}
{% include alert warning='
Warning: This actually does not scale well, but good enough for simple tests.  
More on this in ["Fine-grained repetition"](#fine-grained-repetition).
' %}

### Property customisation
Let's look at how we can calculate if the journey is train-only:
```kotlin
override fun invoke(journey: Journey) = Model(
    // ...,
    trainOnly = journey.legs.all { it.mode == TRAIN }
)
```
{: title="JourneyMapper"}
The tests for this involve setting all the leg modes to `TRAIN`. With the builders approach we could use `LegBuilder.setMode`, with JFixture we just say: <q>all transport modes are `TRAIN`</q>:
```kotlin
@Test fun `trainOnly is true for TRAIN-only journey`() {
    fixture.customise().sameInstance(TransportMode::class.java, TRAIN)
    val fixtJourney: Journey = fixture()

    val result = sut.invoke(fixtJourney)

    assertThat(result.trainOnly, equalTo(true))
}
```
{% include alert info='
`sameInstance` is a built-in method that can be used to make sure a type is **always** resolved to **the same** instance.
' %}

We need to test another scenario though: when there are no `TRAIN` legs. In this case each leg should have a mode of anything but `TRAIN`. Here's a way to do this:
```kotlin
@Test fun `trainOnly is false for a TRAIN-less journey`() {
    fixture.customise().lazyInstance(TransportMode::class.java) {
        fixture.create().fromList(*Enum.valuesExcluding(TRAIN))
    }
    val fixtJourney: Journey = fixture()

    val result = sut.invoke(fixtJourney)

    assertThat(result.trainOnly, equalTo(false))
}
```
{% include alert info='
`lazyInstance` will be called each time a `Leg` is being created to fill its `mode`.  
`fromList` will pick an item from the array.
' %}

`Enum.valuesExcluding` is not in a library, it's one of the few utilities we use to make parameterised tests and fixturing nicer:
```kotlin
inline fun <reified E : Enum<E>>
Enum.Companion.valuesExcluding(vararg excluded: E): Array<E> =
    (enumValues<E>().toList() - excluded).toTypedArray()
```

You may notice that this `lazyInstance` + `fromList` + `valuesExcluding` combination has potential for re-use, and you're right:
it is possible to extract customisation logic via `SpecimenSupplier` and/or `Customisation` interfaces.

### Mutating the immutable
I warn you, things are going to get controversial.
You may have noticed that the only `var` I used is in the builder: we use a lot of immutable data types.
These data types still need to be created, and we're using JFixture as our builders. This is where this very useful small utility comes into play:
```kotlin
fun Any.setField(name: String, value: Any?) {
    this::class.java.getDeclaredField(name).apply {
        isAccessible = true
        set(this@setField, value)
    }
}
```
An example usage would look like this:
```kotlin
@Test fun `duration returns time for whole journey`() {
    val expectedMinutes: Int = fixture()
    val fixtJourney: Journey = fixture()
    fixtJourney.legs.last().setField("arrival", fixtJourney.legs.first().departure.plusMinutes(expectedMinutes))

    val result = sut.invoke(fixtJourney)

    assertThat(result.length, equalTo(Duration.of(expectedMinutes, ChronoUnit.MINUTES)))
}
```
You can see that it gives us the benefit of <q>naturally</q> mutating objects that are otherwise immutable.
Additionally it really focuses on the bits that we care about and leaves everything else up to JFixture.
The reflection may look counter-productive, but in the rare instance we rename properties or change types of properties the tests will fail at run-time;
which is slower to detect than a compile error, but we're still protected from false positives.

Sometimes each object has to contain self-consistent data, for example: each leg has to be a non-zero length travel. In this case `intercept` comes in handy combined with `setField`:
```kotlin
fixture.customise().intercept(Leg::class.java) {
    it.setField("arrival", it.departure.plusMinutes(fixture<Long>()))
}
```
{% include alert info='
`intercept` is a built-in method that lets you mutate the created object further after creation. It will be called once for each instance.
' %}

{% include alert warning='
JFixture has a `propertyOf` customisation which we could use instead of `setField`, but it\'s a no-go when using immutable classes. It will only work on `var`s, not `val`s.
' %}

### Fine-grained property customisation
Here's the thing about `lazyInstance`: it affects every single object created from the given `fixture` factory. This may be unwanted, and needs to be resolved.
Let's consider what happens if there are `Passengers` in the system:
```kotlin
data class Passenger(
    val preferredMode: TransportMode
)
```
In this case, creating a `Journey` and a `Passenger` in the same test would mean we would be always creating them with the same `TransportMode` when using `sameInstance`.
To make this more explicit we can use:
```kotlin
fixture.customise().intercept(Leg::class.java) {
    it.setField("mode", TransportMode.TRAIN)
}
fixture.customise().intercept(Passenger::class.java) {
    it.setField("preferredMode", TransportMode.WALK)
}
```

### Fine-grained repetition
Similarly `repeatCount` is a tricky one. It changes each collection's size at once, which is probably not what we want. For example we may need to test 2 passengers over 3 legs:
```kotlin
data class Journey(
    // ...,
    val legs: List<Leg>,
    val passengers: List<Passenger>
)
```
{: title="Adding passengers to data type"}

```kotlin
val fixtJourney: Journey = fixture()
fixtJourney.setField("passengers", fixture.createList<Passenger>(size = 2))
```
{: title="Creating a specific number of passengers"}

`createList` is not a library function, it is one of the extensions we added to help us create lists in a very simple way. JFixture --- being designed for Java --- has some quirks in Kotlin, so hiding them in utility functions helps to write nicer code:
```kotlin
@Suppress("UNCHECKED_CAST") // can't have List<T>::class literal, so need to cast
inline fun <reified T : Any> JFixture.createList(size: Int = 3): List<T> =
    this.collections().createCollection(List::class.java as Class<List<T>>, T::class.java, size)
```

## Best practices
Now that we have the tools, here are some tips to prevent hurting ourselves.

### Shared JFixture
It might be tempting to create globals, but try not to.
It's not worth the hours of debugging when you accidentally end up with the wrong fixtured data because another test customised it in a counter-productive way.
```kotlin
val fixture = JFixture()
// or
object fixture : JFixture() { ... }

@TestMethodOrder(Random::class)
class SharedStateTest {
    @Test fun customiser() {
        fixture.customise().sameInstance(String::class.java, "")

        assertThat(fixture<String>(), emptyString())
    }

    @Test fun annoyedObserver() {
        assertThat(fixture<String>(), not(emptyString()))
    }
}
```
In the above example the `fixture` global property outlives the test's lifecycle and leaks the `""` customisation to the other test, which expects `JFixture`'s default behaviour.
This expectation is usually implicit when writing fixtured tests.

As seen above, sharing state between a single test class' methods is risky. We always use non-static `JFixture` instance set up in `@BeforeEach` to prevent cross-test customisations:
```kotlin
private lateinit var fixture: JFixture
@BeforeEach fun setUp() {
    fixture = JFixture()
}
```
If we share `fixture` like this and put customisations into the `setUp` method, we could end up with not fully self-contained tests. Your mileage may vary on how much shared setup is acceptable in your project. This is a similar decision to how/where `mock()` variables are set up and stubbed.

Note that having `private val fixture = JFixture()` inside the class may not be enough,
because the test runner may create an instance per test class, not per test method: Google&nbsp;`@TestInstance(PER_CLASS)` for more information on when this could break down.

### Sharing data setup
That being said, sharing setup is a good idea.
For example, if all the tests create objects which have `CharSequence` fields, the following setup makes sure that is possible in each test:
```kotlin
@BeforeEach fun setUp() {
    fixture = JFixture()
    fixture.apply {
        customise().useSubType(CharSequence::class.java, String::class.java)
    }
}
```
Notice that it's only the code being shared, not the run-time objects.

### Centralized Fixture
Taking it a step further, it's very likely we'll end up having very common customisations.
`CharSequence`&nbsp;&rarr;&nbsp;`String` is a good example; it could occur often in Android.
It is recommended to create a custom type that builds on JFixture:
```kotlin
class MyFixture : JFixture() {
    init {
        customise().useSubType(CharSequence::class.java, String::class.java)
    }
}
```
It helps:
 * sharing customisations
 * sharing fixture related utility methods  
   (not so beneficial when we can use Kotlin extension methods, but it is in Java)
 * creating a better API fitting your style  
   (if you go with encapsulation over inheritance)

That said, we are not using this pattern, because we prefer easily discoverable and focused test setups.

### Stubbing fixture behaviour
Let's see what happens if our data classes have calculated properties, for example:
```kotlin
data class Journey(
    // ...
    val legs: List<Leg>,
) {
    val changeCount get() = legs.size - 1
}
```
This is very simple, but it can easily get complicated, in which case setting up the fixture to be exactly correct for the calculated property could be tricky.
At this point you might be thinking: let's mock the logic to isolate it, but it's on a JFixture generated class.
Mockito spies come to the rescue:
```kotlin
val spyJourney = spy(fixture<Journey>())
doReturn(6).whenever(spyJourney).changeCount
```
{% include alert warning='
Beware: when using `spy`s, we must always use the `doReturn(result).when(spy).method(args)` pattern,
otherwise the real method gets called, which can cause problems.
' %}

Tip: even when using annotated setup, it's possible to combine the two frameworks:
```kotlin
@Mock lateinit var mockView: JourneyView
@Mock lateinit var mockDataSource: DataSource<Journey>
@Mock lateinit var mockMapper: (Journey) -> Model

@Fixture lateinit var fixtJourneyId: String
@Spy @Fixture lateinit var spyJourney: Journey
@Fixture lateinit var fixtModel: Model

private lateinit var fixture: JFixture

private lateinit var sut: JourneyPresenter

@BeforeEach fun setUp() {
    fixture = JFixture()
    FixtureAnnotations.initFixtures(this, fixture)
    MockitoAnnotations.initMocks(this)

    sut = JourneyPresenter(mockView, mockDataSource, mockMapper)
}
```
{: title="JourneyPresenterTest"}
The important thing here is to have `initMocks` **after** `initFixtures`.

## Culprits
No tool is without its drawbacks --- here are some interesting problems we have encountered while using JFixture.

### Kotlin generics interoperability
Kotlin makes every usage of a generic `out T` (e.g. `kotlin.collections.List<T>`) automatically appear in the class files as `? extends T`.
JFixture doesn't like this, because there's no right choice for it to pick when creating test data.
The workaround we use is adding `@JvmSuppressWildcards` on the field declarations like so:
```kotlin
@Fixture lateinit var fixtJourneys: List<@JvmSuppressWildcards Journey>
```

### Customise the right JFixture
When using the annotated setup, it's quite easy to end up using the wrong `JFixture` instance and wonder why none of our customisations work:
```kotlin
@Fixture lateinit var fixtModel: Model

private lateinit var fixture: JFixture

@BeforeEach fun setUp() {
    fixture = JFixture()
    fixture.customise()....
    FixtureAnnotations.initFixtures(this)
}
```
The problem here is using the wrong `initFixtures` overload.
When we create and customise a `JFixture` instance, we need to call `initFixtures(this, fixture)`; otherwise `initFixtures` will create a new non-customised `JFixture` instance.

### Beware of overloads
```kotlin
fixture.customise().useSubType(CharSequence::class.java, String::class.java)
fixture.customise().sameInstance(CharSequence::class.java, String::class.java)
```
Let's say we wanted to use `useSubType`, but accidentally used `sameInstance`. This makes a subtle difference when it's one of the hundreds of lines of test code. Sadly, this compiles, and when JFixture tries to create an instance of `CharSequence`, it throws a `ClassCastException`: cannot cast `Class<String>` to `CharSequence`. This is because `sameInstance` has an overload that matches the arguments:
```java
public interface FluentCustomisation {
    <T> FluentCustomisation sameInstance(Class<T> clazz, T instance);
    <T> FluentCustomisation sameInstance(Type type, T instance);
}
```
`Class<*>` implements `Type` so when the `instance` argument is not a subclass of `T` in `clazz`, the overload resolution finds the `Type` overload and `T` becomes `Class<String>`.

### Flaky tests
One of the main benefits of JFixture is reproducibility through constrained non-determinism.
In practice this means that if tests fail on one computer (e.g. CI) they'll fail the same way on another (e.g. dev machine).
Mind you, this failure may not be immediate, but it's eventually reproducible.
Don't fret though, it's not as bad as the [infinite monkey theorem](https://en.wikipedia.org/wiki/Infinite_monkey_theorem) states.
In practice, we observed that if we see a flaky test on the CI, we can simply run the test a 100 times and we'll see some failures:

![Run/Debug Configurations > JUnit > Configuration > Repeat > N Times](data:image/png;base64,
	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
	QmCC
)

Here's an example flaky test that will pass 90% of the time:
```kotlin
enum class Type { Other, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8, Type9 }

fun Type.isValidType() = this != Other
```
{: title="Production code"}
```kotlin
@Test fun flaky90() {
    val fixture = JFixture()
    val fixtType: Type = fixture()

    val result = fixtType.isValidType()

    assertTrue(result)
}
```
{: title="Test code"}
This could mean that if you run the test a few times, and the code reviewer runs it,
and the CI runs it; it's still going to pass all those times, but then when you merge to `master`, it fails.
The above example is over-simplified, but even the most complex flaky tests we had of this type weren't that hard to debug and fix.
Notice that the reason for failure is assuming what the fixture will generate.
If this `isValidType` is used in an `if`, that behaviour will trigger 90% of the time.
To fix this test, we need to use `valuesExcluding` technique described in the [Property Customisation](#property-customisation) section,
and write a separate test for `Other` specifically.
Bear in mind that in some cases we need to consider that the `isValidType`'s input should be parameterised to test all possibilities (not just a random one), but that's a topic for another time.

## Conclusion
Introducing JFixture to an existing project is a big leap, but we think it's worth the effort and the learning curve is not that bad.
There will be times when you scratch your heads, but you'll learn something new each time, until you develop a solid stable usage pattern.
I personally found it very useful to debug into JFixture when something is wrong.
Give it a whirl and let me know how you find the framework.

## References
 * [JFixture library's GitHub repository](https://github.com/FlexTradeUKLtd/jfixture)
 * [JFixture library's documentation](https://github.com/FlexTradeUKLtd/jfixture/wiki)
 * [Example code used](https://github.com/TWiStErRob/TWiStErRob/tree/master/JFixturePlayground)
