
<script>
	var mtpushModule = uni.requireNativePlugin("EL-MTPush")
	export default {
		onLaunch: function() {
			console.log('App Launch')
			if(uni.getSystemInfoSync().platform == "ios"){
				
				mtpushModule.requestNotificationAuthorization((result)=>{
					let status = result.status
					if (status < 2) {
						uni.showToast({
							icon: 'none',
							title: '您还没有打开通知权限',
							duration: 3000
						})
					}
				})
			}
			
			// mtpushModule.setCountryCode("US");
			// mtpushModule.setTcpSSL(true)
			mtpushModule.setLoggerEnable(true);
			mtpushModule.initPushService();
			mtpushModule.addConnectEventListener(result=>{
				let connectEnable = result.connectEnable
				uni.$emit('connectStatusChange',connectEnable)
			});
			
			mtpushModule.addNotificationListener(result=>{
				let notificationEventType = result.notificationEventType
				let messageID = result.messageID
				let title = result.title
				let content = result.content
				let extras = result.extras
				
				uni.showToast({
					icon: 'none',
					title: JSON.stringify(result),
					duration: 3000
				})
			});
			
			mtpushModule.addCustomMessageListener(result=>{
				let type = result.type
				let messageType = result.messageType
				let content = result.content
				uni.showToast({
					icon: 'none',
					title: JSON.stringify(result),
					duration: 3000
				})
			});
			
			mtpushModule.addTagAliasListener(result=>{
				uni.showToast({
					icon: 'none',
					title: JSON.stringify(result),
					duration: 3000
				})
			});
			
			if(uni.getSystemInfoSync().platform == "ios"){
				mtpushModule.addLocalNotificationListener(result=>{
					let messageID = result.messageID
					let title = result.title
					let content = result.content
					let extras = result.extras
					uni.showToast({
						icon: 'none',
						title: JSON.stringify(result),
						duration: 3000
					})
				})
			}
			
			
		},
		onShow: function() {
			console.log('App Show')
		},
		onHide: function() {
			console.log('App Hide')
		}
	}
</script>

<style>
	/*每个页面公共css */
</style>
