<template>
	<div>
		<view>
			<input v-model="inputBadge" placeholder="请输入badge"/>
			</br>
			<label @click='setBadge'>设置角标</label>
			</br>
			</br>
			<input placeholder="请输入电话号码" v-model="inputPhoneNumber"/>
			</br>
			<label @click='setMobileNumber'>设置电话号码</label>
			</br>
			</br>
			
		</view>
	</div>
	
</template>

<script>
    // 首先需要通过 uni.requireNativePlugin("ModuleName") 获取 module 
    var mtpushModule = uni.requireNativePlugin("EL-MTPush")
	
	mtpushModule.addMobileNumberListener(result=>{
		let code = result.code
		uni.showToast({
			icon:'none',
			title: JSON.stringify(result),
			duration: 3000
		})
	})
	
    export default {
		
		data() {
			return {
				inputPhoneNumber: '',
				inputBadge: ''
			}
		},
		
        methods: {
			
			setMobileNumber() {
				let mobileNumber = this.inputPhoneNumber
				mtpushModule.setMobileNumber({
					mobileNumber: mobileNumber
				})
			},
			
			setBadge(){
				let badge = parseInt(this.inputBadge)
				mtpushModule.setBadge(badge)
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
