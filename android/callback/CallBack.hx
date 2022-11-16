package android.callback;

#if (!android && !native && macro)
#error 'extension-androidtools is not supported on your current platform'
#end
import android.callback.CallBackEvent;
import android.widget.Toast;
import lime.system.JNI;
import openfl.events.EventDispatcher;
import haxe.Json;

/**
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
#if !debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.system.JNI)
class CallBack
{
	private static var initialized:Bool = false;
	private static var dispatcher:EventDispatcher = new EventDispatcher();

	public static function init():Void
	{
		if (initialized)
			return;

		var initCallBack_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'initCallBack', '(Lorg/haxe/lime/HaxeObject;)V');
		initCallBack_jni(new CallBackHandler());

		initialized = true;
	}

	public static function addEventListener(type:String, listener:Dynamic, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
		dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);

	public static function removeEventListener(type:String, listener:Dynamic, useCapture:Bool = false):Void
		dispatcher.removeEventListener(type, listener, useCapture);

	public static function dispatchEvent(event:CallBackEvent):Void
		dispatcher.dispatchEvent(event);

	public static function hasEventListener(type:String):Bool
		return dispatcher.hasEventListener(type);
}

private class CallBackHandler
{
	public function new() {}

	public function onActivityResult(content:String):Void
	{
		var daEvent:CallBackEvent = new CallBackEvent(CallBackEvent.ACTIVITY_RESULT, Json.parse(content));		
		CallBack.dispatchEvent(daEvent);
	}

	public function onRequestPermissionsResult(content:String):Void
	{
		var daEvent:CallBackEvent = new CallBackEvent(CallBackEvent.REQUEST_PERMISSIONS_RESULT, Json.parse(content));		
		CallBack.dispatchEvent(daEvent);
	}
}
