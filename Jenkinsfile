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
    }
    stage('构建') {
      steps {
        sh 'apt-get install -y python3-pip'
        sh 'pip3 install mkdocs'
        sh './build-docs.sh'
      }
    }
    stage('部署') {
      steps {
        sh "coscmd config -a ${env.COS_SECRET_ID} -s ${env.COS_SECRET_KEY}" +
           " -b ${env.COS_BUCKET_NAME} -r ${env.COS_BUCKET_REGION}"
        sh 'coscmd upload -r ./site/ /'
      }
    }
  }
}
