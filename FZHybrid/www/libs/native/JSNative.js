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
		},
		registerNotification: function (params) {
			_postMessageToNative(params, 'registerNotification');
		},
		postNotification: function (params) {
			_postMessageToNative(params, 'postNotification');
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
		} else {
			var methods_Classes = {
				log: function (params) {
					 JSNative_FZLog_Instance.log(params);
				},
				optionalInstanceTest: function (params) {
					 JSNative_FZTest_Instance.optionalInstanceTest(params)
				},
				requiredInstanceTest: function (params) {
					 JSNative_FZTest_Instance.requiredInstanceTest(params)
				},
				push: function (params) {
					 JSNative_FZNavigator_Instance.viewController = VIEWCONTROLLER;
					 JSNative_FZNavigator_Instance.push(params)
				}
			};

			return methods_Classes[methodName](params);
		}
	}

	return methods;
})();

