# olib_semver - semver features in a string abstract

* Using [utest](https://github.com/haxe-utest/utest) for testing.

Nearly complete Semantic Versioning 2.0.0 implementation in Haxe. As it is now, only the prerelease comparison is not totally implemented.

Why? There are a few other semver implementations in Haxe, but most use a class instead of a string abstract. This means that you have to design custom serialization and deserialization logic to handle them. With an abstract, serializers see the version as what it is: a string.

```haxe
var v = new Version("1.2.3-alpha.1+001");
var json = Json.stringify(v);
var v2:Version = Json.parse(json);
```


## Installation

```bash
haxelib install olib_semver
```

## Usage

```haxe
import olib.semver.Version;

var version:Version = "1.1.0"; //valid
var version_with_v:Version = "v1.1.2"; //also valid, the v is ignored
var version_with_prerealase:Version = "1.1.2-alpha";
var version_with_prerealase_and_metadata:Version = "1.1.2-alpha+build.123";

version != version_with_v; //true, including prerelease and build metadata
version.minorMatch(version_with_v); //true, ignores patch (in this case, _._.2), prerelease and build metadata
version_with_prerealase.patchMatch("1.1.2-beta"); //true, ignores prerelease and build metadata
version_with_prerealase_and_metadata.prereleaseMatch("1.1.2-alpha+potato"); //true, ignores build metadata
```
