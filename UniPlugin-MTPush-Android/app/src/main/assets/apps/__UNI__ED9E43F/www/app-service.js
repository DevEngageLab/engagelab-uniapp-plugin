(this["webpackJsonp"]=this["webpackJsonp"]||[]).push([["app-service"],{"0de9":function(t,e,n){"use strict";function r(t){var e=Object.prototype.toString.call(t);return e.substring(8,e.length-1)}function i(){return"string"===typeof __channelId__&&__channelId__}function o(t,e){switch(r(e)){case"Function":return"function() { [native code] }";default:return e}}function a(t){for(var e=arguments.length,n=new Array(e>1?e-1:0),r=1;r<e;r++)n[r-1]=arguments[r];console[t].apply(console,n)}function u(){for(var t=arguments.length,e=new Array(t),n=0;n<t;n++)e[n]=arguments[n];var a=e.shift();if(i())return e.push(e.pop().replace("at ","uni-app:///")),console[a].apply(console,e);var u=e.map((function(t){var e=Object.prototype.toString.call(t).toLowerCase();if("[object object]"===e||"[object array]"===e)try{t="---BEGIN:JSON---"+JSON.stringify(t,o)+"---END:JSON---"}catch(i){t=e}else if(null===t)t="---NULL---";else if(void 0===t)t="---UNDEFINED---";else{var n=r(t).toUpperCase();t="NUMBER"===n||"BOOLEAN"===n?"---BEGIN:"+n+"---"+t+"---END:"+n+"---":String(t)}return t})),s="";if(u.length>1){var l=u.pop();s=u.join("---COMMA---"),0===l.indexOf(" at ")?s+=l:s+="---COMMA---"+l}else s=u[0];console[a](s)}n.r(e),n.d(e,"log",(function(){return a})),n.d(e,"default",(function(){return u}))},"29ad":function(t,e){uni.invokePushCallback({type:"enabled",offline:!0}),Promise.resolve().then((function(){(function(){"undefined"!==typeof plus&&plus.push&&plus.globalEvent.addEventListener("newPath",(function(t){var e=t.path;if(e){var n=getCurrentPages(),r=n[n.length-1];r&&r.$page&&r.$page.fullPath===e||uni.navigateTo({url:e,fail:function(t){t.errMsg.indexOf("tabbar")>-1?uni.switchTab({url:e,fail:function(t){console.error(t.errMsg)}}):console.error(t.errMsg)}})}}))})(),plus.push.setAutoNotification&&plus.push.setAutoNotification(!1)}))},"4ea4":function(t,e){t.exports=function(t){return t&&t.__esModule?t:{default:t}},t.exports.__esModule=!0,t.exports["default"]=t.exports},"604a":function(t,e,n){"use strict";var r=n("4ea4"),i=r(n("9523"));n("d768"),n("29ad");var o=r(n("8bbf")),a=r(n("9fb6"));function u(t,e){var n=Object.keys(t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(t);e&&(r=r.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),n.push.apply(n,r)}return n}o.default.config.productionTip=!1,a.default.mpType="app";var s=new o.default(function(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{};e%2?u(Object(n),!0).forEach((function(e){(0,i.default)(t,e,n[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(n)):u(Object(n)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(n,e))}))}return t}({},a.default));s.$mount()},6160:function(t,e,n){"use strict";n.r(e);var r=n("78da"),i=n.n(r);for(var o in r)["default"].indexOf(o)<0&&function(t){n.d(e,t,(function(){return r[t]}))}(o);e["default"]=i.a},7037:function(t,e){function n(e){return t.exports=n="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t},t.exports.__esModule=!0,t.exports["default"]=t.exports,n(e)}t.exports=n,t.exports.__esModule=!0,t.exports["default"]=t.exports},"724d":function(t,e,n){"use strict";(function(t){Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0;var n=uni.requireNativePlugin("EL-MTPush"),r={onLaunch:function(){t("log","App Launch"," at App.vue:6"),"ios"==uni.getSystemInfoSync().platform&&n.requestNotificationAuthorization((function(t){var e=t.status;e<2&&uni.showToast({icon:"none",title:"\u60a8\u8fd8\u6ca1\u6709\u6253\u5f00\u901a\u77e5\u6743\u9650",duration:3e3})})),n.setLoggerEnable(!0),n.initPushService(),n.addConnectEventListener((function(t){var e=t.connectEnable;uni.$emit("connectStatusChange",e)})),n.addNotificationListener((function(t){t.notificationEventType,t.messageID,t.title,t.content,t.extras;uni.showToast({icon:"none",title:JSON.stringify(t),duration:3e3})})),n.addCustomMessageListener((function(t){t.type,t.messageType,t.content;uni.showToast({icon:"none",title:JSON.stringify(t),duration:3e3})})),n.addTagAliasListener((function(t){uni.showToast({icon:"none",title:JSON.stringify(t),duration:3e3})})),"ios"==uni.getSystemInfoSync().platform&&n.addLocalNotificationListener((function(t){t.messageID,t.title,t.content,t.extras;uni.showToast({icon:"none",title:JSON.stringify(t),duration:3e3})}))},onShow:function(){t("log","App Show"," at App.vue:80")},onHide:function(){t("log","App Hide"," at App.vue:83")}};e.default=r}).call(this,n("0de9")["default"])},"78da":function(t,e,n){"use strict";(function(t){Object.defineProperty(e,"__esModule",{value:!0}),e.default=void 0;var n=uni.requireNativePlugin("EL-MTPush"),r=1,i={data:function(){return{connectStatus:"\u672a\u8fde\u63a5",registrationID:"\u672a\u83b7\u5f97",inputTags:"",inputAlias:""}},onLoad:function(){var e=this;t("log","\u5f00\u59cb\u76d1\u542c\u8fde\u63a5\u72b6\u6001"," at pages/index/index.vue:65"),uni.$on("connectStatusChange",(function(n){var r="";1==n?(r="\u5df2\u8fde\u63a5",e.getRegistrationID()):r="\u672a\u8fde\u63a5",t("log","\u76d1\u542c\u5230\u4e86\u8fde\u63a5\u72b6\u6001\u53d8\u5316 --- ",r," at pages/index/index.vue:74"),e.connectStatus=r}))},onUnload:function(){uni.$off("connectStatusChange")},methods:{initPush:function(){n.initPushService()},openSettingsForNotification:function(){var t=this;n.openSettingsForNotification((function(e){t.showToast(e)}))},setLoggerEnable:function(){n.setLoggerEnable(!0)},setLoggerUnEnable:function(){n.setLoggerEnable(!1)},getRegistrationID:function(){var e=this;n.getRegistrationID((function(n){var r=n.registerID;t("log",r," at pages/index/index.vue:109"),e.registrationID=r}))},addTags:function(){var t=this.inputTags.split(",");n.addTags({tags:t,sequence:r++})},updateTags:function(){var t=this.inputTags.split(",");n.updateTags({tags:t,sequence:r++})},deleteTag:function(){var t=this.inputTags.split(",");n.deleteTags({tags:t,sequence:r++})},deleteTags:function(){n.cleanTags({sequence:r++})},queryTag:function(){var t=this.inputTags;n.queryTag({tag:t,sequence:r++})},queryTags:function(){n.getAllTags({sequence:r++})},setAlias:function(){var t=this.inputAlias;n.setAlias({alias:t,sequence:r++})},deleteAlias:function(){n.deleteAlias({sequence:r++})},queryAlias:function(){n.queryAlias({sequence:r++})},showToast:function(t){uni.showToast({icon:"none",title:JSON.stringify(t),duration:3e3})}}};e.default=i}).call(this,n("0de9")["default"])},"8bbf":function(t,e){t.exports=Vue},"8f63":function(t,e,n){"use strict";n.r(e);var r=n("e233"),i=n("6160");for(var o in i)["default"].indexOf(o)<0&&function(t){n.d(e,t,(function(){return i[t]}))}(o);var a=n("f0c5"),u=Object(a["a"])(i["default"],r["b"],r["c"],!1,null,null,null,!1,r["a"],void 0);e["default"]=u.exports},9523:function(t,e,n){var r=n("a395");t.exports=function(t,e,n){return e=r(e),e in t?Object.defineProperty(t,e,{value:n,enumerable:!0,configurable:!0,writable:!0}):t[e]=n,t},t.exports.__esModule=!0,t.exports["default"]=t.exports},"9fb6":function(t,e,n){"use strict";n.r(e);var r=n("e804");for(var i in r)["default"].indexOf(i)<0&&function(t){n.d(e,t,(function(){return r[t]}))}(i);var o=n("f0c5"),a=Object(o["a"])(r["default"],void 0,void 0,!1,null,null,null,!1,void 0,void 0);e["default"]=a.exports},a395:function(t,e,n){var r=n("7037")["default"],i=n("e50d");t.exports=function(t){var e=i(t,"string");return"symbol"===r(e)?e:String(e)},t.exports.__esModule=!0,t.exports["default"]=t.exports},d768:function(t,e,n){if("undefined"===typeof Promise||Promise.prototype.finally||(Promise.prototype.finally=function(t){var e=this.constructor;return this.then((function(n){return e.resolve(t()).then((function(){return n}))}),(function(n){return e.resolve(t()).then((function(){throw n}))}))}),"undefined"!==typeof uni&&uni&&uni.requireGlobal){var r=uni.requireGlobal();ArrayBuffer=r.ArrayBuffer,Int8Array=r.Int8Array,Uint8Array=r.Uint8Array,Uint8ClampedArray=r.Uint8ClampedArray,Int16Array=r.Int16Array,Uint16Array=r.Uint16Array,Int32Array=r.Int32Array,Uint32Array=r.Uint32Array,Float32Array=r.Float32Array,Float64Array=r.Float64Array,BigInt64Array=r.BigInt64Array,BigUint64Array=r.BigUint64Array}uni.restoreGlobal&&uni.restoreGlobal(weex,plus,setTimeout,clearTimeout,setInterval,clearInterval),__definePage("pages/index/index",(function(){return Vue.extend(n("8f63").default)}))},e233:function(t,e,n){"use strict";n.d(e,"b",(function(){return r})),n.d(e,"c",(function(){return i})),n.d(e,"a",(function(){}));var r=function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("div",[n("br"),n("br"),n("label"),n("label",[t._v(t._$s(4,"t0-0",t._s(t.connectStatus)))]),n("br"),n("label"),n("label",[t._v(t._$s(7,"t0-0",t._s(t.registrationID)))]),n("br"),n("label"),n("br"),n("button",{attrs:{_i:11},on:{click:t.initPush}}),n("button",{attrs:{_i:12},on:{click:t.openSettingsForNotification}}),n("br"),n("br"),n("button",{attrs:{_i:15},on:{click:t.setLoggerEnable}}),n("button",{attrs:{_i:16},on:{click:t.setLoggerUnEnable}}),n("button",{attrs:{_i:17},on:{click:t.getRegistrationID}}),n("br"),n("br"),n("br"),n("label"),n("br"),n("br"),n("input",{directives:[{name:"model",rawName:"v-model",value:t.inputTags,expression:"inputTags"}],attrs:{_i:24},domProps:{value:t._$s(24,"v-model",t.inputTags)},on:{input:function(e){e.target.composing||(t.inputTags=e.target.value)}}}),n("br"),n("input",{directives:[{name:"model",rawName:"v-model",value:t.inputAlias,expression:"inputAlias"}],attrs:{_i:26},domProps:{value:t._$s(26,"v-model",t.inputAlias)},on:{input:function(e){e.target.composing||(t.inputAlias=e.target.value)}}}),n("br"),n("label",{attrs:{_i:28},on:{click:t.addTags}}),n("label",{attrs:{_i:29},on:{click:t.updateTags}}),n("label",{attrs:{_i:30},on:{click:t.queryTags}}),n("br"),n("br"),n("label",{attrs:{_i:33},on:{click:t.deleteTag}}),n("label",{attrs:{_i:34},on:{click:t.deleteTags}}),n("label",{attrs:{_i:35},on:{click:t.queryTag}}),n("br"),n("br"),n("label",{attrs:{_i:38},on:{click:t.setAlias}}),n("label",{attrs:{_i:39},on:{click:t.deleteAlias}}),n("label",{attrs:{_i:40},on:{click:t.queryAlias}})])},i=[]},e50d:function(t,e,n){var r=n("7037")["default"];t.exports=function(t,e){if("object"!==r(t)||null===t)return t;var n=t[Symbol.toPrimitive];if(void 0!==n){var i=n.call(t,e||"default");if("object"!==r(i))return i;throw new TypeError("@@toPrimitive must return a primitive value.")}return("string"===e?String:Number)(t)},t.exports.__esModule=!0,t.exports["default"]=t.exports},e804:function(t,e,n){"use strict";n.r(e);var r=n("724d"),i=n.n(r);for(var o in r)["default"].indexOf(o)<0&&function(t){n.d(e,t,(function(){return r[t]}))}(o);e["default"]=i.a},f0c5:function(t,e,n){"use strict";function r(t,e,n,r,i,o,a,u,s,l){var c,f="function"===typeof t?t.options:t;if(s){f.components||(f.components={});var p=Object.prototype.hasOwnProperty;for(var d in s)p.call(s,d)&&!p.call(f.components,d)&&(f.components[d]=s[d])}if(l&&("function"===typeof l.beforeCreate&&(l.beforeCreate=[l.beforeCreate]),(l.beforeCreate||(l.beforeCreate=[])).unshift((function(){this[l.__module]=this})),(f.mixins||(f.mixins=[])).push(l)),e&&(f.render=e,f.staticRenderFns=n,f._compiled=!0),r&&(f.functional=!0),o&&(f._scopeId="data-v-"+o),a?(c=function(t){t=t||this.$vnode&&this.$vnode.ssrContext||this.parent&&this.parent.$vnode&&this.parent.$vnode.ssrContext,t||"undefined"===typeof __VUE_SSR_CONTEXT__||(t=__VUE_SSR_CONTEXT__),i&&i.call(this,t),t&&t._registeredComponents&&t._registeredComponents.add(a)},f._ssrRegister=c):i&&(c=u?function(){i.call(this,this.$root.$options.shadowRoot)}:i),c)if(f.functional){f._injectStyles=c;var g=f.render;f.render=function(t,e){return c.call(e),g(t,e)}}else{var v=f.beforeCreate;f.beforeCreate=v?[].concat(v,c):[c]}return{exports:t,options:f}}n.d(e,"a",(function(){return r}))}},[["604a","app-config"]]]);