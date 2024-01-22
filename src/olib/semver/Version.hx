package olib.semver;

import haxe.Exception;

abstract Version(String) from String
{
    static var regex:EReg = ~/^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$/;

    public static function validate(semver:String):Bool
    {
        return regex.match(semver);
    }

    public inline function new(version:String)
    {
        if (version == null)
        {
            this = null;
            return;
        }

        if (version.charAt(0) == "v")
            version = version.substr(1);

        if (!validate(version))
            throw new VersionException("Invalid version string: " + version);
        this = version;
    }

    public var major(get, never):Int;
    public var minor(get, never):Int;
    public var patch(get, never):Int;
    public var prerelease(get, never):String;
    public var buildmetadata(get, never):String;

    function get_major():Int
    {
        validate(this);
        return Std.parseInt(regex.matched(1));
    }

    function get_minor():Int
    {
        validate(this);
        return Std.parseInt(regex.matched(2));
    }

    function get_patch():Int
    {
        validate(this);
        return Std.parseInt(regex.matched(3));
    }

    function get_prerelease():String
    {
        validate(this);
        return regex.matched(4);
    }

    function get_buildmetadata():String
    {
        validate(this);
        return regex.matched(5);
    }

    public inline function minorMatch(version:Version):Bool
    {
        return major == version.major && minor == version.minor;
    }

    public inline function patchMatch(version:Version):Bool
    {
        return minorMatch(version) && patch == version.patch;
    }

    public inline function prereleaseMatch(version:Version):Bool
    {
        return patchMatch(version) && prerelease == version.prerelease;
    }

    @:op(a == b) public static function eq(a:Version, b:Version):Bool
    {
        return a.major == b.major && a.minor == b.minor && a.patch == b.patch && a.prerelease == b.prerelease && a.buildmetadata == b.buildmetadata;
    }

    @:op(a < b) public static function lt(a:Version, b:Version):Bool
    {
        if (a.major < b.major)
            return true;
        if (a.major > b.major)
            return false;
        if (a.minor < b.minor)
            return true;
        if (a.minor > b.minor)
            return false;
        if (a.patch < b.patch)
            return true;
        if (a.patch > b.patch)
            return false;
        if (a.prerelease == null && b.prerelease != null)
            return false;
        if (a.prerelease != null && b.prerelease == null)
            return true;
        if (a.prerelease == null && b.prerelease == null)
            return false;
        return a.prerelease < b.prerelease;
    }

    @:op(a > b) public static function gt(a:Version, b:Version):Bool
    {
        return b < a;
    }

    @:op(a <= b) public static function le(a:Version, b:Version):Bool
    {
        return a < b || a == b;
    }

    @:op(a >= b) public static function ge(a:Version, b:Version):Bool
    {
        return a > b || a == b;
    }
}

class VersionException extends Exception {}
