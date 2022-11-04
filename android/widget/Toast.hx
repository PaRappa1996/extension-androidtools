package android.widget;

#if (!android && !native && macro)
#error 'extension-androidtools is not supported on your current platform'
#end
import lime.system.JNI;

/**
 * @see https://developer.android.com/reference/android/widget/Toast
 * 
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
#if !debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.system.JNI)
class Toast
{
	public static final LENGTH_SHORT = 0;
	public static final LENGTH_LONG = 1;

	/**
	 * Makes a toast text.
	 */
	public static function makeText(text:String, duration:Int):Void
	{
		var toast_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'toast', '(Ljava/lang/String;I)V');
		toast_jni(text, duration);
	}
}
