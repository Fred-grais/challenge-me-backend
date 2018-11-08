#!/usr/bin/env bash
curl --user 16c6acaa597a1a1099023489f9a81b170df292eb: \
    --request POST \
    --form revision=abb07d43d96790ee4452d0bb5879fd2ac57e9264\
    --form config=@config.yml \
    --form notify=false \
        https://circleci.com/api/v1.1/project/github/Fred-grais/challenge-me-front/tree/master
