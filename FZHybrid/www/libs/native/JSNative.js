var JSNative = (function() {
	var methods = {
		log: function () {
			 _postMessageToNative(arguments, 'log');
		},
		optionalInstanceTest: function () {
			 _postMessageToNative(arguments, 'optionalInstanceTest');
		},
		requiredInstanceTest: function () {
			 _postMessageToNative(arguments, 'requiredInstanceTest');
		},
		push: function () {
			 _postMessageToNative(arguments, 'push');
		},
		registerNotification: function () {
			_postMessageToNative(arguments, 'registerNotification');
		},
		postNotification: function () {
			_postMessageToNative(arguments, 'postNotification');
		}
	};

	function _postMessageToNative(arguments, methodName) {
		var webkit = window.webkit;
		if (typeof webkit == 'object') {
			var paramsList = Array.prototype.slice.apply(arguments).map(function (value, index) {
				if (typeof value == 'function') {
					return value.toString();
				} else if (typeof value == 'object') {
					for (var key in value) {
						if (typeof value[key] == 'function') {
							value[key] = value[key].toString();
						}
					}
				} 
				return value;
			});
			 
			try {
			    webkit.messageHandlers[methodName].postMessage(paramsList);
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

