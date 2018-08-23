# ViewStates
ViewStates makes it easier to create a view with loading, success, no data and error states. The UI can be custom easily.

## Preview

![](images/custom_theme.gif)

## Getting started

You just need to copy 2 files `ViewState.swift` and `UIImage+Gif.swift` to your project. For the `UIImage+Gif.swift`, I took it from this repo: https://github.com/swiftgif/SwiftGif . The purpose of this library is to animate a GIF image for the loading state. I would like to give a thank to the authors.

## How to use

- Init the ViewState, and set the view you want to display the ViewState as the `parentView` of the ViewState

``` swift
class ViewController: UIViewController {
    let viewState = ViewState()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewState.parentView = self.view
    }
}
```
- Display the loading state:
```
viewState.showLoadingState(loadingMessage: "Loading...")
```
- When an async task complete successfully, we hide the ViewState:
```
viewState.hideViewState()
```
- When an async task complete with an error, we can show the error state:
```
self.viewState.showErrorState("Oops! Something went wrong...")
```
- When there are nothing to display after geting from async task, we can display the `NoData` state:
```
self.viewState.showNoDataState("There is nothing to display")
```

## Customization
You can set the custom theme for the ViewState once for all views in the app. You can put it in `AppDelegate` or somewhere you want.
```
let theme = ViewStateTheming()
theme.messageTextColor = .red
theme.actionButtonBackgroundColor = .green
theme.actionButtonTitleColor = .white
....
ViewState.useCustomeTheme(theme)
```



