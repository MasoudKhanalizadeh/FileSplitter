# File Splitter

File Splitter is a flexible Bash script designed to divide files into halves, thirds, or quarters while logging the entire process for debugging and record-keeping. This tool is ideal for scenarios where you need to process large files or analyze data in smaller, manageable chunks.

---

## Features

- **Flexible Splitting**: Divide files into:
  - Two equal parts (halves)
  - One-third and two-thirds
  - One-quarter and three-quarters
- **Logging**: Generates a detailed log file (`Splitter_log.txt`) for each operation, capturing steps and results.
- **Validation**: Ensures valid input and handles errors gracefully.

---

## Requirements

- Bash (v4.0 or higher)
- `wc` and `split` commands (pre-installed on most Unix-like systems)

---

## Usage

1. Clone the repository:
   ```bash
   git clone <repository_url>
   cd FileSplitter
   ```

2. Make the script executable:
   ```bash
   chmod +x file_splitter.sh
   ```

3. Run the script:
   ```bash
   ./file_splitter.sh
   ```

4. Follow the prompts to select files and define splitting options.

---

## Example Output

For a file named `example.csv` with 100 lines, choosing to split into halves will result in:

- `half1_example.csv` with 50 lines
- `half2_example.csv` with 50 lines

The log file (`Splitter_log.txt`) will include:
- Number of lines in the original file
- Lines in each split file
- Ratio and division results

---

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

---

## Author

**Masoud Khanalizadeh Imani**  
Contact: masoud.khanalizadehimani@gmail.com  
Date: 23 Jan 2025

---

## Contributing

Feel free to submit issues or feature requests through the GitHub repository. Contributions are welcome via pull requests.

