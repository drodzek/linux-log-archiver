# Linux Log Archiver

A specialized Bash utility designed for automated log file archiving and rotation. This tool provides a robust way to manage system logs by organizing, compressing, and cleaning up old data to maintain optimal disk space.

## Description

The script performs a recursive search within a specified root directory to identify files matching the `*.log.*` pattern. It processes them through the following workflow:

1.  **Renaming**: Files are renamed to follow the convention: `<original_prefix>.<date_time>.log.<remaining_part>`.
2.  **Compression**: Each renamed file is compressed into a `.gz` archive using `gzip`.
3.  **Retention**: The script automatically identifies and deletes `.gz` archives within the directory tree that are older than 10 days.

## Features

* **Recursive Processing**: Automatically traverses all subdirectories to find log files.
* **Idempotency**: Skips files that are already compressed (`.gz`), preventing redundant processing.
* **Collision Avoidance**: Uses a detailed timestamp (`YYYY-MM-DD_HHMM`) to prevent naming conflicts during multiple runs on the same day.
* **Space Management**: Integrated cleanup mechanism to maintain disk space.
* **Robustness**: Properly handles file names containing spaces and hidden files (dotfiles).

## Installation

1.  Clone or download the script files to your local machine.
2.  Grant execution permissions to the scripts:
    ```bash
    chmod +x log-archiver.sh setup-test-env.sh
    ```

## Usage

Run the main script by providing the target directory as the first argument:

```bash
./log-archiver.sh /path/to/directory
```

## Testing

A `setup-test-env.sh` script is provided to simulate a production-like environment. It creates a directory structure with various test cases:
* Standard log files ready for archiving.
* Log files with spaces in names.
* Hidden log files.
* Already compressed archives (to verify they are ignored).
* Expired archives (simulated 11 days old to verify deletion).
* Files that should be ignored (wrong patterns).

To run the full test suite:
1. Generate the test environment:
```bash 
./setup-test-env.sh /path/to/directory
```
2. Run the archiver:
```bash
./log-archiver.sh /path/to/directory
```

## Technical implementation details
* The script utilizes native Bash parameter expansion (`${filename%%.log.*}` and `${filename#*.log.}`) for string manipulation. This is significantly faster than spawning external processes like sed or awk.

* All variables are strictly quoted to ensure compatibility with filesystems containing spaces or special characters.

* The deletion mechanism uses the `-mtime` flag of the find command, which relies on the file system's modification timestamp rather than the date string in the filename, ensuring accurate data management.
