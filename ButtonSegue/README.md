# Button Segue

Example of unit testing a segue which is initiated by a button on one view
controller (called the PresentingViewController) to a second view controller
(called the PresentedViewController) - as illustrated in the following figure:


![Button Storyboard Segue](./images/ButtonStoryboardSegue.png "Simple Storyboard
Segue using a button to initiate the segue")

For this type of segue, the following aspects should be tested:
- There is an outlet hooked up for the button. This tests we have a button.
- The button is connected to an action. This tests the button is connected to the segue.
- The segue has an identifier. The specific text of the identifier is not important, however,
it must exist if it is going to be used on the `prepare(for segue: UIStoryboardSegue, sender: Any?)`
method of the `PresentingViewController`.
- Tapping the button causes the `PresentingViewController` to presents the
`PresentedViewController`. This tests the segue is connected to the
`PresentedViewController` (and not some other object).
- When the button is tapped, some model data is passed from the
`PresentingViewController` to the `PresentedViewController`. This tests the
method  `prepare(for segue: UIStoryboardSegue, sender: Any?)` is performing
the required functionaility.

Testing is performed in the file `PresentingViewControllerTests.swift` file, which is
part of the `ButtonSegueTests` target.

## Test Setup and Teardown
The `setUp()` method is used to initialise the test harness with an instance of the
`PresentedViewController`, which is called sut (for System Under Test). Once this is
obtained, `loadViewIfNeeeded()` is called to load the view:

```swift
override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    sut = storyboard.instantiateViewController(withIdentifier: "PresentingViewController") as? PresentingViewController
    sut.loadViewIfNeeded()
}
```

The `tearDown()` method is used to set the `sut` to `nil`, to clean up the test harness
between tests.
```swift
override func tearDown() {
    sut = nil
    super.tearDown()
}
```

## Test Cases

The following describes the test cases included in the file
`PresentingViewControllerTests.swift`. Not all these tests are required they go
beyond the aspects listed above. This is only to illustrate what can be tested - not what
should or needs to be tested.

### Test Button Exists
The first test verifies there is a button, and it is instantiated from the storyboard:
```swift
func test_viewController_hasButtonToTap() {
    XCTAssertNotNil(sut.buttonToTap, "The view controller shall have a button to tap.")
}
```
This requires three things to be done:
1. An `@IBOutlet` for the `UIButton` is added to `PresentingViewController.swift` - here it is called `buttonToTap`.
2. A `UIButton` is added to the view controller in the storyboard.
3. These two are connected.

### Test Button has a Target
The second test verifies the button has a target object for an action:
```swift
func test_buttonToTap_hasATarget() {
    XCTAssertNotNil(sut.buttonToTap.allTargets.first, "The button to tap shall have at least one target.")
}
```
The test only verifies there is at least one target. This requires two things to be done:
1. Add a second view controller - here it is called `PresentedViewController`.
2. Add a segue from the button to this new view contoller in the storyboard.

__Note:__
1. This does not require the segue to have an identifier, only that the segue exists.
2. The target here is the segue itself, and this associates an event for the button with an
action method on the segue.


Also, a `UINavigationController` has been added to enable navigation back to the first (`PresentingViewController`).

### Test Segue has an Identifier
The next test verifies the segue has an identifier:
```swift
func test_buttonSegue_hasAnIdentifier() {
    let segue = sut.buttonToTap.allTargets.first?.base
    XCTAssertNotEqual((segue as AnyObject).identifier, "", "The segue from the button shall have an identifier.")
}
```
It is possible to access the segue from the button target as the `base` property of
`AnyHashable` provides access to the original object. However, we cannot check the type
of this object since it is most likely a private type - adding the line:
```swift
print(">> segue: \(String(describing: segue))")
```
results in output like:
```
>> segue: Optional(<UIStoryboardShowSegueTemplate: 0x600001c74040>)
```
Where `UIStoryboardShowSegueTemplate` is unknown to the compiler, so it's type
cannot be checked with a test of the form:
```swift
XCTAssertTrue(segue is UIStoryboardShowSegueTemplate)
```

### Test Button Control Event(s)
The next test verifies the button only responds to touch up inside events:
```swift
func test_buttonToTap_onlyRespondsToTouchUpInsideEvent() {
    XCTAssertEqual(sut.buttonToTap.allControlEvents, .touchUpInside, "The button to tap shall only respond to touch up inside events.")
}
```
The property `allControlEvents` is a bitmask which can be used to determine which
types of events the button will respond to. While not necessary in this case, it does show
what can be tested - if it is important enough to be tested.

### Test Only One Action
The next test verifies there is only one action for the touch up inside event:
```swift
func test_buttonToTap_hasOnlyOneActionForTouchUpInsideEvent() {
    guard let actions = sut.buttonToTap.actions(forTarget: sut.buttonToTap.allTargets.first, forControlEvent: .touchUpInside) else {
        XCTFail("There should be a target action for the touch up inside event.")
        return
    }
    XCTAssertEqual(actions.count, 1, "There shall only be one target action for the touch up inside event.")
}
```
Again while not necessary in this case, if it is important to ensure there is only one action
for a particular control event this can be tested.

### Test Action is `perform:` Method
The next test is verifies the action for the touch up inside event is the `perform:` method
of the segue:
```swift
func test_actionForTouchUpInside_isSeguePeform() {
    guard let actions = sut.buttonToTap.actions(forTarget: sut.buttonToTap.allTargets.first, forControlEvent: .touchUpInside) else {
        XCTFail("There should be a target action for the touch up inside event.")
        return
    }
    XCTAssertTrue(actions.contains("perform:"), "The target action for the touch up inside event shall be the segue's 'perform:' method.")
}
```
This test is not necessary at all - since it is testing Apple framework functionality. However,
it is included here to illustrate what is possible and why it is not a good idea to test this.
It is not recommened such a test be used, since changes in the framework could result in
this test failing in the future. It is important testing is only done on things that we have
control over - and not external dependencies.

This is considered a fragile test as it is suseptible to failure if there is a change in the way
a segue is implemented, and that is outside the scope of the application being developed.

### Test Tapping Button Presents New View Controller
This test simulates tapping the button to perform the segue and verify the expected view
controller is presented. It uses a `ViewControllerPresentSpy` to gain access to the
presented view controller.  This requires the following to be done:
- Adding the `ViewControllerPresentSpy` to the project - along with the extensions it
depends on.
- Creating an instance of `ViewControllerPresentSpy` to use in the test.
- Create a window, set the root view controller of this window to the sut (our
`PresentingViewController`) and make the window visible. This is necessary to have
this view controller present the other view controller.
- Simulate tapping the button by sending and action for the event `.touchUpInside`.
- The RunLoop needs to be exercised in `tearDown()` to clean up memory. 

With this all done, the view controller spy can be used to verify if the presented view
controller is the expected type of `PresentedViewController`.

```swift
func test_tappingButtonToTap_presentsThePresentedViewController() {
    let sutPresentSpy = ViewControllerPresentSpy()
    let window = UIWindow()
    window.rootViewController = sut
    window.isHidden = false
    sut.buttonToTap.sendActions(for: .touchUpInside)
    XCTAssertTrue(sutPresentSpy.presented is PresentedViewController, "Tapping the button to tap shall present the PresentedViewController.")
}
```
The `tearDown()` method is now:
```swift
override func tearDown() {
    RunLoop.current.run(until: Date())
    sut = nil
    super.tearDown()
}
```
The `ViewControllerPresentSpy` uses method swizzling to capture parameters passed
to the `PresentingViewController`'s `present(_:animated:completion:)` method.
The first of these is the presented view controller - which enables the test above.

__Note:__ The two view controllers implement `init()` and `deinit` which both print
a message to the console to show if and when they are called. To see memory related
issues, remove the call to `RunLoop.current.run(until: Date())` from the
`tearDown()` method. This will show that `deinit` for the `PresentingViewController`
is not called untill after the test suite has finished - rather than after the test case has
completed. This implies there is a view controller hanging around in memory until after
the tests have all been run, which is not ideal as it is preferred to have a clean test
environment for each test case.

### Test Presenting View Controller is SUT
This test verifies the presenting view controller is the System Under Test (SUT):
```swift
func test_tappingButtonToTap_hasPresentingViewControllerAsSut() {
    let sutPresentSpy = ViewControllerPresentSpy()
    showViewControllerAndTapButton()
    XCTAssertTrue(sutPresentSpy.presenting === sut, "When tapping the button to tap, the presenting view controller shall be the SUT.")
}
```
The `===` operator is used to verify `sutPresentSpy.presenting` points to the same
address as the `sut`.

__Note:__ The tests have been refactored to use helper methods in an extension to
show the view controller and tap the button using the method
`showViewControllerAndTapButton()`.

### Test `present(_:animated:completion:)` Only Called Once
The test verifies the swizzled method is only called once, meaning the presented view
controller is only presented once:
```swift
func test_tappingButtonToTap_onlyPresentsPresentedViewControllerOnce() {
    showViewControllerAndTapButton()
    XCTAssertEqual(sutPresentSpy.presentedCount, 1, "When tapping the button to tap, the PresentedViewController shall only be presented once.")
}
```
__Note:__ The tests have been refactored again to provide a class property for the
`sutPresentSpy` move the instantiation of the test spy to the `setUp()` method, and
set it to `nil` in the `tearDown()` method. These methods are now:
```swift
override func setUp() {
    super.setUp()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    sut = storyboard.instantiateViewController(withIdentifier: "PresentingViewController") as? PresentingViewController
    sut.loadViewIfNeeded()
    sutPresentSpy = ViewControllerPresentSpy()
}

override func tearDown() {
    RunLoop.current.run(until: Date())
    sutPresentSpy = nil
    sut = nil
    super.tearDown()
}
```
