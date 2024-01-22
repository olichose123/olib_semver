package olib.semver.tests;

import haxe.Json;
import utest.Assert;
import olib.semver.Version;

class Tests extends utest.Test
{
    function testRegex()
    {
        // ah, brute force testing
        Assert.isTrue(Version.validate("1.2.3"));
        Assert.isTrue(Version.validate("1.2.3-alpha"));
        Assert.isTrue(Version.validate("1.2.3-alpha.1"));
        Assert.isTrue(Version.validate("1.2.3-0.3.7"));
        Assert.isTrue(Version.validate("1.2.3-x.7.z.92"));
        Assert.isTrue(Version.validate("1.2.3-alpha+001"));
        Assert.isFalse(Version.validate("1.2.3-"));
        Assert.isFalse(Version.validate("1.2.3+"));
        Assert.isFalse(Version.validate("001.001.001"));
        Assert.isFalse(Version.validate("001"));
        Assert.isFalse(Version.validate("potato"));
    }

    function testVersionParts()
    {
        var v = new Version("1.2.3-alpha.1+001");
        Assert.equals(1, v.major);
        Assert.equals(2, v.minor);
        Assert.equals(3, v.patch);
        Assert.equals("alpha.1", v.prerelease);
        Assert.equals("001", v.buildmetadata);

        v = new Version("1.2.3");
        Assert.equals(1, v.major);
        Assert.equals(2, v.minor);
        Assert.equals(3, v.patch);
        Assert.equals(null, v.prerelease);
        Assert.equals(null, v.buildmetadata);
    }

    function testVersionComparison()
    {
        Assert.isTrue(new Version("1.2.3") == new Version("1.2.3"));
        Assert.isTrue(new Version("1.2.3") <= new Version("1.2.3"));
        Assert.isTrue(new Version("1.2.3") >= new Version("1.2.3"));
        Assert.isTrue(new Version("1.2.3") < new Version("1.2.4"));
        Assert.isTrue(new Version("1.2.3") < new Version("1.3.0"));
        Assert.isTrue(new Version("1.2.3") < new Version("2.0.0"));
        Assert.isTrue(new Version("1.2.3") < new Version("2.0.0-alpha"));
        Assert.isTrue(new Version("1.2.3") < new Version("2.0.0-alpha.1"));
        Assert.isTrue(new Version("1.2.3-alpha") < new Version("1.2.3"));
        Assert.isTrue(new Version("1.2.3-alpha") < new Version("1.2.3-alpha.1"));
        Assert.isTrue(new Version("1.2.3-alpha") < new Version("1.2.3-beta"));
        Assert.isTrue(new Version("1.3.0").minorMatch(new Version("1.3.1")));
        Assert.isTrue(new Version("1.3.1").patchMatch(new Version("1.3.1-alpha.1")));
    }

    function testSerialization()
    {
        var v = new Version("1.2.3-alpha.1+001");
        var json = Json.stringify(v);
        var v2:Version = Json.parse(json);
        Assert.equals(v, v2);
    }
}
