#!groovy


KubeDeploy(
    docker: [
        file: 'docker/docs.dockerfile',
        repo: 'wallarm-dkr-infra.jfrog.io',
        image: 'wallarm-docs-ru'
    ],
    helm: [
        repo: 'wallarm/helm',
        baseVersion: '0.2.0'
    ],
    deploy: [
        cluster: 'infra',
        release: 'wallarm-docs-ru'
    ])
