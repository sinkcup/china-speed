# 计算机技术分享：中国速度

## apt source

```
find /etc/apt/ -name "*.list" -print0 | xargs -0 sed -i 's/[a-z]\+.debian.org/mirrors.aliyun.com/g'

find /etc/apt/ -name "*.list" -print0 | xargs -0 sed -i 's/[a-z]\+.debian.org/mirrors.cloud.tencent.com/g'
```
