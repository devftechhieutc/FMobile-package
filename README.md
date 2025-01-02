# FMobile

## Features

* login username/ password
* Login bio metrics
* Login social ( FB, GG, Zalo , Tele, Apple, F-id)
* Forgot pass
* Register (username/pass/re-pass, ref code (on-off))
* Remember
* Show/hidden password
* Validate input (password/re-password)
* Policy màn register (on off)

## Development Requirements

* iOS 13.0+
* Swift: 5
* Xcode Version: 16.2

## Install FMobile SDK

Simply copy the github link of this project into the Swift Package Manager and install it. Don't forget to add the library

### Installation with Swift Package Manager

Once you have your Swift package set up, adding FMobile as a dependency is as easy as adding it to the dependencies value of your <code>Package.swift</code>.
```
dependencies: [
    .package(url: "https://github.com/devftechhieutc/FMobile-package", .upToNextMajor(from: "1.0.0"))
]
```

- Write Import statement on your source file
```swift
import FMobile-package
```
### Add google services

Download and add files GoogleService-Info.plist to project.

## Usage

### Initialize FmobileSDK in file Application
* Param license will be provided depend on each application

* Param enviroment represents which enviroment application is running: DEV, STAGING, PRODUCTION

* Last params is enableDebugMode (true/false)

```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FMobileConfig.setEnviroment(.dev)
        FMobileConfig.setSDKLicense("c20ad4d76fe97759aa27a0c99bff6710")
        FMobileAppdelegate.didFinishLaunching(application, with: launchOptions)
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
       
        FMobileAppdelegate.attrachConfigDarkMode()
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FMobileAppdelegate.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return FMobileAppdelegate.application(app, open: url, options: options)
    }

```
### Register to sdk

```swift
 override func viewDidLoad() {
        super.viewDidLoad()
        FMobile.instace().authManager.add(self)
    }
```

### Open Login With SDK 

```swift
   FMobile.instace().authManager.loginWithSDKForm(context: self)
```


### Receive data to FMobile 

```swift

   class LoginCommand: FMobileLoginCommand {
    func execute(with account: String, password: String) -> AnyPublisher<String, NSError> {
        return Future<String, NSError> { promise in
            // handle login with module
            promise(.success(""))
        }
        .eraseToAnyPublisher()
    }
    
}


/// Example login with apple
extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}

extension ViewController: AuthManagerDelegate {
    func didSignInSuccess(with token: String) {
        print("didSignInSuccess: \(token)")
    }
    
    func didSignInFailure(_ error: FMobileError) {
        print("didSignInFailure: \(error)")
    }
    
    func didSignOut() {
        
    }
}
```
  
