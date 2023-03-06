pipeline {
  agent any
  input {
    message:"Would you like to provision or destroy the infrastructure?"
    ok "Done"
    parameters {
      choice (name: 'Infrastructure', choices:['Provision', 'Destroy'])
    }
  }

  environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = 'ap-southeast-2'
      }

  stages {

    stage('Provisioning infrastructure'){
        when {
            expression {
                params.Infrastructure == 'Provision'
            }
        }
      steps {
        sh 'terraform init'
        sh 'terraform apply --auto-approve'
      }

    }

    stage('Deploy infrastructure') {
      when {
            expression {
                params.Infrastructure == 'Destroy'
            }
        }
      steps {      
        sh 'terraform destroy --auto-approve'
      }
    }
  }

}


