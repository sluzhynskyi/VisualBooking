## Visuap Booking app
![merge_from_ofoct](https://user-images.githubusercontent.com/44615981/102927711-261fb380-44a0-11eb-9399-b688f389f7fe.png)

This app help user make a reservation of the table with nice looking UI, in interactive way

## Architecture
Build in MVC Architecture

## Libraries
- [Macaw](https://github.com/exyte/Macaw), but with some modification, so in Podfile used my [fork](https://github.com/sluzhynskyi/Macaw/tree/NodeImprove)
- [MultiSlider](https://github.com/yonat/MultiSlider), my [branch](https://github.com/sluzhynskyi/MultiSlider/tree/DateSlider) also used in Podfile
- Firebase/Analytics
- Firebase/Firestore
- Firebase/Auth
- [FlagPhoneNumber](https://github.com/chronotruck/FlagPhoneNumber)
- [PinCodeTextField](https://github.com/tkach/PinCodeTextField)

## How to run
- Install cocoapods if you MAC didn't `brew install cocoapods`
- Install pods, that required `pod install`
- Open workspace `open VisualBooking.xcworkspace`
- Change Google-Service.info file for Firebase
- Cmd + R to run
