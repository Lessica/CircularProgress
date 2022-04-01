# CircularProgress

A simple circular progress view for iOS.

## Usage

```swift
let stackView = CircularProgressStackView()
stackView.spacing = 6  // <- set to nil to allow custom layouts

let redProgressView = CircularProgressView(
    fillColor: CircularColor.taleRed,  // <- example colors, not available in package
    backgroundColor: CircularColor.taleSecondaryRed
)
redProgressView.progressItem.progress = 0.75  // <- initial progress, change it later in main thread to trigger animations

let greenProgressView = CircularProgressView(
    fillColor: CircularColor.taleGreen,
    backgroundColor: CircularColor.taleSecondaryGreen
)
greenProgressView.progressItem.progress = 0.7

let blueProgressView = CircularProgressView(
    fillColor: CircularColor.taleBlue,
    backgroundColor: CircularColor.taleSecondaryBlue
)
blueProgressView.progressItem.progress = 0.65

stackView.addSubview(redProgressView)
stackView.addSubview(greenProgressView)
stackView.addSubview(blueProgressView)

self.view.addSubview(stackView)
```

# Replay

https://user-images.githubusercontent.com/5410705/161236466-549eecd2-90b5-416c-bd63-213341fb993b.mp4

