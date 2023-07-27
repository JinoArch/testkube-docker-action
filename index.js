// index.js
const { exec } = require('child_process');
const core = require('@actions/core');

async function run() {
  try {
    // Get user inputs or use default values
    const testkubeVersion = core.getInput('testkube-version') || '1.11.19';
    // const kubectlVersion = core.getInput('kubectl-version') || 'v1.27.4';

    // Install Testkube
    await executeCommand(`curl -LO https://github.com/kubeshop/testkube/releases/download/v${testkubeVersion}/testkube_${testkubeVersion}_Linux_x86_64.tar.gz`);
    await executeCommand(`tar -xvf testkube_${testkubeVersion}_Linux_x86_64.tar.gz`);
    await executeCommand(`mv kubectl-testkube /usr/local/bin/`);
    await executeCommand(`kubectl testkube version`);

    core.info('Testkube installation completed successfully!');
  } catch (error) {
    core.setFailed(`Action failed with error: ${error.message}`);
  }
}

async function executeCommand(command) {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        reject(error);
      } else {
        resolve(stdout);
      }
    });
  });
}

run();
