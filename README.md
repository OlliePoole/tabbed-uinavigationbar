### Tabbed-UINavigationBar
A UINavigationBar subclass with scrolling tabs. Similar to the Medium iOS application.

## Demo
![](http://i.imgur.com/w29bc2r.png)

## Requirements
None

## Adding to your project
1. Download the [latest code version](https://github.com/olliepoole/tabbed-uinavigationbar/archive/master.zip) or add the repository as a git submodule to your git-tracked project.
2. Open your project in Xcode, then drag and drop `TabbedNavigationBar.swift` onto your project (use the "Product Navigator view"). Make sure to select Copy items when asked if you extracted the code archive outside of your project.

## Usage
**Creation:**  
```swift
let options = ["Suggested", "Most Recent", "Most Popular", "All"]
let tabbedNavBar = TabbedNavigationBar(withTabs: options, navFrame: CGRectMake(0, 0, view.frame.width, 62.0))
```

**Responding to Events:**  
The navigation bar has a delegate (`tabbedDelegate: TabbedNavigationBarDelegate`), this sends events when the user selects an option on the navigation bar.
```swift
  func tabbedNavigationBar(navigationBar: TabbedNavigationBar, didSelectOption option: String, atIndex index: Int) {
  }
```

**Adding to your ViewController**  
First hide the default navigation bar if you're using a `UINavigationController`
```swift
  navigationController?.setNavigationBarHidden(true, animated: false)
```
Next, simply add the tabbed navigation bar in place of the hidden one.
```swift
  view.addSubview(tabbedNavBar)
```
