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

