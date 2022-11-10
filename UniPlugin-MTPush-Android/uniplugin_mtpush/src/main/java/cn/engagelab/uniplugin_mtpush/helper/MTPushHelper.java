package cn.engagelab.uniplugin_mtpush.helper;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.engagelab.privates.push.api.CustomMessage;
import com.taobao.weex.bridge.JSCallback;

import java.util.HashMap;
import java.util.Set;

import cn.engagelab.uniplugin_mtpush.common.MTConstants;
import cn.engagelab.uniplugin_mtpush.common.MTLogger;

import com.engagelab.privates.push.api.NotificationMessage;

public class MTPushHelper {

    public static HashMap<String, JSCallback> eventCallback = new HashMap<>();

    public static void sendNotifactionEvent(JSONObject params, int notificationType) {
        if (notificationType != 1) {
            MTPushHelper.sendEvent(MTConstants.NOTIFICATION_EVENT, params);
        } else {
            MTPushHelper.sendEvent(MTConstants.LOCAL_NOTIFICATION_EVENT, params);
        }

    }

    public static void sendEvent(String eventName, JSONObject params) {
        try {
            if (!TextUtils.isEmpty(eventName) && params != null) {
                MTLogger.d("sendEvent :" + eventName + " params:" + params);
                JSCallback jsCallback = eventCallback.get(eventName);
                if (jsCallback != null) {
                    jsCallback.invokeAndKeepAlive(params);
                    MTLogger.e("sendEvent :" + eventName + " success");
                    return;
                }
                MTLogger.e("sendEvent :" + eventName + " failed");
            }
        } catch (Throwable throwable) {
            MTLogger.e("sendEvent error:" + throwable.getMessage());
        }
    }

    public static JSONObject convertNotificationToMap(String eventType, NotificationMessage message) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.NOTIFICATION_EVENT_TYPE, eventType);
        jsonObject.put(MTConstants.MESSAGE_ID, message.getMessageId());
        jsonObject.put(MTConstants.TITLE, message.getTitle());
        jsonObject.put(MTConstants.CONTENT, message.getContent());
        jsonObject.put(MTConstants.ANDROID, JSONObject.parseObject(JSONObject.toJSONString(message)));
        convertExtras(message.getExtras().toString(), jsonObject);
        return jsonObject;
    }

    public static JSONObject convertThirdOpenNotificationToMap(String msgId, String title, String content, String extra, String android) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.NOTIFICATION_EVENT_TYPE, MTConstants.NOTIFICATION_OPENED);
        jsonObject.put(MTConstants.MESSAGE_ID, msgId);
        jsonObject.put(MTConstants.TITLE, title);
        jsonObject.put(MTConstants.CONTENT, content);
        jsonObject.put(MTConstants.ANDROID, JSONObject.parseObject(android));
        convertExtras(extra, jsonObject);
        return jsonObject;
    }

    public static JSONObject convertNotificationBundleToMap(String eventType, Bundle bundle) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.NOTIFICATION_EVENT_TYPE, eventType);
        jsonObject.put(MTConstants.MESSAGE_ID, bundle.getString("cn.jpush.android.MSG_ID", ""));
        jsonObject.put(MTConstants.TITLE, bundle.getString("cn.jpush.android.NOTIFICATION_CONTENT_TITLE", ""));
        jsonObject.put(MTConstants.CONTENT, bundle.getString("cn.jpush.android.ALERT", ""));
        convertExtras(bundle.getString("cn.jpush.android.EXTRA", ""), jsonObject);
        return jsonObject;
    }

    public static JSONObject convertCustomMessage(CustomMessage customMessage) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.MESSAGE_ID, customMessage.getMessageId());
        jsonObject.put(MTConstants.TITLE, customMessage.getTitle());
        jsonObject.put(MTConstants.CONTENT, customMessage.getContent());
        convertExtras(customMessage.getExtras().toString(), jsonObject);
        jsonObject.put(MTConstants.ANDROID, JSONObject.parseObject(JSONObject.toJSONString(customMessage)));
        return jsonObject;
    }

    public static void convertExtras(String extras, JSONObject jsonObject) {
        if (TextUtils.isEmpty(extras) || extras.equals("{}")) return;
        try {
//            JSONObject extrasMap = new JSONObject();
//            JSONObject jsonObject = JSONObject.parseObject(extras);
//            Iterator<String> it = jsonObject.keys();
//            while (it.hasNext()) {
//                String key = it.next();
//                String value = jsonObject.getString(key);
//                extrasMap.put(key, value);
//            }
            jsonObject.put(MTConstants.EXTRAS, JSONObject.parseObject(extras));
        } catch (Throwable throwable) {
            MTLogger.w("convertExtras error:" + throwable.getMessage());
        }
    }

    public static void launchApp(Context context) {
        try {
            Intent intent = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_CLEAR_TOP);
            context.startActivity(intent);
        } catch (Throwable throwable) {
            MTLogger.e("");
        }
    }

    public static JSONObject OPEN_NOTIFICATION_DATA = null;
    public static int OPEN_NOTIFICATION_TYPE = 0;
    public static boolean IS_DESTROY = true;// 标识当前插件是否被销毁

    /**
     * 缓存通知点击信息，再用户注册监听后返回给用户
     *
     * @param jsonObject
     */
    public static void saveOpenNotifiData(JSONObject jsonObject, int type) {
        if (IS_DESTROY) {
            MTLogger.d("saveOpenNotifiData:" + jsonObject);
            OPEN_NOTIFICATION_DATA = jsonObject;
            OPEN_NOTIFICATION_TYPE = type;
        }
    }

    public static void sendCacheOpenNotifiToUser(int type) {
        if (type == 0 && OPEN_NOTIFICATION_TYPE == 1) {
            return;
        }
        if (!IS_DESTROY && OPEN_NOTIFICATION_DATA != null) {
            MTLogger.d("sendCacheOpenNotifiToUser:" + OPEN_NOTIFICATION_DATA);
            sendNotifactionEvent(OPEN_NOTIFICATION_DATA, OPEN_NOTIFICATION_TYPE);
            OPEN_NOTIFICATION_DATA = null;
        }
    }

}
