# SwiftyGA
Integrate Google Analytics in your app without Pod or Google SDK! 😃
<br />

# Getting Started
1. Just add 'SwiftyGA.swift' in your project.
<br />

## Usage
1.in AppDelegate copy and paste following code:<br />
```swift
import SwiftyGA
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SwiftyGA.shared.configure(trackingID: "REPLACE-YOUR-TRACKING-ID")
        return true
    }
```

2.screen visits(hits):<br />
```swift
override func viewWillAppear(_ animated: Bool) {
        SwiftyGA.shared.screenView(Utility.screenName(obj: self))
    }
```

3.action and events in your ViewController:

```swift
@IBAction func tapMeAction(_ sender: Any) {
        SwiftyGA.shared.event(category: Track.Category.click, action: Track.Action.tap, label: Utility.screenName(obj: self), value: nil)
    }
```

## Questions<br/>
If you have any questions about the project, please contact via email: arashzjahangiri@gmail.com

Pull requests are welcome!

Licence

MIT.
