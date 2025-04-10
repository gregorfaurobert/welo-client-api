# PDF Segment Coordinate Finder

A Python application that finds the coordinates of text segments within PDF documents.

## Features

- Extract coordinates of specific text segments from PDFs
- REST API endpoint for easy integration
- Comprehensive error handling
- Logging for debugging and monitoring

## Installation

1. Clone the repository
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

### As a Python Module

```python
from src.segment_finder import find_segment_coordinates

segments = ["Your text segment 1", "Your text segment 2"]
results = find_segment_coordinates("path/to/your.pdf", segments)
```

### As an API

1. Start the Flask server:
   ```bash
   python src/api.py
   ```

2. Send a POST request to `http://localhost:5000/segments`:
   ```json
   {
       "pdf_path": "path/to/your.pdf",
       "segments": ["Your text segment 1", "Your text segment 2"]
   }
   ```

## Testing

Run the tests using pytest:
```bash
pytest tests/
```

## Project Structure

```
.
├── requirements.txt
├── src/
│   ├── __init__.py
│   ├── segment_finder.py
│   └── api.py
├── tests/
│   ├── __init__.py
│   ├── test_data/
│   │   └── sample.pdf
│   └── test_segment_finder.py
└── README.md
```

## Dependencies

- PyMuPDF (fitz)
- Flask
- python-dotenv
- pytest

## License

MIT License 