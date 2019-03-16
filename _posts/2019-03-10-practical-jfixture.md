---
title: "Practical JFixture"
subheadline: "How to use it to help you write clean, focused tests"
teaser: "Magic one-liner with powerful behavior"
category: dev
tags:
- test
- tutorial
- efficiency
---

Tests need data, let's see how can we create them using [JFixture](https://github.com/FlexTradeUKLtd/jfixture).<!--more--> 
In this article I'll go through some practical usage patterns of JFixture, and compare those to some other alternatives.

## Intro

> JFixture is a Java library to assist in the writing of Unit Tests, particularly when following Test Driven Development. It generates types based on the concept of 'constrained non-determinism', which is an implementation of the [Generated Value](http://xunitpatterns.com/Generated%20Value.html) xUnit test pattern.
<cite>[JFixture README.md](https://github.com/FlexTradeUKLtd/jfixture)</cite>

What this really means, is that JFixture can create any data object with very little developer effort, here's an example:
```java
private final JFixture fixture = new JFixture();

@Test public void test() {
    Journey fixtJourney = fixture.create(Journey.class);

    Model result = sut.process(fixtJourney);

    assertNotNull(result);
}
```
No matter how deep or complicated it gets, JFixture usually finds a way to create an instance with all the data filled in.

{% include alert info='
Note: the above is the only Java example; in this article I used Kotlin as the primary language, because of its conciseness.
JFixture was written for the JVM, so was Kotlin, so they\'re easily interoperable.
Everything you see here applies to Java as well (unless it\'s about using some Kotlin language feature).

I chose JUnit Jupiter and Mockito + Mockito Kotlin as the testing frameworks in this article.
' %}

## Motivation
Here's a question: when reading the below two setup approaches, which of them convey it better what setup the test needs in order to verify a certain behavior?
```kotlin
val fixtJourney = Journey(
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
{: title="classic approach"}

```kotlin
fixture.customise().sameInstance(TransportMode::class.java, TransportMode.TRAIN)
val fixtJourney = fixture.create(Journey::class.java)
```
{: title="customised JFixture"}
> At this point you probably don't know how JFixture works; yet, hopefully, you can easily figure out what happens in the above example. <cite>me</cite>

{% include toc.md %}

## The need for JFixture

### From the ground up
Let's image we're writing a user interface for displaying some info based on a journey. Journey data is coming from a data source, and we do some transformation on it to display it on the UI.

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
additionally let's say this is the class that orchestrates the loading and displaying:
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
            .subscribe { model ->
                view.show(model)
            }
    }
}
```
here are the collaborator interfaces for completeness (using something like RxJava's `Single`):
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
Mind you, that we're testing the data flow here: `dataSource` &rarr; `mapper` &rarr; `view`.
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
The simplest way to fulfill the missing pieces above is this:
```kotlin
private val fixtJourneyId = ""
private val fixtJourney = Journey("", "", "")
private val fixtModel = Model("", 0, 0)
```
{: title="Classic data setup for test"}
Here, we filled in the values, so that it compiles. At the same time we, don't really care about what the values are, so we mostly use default values such as use empty strings, `false`, or `0`s.

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
OK... I took a shortcut here, but what will happen if can't assume to have an empty list there?
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
Cool, it works! Using code looks clean, but is that scalable? How many factory methods should we create to cover all the model types. Is it easily maintainable? How many variations of the same factory method should we have to satisfy all the test scenarios? Okay, we could parameterise each factory method by passing in the params that we are interested in; we could even leverage Kotlin's default parameters for functions. But..., what happens if it's a complex model? How many parameters and/or overloads should we have?

### Enter builders
So then, let's move on to the next solution... _builders_! The perfect tool to solve all our issues in terms of maintainability, is it not?
It alleviates the repetition and allows dynamism for creating objects; for example something like this would help with `Journey`s:
```kotlin
fun journey() = JourneyBuilder()

class JourneyBuilder(
    private var id: String = "",
    private val legs: MutableList<Leg> = mutableListOf()
) {
    fun build() = Journey(id, legs)

    fun setId(id: String): JourneyBuilder = this.apply { this.id = id }

    fun addLeg() = LegBuilder()

    inner class LegBuilder(
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

        fun finish() = this@JourneyBuilder.also { it.legs.add(build()) }
    }
}
```
{: title="Re-using code by implementing complex builder classes"}

Phew, that was a lot of code to type --- and I didn't even write out all the properties (e.g. `destination`), and sub-builders (e.g. `Stop`), nor did I use Kotlin DSL and lambdas.

Anyway, let's use this builder to replace the factory:
```kotlin
private val fixtJourney = journey()
    .addLeg()
    .finish()
    .addLeg()
    .finish()
    .build()
```
{: title="Simple, yet dynamic builder usage"}

Nice! Easy to read, we can create our own domain specific language. But I think it's easy to see how the builder approach might get complicated really fast as the system grows and more data types, properties are added and combined together in various ways.

### JFixture to the rescue

Remember `JourneyBuilder` we created just now? Turns out a very similar effect can be achieved by using the `JFixture` library:
```kotlin
private val fixtJourney: Journey = fixture.create(Journey::class.java)
```
... but what does this do? and what are the benefits? That's what I'll explore next.

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

{% include alert info='
Pro tip: "with least number of arguments" can be changed with
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

 * **less code to write**  
   We can save a lot of code that would just create our objects by using the library.

 * **less code to maintain**  
   Every time a new property is added all the usages of the class has to be revised and the constructor calls/builders adjusted.
   Most of the time these are unrelated places and the new field doesn't affect behavior of the tests, yet we still have to modify them.
   With builders the situation is much better, than the classic or factory approach, but maintenance is still needed.

 * **customization of objects is still possible**  
   the flexibility of the builder is that we can pick which parts to be set and how.
   For example a `TRAIN`-only journey with multiple legs; this is still easily possible.

#### Benefits: Data is randomized
Don't worry, it's the [good type of random](https://github.com/FlexTradeUKLtd/jfixture#overview).

 * **no conflicts from random data**  
   Consider this simple thing:
   ```kotlin
   val journeys = setOf(
       journey().addLeg().finish().build(),
       journey().addLeg().finish().build()
   )
   assertThat(journeys, hasSize(2))
   ```
   With the hand-built builders we would have to write random code ourselves to get this to pass.
   What's even worse: it could sometimes pass and sometimes wouldn't pass, depending on what time it is now and how fast our computer is.

 * **more confidence in verification**  
   With the current builder implementation
   ```kotlin
   fixtJourney.legs[0].origin.name == fixtJourney.legs[1].origin.name
   ```
   so when checking `assertEquals(fixtJourney.legs[0].origin.name, model.origin)` we could get a false positive, if the production code is using the wrong leg.

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
If we were to use the classic approach, tests for this would get unweildy. Builders are a bit better, but testing for multiple counts in a parameterized test still requires some form of looping, or a custom factory just to create a certain amount of legs. With JFixture this is supported out of the box for any type:
```kotlin
@CsvSource("1, 0", "2, 1", "3, 2", "4, 3")
@ParameterizedTest
fun `changeCount is mapped correctly`(legCount: Int, expectedChanges: Int) {
    fixture.customise().repeatCount(legCount)
    val journey: Journey = fixture()

    val result = sut.invoke(journey)

    assertThat(result.changeCount, equalTo(expectedChanges))
}
```
{% include alert info='
`repeatCount` is a built-in method that changes how many elements each fixtured collection will contain;
the default is&nbsp;[<var>3</var>](https://github.com/FlexTradeUKLtd/jfixture/blob/master/jfixture/src/main/java/com/flextrade/jfixture/MultipleCount.java).
' %}
{% include alert warning='
Warning: This actually doesn\'t scale well, but good enough for simple tests.  
More on this in ["Fine-grained repetition"](#fine-grained-repetition).
' %}

### Property customization
Let's look at how we can calculate if the journey is train-only:
```kotlin
override fun invoke(journey: Journey) = Model(
    // ...,
    trainOnly = journey.legs.all { it.mode == TRAIN }
)
```
{: title="JourneyMapper"}
The tests for this involve setting all the leg modes to `TRAIN`. With the builders approach we could use `LegBuilder.setMode`, with JFixture we just say: "all transport modes are `TRAIN`":
```kotlin
@Test fun `trainOnly is true for TRAIN-only journey`() {
    fixture.customise().sameInstance(TransportMode::class.java, TRAIN)
    val journey: Journey = fixture()

    val result = sut.invoke(journey)

    assertThat(result.trainOnly, equalTo(true))
}
```
{% include alert info='
`sameInstance` is a built-in method that can be used to make sure a type is always resolved to the same instance.
' %}

We need to test another scenario though: when there are no `TRAIN` legs. In this case each leg should have a mode of anything but `TRAIN`. Here's a way to do this:
```kotlin
@Test fun `trainOnly is false for a TRAIN-less journey`() {
    fixture.customise().lazyInstance(TransportMode::class.java) {
        fixture.create().fromList(*Enum.valuesExcluding(TRAIN))
    }
    val journey: Journey = fixture()

    val result = sut.invoke(journey)

    assertThat(result.trainOnly, equalTo(false))
}
```
{% include alert info='
`lazyInstance` will be called each time a `Leg` is being created to fill its `mode`.  
`fromList` will pick an item from the array.
' %}

{% include alert warning='
`Enum.valuesExcluding` is not in a library, it\'s one of the few utilities we use to make parameterized tests and fixturing nicer:
```kotlin
inline fun <reified E : Enum<E>>
Enum.Companion.valuesExcluding(vararg excluded: E): Array<E> =
    (enumValues<E>().toList() - excluded).toTypedArray()
```
' %}

You may notice that this `lazyInstance` + `fromList` + `valuesExcluding` combination has potential for re-use, and you're right:
it is possible to extract customization logic via `SpecimenSupplier` and/or `Customization` interfaces.

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
    val journey: Journey = fixture()
    journey.legs.last().setField("arrival", journey.legs.first().departure.plusMinutes(15))

    val result = sut.invoke(journey)

    assertThat(result.length, equalTo(Duration.of(15, ChronoUnit.MINUTES)))
}
```
You can see that it gives us the benefit of "naturally" mutating objects that are otherwise immutable.
Additionally it really focuses on the bits that we care about and leaves everything else up to JFixture.
The reflection may look counter-productive, but in the rare occurrence we rename properties or change types of properties the tests will fail at runtime;
which is slower to detect than a compile error, but we're still protected from false positives.

Sometimes each object has to contain self-consistent data, for example: each leg has to be a non-zero length travel. In this case `intercept` comes in handy combined with `setField`:
```kotlin
fixture.customise().intercept(Leg::class.java) {
    it.setField("arrival", it.departure.plusMinutes(fixture<Long>()))
}
```

{% include alert warning='
JFixture has a `propertyOf` customisation which we could use instead of `setField`, but it\'s a no-go when using immutable classes. It\'ll only work on `var`s, not `val`s.
' %}

### Fine-grained property customization
There's an interesting thing about `lazyInstance`: it affects every single object created from the given `fixture` factory. This may be unwanted and needs to be resolved.
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
Similarly `repeatCount` is a tricky one. It changes each collection's size at once, which is probably not what we want. For example I may need to test 2 passengers over 3 legs:
```kotlin
data class Journey(
    // ...,
    val legs: List<Leg>,
    val passengers: List<Passenger>
)
```
{: title="Adding passengers to data type"}

```kotlin
val journey: Journey = fixture()
journey.setField("passengers", fixture.createList<Passenger>(size = 2))
```
{: title="Creating a specific number of passengers"}

{% include alert warning='
`createList` is not a library function, it is one of the extensions we added to help us create lists in a very simple way. JFixture being designed for Java has some quirks in Kotlin, hiding it in utility functions helps to deal with it nicely:
```kotlin
@Suppress("UNCHECKED_CAST") // can\'t have List<T>::class literal, so need to cast
inline fun <reified T : Any> JFixture.createList(size: Int = 3): List<T> =
    this.collections().createCollection(List::class.java as Class<List<T>>, T::class.java, size)
```
' %}

## Best practices
Now that we have the tools, here are some tips to prevent hurting ourselves.

### Shared JFixture
It might be tempting to create a globals:
```kotlin
val fixture = JFixture() // top-level
// or
object fixture : JFixture() { ... }
```
... but try not to.
It's not worth the hours of debugging when you accidentally end up with the wrong fixtured data because another test customised in a counter-productive way.
```kotlin
private val fixture = JFixture()

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
In the above example the `fixture` file-global property out-lives the test's lifecycle and leaks the `""` customization to the other test, which expects `JFixture`'s default behavior.
This expectation is usually implicit when writing fixtured tests.

As seen above even sharing state between a single test class' methods is risky. We always use non-static `JFixture` instance set up in `@BeforeEach` to prevent cross-test customizations:
```kotlin
private lateinit var fixture: JFixture
@BeforeEach fun setUp() {
    fixture = JFixture()
}
```
{% include alert warning='
Note: having `private val fixture = JFixture()` inside the class may be not enough,
because the test runner may create an instance per test class, not per test method: Google&nbsp;`@TestInstance(PER_CLASS)`.
' %}

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
Notice that it's only the code being shared, not the runtime objects.

### Centralized Fixture
Taking it a step further, it's very likely we'll end up having very common customizations.
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
 * sharing customizations
 * sharing fixture related utility methods  
   (Not so beneficial when we can use Kotlin extension methods, but it is in Java.)
 * if you go with encapsulation over inheritance you can create an API better fitting your style

That said, we are not using this pattern, because we prefer easily discoverable and focused test setup.

### Stubbing fixture behavior
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

Tip: even when using annotated setup, it's possible the combine the two frameworks:
```kotlin
@Mock lateinit var mockView: JourneyView
@Mock lateinit var mockDataSource: DataSource<Journey>
@Mock lateinit var mockMapper: (Journey) -> Model

@Fixture lateinit var fixtJourneyId: String
@Spy @Fixture lateinit var fixtJourney: Journey
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
No tool is without its drawbacks, here are some interesting problems we encountered while using JFixture.

### Kotlin generics interoperability
Kotlin makes every usage of a generic `out T` (e.g. `kotlin.collections.List<T>`) automatically appear in the class files as `? extends T`.
JFixture doesn't like this, because there's no right choice for it to pick when creating test data.
The workaround we use is adding `@JvmSuppressWildcards` on the field declarations like so:
```kotlin
@Fixture lateinit var fixtJourneys: List<@JvmSuppressWildcards Journey>
```

### Customise the right JFixture
When using the annotated setup, it's quite easy to end up using the wrong `JFixture` instance and wonder why none of our customizations work:
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
When we create and customize a `JFixture` instance, we need to call `initFixtures(this, fixture)`; otherwise `initFixtures` will create a new uncustomised `JFixture` instance.

### Beware of overloads
Let's say we want to write the following:
```kotlin
fixture.customise().useSubType(CharSequence::class.java, String::class.java)
```
but accidentally end up writing this:
```kotlin
fixture.customise().sameInstance(CharSequence::class.java, String::class.java)
```
a subtle difference when it's one of the hundreds of lines of test code.

Sadly, this compiles, and when triggered it throws a `ClassCastException`. This is because `sameInstance` has an overload that matches the arguments:
```java
public interface FluentCustomisation {
    <T> FluentCustomisation sameInstance(Class<T> clazz, T instance);
    <T> FluentCustomisation sameInstance(Type type, T instance);
}
```
`Class<*>` implements `Type` so when the `instance` argument is not a subclass of `T` in `clazz`, the overload resolution finds the `Type` overload.

### Flaky tests
One of the main benefits of JFixture is reproducability through constrained non-determinism.
In practice this means that if it fails on one computer (e.g. CI) it'll fail the same way on another (e.g. dev machine).
Mind you that determinism doesn't mean immediate reproducability, but eventual.
Don't fret though, it's not as bad as the [inifinite monkey theorem](https://en.wikipedia.org/wiki/Infinite_monkey_theorem) states.
In practice, we observed that if we see a flaky test on the CI, we can simply run the test a 100 times and we'll see some failures:

![Run/Debug Configurations > JUnit > Configuration > Repeat > N Times](data:image/png;base64,
	iVBORw0KGgoAAAANSUhEUgAABAYAAACjCAIAAACWpovAAAAAAXNSR0IArs4c6QAAAARnQU1BAACx
	jwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAACc4SURBVHhe7d3fiyTXleDxehlm/4sZbD/N+GXR
	0rtt1jDsPvlfkP2wNayKwTO0xsjWD0suN/I2ZSNUFq1tGqFm0DbIXqyasTBWMS1jra0dBpZt3DJa
	4+lua9XWSrJaLUGXwZYsaLTn3nPujXvjV0VmRkRmZH4/NK4b5/6Im5mRGefUD3nrbwEc5/Of//yf
	/dmfr/6/f/sf/qIUKf07ceLEp1bApz/9aWsN7G8/8SfVf9Y3gH/zqU9uf/JPT33iT/7zJ//0M5/6
	pEUBAFh5riT4GAAAAMCmoiQAAAAANholAQAAALDRKAkAAACAjUZJAAAAAGw0SgIAAABgo1ESAAAA
	ABvtmJLg33dmEwAAAABMytZfn/ora9axfL8DmwAAAABgUjqVBHaQVwjf//7304gOAAAAALAUW1tb
	ly9ftoOEBKXLDup0Kgm+853vSPvg4EAPVYeS4HBHTh7sHFp0ZrKMm5yt9pknrltvDRnZ2j+b6098
	xk46z6q6a5nolulxV7lBFwcAAMAUSOr/R3/8r+R/7dirDZZ0Kgm++MUvSvsrX/mKHqpuJUHIU11m
	PF9RINmuLpIm+j7RblwvHbkYOXl6nutPPDHbY5j/YXfQ38MEAADAWigVAKXDJmOVBHPnr5KUW06d
	ryDxxmS7r1y57RzdDJq1D7o4AAAAJimWAbFhHc0WKgnu3LljB11+SmDNNJGNbd94wn4zKM1zr8eK
	IJsopCfk666pNOBHHlowzKk9bzHXnz5dv7UiKM4YR1QfgkRMOGw5ae32XGNnR8a6kxTL5UfhsLy4
	aN6bKMaFYQAAAFgHl30x0LEeEDP/LcGpU6deeeWVM2fO/OY3v7lx44YOEDo+V0pbVZK8Fm0/Use4
	ZhwtB2k7ThQuo/V9Sfxwx7f8ahpzo+Ip4vTYdiP1BD5BjgM8CeWBoJiVr199CPFEabvoTk7aODJG
	g7S3fkqnvUnDxgEAAGCtXB6iJLADf/ilL33p3XfflfatW7ekrQOEDsiFPNXlpjH9DMGsXRt0zRjN
	xwhZ1B+6xRPuPNlIOQgpcAyGdlgjC0bZthN5vG392mD9SY+d7o9M85Tue3MjiygAAADWw+WBfnGo
	5LOf/eznPvc5OwhsQqbIRK8XaXBdelofTCY56Zgk942NQjoydtedIjtDvr5Ts7STh2Va4/q1wfqT
	Hje9OGmcXzdlhr05bnj8qQIAAAAm7nJeBpQOm8xTEtSyCZnaTNRloZaDSsyCdSNlYJarlsbERLZY
	JUgixdmazpt0l5YRrj+eyA3y/8WhYlayqgTT7cX1a4PVkzZtL0yPTTew0lu03eRuezMyKjsGAADA
	NF2uKwBqgyWjlQR5Kqt2dpJENo60toy31NbEaaJY1nFLB26OW8H/VW4IqJrzFsGaPy9W6eKxvwjG
	kG07b9cGG04agg1PSzile2QWtBnhIdvIjnuzySJ/mgEAADBNkthdrkv9JShddlBntr8liN555x3t
	iqyjN9mfEYzBZdKjJ8dLOSkAAACQGPSnBFPivmk+chGypJMCAAAAqWNKgnVX/JLNiL8/s5STAgAA
	APU2vCQAAAAANh0lAQAAALDRKAkAAACAjUZJAAAAAGw0SgIAAABgo1ESAAAAABuNkgAAAADYaJQE
	AAAAwEZzJcFvAQAAAGwqSgIAAABgo1ESAAAAABuNkgAAAADYaJQEAAAAwEajJAAAAAA2GiUBAAAA
	sNEoCQAAAICNRkkAAAAAbDRKAqCrHwMAMAq78QBjoSQAupLPaPt//QYAYDCUBBgfJQHQFSUBAGAE
	lAQYHyUB0BUlAQBgBJQEGN/algSnmtmIVfLee+/98Ic/PHv27Le//e3r169bFCuGkgAAMAJKAoyP
	kqATm9nKhs7u3XffPXPmjC7yve99z6JYPZQEAIARjFAS3NWNjV4q28pxbDTm1WdJoEmtHSxbv5vR
	1drZ0NmdO3dOV3jmmWdu376twbfeeksbWB2UBACAEYxTEtjJmq1Inj2hrU7a+pcE2qilI7toH9/e
	2+6999677777ZPru7u7777+vwVdfffX06dPaxtHRwfbW1tb2gR1b5MTelSM7HkulJDjckY0FJ/ev
	+Yj/WqOly2TLecdMaKQrJbNdYOfQDoozFSNKETtMpgAAxrKyJYHekL3tgyMxxu14kZLA7bcuf1hW
	IlHSZT+jbZWSoJP28e297d566y2dLs6fPy9Vwc9//vOHH35Y6gQbMaN/8exgdjJXPolazLr4hQsX
	fvnLX1bb3emb4cQJ9/GTRsZ/J8vDt88eI4lzKWmvRqKWrpLuI0XtYAnGbP7a/knJ7XeSSOyNc6sR
	bVMSAMASyO3GbjyDmSPPPrqy52/F7uYr7T1XE4xxO567JHAbPrG9faLYYdzwshKJki77GW2rW9vb
	29ZcmOa1drBscTOxkaoNtmgf397bTmqA+++/X1cQjz32mP7Q4Mknn7QRs4gJ/UBVwRzLXr169fTp
	01oJpO3u7M1wIG9s964pIqO/k+UZsM8ekybQqhqJWrpKuo8UtYMlWMrmk0jSlHLBTa5GnOoiAIAx
	yO3GbjyDmackCOmrHY91O567JHAVwd4V/V+NxA0vK5Eo6bKf0ba6aEmgiWwTG9SZTWtgg7qJU7RR
	S0d20T6+vbeF1APxDwlSUhVI9myDOiul8r1XBXMv+JOf/CT+WlTa7ii+GfRLGpG2tIz/yaB1Sf1g
	Mf9NDU/nujEx5L/bERY7/s0mT4J99hhJmkvpeBGRlrG8Onb5nnue3j+ZZNzZStmBfpff0+HF8T0v
	FCfJs3eJl7L5IpIk/RauRkotAMCY5HZjN57BzFMSuPtlcTMVpXtu7Kq9NW9vyyh/283vwjqlxXwl
	gT+Nv7uHrz4Ybvmh4YLFftyGJCJ92igPq/4O0oyPvba3eT/+6Uq6VLrmc7eTiaXV9uxkEtKJ7Tal
	JNBgVBtsoePb2dDObt++XVsPPPzww7/4xS9sUGf9JvGitODcS7322mvf+MY39CcDabu78iWev3NU
	3uUv/6TpBrh2+a0lTdcKU/1KbeR5sM8eI0lzwafPEkmyeSdGtOES+mrKnTRFukjSPtxxrXxoPjgq
	D0ojlAQAsOLkdmM3nsEskGe7W16SMaf3XHef1ZEi3nC1T1pp0LX9XdiPbTPnVkMlEGsCF8y2FBvh
	4bgH54MS05Rddij8JnUVaSidaGuEidZXPpFrWYeX99Y33DDNUpKI8hEXCu0wPrR1QHwIpdelyab8
	4lAtHdmFTWhlQ7uReuCZZ56xmadO3X///VIGXL9+/erVqzN9B13V1gOql6pgkUX6+luC+PbwF3Ye
	MfFtUH5vpO3waRYkFf+x5Kmwzx4jSXMpHU8i0jQacV0nT6YTYs6tyX6ULOIqiIQM95F8kWyyF1eO
	igglAQCsOLnd2I1nMPPl2UrvpO5u3HTPlabxd960a/a78HxbTTN4d86G78r7/RQZs0TdgU52g+Lv
	LVtIh4n0QQmd6OLSMn6JfFhTb76fhNtNtoJII7XtpgHt+FuCTnR8OxvaQen3haQemCNRjlrqAbVg
	VbDI9F7kV7a+d8NFH97Jxdu34W0Q23GKW3pG8mTaZ4+RpLmUjoeIS9w1n475tnT5miBJs7Uvy8id
	ZNlinYwLN/5cQkiwNCuJJE07dTXiVBcBAIxBbjd24xnMIiWBCPfStvts/a159rvwHFv1ZyzRLYVN
	VnarEyXqx+nO9bv00t4+CA9Fh4nsQcVVwtf2x17tbdqPSFdQ+alr2k0D2q1tSRDprmrZiA5sQt0U
	6+i8mtQDTz75pM1ZuB7YBKWr2b9bhL/o48XvgtqqfxskQ6XhWn4xJ/bYcbMZSoLY45J3bVkom+MS
	8J2dUkWQDZF2Mj4RcvdsvUCCzSWB25K2w9xqxNqUBACwBKtZEhwd7IVbarzp1t1n4/228dbsDtyK
	3cy11ezOXiTaxebShutyw8IoaUsz/ZUhyZZLe04fSM3yLhLXdw03rLk3b7iWP4mTrqCyNcO5Xdum
	5ietTG9CSdCJTfBTrOWVurp4/vnnbcKpU1/72tfm+DPiTVO9mt3lbxe9b7oCwf4rY01vg6wdJjny
	NrKe498tM5QEPst2iow/7wrzJFpJvPNlw0qOjHQTlE2zQLaIxEqL5pGwSBGqRmoWAQCMYUVLAne/
	DPLfw0nb7bdmNzK/C2uwxRxb1fPZgefO6ZL2uMlk58V+SptMBxRdSlfwf+PrWFLe+thbehv249dN
	ulQp4o5s8HbNapXpTfosCVaTZd91bEQHNqGPkuD27dv6U4Ld3d0bN25YFFNQKQl6MEze3cuqlAQA
	sByrWRIsy2putXuqPRXrXxKsoPfff//ixYvUA5PTf0lwrfxnBD3R7/kvsLQuQEkAAMswTknQhY32
	/H0hYx0Ds60cx0aPxZ6CnPVNEyUB0FWvJYH+PtAgBQEAYNJGKAmwIH5KAGyu/n9KAABABSUBxkdJ
	AHRFSQAAGAElAcZHSQB0JZ/RAACMwG48wFgoCQAAAICN1rUk+AkwALu8AAAAsDwzlAT2C25ATygJ
	AAAAVgElAZaGkgAAAGAVUBJgaSgJAAAAVgElAZaGkgAAAGAVUBJgaSgJAAAAVsHWX5/6K2u2Gqgk
	+MMP/6s2/uHq32kDm4OSAAAAYBUssySQeuC393xC23/5wn9srwqu7Z/c2traOZTm4Y60Tu5f0460
	p1ZpOFYGJQEAAMAqWFpJ8OEPnpB6IC0J5N/z1/6bHlb1UxL4dvNQjIqSAAAAoBf/p5UNajZPSXDv
	vffu7u6+8847dvzxxzdv3pSIxO34OPrzgWpJ0PKzgvlLgoSfSUmwKigJAAAAeiF5/9UGQ5UEjz76
	qGT/Dz744K9+9Ss5vHHjxkMPPaR1gg5ol9YD1ZKgqSroVBJoyn/ypAu4hh8ThmunoSxYAZQEAAAA
	vVhCSfC73/3usccekxrgy1/+8qVLl7QeOHPmzK1bt2xEq+FLAtdVRJPh2k85sCIoCQAAAHqxhJJA
	/OEPf9CqQEk9cHR0ZH0dDPWLQ0nKr1E3ipJgVVESAAAA9GI5JYG4c+fOuXPnpB7Y39+fqR5Qc/15
	cZLYl0qCSspPSbD6KAkAAAB6sbSSQL300ksffPCBHcxolv8IafKjgNJBWiAcVxJkE7FslAQAAAC9
	WHJJsCCpCrTRXA9oGh+zeqPJvyo6jisJinmUBSuAkgAAAKAX0y4JsMkoCQAAAHpBSYCpoiQAAADo
	BSUBpmqIkuDo6MreCf3lsK2tE3tXjo6so5ujg22d+LOfyTJuvnX0yu9xqMW7S5+qOZ6rWgs+/8c6
	cq/QeE/dHA+n+w6Hfq6Wa+RXCgBASYCp6r0k0BRr+8CyEDncC+0ufBJTTO/XqmVI/rkq9nOwLY97
	0b0t+Px3MebTON/D6bjDEZ6r5aIkAICRURJgqvotCfR7rosk9IMmMSuVIS3+XFUNsWbVaE/j3A+n
	yw7Hea6Wi5IAAEY2XkkgywE96rkksCyrJgXxXUbzMMtX9vyvCdlvbUjEhENLaOJ0P8F3pr2hrY3t
	bf3mb7JcfhQOy4uLpr1JsF9Nz1XpISR784e6sYP4bGQba1pTdHyMpfO1TSw/dfXnXcRMDycNxosk
	H5kt1X3xUvEQHn39S1N77dnEML7L9nqRvlJR6dGVgsn7K9uZDgMAtJPMyiqACumyQc0oCbA0/ZcE
	Pp2w40ATJE0sfKahOYfPmnzCFPotr7JsKbTT6T5PicH6kdKSYJT31k/psje3Vn/S58o/KFGcWlpu
	TNikax9s+26/MR0YduuW83p4/qURUljRPDFruF6/PT+pN3M8HA262HE7nG1xiYWnxTdrVtaJ6SlE
	HJYu22V7vUjXV+k2jnnqJJZcCQCALiSzsgqgQrpsUDNKAizNOD8lKMV9spHnQ6FdH5Tp/uvxI5Og
	i8uRaZ7SeW86oC+l8xb7SU/txiTc8GwzciAxbYvSmlH3x6hnlJaObJ9Y3Z4O68tsD0eCflNuQIcd
	zra4W9B/lYZfuLpyPKlOdEcm7GSW7fWitCVR/+ia9yYtHQkA6EIyK6sAKqTLBjWjJMDS9FwShIzD
	joP6RCTJV4pEpDZYm7IcOz2ctJhfO6Xz3nRAX0rLFvtJT53vTeQbs27tEos//zrADdcst3VidXv9
	mu3hSNBvyg3osMOZFpeGLq//K4fVlbPnM/QW2wpf05HVRfpVellF6Yz66Gr3pgPccH8l6CEAoJ1k
	VlYBVEiXDWpGSYCl6bckEC6jSHIIyTb2XGbkohqMSUmWQoV2c9Cm+xxFg7aQG+n6K9PjbDew0lt0
	u8ld9ibtfvnH4k4n7Xw/6andgR/upJG4W+1Svt8ejjuc8fn3kxwZ5Y5bJ2qvbmYg/gzdH44FXazD
	Drsvbm33lwLhsLKyj7iTurY1S9febNtbXLollW6j/anzwx33uId8iQFgnUhmZRVAhXTZoGYTLgn+
	5Z9e1MbLV36sDUxL7yWB8KlG4DOfPGgJR5qvxHZt0LVd0qKTkz/NDMGt7e266eGULpOzoM1wiVAy
	stvepN274iH4c7tIfrrsyQzb9n/DagEdllro+S/24052/MR8exLpXceH44Jh8w1/v1uzwxkW12j5
	V4+C0hUV+5Jrb47tLSh9OYWc0gVrH11lb8lUuxIAAMeSzMoqgArpskHNploSSD3w2g/+Tts/+N//
	vVoVvPrqpQtf//rp4PHn/tlH3FcbkWjpimSErRXIBOubhW7s68npfODCpVeLw9L6pYgeplMmaoiS
	YFA+odncHCXNOzFRq3wNb/j7CwAWJJmVVQAV0mWDmk2yJLj6T5ekHkhLAvn3P195SQ9VNctfsCRQ
	3UeK2sE+aNn8q6/+83OPS25/IYlYb5xbjZQWma7JlQTue5f+m5h2vGEoCdbAKl/DG/7+AoAFSWZl
	FUCFdNmgZtMrCfTnA9WSoPSzgjSBVtVI1NJV0n2kqB3sg1k2n0a0qXEpF9zkSkQa1UWmaBIlQfFr
	GM5GfwuTkmCiVvka5v0FAH2RzMoqgArpskHNJlYSpPVAtSRIq4JqOp5GpKW/iqPZduzyja/vPv39
	5x53Gbef59N035mOtC7/Xf74azz6XX9d+el//Mf4m0sxpxd+hcaSICb9Lu7D1YhrVBaZosn9lAAA
	AGA1SWZlFUCFdNmgZutdEhS//e8TdokU2byIkdBwCb2MdF0+5dZhvmmz0kWy9qULrpXMEtUzCh/M
	svk0QkkAAACAWUlmZRVAhXTZoGYb+otD0tRSQf/MV7sef9wdJINdzu0afkgSD4u4CqKoOtxwH8kX
	scFRXNmO8wglAQAAAGYlmZVVABXSZYOabeKfF/vEXdN9zbe1JPA1QfI9fu1LM3KRLhvX0a5IwlIh
	+BOU9yB8MJuVRrSpcdtcJSKN6iJTREkAAADQC8msrAKokC4b1GySJYHo9h8hzdLxGIlffU6vLQvp
	FxvvEvALF3xarhGRLuvbxfiUZfPJ4MgHm0sCtyXXjnOrkdKU6aIkAAAA6IVkVlYBVEiXDWo21ZJA
	SFWgjWo9INIEWhVJts+y3a/6hIy/1KVNmSJRSbx1uiotq8P97w35Xxwqfh/J8nUZrV06XlSz+VIk
	LiKhxkhlkSmiJAAAAOiFZFZWAVRIlw1qNuGSYASad9tBT3rJ5ikJAAAAEElmZRVAhXTZoGaUBI3c
	TwDCjwt65LP57P+9eFb6Q4PN+X8v/otv/C/+dfxnTxkAANgwkllZBVAhXTaoGSVBDfv1oQWydnRB
	SdD7P3vKAADAhpHMyiqACumyQc0oCbA0lAS9//sfAABgY1iq5ElmZRVAhXTZoGaUBFiajiVB6YoH
	AADA0kqCj4FeURIAAADMh5IAa4KSAAAAYD6UBFgTlAQAAADzWcOS4MMPP/zRj3507ty5s2fPvv32
	2xbFuqMkAAAAmM+6lQS///3v9/b2TnnPP/+8RbEBKAkAAADms24lwVNPPaX1wLPPPnvnzh0NHh0d
	aQNrjJJgOH+P4dlzjRHZU4/JXn62e/TKntxWf/xf/i//JvrPXsI6K1ES3HvvvY8++ujiifuHH354
	3333ST1w+vTpjz76SIOvvfaaLK7tjz++tn9yq+zk/jXr7cPhTu9LogtKguHITeL/YUgdb8PoFxe2
	mu7lxyvYu44Xg2SWduvFpEygJNjd3ZWq4Fvf+tYHH3xgoblIUaE/IhBPP/20VAXXr19/5JFHpE6w
	EYFWBoMk7u0lge/dObQj9IiSYDjcd4c23Zxs0riw1XQvP17B3nW8GCgJJmoCJcHNmzcffPBBqQq+
	+c1vLlIVSA3wwAMPWE1w6tT+/r7+0OD8+fM2IlhWSeA7KQkGQUkwHO67Q5tuTjZpXNhqupcfr2Dv
	Ol4MlAQTNYGSQNy4cUOrgrNnz8a/AZiJ1APxDwlSUhW8+eabNiioKQnSXynSDht0MsRP7uyEpib1
	mv3HqM6KJUFlQa0HjK5QPWk6itJhFpQEw+G+O7Tp5mSTxoWtpnv58Qr2ruPFQEkwUdMoCcSlS5ek
	JBAvvfSShTqTKqK2HnjkkUdef/11G5SolAQ+EU/TdGkngyx1dwOSqGbvyQDXjCVBlER0Rkj1a05a
	nY2OKAmGw313aNPNySaNC1tN9/LjFexdx4uBkmCiJvZTgv39/Vl/d0jqgWeffdaKgFOnHnjgASkD
	3n777TfffDP+kXFJktd7mqqnYkngU/Z0fJG1p/l7HFwNeslcqwJqTxpn2ArojJJgONx3hzbdnGzS
	uLDVdC8/XsHedbwYKAkmagIlwc2bNx966CGpB86cOTPrf3eo9PtCUg/8+te/tr5maYpfPTQxy88H
	dCwJNOF3vckwDWpJUH9SoYPq+9Bo8ZLgYNue+OjE3hXrm8XRkawkU4/sWCJX9k7kkSbVuaug9r77
	xhsv795lT9TWXbsvvyEu3u1bNgKdrX5O5q/MQpe3xqAXcy+Lk1CqLpdf6QLYPliJz6jSK+g/gra2
	7r5oxxbJPpT8iMy//pu/uYsPrqDjZ1F9SeCyF/uepxOSmSKXqUYwrgmUBPpfHJqvHjh//rxVA53r
	AVFOx/U4XsqH+64nZvn5eH9J+6Ze3L5ZjPXBf/f4i3FGOjdZsuGkpjgJOurrpwQzpRq1gxdJVnpJ
	dHpXzZy0HLj7ot1E5XD3IiXB/Drehpdojitz0Iu5l8WrF/Zm6nL5pU+4a7qioM9Xdr4XtPQK6kfQ
	XXclH00NH0p8WDXp+FlUKQl8QrOzsxNTGpfGaFsams1UIxjbBEoCqQekKrh165Ydd3Z4eGjVwKlT
	skL1z4ibpGm6sQRd+Z4kf0/HF9m6bxXipa7doVf/PjmcK0R1cOWkyZJhBrqhJBhO5b7rCoJ40424
	y1Z997vflY8pOwhefPFFiduB1/E2vERzXJmDXsy9LF66sNdPj5df+oQP8crOt2blo8l/BF3cvct9
	DrkPIkqCqN/PovqfErgURpObrCmZjuU3pQhGN4GSYG537tzRnxKcPn16jopiUT5/57JeEQOVBP53
	fpT7rthRcvyfnpORwfaBjhdxBd/QeWnkxN6ezZOQTQmr+j4/MszQActVvu9aRdB2l5WW8T/ET3/L
	yM3MD/3s9SSfm1/96lfPnTv3+uuvy+GNGzeeeuopibzyyis6QHW8DS9RvCLt2EveDfabJDpse1vC
	28/dTi/7uvfIgU2XuXGl6ptC6OJpML5T8pH+TRpOq1Na1CeUu3btyqVs8eJqtcu1w8iaN8j4erz8
	0gsgfYbLT37+yta9mm6YRGSccYHiyB0m67erfwVfti9pRAdEaTy2rSEVhd+IvITx9dTV3ODSJ9l0
	Psr6/Sw6tiTIkn4frkasjRGtc0kgPvroI6lxl1APCEqCVTJESVC6C7qWBOqyfzv2QtDdA+XulkSy
	3Mg3403URvr7ph8ZZrgVl61835WboL+B2nFQvfsW91r5mv6Cb3643uKt96c//Wl6S051vA0vkV26
	gb9wi+vWJ3zFFS6tMEWaxRshstWKGWGKLdm2uAaLd4oLuoZOdy0LZGesVZdQuszOtV1Tcz5ruaBL
	/2LuWDvSrn9pSksaS9fX5WevkwqfgTVPvg7zrfyFy4b52U7sKo3RmI5pUfcKxhcoa9iIIHuxssHh
	L6NC0w1w7fqX2AWm81HW42cRJcFErXlJsEyUBKtkkJLA5x0FSUZCJlIdHGnwhL8ZppHybS8GZU3/
	NQ36eauifN91iZG7QdpxULpf2pOmN1j/rTS9v7re/HATvPjii1/4wheqP7hXHW/DS1S9Mv17waXv
	eijdPpcvX+HpGyGqDiu16xeve6foW7KQVOzHakoo03bpavcZYJ4aZiMTq5QpLn751b401Sc/fTVF
	8cLZCK/4nojyy+YTO2p7Be2lKiKp+lewLpgNqLzEU/wo6+WziJJgoigJsBEGKwmKvCTSG5zrqLuN
	+aBPhSrfS8sWj0FZzn9Ng37eqqjcdy1LsuMgv3H6xMm17LYq9H4aJ5YO196NGzesVdHxNrxE1Suz
	9O6Q7tI7wrezN0JUGVZu1y9e905pepN20ZZQVi5mHSNRf2UfP3LVLHj5pS+Tvg4uWHny81czdFeH
	hUjxoiYTu2t9BfX1KCKp+lewLpgNaHiJJ/dRtvhn0bElQdq0YqAawegoCbARBikJXNsdaFcq3Mdq
	bmMxqF/SSGXxGHS3Rwm6G6UGQ6dbcdlK913hbpHJLVDulOl/cSh+9XdQu60qCcixHVQON1bH2/AS
	pZeuSq/bJMMrhsW2fvGTTO2wtO0btYtX3ik+mK4f17DjZq0JZbyI3bWul3rMCFtGTvF67nL5tbxM
	2ZOfREovXDYsLuDGxKVcI+3VwS1aXkF3qKl6EomaX8FysDLAtdwSubX5KOv4WXR8SSBZv7Ul6PP/
	agSjoyTARhiiJHCHPvUwcndztzblbnUywALJ90HjCnq7k+bPsr+zDLe9tG2ryPEE/rxYhdutp7fL
	4sYZ+u66+279swN3J1U+o8oPbcUN1vE2vESl94VK3h11V3W8iMMbIV7PtcPK7criLij9Fqr98+Lw
	JnU9NqVFS0KZtYtLva63fqS7tCUyCV0uv/SlEe4p909y+cn3w/zfl1tAx1eGhWM31pa117anV1D5
	FySLqNpXsPFlTdv5S+x6zJp8lHX8LDq+JBBy5BWhagTjoiTARuirJEBV6b6L3nW8DaNfXNiqx8uv
	VDkMjVewdx0vhoaSAKuOkgAbgZJgONx3h9ZjTobuuLBVj5cfJcHUdbwYKAkmipIAG4GSYDjcd4fW
	Y06G7riwVY+XHyXB1HW8GCgJJoqSABuBkmA43HeH1mNOhu64sNV0Lz9ewd51vBgoCSaKkgAbgZJg
	ONx3hzbdnGzSuLDVdC8/XsHedbwYKAkmipIAG4GSYDhyk8DQ7LnGiOypx5RLAvTOntxWklnyb6L/
	7CWsQ0mANUFJAAAAMB9KAqwJSgIAAID5UBJgTVASAAAAzIeSAGuCkgAAAGA+lARYE5QEAAAA86Ek
	wJqgJAAAAJgPJQHWBCUBAADAfCgJsCYoCYbzYwAAsAx2J/bs/zxiAbZQHUoCrAlKguHIR5I9ywAA
	YCzVksD+j6bnQkmAjUBJMBxKAgAAxkdJAMyMkmA4lAQAAIyPkgCYGSXBcCgJAAAYHyUBMDNKguFQ
	EgAAMD5KAmBmlATDoSQAAGB8lATAzPoqCY6Oruyd2DIn9q4ciYNt37IRm2cJJcG1/ZNbJ/ev2dEw
	DncGPUX6EORU4uT+1TEe15jmeA71uTB+cssix6+fLeet0/MLYMNREgAz66Uk0HJg+8CyfzncO6Ak
	mLskqM3njk/yWi04PdW+1EwnOnaprZ1DO2jW40MbzRx7rk5pWaT7+jPtZI5tA8ASUBIAM1u8JNCf
	D8R6IKIkoCQ4Ti9L9fjQRjPHnqtTWhbpvv5MO5lj2wCwBJQEwMx6KAmsImgrCaRltg98V/FbRm5m
	6dDmTb6WqJQEPqPat9/YKHIr91sxaucFNyYovkOeBeUg9CQpmiziojFSLHrPC5U1kzP6YzdrZ0di
	ugFru65iZH7SQ4vnGeKxJ2rdlXHrP3616PWn0KCbbmd0gf2r5TP6qO0otl2j7hFlZ3WSrhf8QXou
	XbU4n832feHZkFhcI5lRfbqSFcv7adpfMsUUEWmZdFeuy/fc87SsWayWrZQdtGym+fUCgJVDSQDM
	rJ+SoC6Dr/6UoEj25auvDVTN4dqWBCGdcs3YCjnZ4Y5v5VmayYbFqSeFj0ruls2NY0y6ZrZUGJ2u
	nrVtGZccatgFrVkEo2TxtK0nkkDjrqIYrF1Kl9D/VbXD0rY0YjQZYI89qnZJpHSuKA6WRlg9afq2
	zkqi2XNYarima0mgejbHrxP4IclcU1rWnc8WS5ZNmiJdJGnP8HoBwMqhJABmNs5PCVzT+GTf/1RA
	WjYyP1wb9T8lKKVfLm1LuAysNvFKgjLFN13adqjtEMqXDRNEPt1O5pXPWBpZpITS4Q/SwTEYlaYn
	ZFzLrgoxmPYmbWmGdNtrGFa0k2DNYw9qu8rnsohXWby+nQbdgV8tBI9/iqJsHS+JSNNoxHWdzMo1
	iYSHlC2TLHL8ZpLBALDCKAmAmfVQEoSawI6D4mcCoWbwLSsShC8EiomlwzXQuSTIcs6GxCsNyhxp
	a24n7Z1DDbiubK7P6PIc1KItZ2wcKR3lpWrWaj+RU7+rQgymvUlbmlma3jCsaCfBhi05tV2lcxVj
	pFVZ/NizF/NDsGE/Lpw9RpGuo6qLpLvyNUGyhPbFEUGybLFOxoXbXi8AWDldSoI33rh499Zduy+/
	UW3YiICSABth8ZJA6A8BYjYvmX/6XxyKX31tUJQEQksEOwiHcbxFJ6tTSaDZW1OWlg0rRrnELvmV
	oZ2d+J3fbJgIKWBpzXxQuTcbaUlikS8m07OgxsrT40GqYVelFZp65Yz6vyodVmzIhevXKQ682Fvb
	lZ8rjnXnibPipNq2NEK0/ukq5qQqT1FsRCESeyq7yua4FeVCKQJeOkTayfhEZTMAsNIoCYCZ9VIS
	CJ/uB1oA5KWAj29v658d+BLC8z89qB5uUEmgmVzgM0aXmlm7GJYE0+Qvb8fxNlpYOluZHuRnydvp
	yGyA/2tdx1ZPZrWdyPqEzUsGxxWqDWunf16cPuhkkXgghzt167Q+9rTL/0lu5VxhRJFbp4vXtl2j
	5ekq70d6THw81ROpGGnZle8K89zaYQdBvuwxmwmB8iIAsFq6lATdURJgI/RVEqCqUhKgC0k71ynl
	zHPupVqzZxYAmlASADOjJBgOJcE8ViiF7sXKPJ5r9ts/ALD2KAmAmVESDIeSYDb2WytrlreuQkmg
	zywFAYBNQUkAzIySYDiUBAAAjI+SAJgZJcFwKAkAABgfJQEwM0qC4chHEgAAGJ/diT3J6RdkC9Wh
	JMCaoCQAAACYDyUB1gQlAQAAwHwoCbAmKAkAAADm02dJ8Nvf/n/Jw4cWTBLAQwAAAABJRU5ErkJg
	gg==
)

Here's an example flaky test that will pass 90% of the time:
```kotlin
enum class Type { Type0, Type1, Type2, Type3, Type4, Type5, Type6, Type7, Type8, Type9 }

@Test fun flaky90() {
    val fixture = JFixture()

    val type: Type = fixture()

    assertNotEquals(Type0, type)
}
```
This could mean that if you run the test a few times, and the code reviewer runs it,
and the CI runs it; it's still going to pass all those times, but then when you merge to `master`, it fails.
The above example is over-simplified, but even the most complex flaky tests we had of this type weren't that hard to debug and fix.

## Conclusion
Introducing JFixture to an existing project is a big leap, but we think it's worth the effort and the learning curve is not that bad.
There will be times when you scratch your heads, but you'll learn something new each time, until you develop a solid usage pattern.
I personally found it very useful to debug into JFixture when something is wrong.
Give it a whirl and let me know how you found it.

## References
 * [JFixture library's GitHub repository](https://github.com/FlexTradeUKLtd/jfixture)
 * [JFixture library's documentation](https://github.com/FlexTradeUKLtd/jfixture/wiki)
 * [Example code used](https://github.com/TWiStErRob/TWiStErRob/tree/master/JFixturePlayground/src/test/java/net/twisterrob/test/jfixture/examples/journey)
