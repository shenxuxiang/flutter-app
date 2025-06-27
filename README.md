# qm_agricultural_machinery_services

an hui qianmo agricultural machinery services application

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 启动项目

```shell
flutter run --dart-define=ENV=development
```

## 打包 APK

每次打包 APK 时，都应该在将版本号 +1。

```shell
flutter build apk --split-per-abi --dart-define=ENV=development --build-name=1.1.1
```

## 查看 release 版本的 SHA1

```shell
keytool -list -v -keystore ./android/release-keystore.jks
```

## 导出证书

```shell
keytool -export -alias release-keystore -keystore ./release-keystore.jks -file certificate.cer
```

## 生成公钥

要获取16进制的公钥字符串，必须先导出证书，另外，在导出证书时不能使用 `-rfc`
参数，否则下方命令将找不到 `./certificate.cer` 文件。

```shell
openssl x509 -inform der -in ./certificate.cer -noout -modulus
```

打印结果:
`Modulus=9ED21C9BBD723A62C012D6724BBE84C49B11753263DAE8CF797DA2891E06AC9EC61D6F55BB7D74B1ECB9C6B4A5EA84102666EB4C9FF8CB3A7E1219FB7B23EBC5FFA0C2AF673667409B96F4B25F70E4F28CDA51CCBEB54507FEF607C3E3942F11DBFA0FE8005C30B0C1DC2DD7A4506DD5B236EB07F28E47ABDFBBE4203CD5B7578D8E1AEE0EF8A569032DB7FC09B4D40C101D7FF513FEBA0793236904B93E61ED5157C09D6672EA8EAAE09F6C70A6C5F742FB9C739061F0FF6449C8FDF6C931838793CAC4FACA3ACCF48577A1A5546C3AD12BD8470E60EA2F988B9F66CBFC8FE51BC990E97C47A295DFAB148FE387D025D229C4CFB2346A1486523563681250FB`
这里我们只需要获取等号后面的 16进制的字符串即可。

## 获取 MD5指纹

```shell
openssl x509 -in certificate.cer -noout -fingerprint -md5
```

打印结果: `md5 Fingerprint=1C:0F:02:F2:A6:5A:F3:80:C0:4E:1C:69:B3:2C:B3:4E`

### 格式化指纹（备案要求）：

* 去掉冒号和空格
* 转为小写
* 最终格式：1C0F02F2A65AF380C04E1C69B32CB34E



