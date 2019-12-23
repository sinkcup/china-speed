pipeline {
    agent any
    stages  {
 
        stage("检出") {
            steps {
                checkout(
                    [$class: 'GitSCM', branches: [[name: env.GIT_BUILD_REF]], 
                    userRemoteConfigs: [[url: env.GIT_REPO_URL, credentialsId: env.CREDENTIALS_ID]]]
                )
            }
        }

        stage("构建") {
            steps {
                echo "构建中..."
                sh 'apt install -y python-pip'
                sh 'pip install mkdocs'
                sh './build-docs.sh'
                sh 'tar -zcf tmp.tar.gz apache2/ site/'
                echo "构建完成."
            }
        }

        stage("部署") {
            steps {
                echo "部署中..."
                script {
                    def remote = [:]
                    remote.name = 'web-server'
                    remote.allowAnyHosts = true
                    remote.host = '106.54.86.239'
                    remote.user = 'ubuntu'
                    // 需要先创建一对 SSH 密钥，把私钥放在 CODING 凭据管理，把公钥放在服务器的 `.ssh/authorized_keys`，实现免密码登录
                    withCredentials([sshUserPrivateKey(credentialsId: "c4af855d-402a-4f38-9c83-f6226ae3441c", keyFileVariable: 'id_rsa')]) {
                        remote.identityFile = id_rsa

                        // SSH 连接到远端服务器
                        sshPut remote: remote, from: 'tmp.tar.gz', into: '/var/www/'
                        sshCommand remote: remote, command: "sudo su; cd /var/www/; mkdir -p china-speed; cp -R site/* china-speed; cp -R apache2/ /etc/;"
                        sshCommand remote: remote, command: "sudo service apache2 restart"
                    }
                }
                echo "部署完成"
            }
        }
    }
}
