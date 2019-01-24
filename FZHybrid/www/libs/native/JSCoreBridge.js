define("jsbridge", function(require, exports, module) {
    // var exec = require('JSNative');
    module.exports =  function(jsParameter) {
        var resultCallback = jsParameter.success;
        var index = jsParameter.tabIndex;
        exec(resultCallback, null, 'AppNativeBackPage', 'backtohome', [index]);
    };
});
alert(jsbridge)