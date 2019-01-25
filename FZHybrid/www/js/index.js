var vueApp;

$(function() {
	createCellComponent();
	initVueApp();
	JSNative.log(null);
	JSNative.registerNotification('FZTestNotification', function (params) {
			JSNative.log(params);
		});
	JSNative.registerNotification('FZTestNotification', function (params) {
			params.date = new Date();
			JSNative.log(params);
		});

	setTimeout(function () {
		JSNative.postNotification('FZTestNotification', {
				age: 28,
				name: '老王',
				address: '北京'
			});
	}, 10);
});

function test() {
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
	print(paramsList);
}

function print (arguments) {
	alert(arguments)
	console.log(arguments);
}

function createCellComponent() {
	Vue.component('cell', {
	  props: ['item'],
	  template: `
	    <div class="mui-table-view-cell" @click="click($event)">
			<a class="mui-navigate-right">
				{{ item.name }}
			</a>
		</div>
	  `,
	  methods: {
	  	click: function(event) {
            if (this.item.name == '调用类方法') {
            	JSNative.optionalInstanceTest(this.item, testCallBack);
            } else if (this.item.name == 'test' || this.item.name == '百度') {
            	JSNative.push(this.item.url, this.item);
            } else {
            	JSNative.requiredInstanceTest(this.item, testCallBack);
            }
	  	}
	  }
	});
}

function initVueApp() {
	vueApp = new Vue({
		el: '#hybirdApp',
		data: {
			items: [{
				name: 'Navigator',
				age: '28',
				gender: 'man',
				city: 'guangzhou'
			},{
				name: 'NavigationBar'
			},{
				name: 'Alert'
			},{
				name: '调用实例方法'
			},{
				name: '调用类方法'
			},{
				name: 'test',
				url: 'test',
				params: {
					name: '火影忍者',
					level: '16',
					boss: '大蛇丸'
				}
			},{
				name: '百度',
				url: 'https://www.baidu.com',
				params: {
					name: '海贼王',
					level: '20',
					boss: '白胡子'
				}
			}]
		},
		methods: {
			click: function (event) {
				
			},
			print: function (param) {
				var $testDiv = $('.list');
				$testDiv.empty();
				var $div = $('<div class="test"></div>');
				$testDiv.append($div);
				var $spanKey = $('<div class="key-item"></div>');
				$spanKey.text('键/类型');
				$div.append($spanKey);
				var $spanValue = $('<div class="value-item"></div>');
				$spanValue.text('值');
				$div.append($spanValue);
				JSNative.log(typeof param + ' :' + param);
				if (typeof param == 'object'){
					for (var key in param) {
						var $div = $('<div class="test"></div>');
						$testDiv.append($div);
						var $spanKey = $('<div class="key-item"></div>');
						$spanKey.text(key);
						$div.append($spanKey);
						var $spanValue = $('<div class="value-item"></div>');
						$spanValue.text(param[key]);
						$div.append($spanValue);
					}
				} else {
					var $div = $('<div class="test"></div>');
					$testDiv.append($div);
					var $spanKey = $('<div class="key-item"></div>');
						$spanKey.text('类型: ' + typeof param);
						$div.append($spanKey);
						var $spanValue = $('<div class="value-item"></div>');
						$spanValue.text('value: ' + param);
						$div.append($spanValue);
				}
			}
 		},
		created: function () {
			
		},
		mounted: function () {

		}
	});
}

function navigator(param) {
	vueApp.items.push({
		name: '新增案例'
	})
}

function testCallBack(param) {
	vueApp.items.push({
		name: '新增案例'
	})
	vueApp.print(param);
}
