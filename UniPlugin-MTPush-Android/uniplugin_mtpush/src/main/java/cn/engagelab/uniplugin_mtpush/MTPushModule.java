package cn.engagelab.uniplugin_mtpush;

import static android.content.ContentValues.TAG;

import android.app.Application;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

//import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.engagelab.privates.core.api.MTCorePrivatesApi;
import com.engagelab.privates.push.api.MTPushPrivatesApi;
import com.engagelab.privates.common.global.MTGlobal;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.taobao.weex.bridge.JSCallback;


import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import cn.engagelab.uniplugin_mtpush.common.MTConstants;
import cn.engagelab.uniplugin_mtpush.common.MTLogger;
import cn.engagelab.uniplugin_mtpush.helper.MTPushHelper;
import io.dcloud.feature.uniapp.annotation.UniJSMethod;
import io.dcloud.feature.uniapp.bridge.UniJSCallback;
import io.dcloud.feature.uniapp.common.UniDestroyableModule;
import io.dcloud.feature.uniapp.common.UniModule;


public class MTPushModule extends UniDestroyableModule {

    public static boolean isAppForeground = false;
    public static Context uniContext = null;

    public void updatePluginStatu() {
        uniContext = mWXSDKInstance.getContext();
        MTPushHelper.IS_DESTROY = false;
    }

    @UniJSMethod(uiThread = true)
    public void setCountryCode(String countryCode) {
        updatePluginStatu();
        Context context = uniContext;
        if (context == null) {
            MTLogger.e("configGoogle context can't be null, please check it");
            return;
        }
        if (!MTGlobal.isMainProcess(context.getApplicationContext()) && !MTGlobal.isRemoteProcess(context.getApplicationContext())) {
            return;
        }
        MTGlobal.setCountryCode(countryCode);
//        if (!enable) {
//            MTGlobal.setCountryCode("CN");
//        } else {
//            MTGlobal.setCountryCode("US");
//        }
    }

    @UniJSMethod(uiThread = true)
    public void setLoggerEnable(boolean enable) {
        updatePluginStatu();
        MTCorePrivatesApi.configDebugMode(mWXSDKInstance.getContext(), enable);
        MTLogger.setLoggerEnable(enable);
    }


    @UniJSMethod(uiThread = true)
    public void setTcpSSl(boolean enable) {
        MTLogger.w("setTcpSSl-----");
        updatePluginStatu();
        MTCorePrivatesApi.setTcpSSl(enable);
    }


    @UniJSMethod(uiThread = true)
    public void openSettingsForNotification(JSCallback callback) {
        updatePluginStatu();
        MTPushPrivatesApi.goToAppNotificationSettings(mWXSDKInstance.getContext());
        if (callback == null) {
            MTLogger.w(MTConstants.CALLBACK_NULL);
            return;
        }
        com.alibaba.fastjson.JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.CODE, 0);
        callback.invoke(jsonObject);
    }

    @UniJSMethod(uiThread = true)
    public void setSiteName(String siteName) {
        MTLogger.w("setSiteName-----");
        updatePluginStatu();
        MTCorePrivatesApi.configAppSiteName(mWXSDKInstance.getContext(),siteName);
    }


    @UniJSMethod(uiThread = true)
    public void initPushService() {
        MTLogger.w("initPushService-----");
        updatePluginStatu();
        MTPushPrivatesApi.init(mWXSDKInstance.getContext());

        // broadcast

        // init fcm
        initFcm();
    }

    void initFcm() {
        try {
            Context context = mWXSDKInstance.getContext();
            ApplicationInfo appInfo = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
            String google_api_key = appInfo.metaData.getString("google_api_key").substring(2);
            String google_app_id = appInfo.metaData.getString("google_app_id").substring(2);
            String gcm_defaultSenderId = appInfo.metaData.getString("gcm_defaultSenderId").substring(2);
            String project_id = appInfo.metaData.getString("project_id").substring(2);
            String google_storage_bucket = appInfo.metaData.getString("google_storage_bucket").substring(2);

//            MTLogger.d("initFcm");
//            MTLogger.d("google_api_key:" + google_api_key);
//            MTLogger.d("google_app_id:" + google_app_id);
//            MTLogger.d("gcm_defaultSenderId:" + gcm_defaultSenderId);
//            MTLogger.d("project_id:" + project_id);
//            MTLogger.d("google_storage_bucket:" + google_storage_bucket);

            FirebaseOptions fireBaseOptions = new FirebaseOptions.Builder()
                    .setApiKey(google_api_key)
                    .setApplicationId(google_app_id)
                    .setGcmSenderId(gcm_defaultSenderId)
                    .setProjectId(project_id)
                    .setStorageBucket(google_storage_bucket)
                    .build();
            FirebaseApp.initializeApp(context, fireBaseOptions);
        }catch (Throwable e) {

        }
    }

    @UniJSMethod(uiThread = true)
    public void stopPush() {
        updatePluginStatu();
        MTPushPrivatesApi.turnOffPush(mWXSDKInstance.getContext());
    }

    @UniJSMethod(uiThread = true)
    public void resumePush() {
        updatePluginStatu();
        MTPushPrivatesApi.turnOnPush(mWXSDKInstance.getContext());
    }

    @UniJSMethod(uiThread = true)
    public void setPushTime(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        JSONArray readableArray = readableMap.getJSONArray(MTConstants.PUSH_TIME_DAYS);
        int startHour = readableMap.getIntValue(MTConstants.PUSH_TIME_START_HOUR);
        int endHour = readableMap.getIntValue(MTConstants.PUSH_TIME_END_HOUR);
        if (readableArray == null || startHour < 0 || startHour > 23 || endHour < 0 || endHour > 23) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        Set<Integer> days = new HashSet<Integer>();
        for (int i = 0; i < readableArray.size(); i++) {
            int day = readableArray.getIntValue(i);
            if (day > 6 || day < 0) {
                MTLogger.w(MTConstants.PARAMS_NULL);
                return;
            }
            days.add(day);
        }

        Context var10000 = mWXSDKInstance.getContext();
        int context1;
        int[] var4 = new int[context1 = days.size()];
        Integer[] var10001 = new Integer[days.size()];
        days.toArray(var10001);
        System.arraycopy(var10001, 0, var4, 0, context1);
        MTPushPrivatesApi.setNotificationShowTime(var10000.getApplicationContext(), startHour, endHour, var4);
    }

    @UniJSMethod(uiThread = true)
    public void setSilenceTime(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int startHour = readableMap.getIntValue(MTConstants.SILENCE_TIME_START_HOUR);
        int startMinute = readableMap.getIntValue(MTConstants.SILENCE_TIME_START_MINUTE);
        int endHour = readableMap.getIntValue(MTConstants.SILENCE_TIME_END_HOUR);
        int endMinute = readableMap.getIntValue(MTConstants.SILENCE_TIME_END_MINUTE);
        if (startHour == 0 || startMinute == 0 || endHour == 0 || endMinute == 0) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        MTPushPrivatesApi.setNotificationSilenceTime(mWXSDKInstance.getContext(), startHour, startMinute, endHour, endMinute);
    }

    @UniJSMethod(uiThread = true)
    public void clearAllNotifications() {
        updatePluginStatu();
        MTPushPrivatesApi.clearNotification(mWXSDKInstance.getContext());
    }

    @UniJSMethod(uiThread = true)
    public void clearNotificationById(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        if (readableMap.containsKey(MTConstants.NOTIFICATION_ID)) {
            Integer id = readableMap.getIntValue(MTConstants.NOTIFICATION_ID);
            MTPushPrivatesApi.clearNotification(mWXSDKInstance.getContext(), id);
        } else {
            MTLogger.w("there are no " + MTConstants.GEO_FENCE_ID);
        }
    }

    @UniJSMethod(uiThread = true)
    public void getRegistrationID(JSCallback callback) {
        updatePluginStatu();
        if (callback == null) {
            MTLogger.w(MTConstants.CALLBACK_NULL);
            return;
        }
        String registrationID = MTCorePrivatesApi.getRegistrationId(mWXSDKInstance.getContext());
        JSONObject jsonObject = new JSONObject();
        jsonObject.put(MTConstants.REGISTRATION_ID, registrationID);
        jsonObject.put(MTConstants.CODE, MTConstants.CODE_SUCESS);
        callback.invoke(jsonObject);
    }

    @UniJSMethod(uiThread = true)
    public void addConnectEventListener(JSCallback callback) {
        updatePluginStatu();
        if (callback != null) {
            MTLogger.w("addConnectEventListener");
            MTPushHelper.eventCallback.put(MTConstants.CONNECT_EVENT, callback);
        }
    }

    @UniJSMethod(uiThread = true)
    public void addNotificationListener(JSCallback callback) {
        updatePluginStatu();
        if (callback != null) {
            MTLogger.w("addNotificationListener");
            MTPushHelper.eventCallback.put(MTConstants.NOTIFICATION_EVENT, callback);
            MTPushHelper.sendCacheOpenNotifiToUser(0);
        }
    }

    @UniJSMethod(uiThread = true)
    public void addCustomMessageListener(JSCallback callback) {
        updatePluginStatu();
        if (callback != null) {
            MTLogger.w("addCustomMessageListener");
            MTPushHelper.eventCallback.put(MTConstants.CUSTOM_MESSAGE_EVENT, callback);
        }
    }

    @UniJSMethod(uiThread = true)
    public void addInMessageListener(JSCallback callback) {
        updatePluginStatu();
        if (callback != null) {
            MTLogger.w("addInMessageListener");
            MTPushHelper.eventCallback.put(MTConstants.INAPP_MESSAGE_EVENT, callback);
        }
    }


    @UniJSMethod(uiThread = true)
    public void setBadge(int number) {
        updatePluginStatu();
        MTPushPrivatesApi.setNotificationBadge(mWXSDKInstance.getContext(), number);
    }

    @UniJSMethod(uiThread = true)
    public void addMobileNumberListener(JSCallback callback) {
        updatePluginStatu();
        if (callback != null) {
            MTLogger.w("addMobileNumberListener");
            MTPushHelper.eventCallback.put(MTConstants.MOBILE_NUMBER_EVENT, callback);
        }
    }

    @UniJSMethod(uiThread = true)
    public void setMobileNumber(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
        String mobileNumber = readableMap.getString(MTConstants.MOBILE_NUMBER);
        MTPushPrivatesApi.uploadMobileNumber(mWXSDKInstance.getContext(), sequence, mobileNumber);
    }

    @UniJSMethod(uiThread = true)
    public void addTagAliasListener(JSCallback callback) {
        updatePluginStatu();
        if (callback != null) {
            MTLogger.w("addTagAliasListener");
            MTPushHelper.eventCallback.put(MTConstants.TAG_ALIAS_EVENT, callback);
        }
    }

    @UniJSMethod(uiThread = true)
    public void addTags(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        if (readableMap.containsKey(MTConstants.TAGS)) {
            JSONArray tags = readableMap.getJSONArray(MTConstants.TAGS);
            int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
            Set<String> tagSet = new HashSet<>();
            for (int i = 0; i < tags.size(); i++) {
                String tag = tags.getString(i);
                tagSet.add(tag);
            }
            String[] arr = tagSet.toArray(new String[0]);
            MTPushPrivatesApi.addTag(mWXSDKInstance.getContext(), sequence, arr);
        } else {
            MTLogger.w("there are no " + MTConstants.TAGS);
        }
    }

    @UniJSMethod(uiThread = true)
    public void updateTags(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        if (readableMap.containsKey(MTConstants.TAGS)) {
            JSONArray tags = readableMap.getJSONArray(MTConstants.TAGS);
            int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
            Set<String> tagSet = new HashSet<>();
            for (int i = 0; i < tags.size(); i++) {
                String tag = tags.getString(i);
                tagSet.add(tag);
            }
            String[] arr = tagSet.toArray(new String[0]);
            MTPushPrivatesApi.updateTag(mWXSDKInstance.getContext(), sequence, arr);
        } else {
            MTLogger.w("there are no " + MTConstants.TAGS);
        }
    }


    @UniJSMethod(uiThread = true)
    public void deleteTags(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        if (readableMap.containsKey(MTConstants.TAGS)) {
            JSONArray tags = readableMap.getJSONArray(MTConstants.TAGS);
            int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
            Set<String> tagSet = new HashSet<>();
            for (int i = 0; i < tags.size(); i++) {
                String tag = tags.getString(i);
                tagSet.add(tag);
            }
            String[] arr = tagSet.toArray(new String[0]);
            MTPushPrivatesApi.deleteTag(mWXSDKInstance.getContext(), sequence, arr);
        } else {
            MTLogger.w("there are no " + MTConstants.TAGS);
        }
    }

    @UniJSMethod(uiThread = true)
    public void cleanTags(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
        MTPushPrivatesApi.deleteAllTag(mWXSDKInstance.getContext(), sequence);
    }

    @UniJSMethod(uiThread = true)
    public void queryTag(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
        String tag = readableMap.getString(MTConstants.TAG);
        MTPushPrivatesApi.queryTag(mWXSDKInstance.getContext(), sequence, tag);
    }

    @UniJSMethod(uiThread = true)
    public void getAllTags(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
        MTPushPrivatesApi.queryAllTag(mWXSDKInstance.getContext(), sequence);
    }


    @UniJSMethod(uiThread = true)
    public void setAlias(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
        String alias = readableMap.getString(MTConstants.ALIAS);
        MTPushPrivatesApi.setAlias(mWXSDKInstance.getContext(), sequence, alias);
    }

    @UniJSMethod(uiThread = true)
    public void deleteAlias(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
        MTPushPrivatesApi.clearAlias(mWXSDKInstance.getContext(), sequence);
    }

    @UniJSMethod(uiThread = true)
    public void queryAlias(JSONObject readableMap) {
        updatePluginStatu();
        if (readableMap == null) {
            MTLogger.w(MTConstants.PARAMS_NULL);
            return;
        }
        int sequence = readableMap.getIntValue(MTConstants.SEQUENCE);
        MTPushPrivatesApi.getAlias(mWXSDKInstance.getContext(), sequence);
    }



    @Override
    public void destroy() {
        MTLogger.e("destroy");
        MTPushHelper.IS_DESTROY = true;
        MTPushHelper.eventCallback = new HashMap<>();
    }
}
