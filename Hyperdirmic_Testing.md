
# Comprehensive Testing Steps for Hyperdirmic Script

## Step 1: Prepare Testing Environment
Ensure that the directories you are monitoring—`~/Desktop` and `~/Downloads`—exist and you have permission to write to them, and that no instances of the script are currently running.

### 1.1 Setup Directories
- Open a terminal.
- Check if these directories exist by running:
  ```
  ls ~/Desktop
  ls ~/Downloads
  ```
- If any directories do not exist, create them:
  ```
  mkdir ~/Desktop
  mkdir ~/Downloads
  ```

### 1.2 Check Initial Conditions
- Check for running instances:
  ```
  ps aux | grep hyperdirmic.py
  ```
- If running instances are found, terminate them:
  ```
  pkill -f hyperdirmic.py
  ```
- Remove existing PID and log files:
  ```
  rm -f /tmp/hyperdirmic.pid
  rm -f /tmp/hyperdirmic.log
  ```

## Step 2: Initial Run
Start the script manually from your command line or through your IDE. Observe the initial outputs and logs, and verify the creation of the PID file.

## Step 3: Functionality Tests
Drop different types of files into the monitored directories and ensure they are correctly moved according to the script's mapping.

### 3.1 File Handling
- Drop `.txt`, `.jpg`, and `.png` files into `~/Desktop` and `~/Downloads`.
- Check the appropriate destination directories.

### 3.2 Directory Ignoring
- Create a new directory inside the monitored folders and ensure it is ignored by the script.

### 3.3 Log Verification
- Check `/tmp/hyperdirmic.log` for appropriate log entries.

## Step 4: Error Handling Tests
Simulate errors to see how the script logs and handles them.

### 4.1 Simulate Errors
- Try renaming or removing destination folders during operation.
- Use read-only files to check error handling.

## Step 5: Performance Monitoring
Monitor the CPU and memory usage to ensure it is within acceptable limits.

## Step 6: Clean-up Tests
Use CTRL+C to stop the script and verify that the PID file is removed.

## Step 7: Review Logs
Review the logs in detail to confirm that all events are logged correctly.

## Step 8: Automated Restart Test
Reload the launch agent and reboot the system to ensure the script starts automatically and functions as expected.

## Step 9: Reporting Issues
Document any unexpected behavior or bugs thoroughly, including steps to reproduce.

# Conclusion
After completing these steps, your script should be thoroughly tested and ready for deployment. If you encounter any issues or need assistance with specific tests, please reach out for further guidance.
