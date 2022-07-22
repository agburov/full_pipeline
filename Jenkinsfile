pipeline {
    agent any
    options {
            ansiColor('xterm')
        }

    parameters {
        string(name: 'environment', defaultValue: 'terraform', description: 'Folder environment used for deployment')
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        booleanParam(name: 'destroy', defaultValue: false, description: 'Destroy Terraform build?')

    }

     environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('checkout') {
            steps {
                 script{
                        dir("${environment}")
                        {
                            git "https://github.com/agburov/full_pipeline.git"
                        }
                    }
                }
            }

        stage('Plan') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }

            steps {
                dir("${environment}") {
                    sh 'terraform init -input=false'
                    sh 'terraform validate'
                    sh 'terraform plan -input=false -out=tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
               not {
                    equals expected: true, actual: params.destroy
                }
           }

           steps {
               script {
                   dir("${environment}") {
                        def plan = readFile 'tfplan.txt'
                        input message: "Do you want to apply the plan?",
                            parameters: [text(name: '', description: 'Check plan in console log', defaultValue: plan)]
                   }
               }
           }
       }

        stage('Apply') {
            when {
                not {
                    equals expected: true, actual: params.destroy
                }
            }

            steps {
                script {
                    dir("${environment}") {
                        sh "terraform apply -input=false tfplan"
                    }
                }
            }
        }

        stage('Destroy') {
            when {
                equals expected: true, actual: params.destroy
            }

        steps {
            script {
                dir("${environment}") {
                    sh "terraform destroy --auto-approve"
                }
            }
        }
    }
  }
}
