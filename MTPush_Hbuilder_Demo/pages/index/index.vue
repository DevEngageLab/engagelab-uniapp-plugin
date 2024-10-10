<template>
    <div>
		</br>
		</br>
		<label style="margin-right: 50rpx;">网络状态:</label>
		<label>{{connectStatus}}</label>
		</br>
		<label style="margin-right: 50rpx;">RegistrationID:</label>
		<label>{{registrationID}}</label>
		</br>
		
		<label>---------------------------------</label>
		</br>
		<button size="mini" type="primary" @click="initPush" style="left: 10pt;">初始化</button>
		<button size="mini" type="primary" @click="openSettingsForNotification" style="left: 20pt;">打开通知设置界面</button>
		</br>
		</br>
		<button size="mini" type="primary" @click="setLoggerEnable" style="left: 10pt;">打开日志</button>
		<button size="mini" type="primary" @click="setLoggerUnEnable" style="left: 20pt;">关闭日志</button>
		<button size="mini" type="primary" @click="getRegistrationID" style="left: 30pt;">获取注册id</button>
		
		</br>
		</br>
		</br>
		<label>---------------Tags/Alias------------------</label>
		</br>
		</br>
		<input placeholder="请使用tags,作为分隔符" v-model="inputTags"/>
		</br>
		<input placeholder="请输入alias" v-model="inputAlias"/>
		</br>
		<label type="primary" @click="addTags" style="margin-right: 50rpx;">增加tags</label>
		<label type="primary" @click="updateTags" style="margin-right: 50rpx;">覆盖tags</label>
		<label type="primary" @click="queryTags" style="margin-right: 50rpx;">查询Tags</label>
		</br>
		</br>
		<label type="primary" @click="deleteTag" style="margin-right: 30rpx;">删除tags </label>
		<label type="primary" @click="deleteTags" style="margin-right: 30rpx;">清空tags</label>
		<label type="primary" @click="queryTag" style="margin-right: 30rpx;">验证tag </label>
		</br>
		</br>
		<label type="primary" @click="setAlias" style="margin-right: 30rpx;">设置 Alias</label>
		<label type="primary" @click="deleteAlias" style="margin-right: 30rpx;">删除Alias </label>
		<label type="primary" @click="queryAlias" style="margin-right: 30rpx;">查询Alias </label>
		
    </div>
</template>

<script>
    // 首先需要通过 uni.requireNativePlugin("ModuleName") 获取 module 
    var mtpushModule = uni.requireNativePlugin("EL-MTPush")
	var seq = 1
    export default {
		
		data() {
			return {
				connectStatus: '未连接',
				registrationID: '未获得',
				inputTags: '',
				inputAlias: ''
			}
		},
		
		onShow() {
			mtpushModule.pageEnterTo("indexView")
		},
		
		onHide() {
			mtpushModule.pageLeave("indexView")
		},
		
		onLoad() {
			console.log('开始监听连接状态')
			uni.$on('connectStatusChange',(connectStatus)=>{  
				   var connectStr = ''
				   if (connectStatus == true) {
					   connectStr = '已连接'
					   this.getRegistrationID()
				   }else {
					   connectStr = '未连接'
				   }
				   console.log('监听到了连接状态变化 --- ', connectStr) 
				   this.connectStatus = connectStr
			    })  
		},
		
		onUnload() {  
			// 移除监听事件  
		    uni.$off('connectStatusChange')
		},
		
        methods: {
			
			
			initPush() {
				// mtpushModule.setTcpSSl(true)
				mtpushModule.initPushService()
			},
			
			openSettingsForNotification() {
				mtpushModule.openSettingsForNotification((result)=>{
					this.showToast(result)
				})
			},
			
			setLoggerEnable() {
				mtpushModule.setLoggerEnable(true)
			},
			
			setLoggerUnEnable() {
				mtpushModule.setLoggerEnable(false)
			},
			
			getRegistrationID() {
				mtpushModule.getRegistrationID(result=>{
					let registerID = result.registerID
					console.log(registerID)
					this.registrationID = registerID
				})	
			},
			
			addTags() {
				var tags = this.inputTags.split(',')
				mtpushModule.addTags({
					'tags':tags,
					'sequence': seq++
				})
			},
			
			updateTags() {
				var tags = this.inputTags.split(',')
				mtpushModule.updateTags({
					'tags':tags,
					'sequence': seq++
				})
			},
			
			deleteTag() {
				var tags = this.inputTags.split(',')
				mtpushModule.deleteTags({
					'tags':tags,
					'sequence': seq++
				})
			},
			
			deleteTags() {
				mtpushModule.cleanTags({
					'sequence': seq++
				})
			},
			
			queryTag() {
				var tag = this.inputTags
				mtpushModule.queryTag({
					'tag':tag,
					'sequence': seq++
				})
			},
			
			queryTags() {
				mtpushModule.getAllTags({
					'sequence': seq++
				})
			},
			
			setAlias() {
				let alias = this.inputAlias
				mtpushModule.setAlias({
					'alias':alias,
					'sequence': seq++
				})
			},
			
			deleteAlias() {
				mtpushModule.deleteAlias({
					'sequence': seq++
				})
			},
			
			queryAlias() {
				mtpushModule.queryAlias({
					'sequence': seq++
				})
			},
			
			showToast(result){
				uni.showToast({
					icon:'none',
					title: JSON.stringify(result),
					duration: 3000
				})
			}

        }
    }
</script>
