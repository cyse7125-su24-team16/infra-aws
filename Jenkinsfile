pipeline {
    agent any

    environment {
        GITHUB_CREDENTIALS_ID = 'github_token'
        DOCKER_CREDENTIALS_ID = 'docker_credentials'
        JENKINS_ADMIN_CREDENTIALS_ID = 'jenkins_credentials'
    }

    stages {
        stage('Checkout PR Branch') {
            steps {
                script {
                    try {
                        // Fetch the latest changes from the origin using credentials
                        withCredentials([usernamePassword(credentialsId: GITHUB_CREDENTIALS_ID, usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
                            sh 'git config --global credential.helper store'
                            sh 'echo "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com" > ~/.git-credentials'
                            // Fetch all branches including PR branches
                            sh 'git fetch origin +refs/pull/*/head:refs/remotes/origin/pr/*'
                            // Dynamically fetch the current PR branch name using environment variables
                            def prBranch = env.CHANGE_BRANCH
                            echo "PR Branch: ${prBranch}"
                            // Checkout the PR branch
                            sh "git checkout -B ${prBranch} origin/pr/${env.CHANGE_ID}"
                        }
                    } catch (Exception e) {
                        echo "Error during PR branch checkout: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Check Commit Messages') {
            steps {
                script {
                    try {
                        // Fetch the latest commit message in the PR branch
                        def latestCommitMessage = sh(script: "git log -1 --pretty=format:%s", returnStdout: true).trim()
                        echo "Latest commit message: ${latestCommitMessage}"

                        // Regex for Conventional Commits
                        def pattern = ~/^\s*(feat|fix|docs|style|refactor|perf|test|chore)(\(.+\))?: .+\s*$/

                        // Check the latest commit message
                        if (!pattern.matcher(latestCommitMessage).matches()) {
                            error "Commit message does not follow Conventional Commits: ${latestCommitMessage}"
                        }
                    } catch (Exception e) {
                        echo "Error checking commit messages: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Compare Changes') {
            steps {
                script {
                    try {
                        // Compare the PR branch with the main branch
                        def diff = sh(script: 'git diff origin/main...HEAD', returnStdout: true).trim()
                        echo "Git Diff: ${diff}"
                        if (diff == "") {
                            echo "No differences found."
                        } else {
                            echo "Differences found:\n${diff}"
                        }
                    } catch (Exception e) {
                        echo "Error comparing changes: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    try {
                        sh 'terraform init'
                        sh 'terraform init -upgrade'
                    } catch (Exception e) {
                        echo "Terraform init failed: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Terraform Format') {
            steps {
                script {
                    try {
                        def fmtResult = sh(script: 'terraform fmt -check > terraform_fmt_output.log 2>&1', returnStatus: true)
                        echo "Terraform fmt exit code: ${fmtResult}"
                        sh 'cat terraform_fmt_output.log'
                        if (fmtResult != 0) {
                            error 'Terraform formatting check failed'
                        }
                    } catch (Exception e) {
                        echo "Terraform format failed: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                script {
                    try {
                        def validateResult = sh(script: 'terraform validate > terraform_validate_output.log 2>&1', returnStatus: true)
                        echo "Terraform validate exit code: ${validateResult}"
                        sh 'cat terraform_validate_output.log'
                        if (validateResult != 0) {
                            error 'Terraform validation failed'
                        }
                    } catch (Exception e) {
                        echo "Terraform validate failed: ${e.getMessage()}"
                        currentBuild.result = 'FAILURE'
                        throw e
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                def setupResult = currentBuild.result == 'SUCCESS' ? 0 : 1
                if (setupResult != 0) {
                    error('One or more Terraform steps failed')
                }
            }
        }
        success {
            echo 'Build and Terraform checks succeeded!'
        }
        failure {
            echo 'Build or Terraform checks failed.'
        }
    }
}
