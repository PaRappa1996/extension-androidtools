package org.haxe.extension;

import android.app.Activity;
import android.app.KeyguardManager;
import android.app.KeyguardManager.KeyguardLock;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.util.Log;
import android.graphics.Point;
import android.net.Uri;
import android.os.PowerManager;
import android.os.PowerManager.WakeLock;
import android.os.Vibrator;
import android.view.Display;
import android.view.WindowManager;
import android.widget.Toast;

import org.haxe.extension.Extension;
import org.haxe.lime.HaxeObject;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class Tools extends Extension
{
    private static KeyguardLock keyguardLock = null;
    private static int resumeOrientation = 0;

    public static String[] getGrantedPermissions() {
        List<String> granted = new ArrayList<String>();

        try {
            PackageInfo packInfo =
                Extension.mainContext.getPackageManager().getPackageInfo(
                    Extension.mainContext.getPackageName(),
                    PackageManager.GET_PERMISSIONS);
            for (int i = 0; i < packInfo.requestedPermissions.length; i++) {
                if ((packInfo.requestedPermissionsFlags[i]
                        & PackageInfo.REQUESTED_PERMISSION_GRANTED)
                    != 0)
                    granted.add(packInfo.requestedPermissions[i]);
            }
        } catch (Exception e) {
            Log.e("Tools", e.toString());
        }

        return granted.toArray(new String[granted.size()]);
    }

    public static void requestPermissions(
        String[] permissions, int requestCode) {
        Extension.mainActivity.requestPermissions(permissions, requestCode);
    }

    public static void setRequestedOrientation(int SCREEN_ORIENTATION) {
        switch (SCREEN_ORIENTATION) {
            case 0:
                Extension.mainActivity.setRequestedOrientation(
                    ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
                resumeOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
                break;
            case 1:
                Extension.mainActivity.setRequestedOrientation(
                    ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
                resumeOrientation =
                    ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE;
                break;
            default:
                Extension.mainActivity.setRequestedOrientation(
                    ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED);
                resumeOrientation = ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED;
                break;
        }
    }

    public static File getContextFilesDir() {
        return Extension.mainContext.getFilesDir();
    }

    public static String fromFile(String path) {
        return Uri.fromFile(new File(path)).toString();
    }

    public static void toast(final String message, final int duration) {
        Extension.mainActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(Extension.mainContext, message, duration).show();
            }
        });
    }

    public static void sendText(final String data, final String textType) {
        Intent sendIntent = new Intent();
        sendIntent.setAction(Intent.ACTION_SEND);
        sendIntent.putExtra(Intent.EXTRA_TEXT, data);
        sendIntent.setType(textType);

        Extension.mainActivity.startActivity(Intent.createChooser(sendIntent, null));
    }

    public static void launchApp(final String packageName) {
        Extension.mainActivity.startActivity(Extension.mainActivity.getPackageManager().getLaunchIntentForPackage(packageName));
    }

    public static void runIntent(final String action, final String uri) {
        Intent intent = new Intent(action);
        if (uri != null)
            intent.setData(Uri.parse(uri));

        Extension.mainActivity.startActivity(intent);
    }

    public static void setBrightness(float brightness) {
        WindowManager.LayoutParams layout =
            Extension.mainActivity.getWindow().getAttributes();
        layout.screenBrightness = brightness;
        Extension.mainActivity.getWindow().setAttributes(layout);
    }

    public static void vibrate(int duration) {
        ((Vibrator) mainContext.getSystemService(Context.VIBRATOR_SERVICE))
            .vibrate(duration);
    }

    public static void wakeUp() {
        PowerManager pm =
            (PowerManager) mainContext.getSystemService(Context.POWER_SERVICE);
        WakeLock wakeLock = pm.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK
                | PowerManager.ACQUIRE_CAUSES_WAKEUP,
            "Tools.class");
        wakeLock.acquire();
        wakeLock.release();
        wakeLock = null;

        KeyguardManager keyguardManager =
            (KeyguardManager) mainActivity.getSystemService(
                Activity.KEYGUARD_SERVICE);
        if (keyguardLock == null)
            keyguardLock =
                keyguardManager.newKeyguardLock(Activity.KEYGUARD_SERVICE);

        keyguardLock.disableKeyguard();
    }

    @Override
    public void onDestroy() {
        if (keyguardLock != null) {
            keyguardLock.reenableKeyguard();
            keyguardLock = null;
        }
    }

    @Override
    public void onPause() {
        if (keyguardLock != null)
            keyguardLock.reenableKeyguard();
    }

    @Override
    public void onResume() {
        if (resumeOrientation != 0)
            Extension.mainActivity.setRequestedOrientation(resumeOrientation);
    }
}
