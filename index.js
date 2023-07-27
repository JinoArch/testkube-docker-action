// index.js
const { exec } = require('child_process');
const core = require('@actions/core');

async function run() {
  try {
    // Get user inputs or use default values
    const testkubeVersion = core.getInput('testkube-version') || '1.11.19';
    // const kubectlVersion = core.getInput('kubectl-version') || 'v1.27.4';

    // Install Testkube
    await executeCommand(`curl -LO https://github.com/testkube/testkube/releases/download/v${testkubeVersion}/testkube_${testkubeVersion}_linux_amd64.tar.gz`);
    await executeCommand(`tar -xzf testkube_${testkubeVersion}_linux_amd64.tar.gz`);
    await executeCommand(`mv testkube /usr/local/bin/`);

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
