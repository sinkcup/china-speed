pipeline {
  agent any
  stages {
    stage('检出') {
      steps {
        checkout(
          [$class: 'GitSCM', branches: [[name: env.GIT_BUILD_REF]],
          userRemoteConfigs: [[url: env.GIT_REPO_URL, credentialsId: env.CREDENTIALS_ID]]]
        )
      }
    }
    stage('测试') {
      steps {
        echo '检查中文 markdown 编写格式规范'
        sh 'npx lint-md-cli *.md'
    }
    stage('构建') {
      steps {
        echo '构建中...'
        sh 'apt-get install -y python3-pip'
        sh 'pip3 install mkdocs'
        sh './build-docs.sh'
        // 打包成压缩包
        sh 'tar -zcf tmp.tar.gz apache2/ site/'
        echo '构建完成.'
      }
    }
    stage('部署') {
      steps {
        echo '部署中...'
        script {
          def remote = [:]
          remote.name = 'web-server'
          remote.allowAnyHosts = true
          remote.host = '106.54.86.239'
          remote.user = 'ubuntu'
          // 需要先创建一对 SSH 密钥，把私钥放在 CODING 凭据管理，把公钥放在服务器的 `.ssh/authorized_keys`，实现免密码登录
          withCredentials([sshUserPrivateKey(credentialsId: "c4af855d-402a-4f38-9c83-f6226ae3441c", keyFileVariable: 'id_rsa')]) {
            remote.identityFile = id_rsa

            // SSH 上传文件到远端服务器
            sshPut remote: remote, from: 'tmp.tar.gz', into: '/tmp/'
            // 解压缩
            sshCommand remote: remote, command: "tar -zxf /tmp/tmp.tar.gz -C /tmp/"
            sshCommand remote: remote, sudo: true, command: "mkdir -p /var/www/china-speed"
            sshCommand remote: remote, sudo: true, command: "cp -R /tmp/site/* /var/www/china-speed/"
            sshCommand remote: remote, sudo: true, command: "cp -R /tmp/apache2/ /etc/"
            // 重启 apache2
            sshCommand remote: remote, sudo: true, command: "a2ensite china-speed.org.cn"
            sshCommand remote: remote, sudo: true, command: "a2enmod headers rewrite ssl"
            sshCommand remote: remote, sudo: true, command: "systemctl reload apache2"
          }
        }

        echo '部署完成'
      }
    }
  }
}
