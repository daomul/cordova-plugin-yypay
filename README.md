## Dynamic Update Plugin for Apache Cordova

Cordova Plugin to automatically update your Cordova iOS app, given an externally hosted zip of the www update.

## Install

#### Latest published version on npm (with Cordova CLI >= 5.0.0)

```
cordova plugin add cordova-plugin-dynamic-update-ios
```

#### Latest version from GitHub

```
cordova plugin add https://github.com/daomul/cordova-plugin-dynamic-update-ios.git
```

## Usage

Add the libz library to your target(because of the zipArchive)

You **do not** need to reference any JavaScript, the Cordova plugin architecture will add a dynamicupdate object to your root automatically when you build.

Ensure you use the plugin after your deviceready event has been fired.

### Download

Downloads the zip file of your update.

```js
dynamicupdate.download(
     function (result) {
       alert(result);
     },
     function (error) {
        alert("Scanning failed: " + error);
     },
     "http://files.cnblogs.com/files/daomul/update.zip"
);
```

## Platforms

iOS only. Android maybe u can call : https://github.com/leecrossley/cordova-plugin-dynamic-update.

## License

[MIT License](http://www.jianshu.com/users/1967b163cb61/latest_articles)
