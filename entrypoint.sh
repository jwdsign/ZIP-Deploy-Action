#!/bin/sh -l

M_LOCAL_DIR=${LOCAL_DIR:-"./"}
M_REMOTE_DIR=${REMOTE_DIR:-"~/"}
M_TEMP_DIR = ${TEMP_DIR:-"./"}

echo "Creating a zip file..."

cd $M_LOCAL_DIR

mkdir -v $M_TEMP_DIR

echo "Moving all files to wrapper directory..."

mv * .$M_TEMP_DIR/

cd $M_TEMP_DIR

echo "Zipping wrapper directory..."

zip ~/brainbox-theme-latest.zip -r ./ -x "src/*" -x ".git/*" -x ".github/*" -x ".gitattributes" -x ".gitignore" -x "bower.json" -x "package.json" -x "webpack.config.js"
cd ~/
echo "Zip file created."

echo "Deploying files"

sshpass -p $DEPLOY_PASSWORD scp -o StrictHostKeyChecking=no brainbox-theme-latest.zip ${DEPLOY_USERNAME}@${TARGET_SERVER}:${M_REMOTE_DIR}

sshpass -p $DEPLOY_PASSWORD ssh ${DEPLOY_USERNAME}@${TARGET_SERVER} bash -c "'

${EXTRA_COMMANDS}
'"
echo "Deploy completed"
