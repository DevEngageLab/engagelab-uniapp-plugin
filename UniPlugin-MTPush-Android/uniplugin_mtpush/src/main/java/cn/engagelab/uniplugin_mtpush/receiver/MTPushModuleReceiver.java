package cn.engagelab.uniplugin_mtpush.receiver;

import android.content.Context;

import com.alibaba.fastjson.JSONObject;
import com.engagelab.privates.common.component.MTCommonReceiver;
import com.engagelab.privates.core.api.WakeMessage;
import com.engagelab.privates.push.api.CustomMessage;
import com.engagelab.privates.push.api.MobileNumberMessage;
import com.engagelab.privates.push.api.NotificationMessage;
import com.engagelab.privates.push.api.PlatformTokenMessage;

import cn.engagelab.uniplugin_mtpush.MTPushModule;
import cn.engagelab.uniplugin_mtpush.common.MTConstants;
import cn.engagelab.uniplugin_mtpush.common.MTLogger;
import cn.engagelab.uniplugin_mtpush.helper.MTPushHelper;

/**
 * 开发者继承MTCommonReceiver，可以获得sdk的方法回调
 * <p>
 * 所有回调均在主线程
 */
public class MTPushModuleReceiver extends MTCommonReceiver {

    @Override
    public void onNotificationStatus(Context context, boolean enable) {
        MTLogger.d("onNotificationStatus:" + enable);
    }

    // 长连接状态回调
    @Override
    public void onConnectStatus(Context context, boolean state) {
        MTLogger.d("onConnectStatus state:" + state);
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.CONNECT_ENABLE, state);
        MTPushHelper.sendEvent(MTConstants.CONNECT_EVENT, jsonObject);
    }

    // 通知消息到达回调
    @Override
    public void onNotificationArrived(Context context, NotificationMessage notificationMessage) {
        MTLogger.d("onNotificationArrived:" + notificationMessage.toString());
        JSONObject jsonObject = MTPushHelper.convertNotificationToMap(MTConstants.NOTIFICATION_ARRIVED, notificationMessage);
        MTPushHelper.sendNotifactionEvent(jsonObject, 0);
    }

    // 通知消息点击回调
    @Override
    public void onNotificationClicked(Context context, NotificationMessage notificationMessage) {
        MTLogger.d("onNotificationClicked:" + notificationMessage.toString());
        if (!MTPushModule.isAppForeground) MTPushHelper.launchApp(context);
        JSONObject jsonObject = MTPushHelper.convertNotificationToMap(MTConstants.NOTIFICATION_OPENED, notificationMessage);
        MTPushHelper.sendNotifactionEvent(jsonObject, 0);
        MTPushHelper.saveOpenNotifiData(jsonObject, 0);
    }

    @Override
    public void onNotificationDeleted(Context context, NotificationMessage notificationMessage) {
        MTLogger.d("onNotificationDeleted:");
    }

    // 自定义消息回调
    @Override
    public void onCustomMessage(Context context, CustomMessage customMessage) {
        MTLogger.d("onCustomMessage:" + customMessage.toString());
        JSONObject jsonObject = MTPushHelper.convertCustomMessage(customMessage);
        MTPushHelper.sendEvent(MTConstants.CUSTOM_MESSAGE_EVENT, jsonObject);
    }

    // 厂商token消息回调
    @Override
    public void onPlatformToken(Context context, PlatformTokenMessage platformMessage) {
        MTLogger.d("onPlatformToken:" + platformMessage.toString());
    }

    //    @Override
//    public void onRegister(Context context, String registrationId) {
//        MTLogger.d("onRegister:" + registrationId);
//    }
//
//    @Override
//    public void onCommandResult(Context context, CmdMessage message) {
//        MTLogger.d("onCommandResult:" + message.toString());
//        JSONObject jsonObject = new JSONObject();
//        jsonObject.put(MTConstants.COMMAND, message.cmd);
//        jsonObject.put(MTConstants.COMMAND_EXTRA, message.extra.toString());
//        jsonObject.put(MTConstants.COMMAND_MESSAGE, message.msg);
//        jsonObject.put(MTConstants.COMMAND_RESULT, message.errorCode);
//        MTPushHelper.sendEvent(MTConstants.COMMAND_EVENT, jsonObject);
//    }


    // 移动号码消息回调
    @Override
    public void onMobileNumber(Context context, MobileNumberMessage mobileNumberMessage) {
        MTLogger.d("onMobileNumber:" + mobileNumberMessage.toString());
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.CODE, mobileNumberMessage.getCode());
        jsonObject.put(MTConstants.SEQUENCE, mobileNumberMessage.getSequence());
        MTPushHelper.sendEvent(MTConstants.MOBILE_NUMBER_EVENT, jsonObject);
    }

    @Override
    public void onWake(Context context, WakeMessage wakeMessage) {
        MTLogger.d("onWake:" + wakeMessage.toString());
    }
}
