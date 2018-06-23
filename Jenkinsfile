#!/usr/bin/env groovy

def orgPath = "src/github.com/ice-judge"
def repoPath = "${orgPath}/ICE"

def schedulerImg = "icejudge/scheduler"
def webImg = "icejudge/web
def judgerImg = "icejudge/judeger"

def pushImg(img) {
	if ("${BRANCH_NAME}" == "master"){
		img.push("latest")	
	}
	img.push("${BRANCH_NAME}-${COMMIT}")
}

node {
	try {
		stage("Checkout"){
			checkout scm
		}


		def scheduler	
		def judger
		def web
		
		stage("Build") {
			scheduler = docker.build(schedulerImg, "-f ./scheduler.Dockerfile .")
			web = docker.build("icejudge/web", "-f ./web.Dockerfile .")
			judger = docker.build("icejudge/judger", "-f ./judger.Dockerfile .")
			sh "docker-compose up -d"
		}
		
		stage("Unit Tests") {
			sh "docker-compose exec -T scheduler make test-go"
		}

		stage("Publish to Docker") {
			withDockerRegistry([ credentialsId: "icejudge-docke-credentials", url: "" ]) {
				COMMIT = "${GIT_COMMIT.substring(0,8)}"
				pushImg(scheduler)			
				pushImg(web)			
				pushImg(judger)			
			}
		}
	} catch (e) {
		throw e
	} finally {
		sh "docker-compose down || true"
	}
}	
