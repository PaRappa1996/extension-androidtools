package android;

#if (!android && !native && macro)
#error 'extension-androidtools is not supported on your current platform'
#end
import lime.system.JNI;
import lime.utils.Log;

/**
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
class Tools
{
	/**
	 * Launches a app by the `packageName`.
	 */
	public static function launchPackage(packageName:String, requestCode:Int = 1):Void
	{
		var launchPackage_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'launchPackage', '(Ljava/lang/String;I)V');
		launchPackage_jni(packageName, requestCode);
	}

	/**
	 * Returns `true` If the device have root.
	 * Returns `false` If the device doesn't have root or there`s a error while the process is runned.
	 */
	public static function isRooted():Bool
	{
		var isRooted_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'isRooted', '()Z');
		return isRooted_jni();
	}

	/**
	 * Returns whether the device is running Android TV.
	 */
	public static function isAndroidTV():Bool
	{
		var isAndroidTV_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'isAndroidTV', '()Z');
		return isAndroidTV_jni();
	}

	/**
	 * Returns whether the device is a ChromeBook.
	 */
	public static function isChromeBook():Bool
	{
		var isChromeBook_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'isChromeBook', '()Z');
		return isChromeBook_jni();
	}

	/**
	 * Sets brightness of the main window, max is 1 and min is 0.
	 */
	public static function setBrightness(screenBrightness:Float):Void
	{
		if (screenBrightness > 1)
			screenBrightness = 1;
		else if (screenBrightness < 0)
			screenBrightness = 0;

		var setBrightness_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'setBrightness', '(F)V');
		setBrightness_jni(screenBrightness);
	}

	/**
	 * Return the brightness of the main window.
	 */
	public static function getBrightness():Float
	{
		var getBrightness_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'getBrightness', '()F');
		return getBrightness_jni();
	}

	/**
	 * Makes the Device to vibrate, the time is in miliseconds btw.
	 */
	public static function vibrate(duration:Int, period:Int = 0):Void
	{
		var vibrate_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'vibrate', '(II)V');

		if (Permissions.getGrantedPermissions().contains(Permissions.VIBRATE))
			vibrate_jni(duration, period);
		else
			Log.warn("VIBRATE permission isn't granted, we can't vibrate the device.");
	}
}
