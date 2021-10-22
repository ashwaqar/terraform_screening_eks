pipeline {
    options {
        buildDiscarder(logRotator(
            numToKeepStr: '15',
            daysToKeepStr: '30'
        ))
        disableConcurrentBuilds()
    }

    agent {
        node {
            label 'master'
            customWorkspace "${JENKINS_HOME}/workspace/${JOB_NAME}/${BUILD_NUMBER}"
        }
    }

    parameters {
        booleanParam(
            name: 'APPLY',
            defaultValue: false,
            description: 'The infra will be applied to the chosen environment.'
        )
        booleanParam(
            name: 'DESTROY',
            defaultValue: false,
            description: 'The infra will be destroyed in the chosen environment.'
        )
        choice(
            name: 'TARGET_ENVIRONMENT',
            choices: ['sandbox','dev','sqa','val','staging','prod'],
            description: 'Infra deployment environment'
        )
    }

    environment {
        TF_AWS_ACCOUNT  = "${ (params.TARGET_ENVIRONMENT in ['prod']) ? 'lunar2-production' : 'lunar2-non-production' }"
    }

    stages {
        stage("Prisma IAC Scan") {
            steps {
                script {
                    prismaIaC assetName: 'screening-prisma-terraform-scan',
                        failureCriteriaHigh: '1000',
                        failureCriteriaLow: '1000',
                        failureCriteriaMedium: '1000',
                        failureCriteriaOperator: 'AND',
                        tags: "env:${params.TARGET_ENVIRONMENT}, repo:${env.JOB_BASE_NAME}, branch: ${env.BRANCH_NAME}",
                        templateType: 'TF',
                        templateVersion: ''
                }
            }
        }
        stage("Define Environment Variables") {
            environment {
                AWS_ACCESS_KEY_ID       = credentials("${env.TF_AWS_ACCOUNT}_TERRAFORM_ACCESS_KEY")
                AWS_SECRET_ACCESS_KEY   = credentials("${env.TF_AWS_ACCOUNT}_TERRAFORM_SECRET_KEY")
            }
            stages {
                stage("Init-Validate-Plan-Apply") {
                    steps {
                        script {
                            sh """
                                terraform init \
                                    -input=false \
                                    -backend-config=environments/${params.TARGET_ENVIRONMENT}/remote-backend.properties
                                terraform validate
                                terraform plan \
                                    -out=${params.TARGET_ENVIRONMENT}_tfplan \
                                    -var-file=environments/${params.TARGET_ENVIRONMENT}/terraform.tfvars
                            """
                            if (params.APPLY) {
                                sh "terraform apply ${params.TARGET_ENVIRONMENT}_tfplan"
                            }
                        }
                    }
                }
                stage("Terraform destroy") {
                    when {
                        expression {
                            (params.DESTROY == true)
                        }
                    }
                    steps {
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }
    }
}
