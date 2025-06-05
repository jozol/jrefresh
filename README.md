# JRefresh

A SwiftUI package providing a highly customizable pull-to-refresh experience for your scrollable views.

---

## 🚀 Features

- **Intuitive "Lift-to-Refresh":**  
  JRefresh only triggers when the user lifts their finger—unlike standard implementations that refresh immediately after passing the threshold.
- **Fully Customizable States:**  
  Easily provide your own views for:
    - Pulling
    - Refreshing
    - Success
    - Error
- **Modern SwiftUI-first API**
- **Supports both vertical and horizontal scroll directions**
- **Lightweight & Easy Integration**

---

## 📦 Installation

### Swift Package Manager

Add the following dependency to your **Package.swift**:

```swift
.package(url: "https://github.com/jozol/JRefresh.git", from: "1.0.0")
```

Or in Xcode:

>**File > Add Packages...** 

and enter the repository URL above.

## 🛠 Usage
### Basic Example
```swift
import JRefresh
import SwiftUI

struct ContentView: View {
    @State private var refreshState: JRefreshState? = nil

    var body: some View {
        JRefreshView(
            refreshState: $refreshState,
            pullThreshold: 48,
            indicatorSpaceHeight: 32) {
                // Refresh
            } indicatorView: { offset, state in
                // Customize view for indicator
            } content: {
                // Your scroll content
            }
    }
}
```

### Customizing Indicator Views
#### You can fully customize the indicator for different states and offset in `indicatorView` closure:
```swift
    indicatorView: { offset, state in
        switch state {
        case .error:
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.red)
        case .success:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
        case .refreshing:
            RotatingIndicator() // control rotation degree via `offset`
        case .none:
            Image(systemName: "arrow.2.circlepath")
                .rotationEffect(.degrees(offset))
        }
    }
```

## 🎯 Why JRefresh?

- User-Expected Behavior:
    - Refreshes only after the user lifts their finger—just like Apple’s stock apps.
- State Customization:
    - Show different UI for pulling, refreshing, success, or error with zero hassle.
- SwiftUI Native:
    - Built for iOS 16+ using modern SwiftUI practices.
- Plug & Play:
    - Drop-in replacement for default ScrollView—no hacks or UIKit required.

## 📱 Requirements

iOS 16+

Swift 5.7+

## 🔖 License

MIT

## 🙏 Contributing

PRs, issues, and feedback are welcome!