# 计算机技术分享：中国速度

由于 apt、composer、nodejs 等常用工具在国外，下载速度较慢，本站分享国内镜像加速信息，让开发者感受“中国速度”。

[![CODING 持续集成](https://china-speed.coding.net/badges/china-speed/job/126839/build.svg)](https://coding.net/products/ci?cps_source=PIevZ6Jr)
[![GitHub Actions](https://github.com/china-speed/china-speed.github.io/workflows/CI/badge.svg)](https://github.com/china-speed/china-speed.github.io/actions)

## apt ubuntu

```shell
find /etc/apt/ -name "*.list" -print0 | sudo xargs -0 sed -i 's/[a-z]\+.ubuntu.com/mirrors.aliyun.com/g'

find /etc/apt/ -name "*.list" -print0 | sudo xargs -0 sed -i 's/[a-z]\+..ubuntu.com/mirrors.cloud.tencent.com/g'
```

## apt debian

```shell
# 注意：debian docker apt 使用 HTTP，阿里云支持；而腾讯云只支持 HTTPS，需要额外安装 ca-certificates
# https://github.com/china-speed/docker-library/tree/master/debian

find /etc/apt/ -name "*.list" -print0 | xargs -0 sed -i 's/[a-z]\+.debian.org/mirrors.aliyun.com/g'
```

## get docker

```shell
# https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-convenience-script

curl -fsSL https://get.docker.com | sudo sh -s -- --mirror Aliyun
curl -fsSL http://get.docker.com.mirrors.china-speed.org.cn | sudo sh --

sudo usermod -aG docker $USER
```

## docker hub

```shell
sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": [
    "https://dockerhub.azk8s.cn",
    "https://hub-mirror.c.163.com"
  ]
}
EOF
sudo service docker restart
docker info
```

## docker gcr.io

```shell
# docker pull gcr.io/google_containers/hyperkube-amd64:v1.9.2

docker pull gcr.azk8s.cn/google_containers/hyperkube-amd64:v1.9.2
```

## docker mcr.microsoft.com

```shell
# docker pull mcr.microsoft.com/dotnet/core/runtime:3.1

docker pull mcr.azk8s.cn/dotnet/core/runtime:3.1
```

## get kubectl

```shell
# https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux

curl -LO http://storage.googleapis.com.mirrors.china-speed.org.cn/kubernetes-release/release/v1.14.8/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version
```

## get composer

```shell
curl -sS http://getcomposer.org.mirrors.china-speed.org.cn/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
```

## composer

```shell
composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/

composer config -g --unset repos.packagist
```

## composer install when lock exists

```shell
url_suffix='.dist.mirrors[0].url="https://mirrors.aliyun.com/composer/dists/%package%/%reference%.%type%"'
jq '."packages"[]'"$url_suffix" composer.lock \
    | jq '."packages"[].dist.mirrors[0].preferred=true' \
    | jq '."packages-dev"[]'"$url_suffix" \
    | jq --indent 4 '."packages-dev"[].dist.mirrors[0].preferred=true' > composer.lock.tmp
mv composer.lock.tmp composer.lock
```

## get nodejs npm

```shell
curl -sL https://deb.nodesource.com.mirrors.china-speed.org.cn/setup_12.x | sudo -E bash -
```

## npm

```shell
npm config set registry https://registry.npm.taobao.org
npm config set sass_binary_site https://npm.taobao.org/mirrors/node-sass

npm config set registry https://mirrors.cloud.tencent.com/npm/
npm config set sass_binary_site https://mirrors.cloud.tencent.com/npm/node-sass

npm config delete registry
```

## pip

```shell
mkdir ~/.pip
cat > ~/.pip/pip.conf << \EOF
[global]
index-url=https://pypi.doubanio.com/simple/
#index-url=https://mirrors.aliyun.com/pypi/simple/
#index-url=https://mirrors.cloud.tencent.com/pypi/simple/
EOF
```

## go

```shell
# goproxy.io 采用 腾讯云香港
# go env -w GOPROXY=https://goproxy.io,direct
# goproxy.cn 采用 七牛大陆 CDN
go env -w GOPROXY=https://goproxy.cn,direct
```

## gradle

```shell
sed -i 's/services.gradle.org/downloads.gradle-dn.com/g' ./gradle/wrapper/gradle-wrapper.properties
```

## gradle maven

```shell
mkdir ~/.gradle
cat > ~/.gradle/init.gradle << \EOF
def repoConfig = {
    all { ArtifactRepository repo ->
        if (repo instanceof MavenArtifactRepository) {
            def url = repo.url.toString()
            if (url.contains('repo1.maven.org/maven2')||url.contains('jcenter.bintray.com')) {
                println "gradle init: [buildscript.repositories] (${repo.name}: ${repo.url}) removed"
                remove repo
            }
        }
    }
    maven {
        url 'http://mirrors.cloud.tencent.com/nexus/repository/maven-public/'
    }
}

allprojects {
    buildscript {
        repositories repoConfig
    }

    repositories repoConfig
}
EOF
```

## acknowledgements

感谢 [腾讯云](https://cloud.tencent.com/act/cps/redirect?redirect=10042&cps_key=16b83d1aa2e322d67b11fa1daaa4ab6b)、[七牛云](https://portal.qiniu.com/signup?code=1h6w1ounb13yp) 提供云存储和国内 CDN。

感谢 [CODING 持续集成](https://coding.net/products/ci?cps_source=PIevZ6Jr) 提供免费的 Jenkins 云服务。

通过上述邀请链接注册，本站将获得流量奖励，供大家下载使用。
