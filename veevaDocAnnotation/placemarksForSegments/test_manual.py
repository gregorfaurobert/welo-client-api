from src.segment_finder import find_segment_coordinates

def test_manual():
    # Path to the sample PDF
    pdf_path = "tests/test_data/sample.pdf"
    
    # Test segments
    segments = [
        "Welcome to the system",
        "Please read the instructions carefully",
        "This is another test segment"
    ]
    
    # Find coordinates
    results = find_segment_coordinates(pdf_path, segments)
    
    # Print results
    print("\nFound segments and their coordinates:")
    for result in results:
        print(f"\nSegment: {result['segment']}")
        print(f"Page: {result['page_number']}")
        print(f"Position: x={result['x']}, y={result['y']}")
        print(f"Size: width={result['width']}, height={result['height']}")
        print(f"Coordinates: {result['coordinates']}")

if __name__ == "__main__":
    test_manual() 