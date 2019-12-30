# 计算机技术分享：中国速度

由于 apt、composer、nodejs 等常用工具在国外，下载速度较慢，本站分享国内镜像信息，让开发者感受“中国速度”。

## apt source

```
find /etc/apt/ -name "*.list" -print0 | xargs -0 sed -i 's/[a-z]\+.debian.org/mirrors.aliyun.com/g'

find /etc/apt/ -name "*.list" -print0 | xargs -0 sed -i 's/[a-z]\+.debian.org/mirrors.cloud.tencent.com/g'
```

## composer setup

```
curl -sS http://getcomposer.org.mirrors.china-speed.org.cn/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
```

## composer mirror before lock

```
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer/

composer config -g --unset repos.packagist
```

## composer mirror when lock exists

```
url_suffix='.dist.mirrors[0].url="https://mirrors.aliyun.com/composer/dists/%package%/%reference%.%type%"'
jq '."packages"[]'"$url_suffix" composer.lock \
    | jq '."packages"[].dist.mirrors[0].preferred=true' \
    | jq '."packages-dev"[]'"$url_suffix" \
    | jq --indent 4 '."packages-dev"[].dist.mirrors[0].preferred=true' > composer.lock.tmp
mv composer.lock.tmp composer.lock
```

## nodejs setup

```
curl -sL https://deb.nodesource.com.mirrors.china-speed.org.cn/setup_12.x | sudo -E bash -
```

## npm registry

```
npm config set registry https://registry.npm.taobao.org
npm config set registry http://mirrors.cloud.tencent.com/npm/

npm config delete registry
```

## pip

```
mkdir ~/.pip
cat > ~/.pip/pip.conf << EOF
[global]
index-url=https://pypi.doubanio.com/simple/
#index-url=http://mirrors.aliyun.com/pypi/simple/
#index-url=http://mirrors.cloud.tencent.com/pypi/simple/
EOF
```

## acknowledgements

感谢 [腾讯云](https://cloud.tencent.com/act/cps/redirect?redirect=10042&cps_key=16b83d1aa2e322d67b11fa1daaa4ab6b)、[七牛云](https://portal.qiniu.com/signup?code=1h6w1ounb13yp) 提供云存储和国内 CDN。

感谢 [CODING 持续集成](https://coding.net/products/ci?cps_source=PIevZ6Jr) 提供免费的 Jenkins 云服务。

通过上述邀请链接注册，本站将获得流量奖励，供大家下载使用。
