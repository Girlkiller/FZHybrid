var vueApp;
$(function() {
	createCellComponent();
	initVueApp();
	alert('aaaaaaaa')
	JSNative.log(JS_NATIVE_PARAMS.boss);
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
	  		if (this.item.name == '山姆') {
	  			JSNative.optionalInstanceTest(this.item);
	  		} else {
	  			JSNative.requiredInstanceTest(this.item);
	  		}
            
            // var paramsString={"name":"Navigator"}; 
            // var params = JSON.parse(paramsString)
   //          var callBack = new Function("return " + this.item.callBack)();
			// var f = function(param) {
			// 	callBack.apply(this, [param]);
			// }
			// f('haha');

			// var callBack = new Function("return " + this.item.callBack)();
   //          var f=function(param){callBack.apply(this, [param]);};f('hhhh');



	  	}
	  }
	});
}

function initVueApp() {
	vueApp = new Vue({
		el: '#testApp',
		data: {
			count: 0,
			items: [{
				name: '山姆',
				callBack: function (param) {
					alert(param.name + param.age);
					return "success";
				}
			},{
				name: '琼恩雪诺',
				callBack: testCallBack
			},{
				name: '卡丽熙'
			},{
				name: '布兰',
				callBack: testCallBack
			},{
				name: '珊莎',
				callBack: testCallBack
			}]
		},
		methods: {
			click: function (event) {
				
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
	vueApp.count++;
	vueApp.items.push({
		name: '异鬼' + vueApp.count,
		callBack: testCallBack
	})
}