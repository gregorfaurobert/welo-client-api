from src.segment_finder import find_segment_coordinates
import os

def load_segments(file_path):
    with open(file_path, 'r') as f:
        return [line.strip() for line in f if line.strip()]

def test_segments():
    # Load segments from file
    segments = load_segments('segments.txt')
    
    # Path to the sample PDF
    pdf_path = os.path.join('tests', 'test_data', 'sample.pdf')
    
    # Find coordinates
    results = find_segment_coordinates(pdf_path, segments)
    
    # Print results
    print("\nFound segments and their coordinates:")
    print("=" * 80)
    
    for result in results:
        print(f"\nSegment: {result['segment']}")
        print(f"Page: {result['page_number']}")
        print(f"Position: x={result['x']}, y={result['y']}")
        print(f"Size: width={result['width']}, height={result['height']}")
        print("-" * 40)
    
    # Print summary
    print("\nSummary:")
    print(f"Total segments searched: {len(segments)}")
    print(f"Segments found: {len(results)}")
    print(f"Segments not found: {len(segments) - len(results)}")
    
    # Print segments not found
    found_segments = {r['segment'] for r in results}
    not_found = [s for s in segments if s not in found_segments]
    if not_found:
        print("\nSegments not found:")
        for segment in not_found:
            print(f"- {segment}")

if __name__ == "__main__":
    test_segments() 