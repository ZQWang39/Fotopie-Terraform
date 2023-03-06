pipeline {
  agent any

  environment {
        AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_DEFAULT_REGION = 'ap-southeast-2'
      }

  stages {
    stage('Provisioning or Destroying infrastructure'){
      steps {
       input {
            message:"Do you want to provision or destroy the infrastructure?"
            ok "Done"
            parameters{
                choice(name:"infrastructure", choices:["provision", "destroy"], description:"Please choose" )
            }
        }
        if (infrastructure == 'Provision') {
              sh 'terraform init'
              sh 'terraform apply --auto-approve'
            } else if (infrastructure == 'Destroy') {
              sh 'terraform destroy --auto-approve'
            }
      }
    }
  }
}


