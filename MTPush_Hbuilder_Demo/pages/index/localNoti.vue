<template>
	<div>
		</br>
		<button type="primary" @click="addLocalNotification">创建一个本地通知 id 123</button>
		</br>
		<button type="primary" @click="removeLocalNotification">删除本地通知 id 123</button>
		</br>
		<button type="primary" @click="clearLocalNotifications">移除所有的本地通知</button>
		</br>
	</div>
</template>

<script>
    // 首先需要通过 uni.requireNativePlugin("ModuleName") 获取 module 
    var mtpushModule = uni.requireNativePlugin("EL-MTPush")
    export default {
		
		data() {
			return {
				
			}
		},
		
        methods: {
			
			addLocalNotification() {
				if(uni.getSystemInfoSync().platform == "ios"){
					mtpushModule.addLocalNotification({
						messageID:'123',
						title:'title',
						content:'content',
						extras:{
							name: 'Cindy',
							age: '16'
						}
					})
				}
			},
			
			removeLocalNotification() {
				if(uni.getSystemInfoSync().platform == "ios"){
					mtpushModule.removeLocalNotification({
						messageID:'123'
					})
				}
			},
			
			clearLocalNotifications() {
				if(uni.getSystemInfoSync().platform == "ios"){
					mtpushModule.clearLocalNotifications()
				}
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

<style>
</style>
