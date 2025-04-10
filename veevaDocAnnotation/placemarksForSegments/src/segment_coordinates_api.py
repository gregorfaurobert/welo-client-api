import sys
import json
from segment_finder import find_segment_coordinates
import logging
from pathlib import Path

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main():
    if len(sys.argv) != 2:
        print("Usage: python segment_coordinates_api.py <request_json_file>")
        print("Example: python segment_coordinates_api.py requestSample.json")
        sys.exit(1)

    json_file = sys.argv[1]
    try:
        json_path = Path(json_file)
        with open(json_path, 'r') as f:
            data = json.load(f)
        
        if not isinstance(data, dict) or "pdf_path" not in data or "segments" not in data:
            print("Error: JSON file must contain 'pdf_path' and 'segments' fields")
            sys.exit(1)
            
        pdf_path = data["pdf_path"]
        segments = data["segments"]
        
        if not isinstance(segments, list):
            print("Error: segments must be a list")
            sys.exit(1)
            
        # Check if PDF file exists
        if not Path(pdf_path).exists():
            print(f"Error: PDF file not found at {pdf_path}")
            sys.exit(1)
            
        results = find_segment_coordinates(pdf_path, segments)
        
        # Save results to response.json in the same directory as the input JSON
        response_path = json_path.parent / 'response.json'
        with open(response_path, 'w') as f:
            json.dump(results, f, indent=2)
        print(f"Results saved to {response_path}")
        
    except json.JSONDecodeError:
        print(f"Error: {json_file} is not a valid JSON file")
        sys.exit(1)
    except Exception as e:
        logger.error(f"Error processing PDF: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    main() 