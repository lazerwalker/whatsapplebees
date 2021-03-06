# WhatsApplebee's

WhatsApplebee's is a real-time chat application that only works if you are currently inside an Applebee's restaurant.

The code included here is the full application as it exists on the [app store](https://itunes.apple.com/us/app/whatsapplebees/id867011102). The only thing missing is the app icon, which has been left out as it contains the official Applebee's logo.

If you're looking for the source code to the site http://whatsapplebees.com, check out the [gh-pages branch](https://github.com/lazerwalker/whatsapplebees/tree/gh-pages).

## Setup

1. Clone this repo.

2. Create a new Parse application at https://parse.com.

3. Add your parse keys to the app using [cocoapods-keys](https://github.com/orta/cocoapods-keys)

   ```sh
   $ gem install cocoapods-keys
   $ pod key set "parseAppID" "YOUR-APPID-HERE"
   $ pod key set "parseClientKey" "YOUR-KEY-HERE"
   ```

4. Open `WhatsApplebees.xcworkspace` in Xcode. Build and run at your leisure!

## Disclaimer

This application was built in about a day, and is more of an art piece than a "serious" application. I may have open-sourced this codebase, but I wouldn't necessarily point to it as a shining example of Objective-C best practices.

## Contact

Em Lazer-Walker

- https://github.com/lazerwalker
- [@lazerwalker](http://twitter.com/lazerwalker)
- http://lazerwalker.com

## License

This project is licensed under the MIT license. See the included LICENSE file for more details.

This repository and the WhatsApplebee's application are independently owned and operated by Mike Lazer-Walker. Applebee’s International, Inc. and its affiliates are not responsible for the content in this repo or on the WhatsApplebee's application.
