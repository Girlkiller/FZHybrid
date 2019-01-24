(function(){function r(e,n,t){function o(i,f){if(!n[i]){if(!e[i]){var c="function"==typeof require&&require;if(!f&&c)return c(i,!0);if(u)return u(i,!0);var a=new Error("Cannot find module '"+i+"'");throw a.code="MODULE_NOT_FOUND",a}var p=n[i]={exports:{}};e[i][0].call(p.exports,function(r){var n=e[i][1][r];return o(n||r)},p,p.exports,r,e,n,t)}return n[i].exports}for(var u="function"==typeof require&&require,i=0;i<t.length;i++)o(t[i]);return o}return r})()({1:[function(require,module,exports){
var JSNative = (function() {
	var methods = {
		log: function (params) {
			 _postMessageToNative(params, 'log');
		},
		optionalInstanceTest: function (params) {
			 _postMessageToNative(params, 'optionalInstanceTest');
		},
		requiredInstanceTest: function (params) {
			 _postMessageToNative(params, 'requiredInstanceTest');
		},
		push: function (params) {
			 _postMessageToNative(params, 'push');
		}
	};

	function _postMessageToNative(params, methodName) {
		var webkit = window.webkit;
		if (typeof webkit == 'object') {
			if (typeof params == 'function') {
				params = params.toString();
			} else if (params !== void 0 && typeof params == 'object') {
				for (var key in params) {
					if (typeof params[key] == 'function') {
						params[key] = params[key].toString();
					}
				}
			} 
			try {
			    webkit.messageHandlers[methodName].postMessage(params);
			} catch (error) {
				alert(error);
			}
		} 
	}

	return methods;
})();


},{}]},{},[1]);
