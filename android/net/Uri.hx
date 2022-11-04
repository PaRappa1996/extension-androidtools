package android.net;

#if (!android && !native && macro)
#error 'extension-androidtools is not supported on your current platform'
#end
import lime.system.JNI;

/**
 * @see https://developer.android.com/reference/android/net/Uri
 * 
 * @author Mihai Alexandru (M.A. Jigsaw)
 */
#if !debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.system.JNI)
class Uri
{
	/**
	 * Decodes '%'-escaped octets in the given string using the UTF-8 scheme.
	 * Replaces invalid octets with the unicode replacement character ('\\uFFFD').
	 * 
	 * @param s encoded string to decode
	 */
	public static function decode(s:String):String
	{
		var decode_jni:Dynamic = JNI.createStaticMethod('android/net/Uri', 'decode', '(Ljava/lang/String;)Ljava/lang/String;');
		return decode_jni(s);
	}

	/**
	 * Encodes characters in the given string as '%'-escaped octets using the UTF-8 scheme.
	 * Leaves letters ('A-Z', 'a-z'), numbers ('0-9'), and unreserved characters ('_-!.~'()*') intact.
	 * Encodes all other characters.
	 * 
	 * @param s string to encode
	 */
	public static function encode(s:String):String
	{
		var encode_jni:Dynamic = JNI.createStaticMethod('android/net/Uri', 'encode', '(Ljava/lang/String;)Ljava/lang/String;');
		return encode_jni(s);
	}

	/**
	 * Creates a Uri from a file. The URI has the form 'file://'. Encodes path characters with the exception of '/'.
	 * Example: 'file:///tmp/android.txt'.
	 *
	 * @param path
	 */
	public static function fromFile(path:String):String
	{
		var fromFile_jni:Dynamic = JNI.createStaticMethod('org/haxe/extension/Tools', 'fromFile', '(Ljava/lang/String;)Ljava/lang/String;');
		return fromFile_jni(path);
	}
}
