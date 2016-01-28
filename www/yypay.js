/**
* 调用OC的JS层代码，在插件的JS代码中可以实现自己的逻辑代码，对外只提供借口方法
*/
var exec = require("cordova/exec");

//类构造方法，用于创建类的对象。
var yypay = function () {
    this.name = "yypay";
};
//在类的prototype(原型)中定义一个函数。
yypay.prototype.pay = function (paymentInfo,paymentInfo2, onSuccess, onError) {
    //使用Cordova创建调用原生代码，最终会将下面参数拼接成URL，然后在原生中截获,
    //后面的param1---3参数是可选，必须是以数组方式传入。
    exec(onSuccess, onError, "YYPay", "pay", [paymentInfo]);
};

//Cordova框架加载时初始化该类的对象。
module.exports = new Yypay();

if(!window.plugins) window.plugins = {};

if (!window.plugins.yypay) window.plugins.yypay = cordova.require("cordova/plugins/yypay");
