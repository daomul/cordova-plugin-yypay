## Dynamic Update Plugin for Apache Cordova

Cordova Plugin to automatically update your Cordova iOS app, given an externally hosted zip of the www update.

## Install

#### Latest published version on npm (with Cordova CLI >= 5.0.0)

```
cordova plugin add cordova-plugin-yypay
```

#### Latest version from GitHub

```
cordova plugin add https://github.com/daomul/cordova-plugin-yypay.git
```

## Usage

Add the libz library to your target(because of the zipArchive)

You **do not** need to reference any JavaScript, the Cordova plugin architecture will add a dynamicupdate object to your root automatically when you build.

Ensure you use the plugin after your deviceready event has been fired.

### Download

Downloads the zip file of your update.

```js

```

## Platforms

iOS  Android

## License

[MIT License](http://www.jianshu.com/users/1967b163cb61/latest_articles)
