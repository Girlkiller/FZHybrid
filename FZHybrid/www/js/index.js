var vueApp;

$(function() {
	createCellComponent();
	initVueApp();
	JSNative.log(JS_NATIVE_PARAMS);
	JSNative.registerNotification({
		name: 'FZTestNotification', 
		callBack: function (params) {
			JSNative.log(params);
		}
	});
	JSNative.registerNotification({
		name: 'FZTestNotification', 
		callBack: function (params) {
			params.date = new Date();
			JSNative.log(params);
		}
	});

	setTimeout(function () {
		JSNative.postNotification({
			name: 'FZTestNotification',
			params: {
				age: 28,
				name: '老王',
				address: '北京'
			}
		});
	}, 10);
});

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
            	JSNative.optionalInstanceTest(this.item);
            } else if (this.item.name == 'test' || this.item.name == '百度') {
            	JSNative.push(this.item);
            } else {
            	JSNative.requiredInstanceTest(this.item);
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
				city: 'guangzhou',
				success: function (param) {
					vueApp.print(param);
				}
			},{
				name: 'NavigationBar',
				callBack: testCallBack
			},{
				name: 'Alert'
			},{
				name: '调用实例方法',
				callBack: testCallBack
			},{
				name: '调用类方法',
				callBack: testCallBack
			},{
				name: 'test',
				url: 'test',
				params: {
					name: '火影忍者',
					level: '16',
					boss: '大蛇丸'
				},
				callBack: testCallBack
			},{
				name: '百度',
				url: 'https://www.baidu.com',
				params: {
					name: '海贼王',
					level: '20',
					boss: '白胡子'
				},
				callBack: testCallBack
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
		name: '新增案例',
		callBack: testCallBack
	})
}

function testCallBack(param) {
	vueApp.items.push({
		name: '新增案例',
		callBack: testCallBack
	})
	vueApp.print(param);
}
