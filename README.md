# Setup

1. make sure you have Carthage installed
2. run `carthage update && carthage build --platform MacOS`
3. Back in Xcode link the new HotKey binary to our app:
> Click the `Converter` with the blue page icon, select the app Target and click the `+` icon under `Frameworks, Libraries, and Embedded Content`. Click `Add Files...` and navigate to the root directory of this project, then go to `Carthage` > `Build` > `Mac` > highlight `HotKey.framework` and click Open.
4. `Commamd + R`
