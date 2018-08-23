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
``` swift
viewState.showLoadingState(loadingMessage: "Loading...")
```
- When an async task complete successfully, we hide the ViewState:
``` swift
viewState.hideViewState()
```
- When an async task complete with an error, we can show the error state:
``` swift
self.viewState.showErrorState("Oops! Something went wrong...")
```
- When there is nothing to display after geting from async task, we can display the `NoData` state:
``` swift
self.viewState.showNoDataState("There is nothing to display")
```

## Advance
- Display `NoData` state with an image, and an action button:
``` swift
self.viewState.showNoDataState("There is nothing to display", noDataImage: UIImage(named: "no_data",
actionButtonTitle: "CREATE ONE", actionHandler: {
    // The code to open the view to create one
}
```
- Dispay `error state` with an image and a `retry` button:
``` swift
self.viewState.showErrorState("Oops! Something went wrong...", errorImage: UIImage(named: "error", 
actionButtonTitle: "RETRY", actionHandler: {
    self.loadData()
})
```

## Customization
You can set the custom theme for the ViewState once for all views in the app. You can put it in `AppDelegate` or somewhere you want.
``` swift
let theme = ViewStateTheming()
theme.messageTextColor = .red
theme.actionButtonBackgroundColor = .green
theme.actionButtonTitleColor = .white
....
ViewState.useCustomeTheme(theme)
```



