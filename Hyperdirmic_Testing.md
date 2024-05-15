
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
Start the script manually from your command line to observe its initial behavior and verify the log and PID file creation.

### Instructions:
1. **Open a terminal.**
2. **Navigate to your script's directory** (if not already there):
   ```bash
   cd /path/to/your/script
   ```
   Replace `/path/to/your/script` with the actual path where `hyperdirmic.py` is located.
   
3. **Activate your virtual environment**:
   ```bash
   source /path/to/your/venv/bin/activate
   ```
   Replace `/path/to/your/venv` with the path to the virtual environment associated with the script.
   
4. **Run the script** using the Python interpreter from your virtual environment:
   ```bash
   python /Users/drucial/scripts/hyperdirmic/hyperdirmic.py
   ```
   Ensure the path to `hyperdirmic.py` is correct as per your directory structure.

These steps will ensure that the script is running in the correct environment with all necessary dependencies loaded.

## Step 3: Functionality Tests

Testing how your script handles different file types and directories is essential for ensuring it performs as expected.

### 3.1 File Handling

Create various file types in the monitored directories and observe how the script processes them.

#### Instructions:

1. **Open a terminal.**

2. **Navigate to the Desktop directory**:
```bash
cd ~/Desktop
```

3. **Create text, image, and other types of files**:
   - **Create a .txt, .jpeg & .png file**:
 ```bash
 echo "Sample text content" > sample.txt
 echo "This is a dummy image file content" > image.jpg
 echo "This is also dummy image file content" > image.png
 ```

4. **Repeat file creation in the Downloads directory**:
```bash
cd ~/Downloads
echo "Sample text content for Downloads" > sample.txt
echo "Dummy image content for Downloads" > image.jpg
echo "More dummy image content for Downloads" > image.png
```

5. **Monitor the log and destination directories**:
   - Check the log file to see how these creations are recorded:
 ```bash
 cat /tmp/hyperdirmic.log
 ```
   - Verify that the files are moved to the correct destination directories:
 ```bash
 ls ~/Downloads/TextFiles
 ls ~/Downloads/Images
 ```

### 3.2 Directory Ignoring

Create directories within `~/Desktop` and `~/Downloads` to ensure they are ignored by the script.

#### Instructions:

1. **Create a new directory on the Desktop**:
```bash
mkdir ~/Desktop/new_directory
```

2. **Create a new directory in Downloads**:
```bash
mkdir ~/Downloads/new_directory
```

3. **Verify that these directories are not processed by the script**:
   - Look for any entries in the log file about these directories:
 ```bash
 cat /tmp/hyperdirmic.log | grep new_directory
 ```
   - There should be no movement or processing logs for these directories if the script correctly ignores them.

### Step 3.3 Log Verification

After performing file operations, verify that the log entries are recorded correctly in the script's log file.

### Instructions:

1. **Open a terminal.**

2. **Use the `cat` command to view the log file**:
   ```bash
   cat /tmp/hyperdirmic.log
   ```

3. **Review the contents of the log file**:
   - Ensure that there are entries corresponding to each file operation you tested (e.g., moving files, handling errors).
   - Look for any error messages or warnings that may indicate problems.
   - Confirm that the actions logged match the expected behavior described in your script's documentation.

These steps will help you ensure that the script is logging its operations correctly and that any unexpected behavior is documented for further investigation.

## Step 4: Error Handling Tests

Testing how your script handles errors is crucial to ensuring that it can gracefully recover from unexpected situations and log these events properly.

### 4.1 Simulate Errors

### Instructions:

1. **Simulate file access errors by using read-only files**:
   - **Create a read-only text file in the monitored directory**:
 ```bash
 cd ~/Desktop
 echo "This file is read-only" > readonly.txt
 chmod 444 readonly.txt
 ```
   - **Verify that the script attempts to process the file and logs the error**:
 ```bash
 tail -f /tmp/hyperdirmic.log
 ```
   - After testing, remove the read-only attribute if needed:
 ```bash
 chmod 644 readonly.txt
 ```

2. **Simulate missing destination directory errors**:
   - **Temporarily rename a destination directory**:
 ```bash
 mv ~/Downloads/TextFiles ~/Downloads/TextFiles_backup
 ```
   - **Create a new text file to trigger the script**:
 ```bash
 echo "Test file for missing directory" > ~/Desktop/testfile.txt
 ```
   - **Check the log for error entries regarding the missing destination directory**:
 ```bash
 cat /tmp/hyperdirmic.log | grep "does not exist"
 ```
   - **Restore the original directory name after testing**:
 ```bash
 mv ~/Downloads/TextFiles_backup ~/Downloads/TextFiles
 ```

3. **Simulate a high-load condition to test script responsiveness under stress**:
   - **Generate multiple files rapidly in the monitored directory**:
 ```bash
 for i in {1..100}; do echo "File $$i content" > ~/Desktop/loadtest_$$i.txt; done
 ```
   - **Monitor system resources and log output during this test**:
 ```bash
 top -pid $(pgrep -f hyperdirmic.py)
 ```
   - **Review the logs for any errors or slow processing times**:
 ```bash
 cat /tmp/hyperdirmic.log
 ```

These steps will help you ensure that your script can handle errors robustly, logging them appropriately, and maintaining functionality under various error conditions. Document all findings for each test scenario.

## Step 5: Performance Monitoring

It's important to monitor the script's resource usage to ensure it operates within acceptable limits.

### Instructions:

1. **Open a terminal.**

2. **Monitor CPU and Memory Usage**:
    - **Use the `top` command to monitor real-time CPU and memory usage**:
 ```bash
 top -pid <PID>
 ```
Replace `<PID>` with the Process ID of your script. This command gives a dynamic view of your script's resource consumption.

    - **Alternatively, use the `ps` command for a snapshot of resource usage**:
 ```bash
 ps -o %cpu,%mem,pid -p <PID>
 ```
Again, replace `<PID>` with the Process ID of your script. This command provides CPU and memory usage percentages along with the PID for quick reference.

3. **Analyze the Output**:
   - Check the CPU percentage to ensure it does not consistently utilize a high percentage of the CPU unless expected based on script operations.
   - Monitor the memory usage to verify that it does not increase indefinitely, which could indicate a memory leak.

4. **Document the observations for any anomalies**:
   - Record the times and conditions under which the resource usage spikes or deviates from normal patterns.
   - Keep these records for further analysis or future reference to understand the script's impact on system performance.

These monitoring tools will help you keep an eye on how resource-intensive your script is, ensuring it runs efficiently without unduly affecting system performance.

## Step 6: Clean-up Tests

Testing the clean-up process is crucial to ensure that your script properly handles termination and removes any temporary files like PID files.

### Instructions:

1. **Start the script**:
   Ensure your script is running by following the steps provided in previous sections to start it.

2. **Stop the script**:
   - **If running in a terminal, use CTRL+C to terminate it**:
     This action sends a SIGINT to the script, which should trigger any cleanup procedures coded in your script's exception handling.
   
   - **Alternatively, send a termination signal manually**:
 ```bash
 kill -SIGINT <PID>
 ```
 Replace `<PID>` with the Process ID of your script. This method is useful if you're not directly in the terminal where the script is running.

3. **Verify removal of the PID file**:
   - **Check if the PID file has been removed**:
 ```bash
 ls /tmp/hyperdirmic.pid
 ```
 This command should return "No such file or directory" if the PID file was successfully removed.

4. **Document the results**:
   - **Confirm that the PID file is always removed upon script termination**.
   - **Note any instances where the PID file remains**, as this could indicate an issue in the script's termination or clean-up logic.

These steps ensure that your script does not leave behind any residue or temporary files that could interfere with future instances of the script running or affect system performance.

## Step 7: Review Logs

Reviewing the logs is crucial for understanding the script's behavior over time and confirming that all operational events and potential errors are logged correctly.

### Instructions:

1. **Open a terminal.**

2. **Use the `cat` or `less` command to view the log file**:
   - **To view the entire log file**:
 ```bash
 cat /tmp/hyperdirmic.log
 ```
 This command will display the entire content of the log file in the terminal.
   
   - **To view the log file with pagination**:
 ```bash
 less /tmp/hyperdirmic.log
 ```
 Using `less` allows you to navigate through the log file using arrow keys or spacebar to move page by page.

3. **Search for specific entries**:
   - **To search within the log file while using `less`**:
 ```bash
 less /tmp/hyperdirmic.log
 ```
 Once open, type `/` followed by the search term and press Enter. For example, `/error` will search for the term "error". Use `n` to jump to the next occurrence and `N` to go back to the previous one.

4. **Analyze the output**:
   - **Look for error messages** that might indicate operational problems.
   - **Ensure there are entries corresponding to each important operation** your script performs, like moving files or handling exceptions.
   - **Check for any unusual patterns or missing entries** that might suggest issues in logging logic or script execution.

5. **Document your findings**:
   - **Record any anomalies or consistent errors** you find, as these could be crucial for debugging and further development.
   - **Keep a log of log review dates and findings** for future reference or audit purposes.

These steps provide a systematic approach to effectively reviewing the log files generated by your script, ensuring that you capture and understand all relevant operational data and errors.

## Step 8: Automated Restart Test

This step ensures that the script is configured to start automatically after a system reboot, verifying its resilience and automatic initialization.

### 8.1 Formal Installation

Install the script using the provided installation script, which sets up everything needed for the script to run at system startup.

### Instructions:

1. **Run the Installation Script**:
   Ensure you are in the directory where `install_hyperdirmic.sh` is located, or provide the full path to it:
   ```bash
   ./install_hyperdirmic.sh
   ```
   This script will set up the virtual environment, install dependencies, configure the launch agent, and ensure everything is ready for the script to run automatically.

### 8.2 Reboot and Test

After installation, reboot the system to confirm that the script starts automatically and functions as expected.

### Instructions:

1. **Reboot the System**:
   You can use the command line to reboot:
   ```bash
   sudo reboot
   ```

2. **Verify that the Script Starts Automatically**:
   After the system restarts, open a terminal and check that the script is running:
   ```bash
   ps aux | grep hyperdirmic.py
   ```
   Additionally, check the log file to confirm that the script has resumed operations:
   ```bash
   cat /tmp/hyperdirmic.log
   ```

3. **Document the Results**:
   Ensure the script resumes its functionality without manual intervention post-reboot.
   Record any issues or irregularities observed post-reboot to ensure reliability and continuity.

These steps validate that your script is not only installed properly but also confirms that it will automatically start and operate correctly after the system has been restarted.


# Conclusion

This concludes the testing procedure.

Thank you for following through.
