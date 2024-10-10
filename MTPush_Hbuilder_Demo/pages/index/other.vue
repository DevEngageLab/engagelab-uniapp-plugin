<template>
	<view>
		<label style="margin-right: 50rpx;">other page</label>
	</view>
</template>

<script>
	// 首先需要通过 uni.requireNativePlugin("ModuleName") 获取 module
	var mtpushModule = uni.requireNativePlugin("EL-MTPush")
	export default {
		data() {
			return {
				
			}
		},
		onShow() {
			mtpushModule.pageEnterTo("otherView")
		},
		
		onHide() {
			mtpushModule.pageLeave("otherView")
		},
		onLoad() {
			
		},
		onUnload() {
			
		},
		methods: {
			
		}
	}
</script>

<style>

</style>
