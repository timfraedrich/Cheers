# Cheers

Cheers is a highly customisable toast library for iOS written in Swift. It offers an alternate presentation style to the UIAlertViewController, by being displayed over the entire window and permitting interaction with other views while being presented.

## Installation

Cheers was written in Swift 5.3 and requires iOS 12.0 or higher.

### CocoaPods

To integrate Cheers into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'CheersLib'
end
```

Then, run the following command:

```
$ pod install
```

### Swift Package Manager

To integrate Cheers into your Xcode project using Swift Package Manager, add it to the dependencies value of your Package.swift:

```
dependencies: [
    .package(url: "https://github.com/timfraedrich/Cheers.git", .upToNextMajor(from: "0.1.0"))
]
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate Cheers into your project manually.

## Usage

Displaying a toast in Cheers is quite easy, all you need to do is create it and hand it to the `Cheers` class, the rest is managed for you:

```swift
let toast = TextToast(text: "Hello World!")
Cheers.show(toast)
```

There is only one type of toast shipped with this Library and that is `TextToast`, although that is probably the most common use case, it is easy to build completely custom toasts from the `BaseToast` class:

```swift
let toast = BaseToast(customise: { baseToast, containerView in
    
    let button = UIButton()
    
    button.setTitle("Click me!", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .blue
    button.layer.cornerRadius = 8
    
    containerView.addSubview(button)
    
    button.snp.makeConstraints { make in
        make.edges.equalToSuperview()
        make.height.equalTo(50)
    }
    
    baseToast.duration = 5

}, isDismissable: true)

Cheers.show(toast)
```

You can even wrap a custom toast in a class to make it reusable and let it perform special functions.

```swift
public class CustomToast: BaseToast {
    
    private let label: UILabel
    
    public init() {
        
        let label = UILabel()
        
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.text = "Feel the colors!"
        label.numberOfLines = 0
        
        self.label = label
        
        super.init(customise: { (banner, contentView) in
            
            contentView.addSubview(label)
            
            label.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
        }, isDismissable: true)
        
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    public func doSomeMagic() {
        UIView.animate(withDuration: 2) {
            self.label.textColor = .blue
        }
    }
}

// in another class

let toast = CustomToast()
Cheers.show(toast)

toast.doSomeMagic()
```

## License

Cheers is released under the MIT license. See LICENSE for details.
