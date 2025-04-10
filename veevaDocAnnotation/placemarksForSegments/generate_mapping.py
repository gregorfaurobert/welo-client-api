import os
import json
import argparse
from src.segment_finder import find_segment_coordinates

def generate_position_mapping(pdf_path):
    """
    Generate position mapping for PDF segments using automatic segmentation.
    
    Args:
        pdf_path (str): Path to the PDF file
    """
    # Define paths
    source_dir = os.path.dirname(pdf_path)
    output_file = os.path.join(source_dir, 'segment_positions.json')
    
    # Find coordinates using automatic segmentation
    results = find_segment_coordinates(pdf_path, None)
    
    # Create a mapping dictionary
    mapping = {
        "document": os.path.basename(pdf_path),
        "segmentation_mode": "automatic",
        "total_segments": len(results),
        "segments": []
    }
    
    # Add each segment's information
    for result in results:
        segment_info = {
            "text": result['segment'],
            "page": result['page_number'],
            "position": {
                "x": result['x'],
                "y": result['y'],
                "width": result['width'],
                "height": result['height']
            },
            "coordinates": result['coordinates']
        }
        mapping["segments"].append(segment_info)
    
    # Write to JSON file
    with open(output_file, 'w') as f:
        json.dump(mapping, f, indent=2)
    
    print(f"\nPosition mapping saved to {output_file}")
    print(f"Total segments found: {len(results)}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Generate segment position mapping from PDF using automatic segmentation')
    parser.add_argument('pdf_file', help='Path to the PDF file')
    args = parser.parse_args()
    
    generate_position_mapping(args.pdf_file) 